-- =============================================
-- Author:		Debarshi Basu
-- Create date: 22/03/2007
-- Description:	Get the List of all Agreements for centers
-- =============================================

CREATE PROCEDURE [NETWORK].[uspGetCenterAgreement]
	@iCenterID INT = NULL,
	@iAgreementID INT = NULL
AS
BEGIN

	SELECT I_Agreement_Center_ID,I_Agreement_ID,I_Centre_Id
	FROM NETWORK.T_Agreement_Center
	WHERE ISNULL(@iAgreementID,I_Agreement_ID) = I_Agreement_ID
		AND ISNULL(@iCenterID,I_Centre_Id) = I_Centre_Id

	
END
