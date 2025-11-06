-- =============================================
-- Author:		Debarshi Basu
-- Create date: 26/03/2006
-- Description:	GETS center list for country
-- =============================================
CREATE PROCEDURE [dbo].[uspModifyTaxCenterDetails]
	@iTaxID int,
	@iCenterID int,
	@sFeeCompIDs varchar(100),
	@nTaxRate numeric(10,6)
AS
BEGIN
	SET NOCOUNT OFF;

	DELETE FROM dbo.T_Fee_Component_Tax
	WHERE I_Centre_Id =  @iCenterID
	AND I_Fee_Component_ID IN (SELECT * FROM fnString2Rows(@sFeeCompIDs,','))
	AND I_Tax_ID = @iTaxID

	INSERT INTO dbo.T_Fee_Component_Tax
	(I_Centre_Id,I_Fee_Component_ID,I_Tax_ID,N_Tax_Rate)
	SELECT @iCenterID,*,@iTaxID,@nTaxRate
	FROM dbo.fnString2Rows(@sFeeCompIDs,',')

END
