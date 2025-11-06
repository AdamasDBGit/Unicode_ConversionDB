CREATE PROCEDURE [dbo].[uspGetQuestion]        
(      
 @iExamCompID INT       
)       
AS       
BEGIN     
 
 --Table[1] for the list of Feedback Master
 SELECT tfm.I_Feedback_Master_ID,S_Feedback_Question FROM ACADEMICS.T_Feedback_Master AS tfm
 WHERE tfm.I_Status=1 AND tfm.I_Exam_Component_ID =  @iExamCompID
       
  
END
