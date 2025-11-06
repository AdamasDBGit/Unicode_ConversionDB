CREATE PROC [ASSESSMENT].[uspGetExamComponentOnPreAssessmentTestI]       
(              
 @iPreAssessmentID INT        
)              
AS               
BEGIN       
      
SELECT tecm.I_Exam_Component_ID,S_Component_Name  FROM dbo.T_Exam_Component_Master AS tecm      
INNER JOIN ASSESSMENT.T_PreAssessment_ExamComponent_Mapping AS tpaecm      
ON tecm.I_Exam_Component_ID = tpaecm.I_Exam_Component_ID      
WHERE tpaecm.I_PreAssessment_ID=@iPreAssessmentID      
AND tecm.I_Exam_Type_Master_ID=14    
      
END
