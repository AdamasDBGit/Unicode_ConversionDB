CREATE PROCEDURE [dbo].[uspEnterAptitudeTestMarks]   
 @iEnquiryID int,  
 @iMarks int,  
 @ibypassAdmissionTest BIT,  
 @iExamComponentID int
AS  
BEGIN TRY  
  
 SET NOCOUNT OFF  
   
 UPDATE T_Enquiry_Test  
 SET N_Marks  = @iMarks,  
 bypass_Admission_Test = @ibypassAdmissionTest  
 WHERE I_Enquiry_Regn_ID = @iEnquiryID 
 AND I_Exam_Component_ID = @iExamComponentID 
   
   
END TRY  
  
BEGIN CATCH  
 --Error occurred:    
  
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int  
 SELECT @ErrMsg = ERROR_MESSAGE(),  
   @ErrSeverity = ERROR_SEVERITY()  
  
 RAISERROR(@ErrMsg, @ErrSeverity, 1)  
END CATCH
