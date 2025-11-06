-- =============================================
-- Author:		Shub
-- Create date: '03/06/2013'
-- Description:	This Function return the name of the person who sold the Form 
-- =============================================
CREATE FUNCTION [REPORT].[fnGetFormSellerForReports]
(
	@iEnquiryRegnID INT
)

RETURNS VARCHAR(8000)

AS 

BEGIN

	DECLARE @Names VARCHAR(8000)  
	SELECT @Names = TUM.S_First_Name + ' ' + ISNULL(TUM.S_Middle_Name,'') + ' ' + ISNULL(TUM.S_Last_Name,'')
	FROM dbo.T_Receipt_Header AS TRH
	INNER JOIN dbo.T_User_Master AS TUM
	ON TRH.S_Crtd_By = TUM.S_Login_ID
	INNER JOIN dbo.T_Student_Detail AS TSD2
	ON TRH.I_Enquiry_Regn_ID = TSD2.I_Enquiry_Regn_ID
	WHERE I_Receipt_Type  IN (
			31,
			32,
			50,
			51,
			57)
			AND TRH.I_Enquiry_Regn_ID =@iEnquiryRegnID

	
	RETURN @Names 
END