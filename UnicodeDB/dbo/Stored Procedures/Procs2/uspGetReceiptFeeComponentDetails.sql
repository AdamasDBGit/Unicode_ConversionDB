-- =============================================
-- Author:		Debarshi Basu
-- Create date: 10/04/2007
-- Description:	Gets the break up of the fee components 
--				covered in a receipt
-- =============================================
CREATE PROCEDURE [dbo].[uspGetReceiptFeeComponentDetails] 
(
	@iReceiptID int
)

AS
BEGIN 
	SET NOCOUNT OFF;

	SELECT C.S_Component_Name,C.S_Component_Code,SUM(A.N_Amount_Paid) AS Amount
	FROM dbo.T_Receipt_Component_Detail A
	LEFT OUTER JOIN dbo.T_Invoice_Child_Detail B
	ON A.I_Invoice_Detail_ID = B.I_Invoice_Detail_ID
	INNER JOIN dbo.T_Fee_Component_Master C
	ON C.I_Fee_Component_ID = B.I_Fee_Component_ID
	WHERE A.I_Receipt_Detail_ID = @iReceiptID
	AND C.I_Status = 1
	GROUP BY C.S_Component_Name,C.S_Component_Code
 
END
