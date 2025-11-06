CREATE PROCEDURE [dbo].[usp_ERPUpdateEnquiryOnAdmission](@EnquiryID INT)
AS
BEGIN


	IF(@EnquiryID>0)
	BEGIN

		update T_Enquiry_Regn_Detail set I_Enquiry_Status_Code=3 where I_Enquiry_Regn_ID=@EnquiryID and I_Enquiry_Status_Code=1


	END


END
