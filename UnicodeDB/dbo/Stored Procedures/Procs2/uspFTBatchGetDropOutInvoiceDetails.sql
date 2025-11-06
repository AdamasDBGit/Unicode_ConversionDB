CREATE PROCEDURE [dbo].[uspFTBatchGetDropOutInvoiceDetails] --1,'10/10/2007','1/1/2002'
	@iCenterID INT,
	@dtCurrentDate DATETIME,
	@dtReportStartDate DATETIME
 
AS
BEGIN

	CREATE TABLE #TEMPTABLE
	(
		ID INT IDENTITY(1,1),
		I_Invoice_Header_ID INT,	
		I_Course_ID INT,
		Dt_Dropout_Date DATETIME,
		N_Invoice_Amount NUMERIC(18,2),
		Dt_Course_Start_Date DATETIME,
		Dt_Course_Actual_End_Date DATETIME,
		N_Amount_Paid NUMERIC(18,2)
	)

	CREATE TABLE #tempTable1
	(
		I_Invoice_Header_ID INT,
		I_Tax_ID INT,
		N_Tax_Due NUMERIC(18,2)
	)
	

	INSERT INTO #TEMPTABLE (I_Invoice_Header_ID,I_Course_ID,Dt_Dropout_Date,N_Invoice_Amount,Dt_Course_Start_Date,
							Dt_Course_Actual_End_Date)
	SELECT IP.I_Invoice_Header_ID,SCD.I_Course_ID,DD.Dt_Dropout_Date,ISNULL(ICH.N_Amount,0),SCD.Dt_Course_Start_Date,
		ISNULL(SCD.Dt_Course_Actual_End_Date,ISNULL(SCD.Dt_Course_Expected_End_Date,@dtCurrentDate))		
	FROM dbo.T_Invoice_Parent IP
	INNER JOIN dbo.T_Invoice_Child_Header ICH
	ON IP.I_Invoice_Header_ID = ICH.I_Invoice_Header_ID
	INNER JOIN dbo.T_Student_Course_Detail SCD
	ON IP.I_Student_Detail_ID = SCD.I_Student_Detail_ID
	AND ICH.I_Course_ID = SCD.I_Course_ID
	INNER JOIN ACADEMICS.T_Dropout_Details DD
	ON SCD.I_Student_Detail_ID = DD.I_Student_Detail_ID
		AND DD.I_Center_Id = @iCenterID
		AND DD.I_Dropout_Status = 1
		AND DD.Dt_Dropout_Date <= @dtCurrentDate
		AND DD.Dt_Dropout_Date >= @dtReportStartDate	
	WHERE  IP.I_Status = 1	
	AND SCD.I_Status = 1
	AND ISNULL(SCD.Dt_Course_Actual_End_Date,ISNULL(SCD.Dt_Course_Expected_End_Date,@dtCurrentDate)) > 	@dtCurrentDate


	DECLARE @iCount INT
	DECLARE @iRowCount INT
	DECLARE @iInvoiceID INT
	DECLARE @iCourseID INT
	DECLARE @nAmountPaid NUMERIC(18,2)
	SELECT @iRowCount = count(ID) FROM #TEMPTABLE
	SET @iCount = 1

	WHILE (@iCount <= @iRowCount)
	BEGIN	
		SELECT @iInvoiceID = I_Invoice_Header_ID,@iCourseID = I_Course_ID FROM #TEMPTABLE 
		WHERE ID = @iCount
		
		SELECT @nAmountPaid = SUM(RCD.N_Amount_Paid)
		FROM dbo.T_Receipt_Component_Detail RCD
		INNER JOIN dbo.T_Invoice_Child_Detail ICD
		ON RCD.I_Invoice_Detail_ID = ICD.I_Invoice_Detail_ID
		INNER JOIN dbo.T_Invoice_Child_Header ICH
		ON ICD.I_Invoice_Child_Header_ID = ICH.I_Invoice_Child_Header_ID
		WHERE ICH.I_Invoice_Header_ID = @iInvoiceID
			AND ICH.I_Course_ID = @iCourseID
		
		UPDATE #TEMPTABLE SET N_Amount_Paid = @nAmountPaid
		WHERE ID = @iCount

		INSERT INTO #tempTable1
		SELECT @iInvoiceID,IDT.I_Tax_ID,SUM(IDT.N_Tax_Value)
		FROM dbo.T_Invoice_Detail_Tax IDT
		INNER JOIN dbo.T_Invoice_Child_Detail ICD
		ON IDT.I_Invoice_Detail_ID = ICD.I_Invoice_Detail_ID
		INNER JOIN dbo.T_Invoice_Child_Header ICH
		ON ICD.I_Invoice_Child_Header_ID = ICH.I_Invoice_Child_Header_ID
		WHERE ICH.I_Invoice_Header_ID = @iInvoiceID
		GROUP BY IDT.I_Tax_ID

		SET @iCount = @iCount + 1
	END

	SELECT * FROM #TEMPTABLE

	SELECT DISTINCT TT.* , Tax.S_Tax_Code
	FROM #tempTable1 TT
	INNER JOIN dbo.T_Tax_Master Tax
	ON TT.I_Tax_ID = Tax.I_Tax_ID

END
