CREATE PROCEDURE [NETWORK].[uspGetAgreements]
	@sCompanyName varchar(100)=NULL,
	@iBPType int=NULL,
	@iBPUserID INT = NULL,
	@iBrandId INT=NULL
AS
BEGIN

	SELECT AD.I_Agreement_ID,
		   AD.S_Company_Name,
		   AD.S_Agreement_Code,
		   AD.Dt_Agreement_date,
		   BP.S_BP_Type,
		   AD.I_Brand_ID,
		   AD.I_Status
	FROM NETWORK.T_Agreement_Details AD
	INNER JOIN NETWORK.T_BP_Master BP
	ON AD.I_BP_ID = BP.I_BP_ID
	WHERE AD.I_Status <> 0
	AND AD.S_Company_Name LIKE '%'+ ISNULL(@sCompanyName,'')+'%'
	AND ISNULL(@iBPType,AD.I_BP_ID) = AD.I_BP_ID
	--AND ISNULL(@iBPUserID,AD.I_BP_User_ID) = AD.I_BP_User_ID
	AND AD.I_Brand_ID=@iBrandId
	ORDER BY AD.Dt_Agreement_date DESC
	
END
