CREATE PROCEDURE [EXAMINATION].[uspGetQuestionList]
	@iQuestionPoolID int
AS

BEGIN
	SET NOCOUNT ON;	
	SELECT QP.I_Question_ID,QP.I_Pool_ID,QP.I_Answer_Type_ID,
			QP.S_Question,ISNULL(QP.S_Question_Options,'') AS S_Question_Options,
			QP.I_Question_Type,QP.I_Complexity_ID,
			QP.I_Document_ID,UD.S_Document_Name,UD.S_Document_Type,
			UD.S_Document_Path,UD.S_Document_URL
	FROM EXAMINATION.T_Question_Pool QP
	LEFT OUTER JOIN dbo.T_Upload_Document UD
	ON QP.I_Document_ID = UD.I_Document_ID
	AND I_Status = 1
	WHERE QP.I_Pool_ID = @iQuestionPoolID
	ORDER BY QP.I_Question_ID

	SELECT QP.I_Question_ID, QC.I_Question_Choice_ID,QC.S_Answer_Desc,
		QC.B_Is_Answer,ISNULL(QC.N_Answer_Marks,0) AS N_Answer_Marks
	FROM EXAMINATION.T_Question_Choices QC
	INNER JOIN EXAMINATION.T_Question_Pool QP
	ON QP.I_Question_ID = QC.I_Question_ID
	WHERE QP.I_Pool_ID = @iQuestionPoolID

	SELECT	QP.I_Question_ID, SQ.I_SubQuestion_ID,SQ.I_SubQuestion_Type,
			SQ.S_SubQuestion_Desc,SQ.S_SubQuestion_Value,SQ.I_Document_ID,
			UD.S_Document_Name,UD.S_Document_Type,
			UD.S_Document_Path,UD.S_Document_URL
	FROM EXAMINATION.T_SubQuestion SQ
	INNER JOIN EXAMINATION.T_Question_Pool QP	
	ON QP.I_Question_ID = SQ.I_Question_ID
	LEFT OUTER JOIN dbo.T_Upload_Document UD
	ON SQ.I_Document_ID = UD.I_Document_ID
	WHERE QP.I_Pool_ID = @iQuestionPoolID

	SELECT	SQ.I_SubQuestion_ID , SQC.I_SubQuestion_Choice_ID,SQC.I_SubQuestion_Choice_Type,
			SQC.S_SubAnswer_Value,SQC.S_SubAnswer_Desc,
			SQC.B_Is_Answer,SQC.I_Document_ID,UD.S_Document_Name,UD.S_Document_Type,
			UD.S_Document_Path,UD.S_Document_URL
	FROM EXAMINATION.T_SubQuestion_Choice SQC
	INNER JOIN EXAMINATION.T_SubQuestion SQ
	ON SQC.I_SubQuestion_ID = SQ.I_SubQuestion_ID
	INNER JOIN EXAMINATION.T_Question_Pool QP
	ON SQ.I_Question_ID = QP.I_Question_ID
	LEFT OUTER JOIN dbo.T_Upload_Document UD
	ON SQC.I_Document_ID = UD.I_Document_ID
	WHERE QP.I_Pool_ID = @iQuestionPoolID
END
