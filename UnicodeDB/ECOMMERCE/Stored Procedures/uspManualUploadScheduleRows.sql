CREATE PROCEDURE [ECOMMERCE].[uspManualUploadScheduleRows]
(
	@ScheduleName NVARCHAR(MAX),
	@CourseID INT,
	@SM NVARCHAR(MAX),
	@SubjectName NVARCHAR(MAX),
	@TopicName NVARCHAR(MAX)
)
AS
BEGIN

	DECLARE @ScheduleID INT=0
	DECLARE @SMID INT=0
	DECLARE @SubjectID INT=0
	--DECLARE @ChapterID INT=0
	--DECLARE @TopicID INT=0

	IF NOT EXISTS
	(
		select * from ECOMMERCE.T_Schedule 
		where 
		CourseID=@CourseID and ScheduleName=@ScheduleName and StatusID=1 
		and CONVERT(DATE,ValidFrom)<=CONVERT(DATE,GETDATE()) and CONVERT(DATE,ISNULL(ValidTo,GETDATE()))>=CONVERT(DATE,GETDATE())
	)
	BEGIN

		INSERT INTO ECOMMERCE.T_Schedule
		(
			ScheduleName,
			CourseID,
			StatusID,
			ValidFrom,
			CreatedBy,
			CreatedOn
		)
		VALUES
		(
			@ScheduleName,
			@CourseID,
			1,
			GETDATE(),
			'rice-group-admin',
			GETDATE()
		)

		SET @ScheduleID=SCOPE_IDENTITY()

	END
	ELSE
	BEGIN


		select @ScheduleID=ScheduleID 
		from ECOMMERCE.T_Schedule 
		where CourseID=@CourseID and ScheduleName=@ScheduleName and StatusID=1 
		and CONVERT(DATE,ValidFrom)<=CONVERT(DATE,GETDATE()) and CONVERT(DATE,ISNULL(ValidTo,GETDATE()))>=CONVERT(DATE,GETDATE())


	END

	-----SM Entry-----
	IF(@ScheduleID>0)
	BEGIN

		IF NOT EXISTS
		(
			select * from ECOMMERCE.T_Schedule_SM where ScheduleID=@ScheduleID and StatusID=1 and SMName=@SM
		)
		BEGIN

		

			insert into ECOMMERCE.T_Schedule_SM
			(
				SMName,
				ScheduleID,
				StatusID
			)
			values
			(
				@SM,
				@ScheduleID,
				1
			)


			set @SMID=SCOPE_IDENTITY()


		END
		ELSE
		BEGIN


			select @SMID=SMID 
			from ECOMMERCE.T_Schedule_SM 
			where 
			SMName=@SM and StatusID=1 and ScheduleID=@ScheduleID	


		END

		-----Subject Entry-----
		IF(@SMID>0)
		BEGIN


			IF NOT EXISTS
			(
				select * from ECOMMERCE.T_Schedule_Subject where SMID=@SMID and StatusID=1 and SubjectName=@SubjectName
			)
			BEGIN

				insert into ECOMMERCE.T_Schedule_Subject
				(
					SubjectName,
					SMID,
					StatusID
				)
				values
				(
					@SubjectName,
					@SMID,
					1
				)

				set @SubjectID=SCOPE_IDENTITY()

			END
			ELSE
			BEGIN

				select @SubjectID=SubjectID from ECOMMERCE.T_Schedule_Subject where SMID=@SMID and StatusID=1 and SubjectName=@SubjectName


			END

			-----Topic Entry-----
			IF(@SubjectID>0)
			BEGIN

				INSERT INTO ECOMMERCE.T_Schedule_Topic
				(
					TopicName,
					SubjectID,
					StatusID
				)
				values
				(
					@TopicName,
					@SubjectID,
					1
				)

			END



		END





	END





END
