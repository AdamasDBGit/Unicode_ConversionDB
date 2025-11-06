CREATE PROCEDURE [dbo].[uspGetSiblingID]   
 @iEnquiryID INT
   
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT OFF  
  
 SELECT S_Sibling_ID FROM dbo.T_Enquiry_Regn_Detail AS TERD WHERE I_Enquiry_Regn_ID = @iEnquiryID 
   
END
