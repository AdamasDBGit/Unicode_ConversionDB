-- =============================================
-- Author:		Debarshi Basu
-- Create date: 26/07/2006
-- Description:	Gets all the tax components attached to a center
-- =============================================

CREATE PROCEDURE [dbo].[uspGetTaxCountryReceiptType]
	@iCountryID int	
AS
BEGIN		

	SELECT I_Tax_ID,I_Receipt_Type,N_Tax_Rate,Dt_Valid_From,Dt_Valid_To
	FROM dbo.T_Tax_Country_ReceiptType
	WHERE I_Country_ID = @iCountryID
	AND I_Status = 1
	AND GETDATE() >= ISNULL(Dt_Valid_From,GETDATE())
	AND GETDATE() <= ISNULL(Dt_Valid_To,GETDATE())

END
