/**************************************************************************************************************
Created by  : Swagata De
Date		: 01.05.2007
Description : This SP will insert a new entry in the exam detail table corresponding to a new exam registration
Parameters  : CenterId,CourseId,TermId,ModuleId
Returns     : Dataset
**************************************************************************************************************/

CREATE PROCEDURE [EXAMINATION].[uspRegisterExamination]
	(
		@iExamComponentID INT,
		@iCenterID INT,
		@iCourseID INT,
		@iTermID INT,
		@iModuleID INT,
		@dtExamRegistrationDate DATETIME,
		@dtExamDate DATETIME,
		@sVenue	VARCHAR(200),
		@dtStartTime DATETIME,
		@dtEndTime DATETIME,
		@sCreatedBy VARCHAR(20),
		@DtCreatedOn DATETIME,
		@sUpdatedBy VARCHAR(20),
		@DtUpdatedOn DATETIME		
	)
AS
SET NOCOUNT ON;	
BEGIN TRY
	DECLARE
	 @sRegnNo VARCHAR(20),
	 @iExamID INT
	 

	INSERT INTO EXAMINATION.T_Examination_Detail
	(
	 I_Exam_Component_ID,
	 I_Centre_Id,
	 I_Course_Id,
	 I_Term_ID,
	 I_Module_ID,
	 Dt_Registration_Date,
	 Dt_Exam_Date,
	 S_Exam_Venue,
	 I_Status_ID,
	 Dt_Exam_Start_Time,
	 Dt_Exam_End_Time,
	 S_Crtd_By,
	 S_Upd_By,
	 Dt_Crtd_On,
	 Dt_Upd_On
	)
	VALUES
	(
	 @iExamComponentID,
	 @iCenterID,
	 @iCourseID,
	 @iTermID,
	 @iModuleID,
	 @dtExamRegistrationDate,
	 @dtExamDate,	 
	 @sVenue,
	 1,--active status
	 @dtStartTime,
	 @dtEndTime,
	 @sCreatedBy,
	 @sUpdatedBy,
	 @DtCreatedOn,
	 @DtUpdatedOn
	 )
	 
	 SET @iExamID=( SELECT SCOPE_IDENTITY())
	 SET @sRegnNo='EXAM' + CAST(@iExamID AS VARCHAR(20))
	 
	 UPDATE EXAMINATION.T_Examination_Detail
	 SET S_Registration_No=@sRegnNo
	 WHERE I_Exam_ID=@iExamID
	 
	 SELECT @sRegnNo
	
END TRY	
	
BEGIN CATCH
--Error occurred:  

DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
SELECT	@ErrMsg = ERROR_MESSAGE(),
		@ErrSeverity = ERROR_SEVERITY()

RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
