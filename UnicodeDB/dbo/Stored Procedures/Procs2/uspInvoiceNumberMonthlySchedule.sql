CREATE PROCEDURE [dbo].[uspInvoiceNumberMonthlySchedule]
AS
BEGIN
	CREATE TABLE #Temp
	(
		ID INT IDENTITY(1,1),
		I_Invoice_Header_ID INT,
		Dt_Installment_Date DATETIME,
		I_Invoice_Detail_ID INT,
		I_Installment_No INT,
		InvoiceType nvarchar(max)
	)

	DECLARE @Month INT
	DECLARE @Year INT

	SET @Month = DATEPART(M,GETDATE())
	SET @Year = DATEPART(YYYY,GETDATE())

	INSERT INTO #Temp
	SELECT 
		IP.I_Invoice_Header_ID,
		ICD.Dt_Installment_Date,
		ICD.I_Invoice_Detail_ID,
		ICD.I_Installment_No,
		CASE WHEN ICD.Flag_IsAdvanceTax IS NOT NULL AND ICD.Flag_IsAdvanceTax = 'Y' THEN 'A'
		ELSE 'I' END
	FROM T_Invoice_Parent AS IP
	INNER JOIN T_Invoice_Child_Header AS ICH
	ON IP.I_Invoice_Header_ID = ICH.I_Invoice_Header_ID
	INNER JOIN T_Invoice_Child_Detail AS ICD
	ON ICH.I_Invoice_Child_Header_ID = ICD.I_Invoice_Child_Header_ID
	WHERE ICD.Dt_Installment_Date >= DATEADD(month,@Month-1,DATEADD(year,@Year-1900,0))
	AND ICD.Dt_Installment_Date < DATEADD(DAY,1,DATEADD(day,-1,DATEADD(month,@Month,DATEADD(year,@Year-1900,0))))
	AND ICD.S_Invoice_Number LIKE 'TEMP%'

	DECLARE @row INT = 1
	DECLARE @count INT
	SELECT @count = COUNT(ID) FROM #Temp

	DECLARE @I_Invoice_Header_ID INT,
		@Dt_Installment_Date DATETIME,
		@I_Invoice_Detail_ID INT,
		@I_Installment_No INT,
		@InvoiceType nvarchar(max)

	DECLARE @INVN nvarchar(max)

	WHILE (@row <= @count)
	BEGIN

		SELECT 
			@I_Invoice_Header_ID = I_Invoice_Header_ID,
			@Dt_Installment_Date = Dt_Installment_Date,
			@I_Invoice_Detail_ID = I_Invoice_Detail_ID,
			@I_Installment_No = I_Installment_No ,
			@InvoiceType = InvoiceType 
		FROM #Temp
		WHERE ID = @row

		IF EXISTS(
			SELECT * FROM T_Invoice_Child_Detail AS ICD		
			INNER JOIN T_Invoice_Parent AS IP
			ON ICD.I_Invoice_Child_Header_ID = IP.I_Invoice_Header_ID
			WHERE IP.I_Invoice_Header_ID = @I_Invoice_Header_ID 			
			AND	ICD.I_Installment_No = @I_Installment_No 
			AND ICD.S_Invoice_Number IS NOT NULL AND (ICD.Flag_IsAdvanceTax <> 'Y' OR ICD.Flag_IsAdvanceTax IS NULL)
			AND ICD.S_Invoice_Number NOT LIKE 'TEMP%'
		)
		BEGIN

			SELECT @INVN = S_Invoice_Number FROM
			T_Invoice_Child_Header AS ICH
			INNER JOIN T_Invoice_Child_Detail AS ICD			
			ON ICH.I_Invoice_Child_Header_ID = ICD.I_Invoice_Child_Header_ID
			INNER JOIN T_Invoice_Parent AS IP
			ON ICH.I_Invoice_Header_ID = IP.I_Invoice_Header_ID
			WHERE IP.I_Invoice_Header_ID = @I_Invoice_Header_ID 
			AND	ICD.I_Installment_No = @I_Installment_No 
			AND ICD.S_Invoice_Number IS NOT NULL
			AND ICD.S_Invoice_Number NOT LIKE 'TEMP%'
			
			 UPDATE T_Invoice_Child_Detail SET S_Invoice_Number = @INVN WHERE I_Invoice_Detail_ID = @I_Invoice_Detail_ID

		END
		ELSE
		BEGIN
						
			EXEC dbo.uspGenerateInvoiceNumberPerMonth  @I_Invoice_Header_ID,@I_Installment_No,@Dt_Installment_Date,@InvoiceType, @INVN OUTPUT		
			
			UPDATE T_Invoice_Child_Detail SET S_Invoice_Number = @INVN WHERE I_Invoice_Detail_ID = @I_Invoice_Detail_ID

		END
	SET @row = @row + 1
	END
	 
	DROP TABLE #Temp
	
END
