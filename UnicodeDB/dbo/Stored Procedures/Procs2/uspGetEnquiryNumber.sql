-- =============================================  
-- Author:  Debarshi Basu  
-- Create date: 01/02/2007  
-- Description: It gets the Enquiry Number from Enquiry Table  
-- exec uspGetEnquiryNumber  
-- =============================================  
CREATE PROCEDURE [dbo].[uspGetEnquiryNumber]    
   
AS  
BEGIN  
 SET NOCOUNT OFF;  
  
 SELECT ISNULL(MAX(I_Enquiry_Regn_ID),0) FROM dbo.T_Enquiry_Regn_Detail  
  
END
