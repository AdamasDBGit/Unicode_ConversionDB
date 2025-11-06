CREATE PROCEDURE [dbo].[uspFTBatchGetOwnCenterInvoiceDetails]
	@iCenterID INT,
	@dtReportStartDate DATETIME,
	@dtReportEndDate DATETIME
 
AS
BEGIN

	SELECT I_Invoice_Header_ID,S_Invoice_No,N_Invoice_Amount,Dt_Invoice_Date
	FROM dbo.T_Invoice_Parent
	WHERE I_Centre_Id = @iCenterID
		AND Dt_Invoice_Date >= @dtReportStartDate
		AND Dt_Invoice_Date <= @dtReportEndDate
		AND I_Status = 1
	ORDER BY I_Invoice_Header_ID

	SELECT I_Invoice_Child_Header_ID,I_Course_ID,N_Amount,N_Tax_Amount
	FROM dbo.T_Invoice_Child_Header
		WHERE I_Invoice_Header_ID IN 
		(SELECT I_Invoice_Header_ID
		FROM dbo.T_Invoice_Parent
		WHERE I_Centre_Id = @iCenterID
		AND Dt_Invoice_Date >= @dtReportStartDate
		AND Dt_Invoice_Date <= @dtReportEndDate
		AND I_Status = 1)

	SELECT I_Invoice_Detail_ID,I_Fee_Component_ID,I_Installment_No,
		Dt_Installment_Date,N_Amount_Due,I_Sequence
	FROM dbo.T_Invoice_Child_Detail
	WHERE I_Invoice_Child_Header_ID IN
		(SELECT I_Invoice_Child_Header_ID
		FROM dbo.T_Invoice_Child_Header
		WHERE I_Invoice_Header_ID IN 
		(SELECT I_Invoice_Header_ID
		FROM dbo.T_Invoice_Parent
		WHERE I_Centre_Id = @iCenterID
		AND Dt_Invoice_Date >= @dtReportStartDate
		AND Dt_Invoice_Date <= @dtReportEndDate
		AND I_Status = 1))

	SELECT ITD.*,TM.S_Tax_Code 
	FROM dbo.T_Invoice_Detail_Tax ITD
	INNER JOIN dbo.T_Tax_Master TM
	ON ITD.I_Tax_ID = TM.I_Tax_ID
	WHERE I_Invoice_Detail_ID IN
		(SELECT I_Invoice_Detail_ID
		FROM dbo.T_Invoice_Child_Detail
		WHERE I_Invoice_Child_Header_ID IN
		(SELECT I_Invoice_Child_Header_ID
		FROM dbo.T_Invoice_Child_Header
		WHERE I_Invoice_Header_ID IN 
		(SELECT I_Invoice_Header_ID
		FROM dbo.T_Invoice_Parent
		WHERE I_Centre_Id = @iCenterID
		AND Dt_Invoice_Date >= @dtReportStartDate
		AND Dt_Invoice_Date <= @dtReportEndDate
		AND I_Status = 1)))

END
