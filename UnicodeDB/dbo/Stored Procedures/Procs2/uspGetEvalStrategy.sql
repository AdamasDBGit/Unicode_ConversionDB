/**************************************************************************************************************  
Created by  : Sandeep Acharyya  
Date  : 03.05.2007  
Description : This SP will retrieve the Evaluation Strategy for the Term / Module  
Parameters  : CourseId,TermId,ModuleId  
Returns     : Dataset  
**************************************************************************************************************/  
CREATE PROCEDURE [dbo].[uspGetEvalStrategy]  
(  
 @iCourseID INT,  
 @iTermID INT,  
 @iModuleID INT = NULL,
 @I_Batch_ID INT = NULL  
)  
AS  
BEGIN 


--CREATE TABLE #temp
--(
--I_Strategy_ID INT,
--I_Exam_Component_ID INT,
--S_Component_Name VARCHAR(MAX),
--I_Course_ID INT,
--I_Term_ID INT,
--I_Module_ID INT,
--I_TotMarks INT,
--I_Exam_Duration INT,
--N_Weightage NUMERIC,
--I_Exam_Type_Master_ID INT,
--S_Exam_Type_Name VARCHAR(MAX),
--S_Remarks VARCHAR(MAX),
--I_IsPSDate BIT,
--I_Template_ID INT,
--StdCount INT
--)

 
   
 IF (@iModuleID IS NULL OR @iModuleID = 0 )  
 BEGIN
 ----akash 16.9.2016
 --INSERT INTO #temp
 --       ( I_Strategy_ID ,
 --         I_Exam_Component_ID ,
 --         S_Component_Name ,
 --         I_Course_ID ,
 --         I_Term_ID ,
 --         I_TotMarks ,
 --         I_Exam_Duration ,
 --         N_Weightage ,
 --         I_Exam_Type_Master_ID ,
 --         S_Exam_Type_Name ,
 --         S_Remarks ,
 --         I_IsPSDate ,
 --         I_Template_ID
 --       )
 ----akash 16.9.2016
   
  SELECT T.I_Term_Strategy_ID AS I_Strategy_ID,  
    T.I_Exam_Component_ID,  
    TECM.S_Component_Name,      
    T.I_Course_ID,  
    T.I_Term_ID,      
    T.I_TotMarks,  
    ISNULL(T.I_Exam_Duration,0) AS I_Exam_Duration,  
    T.N_Weightage,  
    ISNULL(ISNULL([T].[I_Exam_Type_Master_ID],ETM.I_Exam_Type_Master_ID),0) AS I_Exam_Type_Master_ID,
    ISNULL(ETM.S_Exam_Type_Name,'DUMMY') AS S_Exam_Type_Name,
    T.S_Remarks,  
    T.I_IsPSDate,  
    T.I_Template_ID ,
    T2.StdCount    
  FROM dbo.T_Term_Eval_Strategy T WITH(NOLOCK)  
  LEFT JOIN dbo.T_Exam_Component_Master TECM WITH(NOLOCK)  
  ON TECM.I_Exam_Component_ID = T.I_Exam_Component_ID  
  AND TECM.I_Status = 1  
  LEFT JOIN dbo.T_Exam_Type_Master ETM WITH(NOLOCK)  
  ON TECM.I_Exam_Type_Master_ID = ETM.I_Exam_Type_Master_ID
  --akash 16.9.2016
  LEFT JOIN
  ( 
SELECT TBEM.I_Batch_ID,TCM.I_Course_ID,TBEM.I_Term_ID,TBEM.I_Exam_Component_ID,COUNT(DISTINCT TSM.I_Student_Detail_ID) AS StdCount FROM EXAMINATION.T_Student_Marks TSM 
INNER JOIN EXAMINATION.T_Batch_Exam_Map TBEM ON TSM.I_Batch_Exam_ID = TBEM.I_Batch_Exam_ID
INNER JOIN dbo.T_Term_Course_Map TTCM ON TBEM.I_Term_ID = TTCM.I_Term_ID
INNER JOIN dbo.T_Course_Master TCM ON TTCM.I_Course_ID = TCM.I_Course_ID
WHERE 
TBEM.I_Batch_ID=@I_Batch_ID AND TBEM.I_Term_ID=@iTermID AND TCM.I_Course_ID=@iCourseID
GROUP BY TBEM.I_Batch_ID,TCM.I_Course_ID,TBEM.I_Term_ID,TBEM.I_Exam_Component_ID
) T2 ON T.I_Course_ID = T2.I_Course_ID AND T.I_Exam_Component_ID = T2.I_Exam_Component_ID AND T.I_Term_ID = T2.I_Term_ID 
--akash 16.9.2016 
  WHERE T.I_Term_ID = @iTermID  
  AND T.I_Course_ID = @iCourseID  
  AND T.I_Status = 1
  ORDER BY T.I_Exam_Component_ID
  
  
--UPDATE T1
--SET
--T1.StdCount=ISNULL(T2.StdCount,0)
--FROM
--#temp T1
--INNER JOIN
--( 
--SELECT TBEM.I_Batch_ID,TCM.I_Course_ID,TBEM.I_Term_ID,TBEM.I_Exam_Component_ID,COUNT(DISTINCT TSM.I_Student_Detail_ID) AS StdCount FROM EXAMINATION.T_Student_Marks TSM 
--INNER JOIN EXAMINATION.T_Batch_Exam_Map TBEM ON TSM.I_Batch_Exam_ID = TBEM.I_Batch_Exam_ID
--INNER JOIN dbo.T_Term_Course_Map TTCM ON TBEM.I_Term_ID = TTCM.I_Term_ID
--INNER JOIN dbo.T_Course_Master TCM ON TTCM.I_Course_ID = TCM.I_Course_ID
--WHERE 
--TBEM.I_Batch_ID=@I_Batch_ID AND TBEM.I_Term_ID=@iTermID AND TCM.I_Course_ID=@iCourseID
--GROUP BY TBEM.I_Batch_ID,TCM.I_Course_ID,TBEM.I_Term_ID,TBEM.I_Exam_Component_ID
--) T2 ON T1.I_Course_ID = T2.I_Course_ID AND T1.I_Exam_Component_ID = T2.I_Exam_Component_ID AND T1.I_Term_ID = T2.I_Term_ID

-- SELECT * FROM #temp T1

    
 END  
 ELSE  
 BEGIN
  --akash 16.9.2016
 --INSERT INTO #temp
 --       ( I_Strategy_ID ,
 --         I_Exam_Component_ID ,
 --         S_Component_Name ,
 --         I_Course_ID ,
 --         I_Term_ID ,
 --         I_Module_ID,
 --         I_TotMarks ,
 --         I_Exam_Duration ,
 --         N_Weightage ,
 --         I_Exam_Type_Master_ID ,
 --         S_Exam_Type_Name ,
 --         S_Remarks ,
 --         I_IsPSDate ,
 --         I_Template_ID,
 --         StdCount
 --       )
 ----akash 16.9.2016  
  SELECT M.I_Module_Strategy_ID AS I_Strategy_ID,  
    M.I_Exam_Component_ID,  
    TECM.S_Component_Name,      
    M.I_Course_ID,  
    M.I_Term_ID,  
    M.I_Module_ID,      
    M.I_TotMarks,  
    ISNULL(M.I_Exam_Duration,0) AS I_Exam_Duration,  
    M.N_Weightage,  
    TECM.I_Exam_Type_Master_ID,  
    ETM.S_Exam_Type_Name,  
    M.S_Remarks,  
    NULL AS I_IsPSDate,  
    0 AS I_Template_ID ,
    0 AS StdCount
  FROM dbo.T_Module_Eval_Strategy M WITH(NOLOCK)  
  LEFT JOIN dbo.T_Exam_Component_Master TECM WITH(NOLOCK)  
  ON TECM.I_Exam_Component_ID = M.I_Exam_Component_ID  
  AND TECM.I_Status = 1  
  LEFT JOIN dbo.T_Exam_Type_Master ETM WITH(NOLOCK)  
  ON TECM.I_Exam_Type_Master_ID = ETM.I_Exam_Type_Master_ID  
  WHERE M.I_Term_ID = @iTermID   
  AND M.I_Module_ID = @iModuleID  
  AND M.I_Course_ID = @iCourseID  
  AND M.I_Status = 1 
  
   --SELECT * FROM #temp T1
   
 END



 
   
END
