CREATE PROCEDURE [EXAMINATION].[uspGetStudentListForExam]
@iExamID int
AS
BEGIN

DECLARE @iCenterID INT
DECLARE @iCourseID INT
DECLARE @iTermID INT
DECLARE @iModuleID INT
DECLARE @iComponentID INT
DECLARE @dtExamDate DATETIME

SELECT @iCenterID = I_Centre_Id,
@iCourseID = I_Course_ID,
@iTermID = I_Term_ID,
@iModuleID = I_Module_ID,
@iComponentID = I_Exam_Component_ID,
@dtExamDate = Dt_Exam_Date
FROM EXAMINATION.T_Examination_Detail
WHERE I_Exam_ID = @iExamID

SELECT DISTINCT SD.*
FROM dbo.T_Student_Detail SD
INNER JOIN dbo.T_Student_Course_Detail SCOU
ON SD.I_Student_Detail_ID = SCOU.I_Student_Detail_ID
INNER JOIN dbo.T_Student_Center_Detail SCEN
ON SD.I_Student_Detail_ID = SCEN.I_Student_Detail_ID
INNER JOIN dbo.T_Student_Term_Detail STD
ON SD.I_Student_Detail_ID = STD.I_Student_Detail_ID
INNER JOIN dbo.T_Student_Module_Detail SMD
ON SD.I_Student_Detail_ID = SMD.I_Student_Detail_ID
WHERE SCEN.I_Centre_Id = @iCenterID
AND SCOU.I_Course_ID = @iCourseID
AND STD.I_Term_ID = @iTermID
AND SMD.I_Module_ID = @iModuleID
AND SCEN.I_Status = 1
AND SCOU.I_Status = 1
AND SCOU.I_Is_Completed = 0
AND STD.I_Is_Completed = 0
UNION
SELECT DISTINCT SD.*
FROM dbo.T_Student_Detail SD
INNER JOIN dbo.T_Student_Course_Detail SCOU
ON SD.I_Student_Detail_ID = SCOU.I_Student_Detail_ID
INNER JOIN dbo.T_Student_Center_Detail SCEN
ON SD.I_Student_Detail_ID = SCEN.I_Student_Detail_ID
INNER JOIN dbo.T_Student_Term_Detail STD
ON SD.I_Student_Detail_ID = STD.I_Student_Detail_ID
INNER JOIN dbo.T_Student_Module_Detail SMD
ON SD.I_Student_Detail_ID = SMD.I_Student_Detail_ID
WHERE SCEN.I_Centre_Id = @iCenterID
AND SCOU.I_Course_ID = @iCourseID
AND STD.I_Term_ID = @iTermID
AND SMD.I_Module_ID = @iModuleID
AND SCEN.I_Status = 1
AND SCOU.I_Status = 1
AND SCOU.I_Is_Completed = 0
AND STD.I_Is_Completed = 1
AND ISNULL(STD.S_Term_Status,STD.S_Term_Status)='Referred'

END
