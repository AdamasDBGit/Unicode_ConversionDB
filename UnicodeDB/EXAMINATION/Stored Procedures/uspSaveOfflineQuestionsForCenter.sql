/**************************************************************************************************************
Created by  : Debarshi Basu
Date		: 01.05.2007
Description : This SP will get the offline Question Paper for center
Parameters  : 		@iExamID int,
					@iStudentID int
**************************************************************************************************************/


CREATE PROCEDURE [EXAMINATION].[uspSaveOfflineQuestionsForCenter]
(
	@iCenterID int,
	@iExamID int,
	@iExamComponentID int,
	@sExamComponentName varchar(50),
	@sRegistrationNo varchar(20),
	@sQuestionPaperXML xml
)
AS
BEGIN		
	UPDATE EXAMINATION.T_Offline_Examination_Master
	SET S_Component_Name = @sExamComponentName,
		S_Registration_No = @sRegistrationNo,
		S_Question_XML = @sQuestionPaperXML
	WHERE I_Center_ID = @iCenterID
		AND I_Exam_ID = @iExamID
		AND I_Exam_Component_ID = @iExamComponentID

	IF NOT EXISTS (SELECT I_Center_Offline_Exam_ID 
					FROM EXAMINATION.T_Offline_Examination_Master
						WHERE I_Center_ID = @iCenterID	
						AND I_Exam_ID = @iExamID 
						AND I_Exam_Component_ID = @iExamComponentID)
	BEGIN
		INSERT INTO EXAMINATION.T_Offline_Examination_Master
		(I_Center_ID,I_Exam_ID,S_Registration_No,I_Exam_Component_ID,
		 S_Component_Name,S_Question_XML)
		VALUES
		(@iCenterID,@iExamID,@sRegistrationNo,@iExamComponentID,
		@sExamComponentName,@sQuestionPaperXML)
	END
END
