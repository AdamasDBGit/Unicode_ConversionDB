-- =============================================  
-- Author:  Debarshi Basu  
-- Create date: 22/03/2007  
-- Description: Get the Enquiry Types  
-- =============================================  
  
  
CREATE PROCEDURE [dbo].[uspGetEnquiryType]   
AS  
BEGIN  
  
 SELECT I_Enquiry_Type_ID,S_Enquiry_Type_Desc,I_Status  
 FROM T_Enquiry_Type  
 WHERE I_Status = 1  
  
END
