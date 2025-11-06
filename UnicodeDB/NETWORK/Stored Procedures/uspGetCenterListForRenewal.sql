-- =============================================
-- Author:		Santanu Maity
-- Create date: 02/07/2007
-- Description:	GETS list for all center for Renewal
-- =============================================

CREATE PROCEDURE [NETWORK].[uspGetCenterListForRenewal] 
	@iExpiryType int=null,
	@iDaysForLetter int=null		
AS

BEGIN
	SET NOCOUNT OFF;

	if @iExpiryType is not Null
	BEGIN
		SELECT 
			CM.I_Centre_Id,
			CM.S_Center_Code,
			CM.S_Center_Name,
			AD.S_Agreement_Code,
			AD.Dt_Agreement_date,
			AD.Dt_Effective_Agreement_Date,
			AD.N_Renewal_Amount,
			CM.I_Status,
			CM.I_Expiry_Status,
			AD.Dt_Expiry_Date		
		FROM dbo.T_Centre_Master CM WITH(NOLOCK)
			INNER JOIN NETWORK.T_Agreement_Center AC WITH(NOLOCK)
			ON AC.I_Centre_Id = CM.I_Centre_Id 
			INNER JOIN NETWORK.T_Agreement_Details AD
			ON AC.I_Agreement_ID = AD.I_Agreement_ID
		WHERE 
			CM.I_Expiry_Status = @iExpiryType
			AND CM.I_Status = 1
	END
	ELSE
	BEGIN	
		SELECT 
			CM.I_Centre_Id,
			CM.S_Center_Code,
			CM.S_Center_Name,
			AD.S_Agreement_Code,
			AD.Dt_Agreement_date,
			AD.Dt_Effective_Agreement_Date,
			AD.N_Renewal_Amount,
			CM.I_Status,
			CM.I_Expiry_Status,
			AD.Dt_Expiry_Date
		FROM dbo.T_Centre_Master CM WITH(NOLOCK)
			INNER JOIN NETWORK.T_Agreement_Center AC WITH(NOLOCK)
			ON AC.I_Centre_Id = CM.I_Centre_Id 
			INNER JOIN NETWORK.T_Agreement_Details AD
			ON AC.I_Agreement_ID = AD.I_Agreement_ID
		WHERE 
			datediff("d", getdate(),AD.Dt_Expiry_Date )< @iDaysForLetter
			AND CM.I_Status = 1
	END
	
END
