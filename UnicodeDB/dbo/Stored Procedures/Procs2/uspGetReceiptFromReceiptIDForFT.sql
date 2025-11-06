CREATE PROCEDURE [dbo].[uspGetReceiptFromReceiptIDForFT] --exec uspGetReceiptFromReceiptIDForFT 692452
(
	@iReceiptID int
)

AS
BEGIN

SELECT * FROM T_Receipt_Header WITH (NOLOCK)
WHERE I_Receipt_Header_ID = @iReceiptID


SELECT RCD.*,ICD.I_Fee_Component_ID FROM T_Receipt_Component_Detail RCD WITH (NOLOCK)
INNER JOIN T_Receipt_Header RH WITH (NOLOCK)
ON RCD.I_Receipt_Detail_ID = RH.I_Receipt_Header_ID
INNER JOIN dbo.T_Invoice_Child_Detail ICD WITH (NOLOCK)
ON RCD.I_Invoice_Detail_ID = ICD.I_Invoice_Detail_ID
WHERE RH.I_Receipt_Header_ID = @iReceiptID


--01-07-2017 close for new logic
--SELECT RTD.* FROM T_Receipt_Tax_Detail RTD WITH (NOLOCK)
--INNER JOIN T_Receipt_Component_Detail RCD WITH (NOLOCK)
--ON RTD.I_Receipt_Comp_Detail_ID = RCD.I_Receipt_Comp_Detail_ID
--INNER JOIN T_Receipt_Header RH WITH (NOLOCK)
--ON RCD.I_Receipt_Detail_ID = RH.I_Receipt_Header_ID
--WHERE RH.I_Receipt_Header_ID = @iReceiptID

SELECT RTD.*,ICD.I_Fee_Component_ID,FCM.S_Component_Name FROM T_Receipt_Tax_Detail RTD WITH (NOLOCK)
INNER JOIN T_Receipt_Component_Detail RCD WITH (NOLOCK)
ON RTD.I_Receipt_Comp_Detail_ID = RCD.I_Receipt_Comp_Detail_ID
INNER JOIN T_Receipt_Header RH WITH (NOLOCK)
ON RCD.I_Receipt_Detail_ID = RH.I_Receipt_Header_ID
INNER JOIN T_Invoice_Child_Detail ICD WITH (NOLOCK)
ON ICD.I_Invoice_Detail_ID = RTD.I_Invoice_Detail_ID
INNER JOIN T_Fee_Component_Master FCM WITH (NOLOCK)
ON ICD.I_Fee_Component_ID = FCM.I_Fee_Component_ID
WHERE RH.I_Receipt_Header_ID =@iReceiptID
ORDER BY RTD.I_Tax_ID ASC

SELECT TAG_ROW, 0 AS I_Invoice_Detail_ID, S_Invoice_Number, 
	   SUM(N_Amount_Due_OR_ADV) AS N_Amount_Due_OR_ADV, 
	   SUM(N_Tax_Value) AS N_Tax_Value, 
	   SUM(N_Tax_Value_Scheduled) AS N_Tax_Value_Scheduled
FROM(
SELECT 'Invoice' TAG_ROW, 
		0 AS I_Invoice_Detail_ID, 
		ICD.S_Invoice_Number, 
		RCD.N_Amount_Paid AS N_Amount_Due_OR_ADV,
		ISNULL((SELECT SUM(ISNULL(RTD.N_Tax_Paid,0)) FROM T_Receipt_Tax_Detail RTD WHERE RTD.I_Receipt_Comp_Detail_ID = RCD.I_Receipt_Comp_Detail_ID),0)
		AS N_Tax_Value, 
		ISNULL((SELECT SUM(ISNULL(RTD.N_Tax_Paid,0)) FROM T_Receipt_Tax_Detail RTD WHERE RTD.I_Receipt_Comp_Detail_ID = RCD.I_Receipt_Comp_Detail_ID),0)
		AS N_Tax_Value_Scheduled
FROM T_Invoice_Child_Detail ICD
INNER JOIN T_Receipt_Component_Detail RCD ON ICD.I_Invoice_Detail_ID = RCD.I_Invoice_Detail_ID
INNER JOIN T_Receipt_Header RH ON RCD.I_Receipt_Detail_ID = RH.I_Receipt_Header_ID
WHERE RH.I_Receipt_Header_ID = @iReceiptID
AND RCD.N_Amount_Paid > 0
AND CONVERT(DATE, RH.Dt_Receipt_Date) >= CONVERT(DATE, ICD.Dt_Installment_Date)
GROUP BY RCD.I_Receipt_Comp_Detail_ID, ICD.S_Invoice_Number, RCD.N_Amount_Paid) AS INV
GROUP BY TAG_ROW, S_Invoice_Number
UNION
SELECT TAG_ROW, 0 AS I_Invoice_Detail_ID, S_Invoice_Number, 
	   SUM(N_Amount_Due_OR_ADV) AS N_Amount_Due_OR_ADV, 
	   SUM(N_Tax_Value) AS N_Tax_Value, 
	   SUM(N_Tax_Value_Scheduled) AS N_Tax_Value_Scheduled
FROM(
SELECT 'Advance Payment' TAG_ROW, 0 AS I_Invoice_Detail_ID, 
	   '' AS S_Invoice_Number,  
	   RCD.N_Amount_Paid AS N_Amount_Due_OR_ADV,
	   ISNULL((SELECT SUM(ISNULL(RTD.N_Tax_Paid,0)) FROM T_Receipt_Tax_Detail RTD WHERE RTD.I_Receipt_Comp_Detail_ID = RCD.I_Receipt_Comp_Detail_ID),0)
	   AS N_Tax_Value, 
	   ISNULL((SELECT SUM(ISNULL(RTD.N_Tax_Paid,0)) FROM T_Receipt_Tax_Detail RTD WHERE RTD.I_Receipt_Comp_Detail_ID = RCD.I_Receipt_Comp_Detail_ID),0)
	   AS N_Tax_Value_Scheduled
FROM T_Invoice_Child_Detail ICD
INNER JOIN T_Receipt_Component_Detail RCD ON ICD.I_Invoice_Detail_ID = RCD.I_Invoice_Detail_ID
INNER JOIN T_Receipt_Header RH ON RCD.I_Receipt_Detail_ID = RH.I_Receipt_Header_ID
WHERE RH.I_Receipt_Header_ID = @iReceiptID
AND RCD.N_Amount_Paid > 0
AND CONVERT(DATE, RH.Dt_Receipt_Date) < CONVERT(DATE, ICD.Dt_Installment_Date)
GROUP BY RCD.I_Receipt_Comp_Detail_ID, ICD.S_Invoice_Number, RCD.N_Amount_Paid) AS INV
GROUP BY TAG_ROW, S_Invoice_Number
END
