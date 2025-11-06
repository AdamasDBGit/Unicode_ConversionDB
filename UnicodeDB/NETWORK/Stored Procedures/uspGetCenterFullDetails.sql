CREATE PROCEDURE [NETWORK].[uspGetCenterFullDetails]
	@iCenterID INT
AS
BEGIN
	SET NOCOUNT ON;
--- table 0
	SELECT CM.I_Centre_Id,
			CM.S_Center_Code,
			CM.S_SAP_Customer_Id,
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
			BCD.I_Brand_ID,
			CM.Dt_Valid_To,
			ISNULL(CM.[I_Is_Center_Serv_Tax_Reqd],0) AS [I_Is_Center_Serv_Tax_Reqd],
			CM.S_Cost_Center
	FROM dbo.T_Centre_Master CM WITH(NOLOCK)
	LEFT OUTER JOIN dbo.T_Center_Hierarchy_Details CHD WITH(NOLOCK)
		ON CM.I_Centre_Id = CHD.I_Center_Id
			 AND CHD.I_Status <> 0
	LEFT OUTER JOIN NETWORK.T_Center_Address CA WITH(NOLOCK)
		ON CM.I_Centre_Id = CA.I_Centre_Id
	LEFT OUTER JOIN dbo.T_Country_Master COU
		ON CM.I_Country_ID = COU.I_Country_ID
		AND COU.I_Status = 1
	INNER JOIN dbo.T_Brand_Center_Details BCD
		ON CM.I_Centre_Id = BCD.I_Centre_Id
	WHERE CM.I_Centre_Id = @iCenterID
		

--	TABLE 1
	SELECT AD.I_Agreement_ID,
			AD.I_Brand_ID,
			AD.I_City_ID,
			AD.I_Agreement_Template_ID,
			AD.I_State_ID,
			AD.I_Country_ID,
			AD.I_Currency_ID,
			AD.I_BP_ID,
			AD.S_Company_Name,	
			AD.S_BP_Email,
			AD.S_Company_Address1,
			AD.S_Company_Address2,
			AD.S_Pin_No,
			AD.S_Phone_Number,
			AD.S_Agreement_Code,
			AD.Dt_Agreement_date,
			AD.Dt_Effective_Agreement_Date,
			AD.S_Territory,
			AD.I_BP_User_ID,
			AD.Dt_Expiry_Date,
			AD.S_Authorised_Courses,
			AD.S_Reason,
			AD.S_Firm_Registration_No,
			AD.S_Business_Jurisdiction,
			AD.S_Authorised_Signatories,
			AD.I_Signatories_Age,
			AD.S_Signatories_Address1,
			AD.S_Signatories_Address2,
			AD.S_Signatories_City,
			AD.S_Signatories_State,
			AD.S_Signatories_Country,
			AD.S_Signatories_Pin,
			AD.S_Signatories_Phone_Number,	
			AD.Dt_Frankling_Date,
			AD.N_Amount,
			AD.N_Renewal_Amount,
			AD.S_Constitution,
			AD.S_Place,
			AD.S_Plan,
			AD.I_Document_ID,
			AD.I_Status,
			UD.S_Document_Name,
			UD.S_Document_Type,
			UD.S_Document_Path,
			UD.S_Document_URL
	FROM NETWORK.T_Agreement_Details AD WITH(NOLOCK)
	INNER JOIN NETWORK.T_Agreement_Center AC
		ON AC.I_Agreement_ID = AD.I_Agreement_ID
	LEFT OUTER JOIN dbo.T_Upload_Document UD WITH(NOLOCK)
	ON AD.I_Document_ID = UD.I_Document_ID
	WHERE AC.I_Centre_Id = @iCenterID

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
