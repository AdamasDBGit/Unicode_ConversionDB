-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspUpdateInvoiceParentForAdvanceTax]
(
	@iReceiptDetailId INT = NULL	
)
AS
BEGIN
SET NOCOUNT ON;

-------------- update T_Invoice_Child_Header.N_Tax_Value : against new inserted as well as updated records in detail
-- select A.N_Tax_Amount,B.N_Tax_Value
UPDATE A SET A.N_Tax_Amount = ISNULL(B.N_Tax_Value,0)
FROM T_Invoice_Child_Header A
INNER JOIN
(SELECT 
	ICD.I_Invoice_Child_Header_ID,
	SUM(ISNULL(IDT.N_Tax_Value,0)) N_Tax_Value
	FROM T_Invoice_Child_Detail AS ICD
	INNER JOIN T_Invoice_Detail_Tax AS IDT
	ON ICD.I_Invoice_Detail_ID = IDT.I_Invoice_Detail_ID
	WHERE ICD.I_Invoice_Child_Header_ID IN (SELECT CD.I_Invoice_Child_Header_ID
											FROM T_Receipt_Component_Detail RCD
											INNER JOIN T_Invoice_Child_Detail CD ON RCD.I_Invoice_Detail_ID = CD.I_Invoice_Detail_ID
											WHERE RCD.I_Receipt_Detail_ID = @iReceiptDetailId)
	GROUP BY ICD.I_Invoice_Child_Header_ID
	) B
ON A.I_Invoice_Child_Header_ID = B.I_Invoice_Child_Header_ID

----------------------------- update T_Invoice_Parent.N_Tax_Value : : against new inserted as well as updated records in detail
-- select A.N_Tax_Amount,B.N_Tax_Value
UPDATE A SET A.N_Tax_Amount = ISNULL(B.N_Tax_Value,0)
FROM T_Invoice_Parent A
INNER JOIN
(SELECT 
	ICH.I_Invoice_Header_ID,
	SUM(ISNULL(IDT.N_Tax_Value,0)) N_Tax_Value
	FROM T_Invoice_Child_Header AS ICH
	INNER JOIN T_Invoice_Child_Detail AS ICD
	ON ICH.I_Invoice_Child_Header_ID = ICD.I_Invoice_Child_Header_ID
	INNER JOIN T_Invoice_Detail_Tax AS IDT
	ON ICD.I_Invoice_Detail_ID = IDT.I_Invoice_Detail_ID
	WHERE ICD.I_Invoice_Child_Header_ID IN (SELECT CD.I_Invoice_Child_Header_ID
											FROM T_Receipt_Component_Detail RCD
											INNER JOIN T_Invoice_Child_Detail CD ON RCD.I_Invoice_Detail_ID = CD.I_Invoice_Detail_ID
											WHERE RCD.I_Receipt_Detail_ID = @iReceiptDetailId)
	-- WHERE ICH.I_Invoice_Header_ID IN (SELECT DISTINCT I_Invoice_Child_Header_ID FROM NewInserted)
	GROUP BY ICH.I_Invoice_Header_ID
	) B
ON A.I_Invoice_Header_ID = B.I_Invoice_Header_ID
END
