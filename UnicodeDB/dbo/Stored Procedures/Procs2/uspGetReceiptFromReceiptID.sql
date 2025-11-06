CREATE PROCEDURE [dbo].[uspGetReceiptFromReceiptID]
(
	@iReceiptID int
)

AS
BEGIN
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

SELECT * FROM T_Receipt_Header WITH (NOLOCK)
WHERE I_Receipt_Header_ID = @iReceiptID


SELECT RCD.* FROM T_Receipt_Component_Detail RCD WITH (NOLOCK)
INNER JOIN T_Receipt_Header RH WITH (NOLOCK)
ON RCD.I_Receipt_Detail_ID = RH.I_Receipt_Header_ID
WHERE RH.I_Receipt_Header_ID = @iReceiptID

SELECT RTD.* FROM T_Receipt_Tax_Detail RTD WITH (NOLOCK)
INNER JOIN T_Receipt_Component_Detail RCD WITH (NOLOCK)
ON RTD.I_Receipt_Comp_Detail_ID = RCD.I_Receipt_Comp_Detail_ID
INNER JOIN T_Receipt_Header RH WITH (NOLOCK)
ON RCD.I_Receipt_Detail_ID = RH.I_Receipt_Header_ID
WHERE RH.I_Receipt_Header_ID = @iReceiptID


END
