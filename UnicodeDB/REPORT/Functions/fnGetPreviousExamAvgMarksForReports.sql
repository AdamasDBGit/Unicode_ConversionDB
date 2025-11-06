-- =============================================
-- Author:		Arindam Roy
-- Create date: '07/19/2007'
-- Description:	This Function return the Average Previous Exam Marks
-- =============================================
CREATE FUNCTION [REPORT].[fnGetPreviousExamAvgMarksForReports]
(
	@iCenterID INT,
	@iCourseID INT,
	@iTermID INT,
	@iModuleID INT,
	@iExamComponentID INT,
	@ExamDate DATETIME
)

RETURNS NUMERIC(8,2)

AS 

BEGIN

	DECLARE @ExamID INT
	DECLARE @AvgMarks NUMERIC(8,2)

	 SELECT TOP(1)
			@ExamID=ED.I_Exam_ID
	   FROM EXAMINATION.T_Examination_Detail ED
			INNER JOIN EXAMINATION.T_Eligibility_List EL
			ON ED.I_Exam_ID=EL.I_Exam_ID
	  WHERE I_Centre_Id=@iCenterID
		AND I_Course_ID=@iCourseID
		AND I_Term_ID=@iTermID
		AND I_Module_ID=@iModuleID
		AND I_Exam_Component_ID=@iExamComponentID
		AND Dt_Exam_Date<@ExamDate
		AND I_Status_ID NOT IN(0,3)
	ORDER BY Dt_Exam_Date DESC

	SELECT @AvgMarks=AVG(I_Exam_Total) 
	  FROM EXAMINATION.T_Eligibility_List EL
		   INNER JOIN EXAMINATION.T_Student_Marks SM
		   ON EL.I_Student_Detail_ID=SM.I_Student_Detail_ID
		   AND EL.I_Exam_ID=SM.I_Exam_ID
		   AND EL.I_Exam_ID=@ExamID
	
	RETURN @AvgMarks
END