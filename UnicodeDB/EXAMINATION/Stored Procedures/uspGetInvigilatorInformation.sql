-- =============================================
-- Author:		Debarshi Basu
-- Create date: <03-05-2007	>
-- Description:	To Save the invigilator for an exam
-- =============================================
CREATE PROCEDURE [EXAMINATION].[uspGetInvigilatorInformation]
(
	@iExamID int	
)
AS
BEGIN	
	SELECT I_Exam_ID,I_Exam_Component_ID,I_Centre_Id,I_Course_ID,I_Term_ID,I_Module_ID,
		I_Status_ID,ISNULL(I_Agency_ID,0) AS I_Agency_ID,ISNULL(S_Invigilator_Name,'') AS S_Invigilator_Name,
		ISNULL(S_Identification_Doc_Type,'') AS S_Identification_Doc_Type,ISNULL(C_Invigilator_Notified,'N') AS C_Invigilator_Notified,S_Reason,Dt_Exam_Date,
		S_Registration_No,Dt_Registration_Date,S_Exam_Venue,Dt_Exam_Start_Time,Dt_Exam_End_Time,S_Crtd_By,S_Upd_By,Dt_Crtd_On,Dt_Upd_On
	FROM EXAMINATION.T_Examination_Detail WHERE I_Exam_ID = @iExamID
END
