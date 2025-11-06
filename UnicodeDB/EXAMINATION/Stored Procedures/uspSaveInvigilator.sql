-- =============================================
-- Author:		Debarshi Basu
-- Create date: <03-05-2007	>
-- Description:	To Save the invigilator for an exam
-- =============================================
CREATE PROCEDURE [EXAMINATION].[uspSaveInvigilator]
	@iExamID int,
	@iAgencyID int,
	@sInvigilatorName varchar(500),
	@sIdDocumentType varchar(200),
	@sCreatedBy varchar(20),
	@DtCreatedOn datetime,
	@sUpdatedBy varchar(20),
	@DtUpdatedOn datetime
AS
BEGIN	
	INSERT INTO EXAMINATION.T_Examination_Audit
	(
		I_Exam_ID,I_Exam_Component_ID,I_Centre_Id,I_Course_ID,I_Term_ID,I_Module_ID,
		I_Status_ID,I_Agency_ID,S_Invigilator_Name,S_Identification_Doc_Type,
		C_Invigilator_Notified,S_Reason,Dt_Exam_Date,S_Registration_No,Dt_Registration_Date,
		S_Exam_Venue,Dt_Exam_Start_Time,Dt_Exam_End_Time,S_Crtd_By,S_Upd_By,Dt_Crtd_On,Dt_Upd_On
	)
	SELECT I_Exam_ID,I_Exam_Component_ID,I_Centre_Id,I_Course_ID,I_Term_ID,I_Module_ID,
		I_Status_ID,I_Agency_ID,S_Invigilator_Name,S_Identification_Doc_Type,
		C_Invigilator_Notified,S_Reason,Dt_Exam_Date,S_Registration_No,Dt_Registration_Date,
		S_Exam_Venue,Dt_Exam_Start_Time,Dt_Exam_End_Time,S_Crtd_By,S_Upd_By,Dt_Crtd_On,Dt_Upd_On
	FROM EXAMINATION.T_Examination_Detail WHERE I_Exam_ID = @iExamID

	UPDATE EXAMINATION.T_Examination_Detail
	SET I_Agency_ID = @iAgencyID,
	S_Invigilator_Name = @sInvigilatorName,
	S_Identification_Doc_Type = @sIdDocumentType,
	C_Invigilator_Notified = 'Y',
	S_Crtd_By = @sCreatedBy,
	Dt_Crtd_On = @DtCreatedOn,
	S_Upd_By = @sUpdatedBy,
	Dt_Upd_On = @DtUpdatedOn
	WHERE I_Exam_ID = @iExamID		
END
