CREATE PROCEDURE [dbo].[uspGetallPreEnquiryNo]  --[dbo].[uspGetallPreEnquiryNo] 18            
(                  
 -- Add the parameters for the stored procedure here                  
                 
 @iCenterID int = NULL                             
)                  
                  
AS                  
BEGIN                  
 -- SET NOCOUNT ON added to prevent extra result sets from                  
 -- interfering with SELECT statements.                  
 SET NOCOUNT ON   
	SELECT I_Enquiry_Regn_ID,S_Enquiry_No FROM 
	dbo.T_Enquiry_Regn_Detail A                  
	WHERE A.I_Centre_Id = @iCenterID  

	AND B_IsPreEnquiry =1  
	AND I_Enquiry_Status_Code IS NULL 
	AND (I_PreEnquiryFor IS NULL OR I_PreEnquiryFor NOT IN(2,3))
	ORDER BY A.I_Enquiry_Regn_ID ASC--akash
	
END
