/**************************************************************************************************************              
Created by  : Soumyopriyo              
Date  : 25.06.2011              
Description : This SP will save the user response of the online exam              
Parameters  : iExamComponentID              
Returns     : Dataset              
**************************************************************************************************************/              
              
CREATE PROCEDURE [EXAMINATION].[uspSaveAssessmentExam]              
(              
 @iExamComponentID INT,              
 @iEnquiryID INT = NULL,              
 @DtTestDate DATETIME,              
 @N_Marks NUMERIC(8,2),              
 @B_Has_Passed BIT,              
 @sAnswer XML = NULL,              
 @sCreatedBy VARCHAR(20) = NULL,              
 @sUpdatedBy VARCHAR(20) = NULL,              
 @dtCreatedOn DATETIME = NULL,              
 @dtUpdatedOn DATETIME = NULL      
)              
AS              
BEGIN TRY            
BEGIN TRAN T1           
 --INSERT INTO dbo.T_Enquiry_Test VALUES (@iExamComponentID,@iEnquiryRegnID,@DtTestDate,@N_Marks,@sAnswer)              
 IF EXISTS(SELECT * FROM EOS.T_Employee_Exam_Result               
    WHERE I_Enquiry_Regn_ID= @iEnquiryID AND I_Exam_Component_ID = @iExamComponentID              
    AND DATEDIFF(ss, Dt_Crtd_On, @DtTestDate) = 0)              
 BEGIN              
  UPDATE EOS.T_Employee_Exam_Result              
   SET I_No_Of_Attempts = ISNULL(I_No_Of_Attempts,0) + 1,              
    N_Marks = @N_Marks,              
    B_Passed = @B_Has_Passed,              
    S_Answer_XML = @sAnswer,              
    S_Upd_By = @sUpdatedBy,              
    Dt_Upd_On = @dtUpdatedOn              
  WHERE I_Enquiry_Regn_ID = @iEnquiryID              
   AND I_Exam_Component_ID = @iExamComponentID              
   AND DATEDIFF(ss, Dt_Crtd_On, @DtTestDate) = 0              
 END              
 ELSE              
 BEGIN              
  INSERT INTO EOS.T_Employee_Exam_Result              
  (I_Enquiry_Regn_ID, I_Exam_Component_ID, I_No_Of_Attempts, N_Marks, B_Passed, S_Answer_XML,S_Crtd_By,S_Upd_By,Dt_Crtd_On,Dt_Upd_On)               
  VALUES(@iEnquiryID,@iExamComponentID,1,@N_Marks,@B_Has_Passed,@sAnswer,@sCreatedBy,@sUpdatedBy,@dtCreatedOn,@dtUpdatedOn)              
 END              
       
 UPDATE ASSESSMENT.T_Student_Assessment_Map SET B_Is_Complete = 1,Total_Marks = @N_Marks WHERE I_Exam_Component_ID = @iExamComponentID AND I_Enquiry_Regn_ID = @iEnquiryID          
   
 COMMIT TRAN T1          
     
END TRY          
BEGIN CATCH              
 --Error occurred:                
 ROLLBACK TRAN T1             
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int              
 SELECT @ErrMsg = ERROR_MESSAGE(),              
   @ErrSeverity = ERROR_SEVERITY()              
              
 RAISERROR(@ErrMsg, @ErrSeverity, 1)              
END CATCH
