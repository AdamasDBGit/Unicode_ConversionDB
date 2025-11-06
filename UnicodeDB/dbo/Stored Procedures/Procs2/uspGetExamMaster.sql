CREATE PROCEDURE [dbo].[uspGetExamMaster]                  
              
AS                
BEGIN                
 SET NOCOUNT ON;                
 SELECT A.I_Exam_Component_ID,                
   A.S_Component_Name,                
   A.I_Status,                
   A.S_Component_Type,                
   A.I_Exam_Type_Master_ID,                
   B.S_Exam_Type_Name,        
   A.Dt_Admission_Test,  
   A.N_CutOffPercentage,                 
   A.S_Crtd_By,                
   A.S_Upd_By,                
   A.Dt_Crtd_On,                
   A.Dt_Upd_On,              
   A.I_Brand_ID,            
   ISNULL(C.I_PreAssessment_ID,0) AS I_PreAssessment_ID,    
   A.I_Course_ID,  
   S_Course_Name,
   ISNULL(A.B_Is_Subject,0) B_Is_Subject,
   ISNULL(A.I_Weightage,0) I_Weightage                  
 FROM dbo.T_Exam_Component_Master A                
 LEFT OUTER JOIN dbo.T_Exam_Type_Master B                
 ON A.I_Exam_Type_Master_ID = B.I_Exam_Type_Master_ID              
 LEFT OUTER JOIN ASSESSMENT.T_PreAssessment_ExamComponent_Mapping C            
 ON A.I_Exam_Component_ID = C.I_Exam_Component_ID            
 LEFT OUTER JOIN T_Course_Master TCM  
 on A.I_Course_ID = TCM.I_Course_ID  
 WHERE A.I_Status <> 0                
 ORDER BY A.S_Component_Name                
END
