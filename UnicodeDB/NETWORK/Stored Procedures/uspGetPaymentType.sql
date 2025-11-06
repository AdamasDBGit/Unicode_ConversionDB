-- =============================================
-- Author:		Debarshi Basu
-- Create date: 26/03/2006
-- Description:	GETS list for all Payment Types
-- =============================================
CREATE PROCEDURE [NETWORK].[uspGetPaymentType] 
AS
BEGIN

	SELECT  I_Payment_Charges_ID,S_Payment_Charges
	FROM NETWORK.T_Payment_Charges_Master

END
