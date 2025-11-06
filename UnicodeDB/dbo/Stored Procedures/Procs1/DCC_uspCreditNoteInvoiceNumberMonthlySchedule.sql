
-- select * from T_Invoice_Sequence_Number

-- exec DCC_uspCreditNoteInvoiceNumberMonthlySchedule '2017-12-01 00:00:00.000'

CREATE PROCEDURE [dbo].[DCC_uspCreditNoteInvoiceNumberMonthlySchedule]
(
@FromDate AS DateTime
,@ToDate AS DateTime
)
AS
BEGIN
 
	CREATE TABLE #TempC
	(
		ID INT IDENTITY(1,1),
		I_Invoice_Header_ID INT,
		Dt_Installment_Date DATETIME,
		Dt_Ct_Date DATETIME,
		I_Invoice_Detail_ID INT,
		I_Installment_No INT,
		InvoiceType VARCHAR(50)
	)

	--DECLARE @Month INT
	--DECLARE @Year INT


	--SET @Month = DATEPART(M,@FromDate)
	--SET @Year = DATEPART(YY,@FromDate)


	--Update c SEt c.S_Invoice_Number=NULL From 
	--T_Credit_Note_Invoice_Child_Detail as c Inner Join T_Invoice_Child_Detail as h 
	--on c.I_Invoice_Detail_ID=h.I_Invoice_Detail_ID   
	--WHERE (CASE WHEN h.Dt_Installment_Date >= c.Dt_Crtd_On THEN 
	--h.Dt_Installment_Date ELSE c.Dt_Crtd_On
	-- END)>= DATEADD(month,@Month-1,DATEADD(year,@Year-1900,0))
	--AND  (CASE WHEN h.Dt_Installment_Date > c.Dt_Crtd_On THEN 
	--h.Dt_Installment_Date ELSE c.Dt_Crtd_On
	-- END) < DATEADD(DAY,1,DATEADD(day,-1,DATEADD(month,@Month,DATEADD(year,@Year-1900,0))))

	Update c SEt c.S_Invoice_Number=NULL From 
	T_Credit_Note_Invoice_Child_Detail as c Inner Join T_Invoice_Child_Detail as h 
	on c.I_Invoice_Detail_ID=h.I_Invoice_Detail_ID   
	WHERE (CASE WHEN h.Dt_Installment_Date >= c.Dt_Crtd_On THEN 
	h.Dt_Installment_Date ELSE c.Dt_Crtd_On
	 END)>= @FromDate
	AND  (CASE WHEN h.Dt_Installment_Date > c.Dt_Crtd_On THEN 
	h.Dt_Installment_Date ELSE c.Dt_Crtd_On
	 END) < DateAdd(d,1,@ToDate)


	INSERT INTO #TempC

	
	SELECT 
		IP.I_Invoice_Header_ID,
		ICD.Dt_Installment_Date,
		c.Dt_Crtd_On,
		--(CASE WHEN CAST(ICD.Dt_Installment_Date AS Date)>CAST(c.Dt_Crtd_On AS Date) Then ICD.Dt_Installment_Date ELSE c.Dt_Crtd_On END) AS Installment_Date,
		ICD.I_Invoice_Detail_ID,
		ICD.I_Installment_No
		,'C'
		--,CASE WHEN ICD.Flag_IsAdvanceTax IS NOT NULL AND ICD.Flag_IsAdvanceTax = 'Y' THEN 'A'
		--ELSE 'I' END
	FROM T_Invoice_Parent AS IP
	INNER JOIN T_Invoice_Child_Header AS ICH
	ON IP.I_Invoice_Header_ID = ICH.I_Invoice_Header_ID
	INNER JOIN T_Invoice_Child_Detail AS ICD
	ON ICH.I_Invoice_Child_Header_ID = ICD.I_Invoice_Child_Header_ID
	Inner Join T_Credit_Note_Invoice_Child_Detail as c 
	on c.I_Invoice_Detail_ID=ICD.I_Invoice_Detail_ID
	--WHERE ICD.Dt_Installment_Date >= DATEADD(month,@Month-1,DATEADD(year,@Year-1900,0))
	--AND ICD.Dt_Installment_Date < DATEADD(DAY,1,DATEADD(day,-1,DATEADD(month,@Month,DATEADD(year,@Year-1900,0)))) 

	WHERE (CASE WHEN ICD.Dt_Installment_Date > c.Dt_Crtd_On THEN 
	ICD.Dt_Installment_Date ELSE c.Dt_Crtd_On
	 END)>= @FromDate
	AND  (CASE WHEN ICD.Dt_Installment_Date > c.Dt_Crtd_On THEN 
	ICD.Dt_Installment_Date ELSE c.Dt_Crtd_On
	 END) < DateAdd(d,1,@ToDate)
	 
	--Order By (CASE WHEN ICD.Dt_Installment_Date>c.Dt_Crtd_On Then ICD.Dt_Installment_Date ELSE c.Dt_Crtd_On END),IP.I_Invoice_Header_ID ASC
	--Order By ICD.Dt_Installment_Date,IP.I_Invoice_Header_ID ASC
	Order By c.Dt_Crtd_On,IP.I_Invoice_Header_ID ASC


	DECLARE @row INT = 1
	DECLARE @count INT
	SELECT @count = COUNT(ID) FROM #TempC

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
		FROM #TempC
		WHERE ID = @row
		
		--EXEC dbo.DCC_uspGenerateInvoiceNumberForCreditNote  @I_Invoice_Header_ID,@I_Installment_No,@Dt_Installment_Date, @INVN OUTPUT	
		--UPDATE T_Credit_Note_Invoice_Child_Detail SET S_Invoice_Number = @INVN WHERE I_Invoice_Detail_ID = @I_Invoice_Detail_ID

		DECLARE @ISNullCheck AS Nvarchar(max)

		SET @ISNullCheck=IsNull((Select distinct c.S_Invoice_Number From T_Invoice_Child_Detail as d 
		Inner Join T_Credit_Note_Invoice_Child_Detail as c 
		on c.I_Invoice_Detail_ID=d.I_Invoice_Detail_ID WHERE 
		c.I_Invoice_Detail_ID = @I_Invoice_Detail_ID and d.Dt_Installment_Date=@Dt_Installment_Date AND d.I_Installment_No=@I_Installment_No),'')


		if(IsNull(@ISNullCheck,'')='')
		BEGIN
		--EXEC dbo.DCC_uspGenerateInvoiceNumberForCreditNote  @I_Invoice_Header_ID,@I_Installment_No,@Dt_Installment_Date, @INVN OUTPUT
		EXEC dbo.DCC_uspGenerateInvoiceNumberForCreditNote  @I_Invoice_Header_ID,@I_Installment_No,@FromDate, @INVN OUTPUT
		UPDATE c SET c.S_Invoice_Number = @INVN from
		T_Invoice_Parent AS IP
		INNER JOIN T_Invoice_Child_Header AS ICH
		ON IP.I_Invoice_Header_ID = ICH.I_Invoice_Header_ID
		INNER JOIN T_Invoice_Child_Detail AS ICD
		ON ICH.I_Invoice_Child_Header_ID = ICD.I_Invoice_Child_Header_ID
		Inner Join T_Credit_Note_Invoice_Child_Detail as c 
		on c.I_Invoice_Detail_ID=ICD.I_Invoice_Detail_ID
		--WHERE I_Invoice_Detail_ID = @I_Invoice_Detail_ID
		WHERE IP.I_Invoice_Header_ID = @I_Invoice_Header_ID 
		and ICD.Dt_Installment_Date=@Dt_Installment_Date 
		--and c.Dt_Crtd_On=@Dt_Installment_Date 
		and ICD.I_Installment_No=@I_Installment_No
		END		


	SET @row = @row + 1
	END
	DROP TABLE #TempC
	
END
