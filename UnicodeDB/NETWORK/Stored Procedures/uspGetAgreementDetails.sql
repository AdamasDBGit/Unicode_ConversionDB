-- =============================================
-- Author:		Debarshi Basu
-- Create date: 22/03/2007
-- Description:	Get the Details of an Agreement
-- =============================================

CREATE PROCEDURE [NETWORK].[uspGetAgreementDetails]
	@iAgreementID INT
AS
BEGIN

	SELECT	AD.I_Agreement_ID,
			AD.I_Brand_ID,
			AD.I_City_ID,
			AD.I_Agreement_Template_ID,
			AD.I_State_ID,
			AD.I_Country_ID,
			AD.I_BP_ID,
			AD.I_Currency_ID,
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
	LEFT OUTER JOIN dbo.T_Upload_Document UD WITH(NOLOCK)
	ON AD.I_Document_ID = UD.I_Document_ID
	WHERE AD.I_Agreement_ID = @iAgreementID
	AND AD.I_Status <> 0
END
