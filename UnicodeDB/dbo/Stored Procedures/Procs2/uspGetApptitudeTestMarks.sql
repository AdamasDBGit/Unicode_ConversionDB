CREATE PROCEDURE [dbo].[uspGetApptitudeTestMarks]  
(  
 @iEnquiryId INT  
)  
  
AS  
  
BEGIN  
 SET NOCOUNT ON;   
 SELECT ISNULL(TET.N_Marks,-1) FROM T_ENQUIRY_TEST TET   
 WHERE TET.I_Enquiry_Regn_ID = @iEnquiryId AND  
 TET.I_Exam_Component_ID IN (SELECT I_Exam_Component_ID FROM T_EXAM_COMPONENT_MASTER WHERE S_Component_Type = 'A')  
   
   
END
