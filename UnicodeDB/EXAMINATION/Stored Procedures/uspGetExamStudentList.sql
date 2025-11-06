--uspGetExamStudentList 1
/**************************************************************************************************************
Created by  : Debarshi Basu
Date		: 03.05.2007
Description : This SP will retrieve students enrolled for exam
Parameters  : 
Returns     : Dataset
**************************************************************************************************************/

CREATE PROCEDURE [EXAMINATION].[uspGetExamStudentList] 
	@iExamID int
AS
BEGIN
	SELECT SD.S_First_Name,SD.S_Middle_Name,SD.S_Title, SD.S_Age,
	SD.S_Last_Name,SD.I_Student_Detail_ID,SD.S_Student_ID, SD.S_Email_ID
	FROM EXAMINATION.T_Eligibility_List EL
	INNER JOIN dbo.T_Student_Detail SD WITH (NOLOCK)
	ON SD.I_Student_Detail_ID = EL.I_Student_Detail_ID
	WHERE SD.I_Status = 1
	AND EL.I_Exam_ID = @iExamID
END
