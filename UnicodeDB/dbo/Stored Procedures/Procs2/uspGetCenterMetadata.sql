/*****************************************************************************************************************
Created by: Debarshi Basu
Date: 14 July, 2010
Description: Populates the metadata for center
******************************************************************************************************************/

CREATE PROCEDURE [dbo].[uspGetCenterMetadata]

AS
BEGIN

	SELECT BCD.I_Centre_Id,
		   BCD.I_Brand_ID,	
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
		   CH.I_Hierarchy_Master_ID,
		   CH.I_Hierarchy_Detail_ID,
		   CM.S_Center_Code,
		   CM.S_Center_Name,
		   CM.S_Center_Short_Name,
		   CM.I_Center_Category,
		   CM.I_RFF_Type,
		   CM.I_Is_Startup_Material_In_Place,
		   CM.I_Is_Library_In_Place,
		   CM.I_Country_ID,
		   CM.I_Expiry_Status,
		   CM.I_Is_OwnCenter,
		   CM.S_ServiceTax_Regd_Code,
		   CM.S_SAP_Customer_Id,
		   CM.I_Status,
		   COU.I_Currency_ID,
		   ISNULL(GST.S_GST_Code, 'NA')S_GST_Code,
		   ISNULL(GST.S_State_Code,'NA')S_State_Code,
		   ISNULL(SM.S_State_Name,'NA')S_State_Name
	FROM dbo.T_Centre_Master CM
	INNER JOIN NETWORK.T_Center_Address CA	ON CM.I_Centre_Id = CA.I_Centre_Id
	INNER JOIN dbo.T_Center_Hierarchy_Details CH	ON CH.I_Center_Id = CM.I_Centre_Id
	INNER JOIN dbo.T_Brand_Center_Details BCD	ON CM.I_Centre_Id = BCD.I_Centre_Id
	INNER JOIN dbo.T_Country_Master COU	ON CM.I_Country_ID = COU.I_Country_ID
	LEFT JOIN dbo.T_GST_Code_Master GST ON GST.I_State_ID=CA.I_State_ID AND BCD.I_Brand_ID = GST.I_Brand_ID
	INNER JOIN dbo.T_State_Master AS SM ON GST.I_State_ID = SM.I_State_ID AND CA.I_State_ID = SM.I_State_ID
	WHERE BCD.I_Status = 1	AND CH.I_Status = 1	AND CM.I_Status = 1

END
