CREATE PROCEDURE [EXAMINATION].[uspCheckStudentAssessmentExam]  
(    
	 @iExamComponentID INT,    
	 @iEnquiryID INT 
)    
AS    
BEGIN   

  SELECT teer_Result.I_Enquiry_Regn_ID, I_Exam_Component_ID, I_No_Of_Attempts, N_Marks, B_Passed, S_Answer_XML,teer_Result.S_Crtd_By,teer_Result.S_Upd_By,teer_Result.Dt_Crtd_On,teer_Result.Dt_Upd_On FROM EOS.T_Employee_Exam_Result AS teer_Result
  WHERE teer_Result.I_Enquiry_Regn_ID=@iEnquiryID AND
  teer_Result.I_Exam_Component_ID=@iExamComponentID
 
 
END
