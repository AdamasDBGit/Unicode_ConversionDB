CREATE PROCEDURE [dbo].[uspGetCourseSessionProgressCount]
	@iCourseId INT,
	@iBatchId INT,
	@iCenterId INT
AS
BEGIN
CREATE TABLE #TempTable    
(    
 I_Total_Session_Count INT,    
 I_Planned_Session_Count INT,    
 I_Actual_Session_Count INT
)

INSERT INTO #TempTable
SELECT COUNT(*) AS I_Total_Session_Count,dbo.fnGetTotalSessionCount(@iBatchId,@iCenterId,NULL,GETDATE()) AS I_Planned_Session_Count,dbo.fnGetActualSessionCount(@iBatchId,@iCenterId,GETDATE()) AS I_Actual_Session_Count
FROM dbo.T_Session_Master A
INNER JOIN dbo.T_Session_Module_Map B
ON A.I_Session_ID = B.I_Session_ID
INNER JOIN dbo.T_Module_Master C
ON B.I_Module_ID = C.I_Module_ID
INNER JOIN dbo.T_Module_Term_Map D
ON C.I_Module_ID = D.I_Module_ID
INNER JOIN dbo.T_Term_Master E
ON D.I_Term_ID = E.I_Term_ID
INNER JOIN dbo.T_Term_Course_Map F
ON E.I_Term_ID = F.I_Term_ID
WHERE I_Course_ID = @iCourseId
AND A.I_Status = 1
AND B.I_Status = 1
AND C.I_Status = 1
AND D.I_Status = 1
AND E.I_Status = 1
AND F.I_Status = 1



SELECT * FROM #TempTable

DROP TABLE #TempTable
END
