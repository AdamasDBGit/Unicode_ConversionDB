CREATE PROCEDURE [dbo].[uspGetInstallmentDetails]
	@iInvoiceHeaderID INT

AS
BEGIN
SET NOCOUNT ON
	DECLARE @TempTable TABLE
	(
		ID INT IDENTITY(1,1),
		I_Invoice_Detail_ID INT,
		I_Installment_No INT,
		Dt_Installment_Date DateTime,
		N_Amount_Due Numeric(18,2),
		N_Amount_Paid Numeric(18,2)
	)		

	INSERT INTO @TempTable
	(I_Invoice_Detail_ID,I_Installment_No,Dt_Installment_Date,N_Amount_Due,N_Amount_Paid)	
	SELECT ICD.I_Invoice_Detail_ID,
	ICD.I_Installment_No,
	ICD.Dt_Installment_Date,
	ICD.N_Amount_Due,
	(SELECT SUM(ISNULL(N_Amount_Paid,0)) FROM dbo.T_Receipt_Component_Detail WHERE I_Invoice_Detail_ID = ICD.I_Invoice_Detail_ID
	 AND I_Receipt_Detail_ID NOT IN (SELECT I_Receipt_Header_ID from T_Receipt_header where I_Invoice_Header_ID = @iInvoiceHeaderID and i_status=0
	))
	FROM T_Invoice_Child_Detail ICD
	INNER JOIN T_Invoice_Child_Header ICH
	ON ICH.I_Invoice_Child_Header_ID = ICD.I_Invoice_Child_Header_ID 
	WHERE I_Invoice_Header_ID = @iInvoiceHeaderID

	SELECT distinct I_Installment_No,Dt_Installment_Date,SUM(N_Amount_Due) AS N_Amount_Due,SUM(ISNULL(N_Amount_Paid,0)) AS N_Amount_Paid
	FROM @TempTable
	GROUP BY I_Installment_No,Dt_Installment_Date

END
