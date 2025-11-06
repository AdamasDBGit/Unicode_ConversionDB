CREATE FUNCTION [REPORT].[fnGetLastInstallmentForReports]
(
	@I_Invoice_Header_ID INT,
	@I_Course_ID INT
)
RETURNS  @rtnTable TABLE
(
	Invoice_Header_ID INT,
	Course_ID INT,
	LastPaymentAmt NUMERIC(18,2),
	LastPaymentDate DATETIME
)

AS 
-- Returns the Table containing the center details.
BEGIN

	DECLARE @I_Invoice_Child_Header_ID INT
	DECLARE @I_Receipt_Header_ID INT
	DECLARE @Amount_Paid NUMERIC(18,2)
	DECLARE @Tax_Paid NUMERIC(18,2)
	DECLARE @LastPaymentAmt NUMERIC(18,2)
	DECLARE @LastPaymentDate DATETIME

	SELECT @I_Invoice_Child_Header_ID=I_Invoice_Child_Header_ID
	   FROM dbo.T_Invoice_Child_Header
	  WHERE I_Invoice_Header_ID=@I_Invoice_Header_ID
		AND I_Course_ID=@I_Course_ID

	 SELECT @LastPaymentDate=MAX(Dt_Receipt_Date) 
	   FROM dbo.T_Receipt_Header
	  WHERE I_Invoice_Header_ID= @I_Invoice_Header_ID

	 SELECT @I_Receipt_Header_ID=I_Receipt_Header_ID
	   FROM dbo.T_Receipt_Header
	  WHERE I_Invoice_Header_ID= @I_Invoice_Header_ID
		AND Dt_Receipt_Date=@LastPaymentDate

	 SELECT @Amount_Paid=SUM(ISNULL(N_Amount_Paid,0.00)),
			@Tax_Paid=SUM(ISNULL(N_Tax_Paid,0.00))
	   FROM dbo.T_Invoice_Child_Detail ICD,
			dbo.T_Receipt_Component_Detail RCD
			LEFT OUTER JOIN dbo.T_Receipt_Tax_Detail RTD
			ON RCD.I_Receipt_Comp_Detail_ID=RTD.I_Receipt_Comp_Detail_ID
	  WHERE ICD.I_Invoice_Child_Header_ID=@I_Invoice_Child_Header_ID
		AND ICD.I_Invoice_Detail_ID=RCD.I_Invoice_Detail_ID
		AND RCD.I_Receipt_Detail_ID=@I_Receipt_Header_ID

	SET @LastPaymentAmt=@Amount_Paid + @Tax_Paid

	INSERT INTO @rtnTable
		SELECT	@I_Invoice_Header_ID,
				@I_Course_ID,
				@LastPaymentAmt,
				@LastPaymentDate

	RETURN;

END