/**************************************************************************************************************
Created by  : Swagata De
Date		: 09.05.2007
Description : This SP will save the questions of the offline examination in the local database of destination center
			  after downloading
Parameters  : 
Returns     : 
**************************************************************************************************************/

CREATE PROCEDURE [EXAMINATION].[uspSaveOfflineQuestions]
	(
		@iExamID INT,
		@iExamComponentID INT ,
		@sExamComponentName VARCHAR(50),
		@dtExamDate DATETIME,
		@sRegistrationNo VARCHAR(20),
		@sQuestionPaperXML XML	
		
	)
AS

BEGIN TRY
	SET NOCOUNT ON;
	
	IF EXISTS(SELECT * FROM EXAMINATION.T_Offline_Examination_Master WHERE I_Exam_ID=@iExamID)
		BEGIN
		--Update an existing entry
		UPDATE 	EXAMINATION.T_Offline_Examination_Master 
		SET I_Exam_Component_ID=@iExamComponentID,
			S_Component_Name=@sExamComponentName,
			S_Registration_No=@sRegistrationNo,
			S_Question_XML=@sQuestionPaperXML,
			Dt_Exam_Date=@dtExamDate
		WHERE I_Exam_ID=@iExamID
		END
		
	ELSE
		BEGIN
		--Insert a new entry
		INSERT INTO EXAMINATION.T_Offline_Examination_Master 
		(
			I_Exam_ID,
			I_Exam_Component_ID,
			S_Component_Name,
			S_Registration_No,
			S_Question_XML,
			Dt_Exam_Date
		)
		VALUES
		(
			@iExamID,
			@iExamComponentID,
			@sExamComponentName,
			@sRegistrationNo,
			@sQuestionPaperXML,
			@dtExamDate
		)	
		END
END TRY	
	
BEGIN CATCH
--Error occurred:  

DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
SELECT	@ErrMsg = ERROR_MESSAGE(),
		@ErrSeverity = ERROR_SEVERITY()

RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
