-- =============================================
-- Author:		<Susmita Paul>
-- Create date: <2023 July 14>
-- Description:	<Save Exam Schedule>
-- =============================================
CREATE PROCEDURE [dbo].[uspSaveExamSchedule] 
	-- Add the parameters for the stored procedure here
	(
	@iExamScheduleId INT = NULL,
	@iAcademicSessionID INT,
	@iSchoolGroupID INT,
	@iClassID INT,
	@iCourseID INT,
	@iTermID INT,
	@sTitle varchar(max)=NULL,
	@DtExamStartDate datetime,
	@DtExamEndDate datetime,
	@sCreatedBy varchar(max)
	,@PrincipalSignatureImageName nvarchar(max)=NULL
	,@TeacherSignatureImageName nvarchar(max)=NULL
	,@PrincipalName varchar(max)=NULL
	,@TeacherName varchar(max)=NULL
	)
AS
BEGIN TRY

	SET NOCOUNT OFF;

	DECLARE @ErrorMsg nvarchar(4000)
	declare @TableXml XML
	DECLARE @iSchoolGroupClassID INT= NULL

	BEGIN TRANSACTION
	--print 'err'
	select @iSchoolGroupClassID=SGC.I_School_Group_Class_ID from T_School_Group as SG
				inner join
				T_School_Group_Class as SGC on SG.I_School_Group_ID=SGC.I_School_Group_ID 
				inner join 
				T_Class as TC on TC.I_Class_ID=SGC.I_Class_ID
				where SGC.I_Class_ID=@iClassID and SGC.I_School_Group_ID=@iSchoolGroupID
				select  @sTitle=S_Term_Name from T_Term_Master where I_Term_ID=@iTermID
				DECLARE  @iUserID INT

		select @iUserID=ISNULL(I_User_ID,0) from T_User_Master where S_Login_ID=@sCreatedBy and I_Status=1
	IF (@iExamScheduleId IS NULL OR  @iExamScheduleId <= 0)
	BEGIN

		--print 'err'
		

		IF @iUserID > 0

		BEGIN
		IF NOT EXISTS (SELECT 1 from T_Result_Exam_Schedule where I_Course_ID = @iCourseID and I_Term_ID = @iTermID)
		--print 'err'
		BEGIN
				
				--select @iSchoolGroupClassID

				insert into T_Result_Exam_Schedule
				(
				I_School_Session_ID,
				I_Course_ID,
				Title,
				I_Term_ID,
				I_School_Group_Class_ID,
				Dt_Exam_Start_Date,
				Dt_Exam_End_Date,
				I_Created_By,
				Dt_CreatedAt,
				S_Principal_Signature,
				S_Principal_Name,
				S_Class_Teacher_Signature,
				S_Class_Teacher_Name
				)
				values
				(
				@iAcademicSessionID,
				@iCourseID,
				@sTitle,
				@iTermID,
				@iSchoolGroupClassID,
				@DtExamStartDate,
				@DtExamEndDate,
				@iUserID,
				GETDATE(),
				@PrincipalSignatureImageName,
				@PrincipalName,
				@TeacherSignatureImageName,
				@TeacherName
				)

				select 1 as StatusFlag,'Exam schedule created successfully' as Message

       END
	   ELSE
	   BEGIN
	   select 0 as StatusFlag,'Exam schedule already exists' as Message
	   END

		END
		ELSE
		BEGIN

			select 0 as StatusFlag,'User Not Exists' as ErrorMessage

		END


	END
	ELSE
	BEGIN
	IF NOT EXISTS (SELECT 1 from T_Result_Exam_Schedule where I_Course_ID = @iCourseID and I_Term_ID = @iTermID and I_Result_Exam_Schedule_ID!=@iExamScheduleId)
	BEGIN
	UPDATE T_Result_Exam_Schedule
	SET
	 I_School_Session_ID            = @iAcademicSessionID
	,I_Course_ID					= @iCourseID
	,Title							= @sTitle
	,I_Term_ID						= @iTermID
	,I_School_Group_Class_ID		= @iSchoolGroupClassID
	,Dt_Exam_Start_Date				= @DtExamStartDate
	,Dt_Exam_End_Date				= @DtExamEndDate
	,I_Created_By					= @iUserID
	,Dt_CreatedAt					= GETDATE()
	,S_Principal_Signature			= @PrincipalSignatureImageName
	,S_Principal_Name				= @PrincipalName
	,S_Class_Teacher_Signature		= @TeacherSignatureImageName
	,S_Class_Teacher_Name			= @TeacherName
	where I_Result_Exam_Schedule_ID = @iExamScheduleId
	select 1 as StatusFlag,'Exam schedule updated successfully' as Message
	END
	ELSE
	BEGIN
	 select 0 as StatusFlag,'Exam schedule already exists' as Message
	END
	END


   
COMMIT TRANSACTION
END TRY
BEGIN CATCH
	--Error occurred:  
	ROLLBACK TRANSACTION 
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
