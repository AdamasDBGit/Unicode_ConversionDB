-- =============================================
-- Author:		Debarshi Basu
-- Create date: 26/03/2006
-- Description:	Modifies the Tax Receipt Type Center Mapping
-- =============================================
CREATE PROCEDURE [dbo].[uspModifyTaxCenterReceiptType]
	@iTaxID int,
	@iCenterID int,
	@sReceiptTypeIDs varchar(100),
	@nTaxRate numeric(10,6)
AS
BEGIN
	SET NOCOUNT OFF;

	DELETE FROM dbo.T_Receipt_Type_Tax
	WHERE I_Centre_Id =  @iCenterID
	AND I_Receipt_Type IN (SELECT * FROM fnString2Rows(@sReceiptTypeIDs,','))
	AND I_Tax_ID = @iTaxID

	INSERT INTO dbo.T_Receipt_Type_Tax
	(I_Centre_Id,I_Receipt_Type,I_Tax_ID,N_Tax_Rate)
	SELECT @iCenterID,*,@iTaxID,@nTaxRate
	FROM dbo.fnString2Rows(@sReceiptTypeIDs,',')

END
