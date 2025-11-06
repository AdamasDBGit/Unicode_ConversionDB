/**************************************************************************************************************    
Created by  : Sandeep Acharyya    
Date  : 03.05.2007    
Description : This SP will retrieve the Evaluation Strategy for the Term / Module    
Parameters  : CourseId,TermId,ModuleId    
Returns     : Dataset    
**************************************************************************************************************/    
CREATE PROCEDURE [dbo].[uspGetEvalStrategyforTerm]    
(    
 @iCourseID INT,    
 @iTermID INT,    
 --@iModuleID INT = NULL,  
 @I_Batch_ID INT = NULL    
)    
AS    
    
     
 --IF (@iModuleID IS NULL OR @iModuleID = 0 )    
 BEGIN    
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
    T.I_Template_ID       
  FROM dbo.T_Term_Eval_Strategy T WITH(NOLOCK)    
  LEFT JOIN dbo.T_Exam_Component_Master TECM WITH(NOLOCK)    
  ON TECM.I_Exam_Component_ID = T.I_Exam_Component_ID    
  AND TECM.I_Status = 1    
  LEFT JOIN dbo.T_Exam_Type_Master ETM WITH(NOLOCK)    
  ON TECM.I_Exam_Type_Master_ID = ETM.I_Exam_Type_Master_ID    
  WHERE T.I_Term_ID = @iTermID    
  AND T.I_Course_ID = @iCourseID    
  AND T.I_Status = 1    
 END
