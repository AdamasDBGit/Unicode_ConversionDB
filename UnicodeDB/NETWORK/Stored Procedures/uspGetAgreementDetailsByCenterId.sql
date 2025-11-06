-- =============================================
-- Author:		Swagatam Sarkar
-- Create date: 03/07/2007
-- Description:	Get the Details of an Agreement
-- =============================================

CREATE PROCEDURE [NETWORK].[uspGetAgreementDetailsByCenterId]
	@iCenterID INT
AS
BEGIN
	--Table[0] for Old Agreement Details
	SELECT AD.* FROM NETWORK.T_Agreement_Details AD
	INNER JOIN NETWORK.T_Agreement_Center AC
	ON AD.I_Agreement_ID = AC.I_Agreement_ID
	WHERE AC.I_Centre_Id = @iCenterID
	AND AD.I_Status <> 0

END
