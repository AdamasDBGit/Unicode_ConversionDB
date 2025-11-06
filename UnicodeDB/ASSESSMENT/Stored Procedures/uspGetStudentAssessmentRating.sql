CREATE PROCEDURE [ASSESSMENT].[uspGetStudentAssessmentRating]      
(    
 @iEnquiryID INT,  
 @iExamComponentID INT     
)     
AS     
BEGIN    
  
SELECT    
        I_Exam_Component_ID ,  
        SUM(I_Value) AS Rating FROM STUDENTFEATURES.T_Student_Feedback AS tsf  
INNER JOIN STUDENTFEATURES.T_Student_Feedback_Details AS tsfd  
ON tsf.I_Student_Feedback_ID = tsfd.I_Student_Feedback_ID  
INNER JOIN ACADEMICS.T_Feedback_Option_Master AS tfom  
ON tsfd.I_Feedback_Option_Master_ID = tfom.I_Feedback_Option_Master_ID  
INNER JOIN ACADEMICS.T_Feedback_Master AS tfm  
ON tfom.I_Feedback_Master_ID = tfm.I_Feedback_Master_ID  
WHERE I_Enquiry_Regn_ID = @iEnquiryID  
AND I_Exam_Component_ID = @iExamComponentID  
group BY I_Enquiry_Regn_ID,I_Exam_Component_ID  
  
END
