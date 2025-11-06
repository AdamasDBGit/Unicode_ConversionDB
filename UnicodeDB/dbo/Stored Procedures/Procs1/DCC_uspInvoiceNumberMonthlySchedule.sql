
-- select * from T_Invoice_Sequence_Number

-- exec DCC_uspInvoiceNumberMonthlySchedule '2017-12-01 00:00:00.000'

CREATE PROCEDURE [dbo].[DCC_uspInvoiceNumberMonthlySchedule]
(
@FromDate AS DateTime
,@ToDate AS DateTime
)
AS
BEGIN
	


	CREATE TABLE #Temp
	(
		ID INT IDENTITY(1,1),
		I_Invoice_Header_ID INT,
		Dt_Installment_Date DATETIME,
		I_Invoice_Detail_ID INT,
		I_Installment_No INT,
		InvoiceType VARCHAR(50)
	)

	DECLARE @Month INT
	DECLARE @Year INT

	SET @Month = DATEPART(M,@FromDate)
	SET @Year = DATEPART(YYYY,@FromDate)


	Update T_Invoice_Child_Detail SEt S_Invoice_Number=NULL where 
	Dt_Installment_Date >= @FromDate
	AND Dt_Installment_Date < DateAdd(d,1,@ToDate) 
	and I_Installment_No>0 
	--AND I_Invoice_Child_Header_ID in(215687,215384)

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
	WHERE ICD.Dt_Installment_Date >= @FromDate
	AND ICD.Dt_Installment_Date < DateAdd(d,1,@ToDate) 
	--AND ICD.I_Invoice_Child_Header_ID in(215687,215384)
	AND ICD.I_Installment_No>0
	ORDER by ICD.Dt_Installment_Date,IP.I_Invoice_Header_ID ASC
	--AND ICD.S_Invoice_Number LIKE 'TEMP%'
	

	DECLARE @row INT = 1
	DECLARE @count INT
	SELECT @count = COUNT(ID) FROM #Temp

	DECLARE @I_Invoice_Header_ID INT,
		@Dt_Installment_Date DATETIME,
		@I_Invoice_Detail_ID INT,
		@I_Installment_No INT,
		@InvoiceType VARCHAR(50)

	DECLARE @INVN VARCHAR(256)

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
		--and @Dt_Installment_Date=Dt_Installment_Date
		

		--EXEC dbo.DCC_uspGenerateInvoiceNumberPerMonth  @I_Invoice_Header_ID,@I_Installment_No,@Dt_Installment_Date,@InvoiceType, @INVN OUTPUT
		--UPDATE T_Invoice_Child_Detail SET S_Invoice_Number = @INVN WHERE I_Invoice_Detail_ID = @I_Invoice_Detail_ID


		DECLARE @ISNullCheck AS Nvarchar(max)

		SET @ISNullCheck=IsNull((Select S_Invoice_Number From T_Invoice_Child_Detail WHERE 
		I_Invoice_Detail_ID = @I_Invoice_Detail_ID and Dt_Installment_Date=@Dt_Installment_Date AND I_Installment_No=@I_Installment_No),'')

		if(IsNull(@ISNullCheck,'')='')
		BEGIN
		EXEC dbo.DCC_uspGenerateInvoiceNumberPerMonth  @I_Invoice_Header_ID,@I_Installment_No,@Dt_Installment_Date,@InvoiceType, @INVN OUTPUT		
			
		--UPDATE T_Invoice_Child_Detail SET S_Invoice_Number = @INVN WHERE I_Invoice_Detail_ID = @I_Invoice_Detail_ID
		UPDATE ICD SET ICD.S_Invoice_Number = @INVN from
		T_Invoice_Parent AS IP
		INNER JOIN T_Invoice_Child_Header AS ICH
		ON IP.I_Invoice_Header_ID = ICH.I_Invoice_Header_ID
		INNER JOIN T_Invoice_Child_Detail AS ICD
		ON ICH.I_Invoice_Child_Header_ID = ICD.I_Invoice_Child_Header_ID
		--WHERE I_Invoice_Detail_ID = @I_Invoice_Detail_ID
		WHERE IP.I_Invoice_Header_ID = @I_Invoice_Header_ID 
		and icd.Dt_Installment_Date=@Dt_Installment_Date 
		and ICD.I_Installment_No=@I_Installment_No
		END


	SET @row = @row + 1
	END
	DROP TABLE #Temp
	
END
