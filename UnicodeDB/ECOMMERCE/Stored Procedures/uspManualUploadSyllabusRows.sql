CREATE PROCEDURE [ECOMMERCE].[uspManualUploadSyllabusRows]
(
	@SyllabusName NVARCHAR(MAX),
	@CourseID INT,
	@SubjectName NVARCHAR(MAX),
	@ChapterName NVARCHAR(MAX),
	@TopicName NVARCHAR(MAX)
)
AS
BEGIN

	DECLARE @SyllabusID INT=0
	DECLARE @SubjectID INT=0
	DECLARE @ChapterID INT=0
	--DECLARE @TopicID INT=0

	IF NOT EXISTS
	(
		select * from ECOMMERCE.T_Syllabus where CourseID=@CourseID and SyllabusName=@SyllabusName and StatusID=1 
		and CONVERT(DATE,ValidFrom)<=CONVERT(DATE,GETDATE()) and CONVERT(DATE,ISNULL(ValidTo,GETDATE()))>=CONVERT(DATE,GETDATE())
	)
	BEGIN

		INSERT INTO ECOMMERCE.T_Syllabus
		(
			SyllabusName,
			CourseID,
			StatusID,
			ValidFrom,
			CreatedBy,
			CreatedOn
		)
		VALUES
		(
			@SyllabusName,
			@CourseID,
			1,
			GETDATE(),
			'rice-group-admin',
			GETDATE()
		)

		SET @SyllabusID=SCOPE_IDENTITY()

	END
	ELSE
	BEGIN


		select @SyllabusID=SyllabusID 
		from ECOMMERCE.T_Syllabus 
		where CourseID=@CourseID and SyllabusName=@SyllabusName and StatusID=1 
		and CONVERT(DATE,ValidFrom)<=CONVERT(DATE,GETDATE()) and CONVERT(DATE,ISNULL(ValidTo,GETDATE()))>=CONVERT(DATE,GETDATE())


	END

	-----Subject Entry-----
	IF(@SyllabusID>0)
	BEGIN

		IF NOT EXISTS
		(
			select * from ECOMMERCE.T_Syllabus_Subject where SyllabusID=@SyllabusID and StatusID=1 and SubjectName=@SubjectName
		)
		BEGIN

		

			insert into ECOMMERCE.T_Syllabus_Subject
			(
				SubjectName,
				SyllabusID,
				StatusID
			)
			values
			(
				@SubjectName,
				@SyllabusID,
				1
			)


			set @SubjectID=SCOPE_IDENTITY()


		END
		ELSE
		BEGIN


			select @SubjectID=SubjectID 
			from ECOMMERCE.T_Syllabus_Subject 
			where 
			SyllabusID=@SyllabusID and StatusID=1 and SubjectName=@SubjectName	


		END

		-----Chapter Entry-----
		IF(@SubjectID>0)
		BEGIN


			IF NOT EXISTS
			(
				select * from ECOMMERCE.T_Syllabus_Chapter where SubjectID=@SubjectID and StatusID=1 and ChapterName=@ChapterName
			)
			BEGIN

				insert into ECOMMERCE.T_Syllabus_Chapter
				(
					ChapterName,
					SubjectID,
					StatusID
				)
				values
				(
					@ChapterName,
					@SubjectID,
					1
				)

				set @ChapterID=SCOPE_IDENTITY()

			END
			ELSE
			BEGIN

				select @ChapterID=ChapterID from ECOMMERCE.T_Syllabus_Chapter where SubjectID=@SubjectID and StatusID=1 and ChapterName=@ChapterName


			END

			-----Topic Entry-----
			IF(@ChapterID>0)
			BEGIN

				INSERT INTO ECOMMERCE.T_Syllabus_Topic
				(
					TopicName,
					ChapterID,
					StatusID
				)
				values
				(
					@TopicName,
					@ChapterID,
					1
				)

			END



		END





	END





END
