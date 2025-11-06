
CREATE PROCEDURE [dbo].[uspGetOldInvoiceReceiptWithRmainAmount] --exec uspGetOldInvoiceReceiptWithRmainAmount 166273
(
	@InvoiceHeaderId INT = NULL	
)
	
AS
BEGIN
	SET NOCOUNT ON;
	SELECT B.I_Invoice_Detail_ID, B.I_Fee_Component_ID, 
		   CASE WHEN CONVERT(DATE, GETDATE()) >= CONVERT(DATE, B.Dt_Installment_Date) THEN 1
			ELSE B.I_Installment_No
		END I_Installment_No
		,CASE WHEN CONVERT(DATE, GETDATE()) >= CONVERT(DATE, B.Dt_Installment_Date) THEN DATEADD(d,DATEDIFF(d,0,getdate()),0)
			 ELSE B.Dt_Installment_Date
		END Dt_Installment_Date,
		(ISNULL(B.N_Amount_Due,0.00) - ISNULL(A.N_Amount_Paid,0.00)) N_Amount_Due,
		0 N_Amount_Paid
	FROM (SELECT ICD.I_Invoice_Detail_ID, ICD.I_Invoice_Child_Header_ID, ICH.I_Course_FeePlan_ID, ICD.I_Fee_Component_ID, ICD.I_Installment_No, ICD.Dt_Installment_Date, ICD.N_Amount_Due
	FROM T_Invoice_Child_Detail ICD 
	INNER JOIN T_Invoice_Child_Header ICH ON ICD.I_Invoice_Child_Header_ID = ICH.I_Invoice_Child_Header_ID
	INNER JOIN T_Invoice_Parent IP ON ICH.I_Invoice_Header_ID = IP.I_Invoice_Header_ID 
	WHERE IP.I_Invoice_Header_ID = @InvoiceHeaderId 
	--and ICD.Dt_Installment_Date>GETDATE()
	AND ISNULL(ICD.Flag_IsAdvanceTax,'N') <> 'Y') B
	LEFT JOIN 
	(SELECT RCD.I_Invoice_Detail_ID, SUM(ISNULL(RCD.N_Amount_Paid,0)) N_Amount_Paid
	FROM T_Receipt_Header RH
	INNER JOIN T_Receipt_Component_Detail RCD ON RH.I_Receipt_Header_ID = RCD.I_Receipt_Detail_ID
	WHERE RH.I_Invoice_Header_ID = @InvoiceHeaderId
	AND ISNULL(RH.I_Status,0) <> 0
	GROUP BY RCD.I_Invoice_Detail_ID) A	ON B.I_Invoice_Detail_ID = A.I_Invoice_Detail_ID
	INNER JOIN T_Invoice_Child_Header ICH1 ON B.I_Invoice_Child_Header_ID = ICH1.I_Invoice_Child_Header_ID
	AND (ISNULL(B.N_Amount_Due,0.00) - ISNULL(A.N_Amount_Paid,0.00)) > 0
	ORDER BY B.I_Installment_No
END
