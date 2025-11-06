--[NETWORK].[uspGetCenterFullDetails] 37




-- =============================================
-- Author:		Santanu Maity
-- Create date: 02/08/2007
-- Description:	Get the ownership transfer details of a Center
-- =============================================

CREATE PROCEDURE [NETWORK].[uspGetCenterOwnershipTransferDetails]
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
			CHD.I_Hierarchy_Master_ID
	FROM dbo.T_Centre_Master CM WITH(NOLOCK)
	LEFT OUTER JOIN dbo.T_Center_Hierarchy_Details CHD WITH(NOLOCK)
		ON CM.I_Centre_Id = CHD.I_Center_Id
			 AND CHD.I_Status <> 0
	LEFT OUTER JOIN NETWORK.T_Center_Address CA WITH(NOLOCK)
		ON CM.I_Centre_Id = CA.I_Centre_Id
	WHERE CM.I_Centre_Id = @iCenterID
		

--	TABLE 1
	SELECT * from NETWORK.T_Ownership_Transfer_Request
	WHERE I_Centre_Id = @iCenterID

--	table 2
	SELECT I_Center_Periodic_Charges_ID,
			I_Centre_Id,
			I_Currency_ID,
			I_Payment_Charges_ID,
			Dt_From_Date,
			Dt_To_Date,
			Dt_Due_Date,
			I_Total_Amount,
			I_Transfer_To_SAP
	FROM NETWORK.T_Center_Periodic_Charges WITH(NOLOCK)
	WHERE I_Centre_Id = @iCenterID
		AND I_Status <> 0
	
END
