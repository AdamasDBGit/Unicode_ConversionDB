CREATE PROCEDURE [dbo].[uspGetReceiptFromReceiptIDForFTArchive]
(
	@iReceiptID int
)

AS
BEGIN

SELECT * FROM T_Receipt_Header_Archive WITH (NOLOCK)
WHERE I_Receipt_Header_ID = @iReceiptID


SELECT RCD.*,ICD.I_Fee_Component_ID FROM T_Receipt_Component_Detail_Archive RCD WITH (NOLOCK)
INNER JOIN T_Receipt_Header_Archive RH WITH (NOLOCK)
ON RCD.I_Receipt_Detail_ID = RH.I_Receipt_Header_ID
INNER JOIN dbo.T_Invoice_Child_Detail ICD WITH (NOLOCK)
ON RCD.I_Invoice_Detail_ID = ICD.I_Invoice_Detail_ID
WHERE RH.I_Receipt_Header_ID = @iReceiptID

SELECT RTD.* FROM T_Receipt_Tax_Detail_Archive RTD WITH (NOLOCK)
INNER JOIN T_Receipt_Component_Detail_Archive RCD WITH (NOLOCK)
ON RTD.I_Receipt_Comp_Detail_ID = RCD.I_Receipt_Comp_Detail_ID
INNER JOIN T_Receipt_Header_Archive RH WITH (NOLOCK)
ON RCD.I_Receipt_Detail_ID = RH.I_Receipt_Header_ID
WHERE RH.I_Receipt_Header_ID = @iReceiptID


END
