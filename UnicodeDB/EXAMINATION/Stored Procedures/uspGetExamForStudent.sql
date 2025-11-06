/**************************************************************************************************************
Created by  : Sandeep Acharyya
Date		: 16.05.2007
Description : This SP will get all the Exams for the Student
Parameters  : 
Returns     : 
**************************************************************************************************************/

CREATE PROCEDURE [EXAMINATION].[uspGetExamForStudent]
(
	@iStudentID INT
)
AS
BEGIN
	SELECT DISTINCT TOEM.I_Exam_ID, TOEM.S_Registration_No, TOEM.I_Exam_Component_ID, TOEM.S_Component_Name
	FROM Examination.T_Student_Question_Answer TSQA WITH(NOLOCK)
	INNER JOIN Examination.T_Offline_Examination_Master TOEM WITH(NOLOCK)
	ON TSQA.I_Exam_ID = TOEM.I_Exam_ID
	WHERE TSQA.I_Student_Detail_ID = @iStudentID
END
