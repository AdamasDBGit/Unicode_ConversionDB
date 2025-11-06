-- =============================================
-- Author:		Debarshi Basu
-- Create date: 22/03/2007
-- Description:	Get the List of all Agreements for center creation 
-- =============================================

CREATE PROCEDURE [NETWORK].[uspGetAgreementsForCenterCreation]
	@iStatusApproved INT
AS
BEGIN

	SELECT AD.I_Agreement_ID,
		   AD.S_Company_Name,AD.S_Agreement_Code,
		   AD.Dt_Agreement_date,
		   BP.S_BP_Type,
		   AD.I_Status,
		   AD.I_Brand_ID
	FROM NETWORK.T_Agreement_Details AD
	INNER JOIN NETWORK.T_BP_Master BP
	ON AD.I_BP_ID = BP.I_BP_ID
	WHERE AD.I_Status = @iStatusApproved
	AND AD.I_Agreement_ID NOT IN
		(SELECT I_Agreement_ID FROM NETWORK.T_Agreement_Center)
	ORDER BY AD.Dt_Agreement_date DESC

	
END
