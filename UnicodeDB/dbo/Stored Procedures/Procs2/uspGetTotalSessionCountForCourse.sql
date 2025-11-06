CREATE PROCEDURE [dbo].[uspGetTotalSessionCountForCourse]
(
	@iCourseID INT	
)
AS
BEGIN
	SELECT SUM(Term_Sessions) AS Total_Session_Count  FROM
(SELECT A.I_Total_Session_Count AS Term_Sessions
FROM dbo.T_Term_Master A
INNER JOIN dbo.T_Term_Course_Map B
ON A.I_Term_ID = B.I_Term_ID
WHERE A.I_Status = 1
AND B.I_Status = 1
AND B.I_Course_ID = @iCourseID) C
END
