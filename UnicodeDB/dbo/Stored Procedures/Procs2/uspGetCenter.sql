-- =============================================
-- Author:		Debarshi Basu
-- Create date: 22/03/2007
-- Description:	Get the details of a Center
-- =============================================

CREATE PROCEDURE [dbo].[uspGetCenter]
	@iCenterID INT

AS
BEGIN
	SET NOCOUNT ON;
--- table 0
	SELECT CM.I_Centre_Id,
			CM.S_Center_Code,
			CM.S_Center_Name,
			CM.I_Status,
			CM.S_Center_Short_Name,
			CM.I_Center_Category,
			CM.I_RFF_Type,
			CM.I_Is_Startup_Material_In_Place,
			CM.I_Is_Library_In_Place,
			CM.I_Expiry_Status,
			CM.I_Is_OwnCenter,
			CM.S_ServiceTax_Regd_Code,
			CA.S_Center_Address1,
			CA.S_Center_Address2,
			CA.I_City_ID,
			CA.I_State_ID,
			CA.S_Pin_Code,
			CA.I_Country_ID,
			CA.S_Telephone_No,
			CA.S_Email_ID,
			CA.S_Delivery_Address1,
			CA.S_Delivery_Address2,
			CA.I_Delivery_City_ID,
			CA.I_Delivery_State_ID,
			CA.S_Delivery_Pin_No,
			CA.I_Delivery_Country_ID,
			CA.S_Delivery_Phone_No,
			CA.S_Delivery_Email_ID,
			CHD.I_Hierarchy_Detail_ID,	
			CHD.I_Hierarchy_Master_ID,
			COU.I_Currency_ID,
			BCD.I_Brand_ID
	FROM dbo.T_Centre_Master CM WITH(NOLOCK)
	LEFT OUTER JOIN dbo.T_Center_Hierarchy_Details CHD WITH(NOLOCK)
		ON CM.I_Centre_Id = CHD.I_Center_Id
			 AND CHD.I_Status <> 0
	LEFT OUTER JOIN NETWORK.T_Center_Address CA WITH(NOLOCK)
		ON CM.I_Centre_Id = CA.I_Centre_Id
	INNER JOIN dbo.T_Country_Master COU
		ON CM.I_Country_ID = COU.I_Country_ID
	INNER JOIN dbo.T_Brand_Center_Details BCD
		ON BCD.I_Centre_Id = CM.I_Centre_Id		
	WHERE CM.I_Centre_Id = @iCenterID
	AND BCD.I_Status <> 0
	AND ISNULL(BCD.Dt_Valid_From,GETDATE()) <= GETDATE()
	AND ISNULL(BCD.Dt_Valid_To,GETDATE()) >= GETDATE()
		

END
