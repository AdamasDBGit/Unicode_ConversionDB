CREATE PROCEDURE [dbo].[uspSelectReceiptsforFT]
(
	@iCenterID int,
	@dtDateFrom DATETIME,
	@dtDateTo DATETIME
)
AS 
--[dbo].[uspSelectReceiptsforFT] 111,'5/1/2008','5/25/2008'
BEGIN

	SET NOCOUNT ON
	
	DECLARE @tblTemp TABLE
	(
		[ID] int identity(1,1),
		I_ReceiptHeaderId int,
		S_ReceiptNo varchar(20),
		N_ReceiptAmount numeric(18,2),
		N_ReceiptTaxAmount numeric(18,2),
		Dt_ReceiptDate datetime,
		I_InvoiceId int,
		S_InvoiceNo varchar(50),
		I_StudentId int,
		S_Title varchar(10),
		S_FirstName varchar(50),
		S_MiddleName varchar(50),
		S_LastName varchar(50),
		I_PaymentModeId int,
		I_ReceiptType int,
		I_Status INT
	)
	
	DECLARE @tblFC TABLE
	(
		[FC_ID] int identity(1,1),	
		I_ReceiptHeaderId int,
		I_InvoiceDetailId int,
		I_FeeComponentId int,
		S_FeeComponent_Name varchar(50),
		N_Amount numeric(18,0)
	)
	
	INSERT INTO @tblTemp
	(I_ReceiptHeaderId,S_ReceiptNo,N_ReceiptAmount,N_ReceiptTaxAmount,I_StudentId,S_Title,S_FirstName,S_MiddleName,S_LastName,I_InvoiceId,I_PaymentModeId,Dt_ReceiptDate,I_ReceiptType,I_Status)
	
	SELECT 
	RH.I_Receipt_Header_ID,
	RH.S_Receipt_No,
	RH.N_Receipt_Amount,
	RH.N_Tax_Amount,
	RH.I_Student_Detail_ID,
	TSD.S_Title,
	TSD.S_First_Name,
	TSD.S_Middle_Name,
	TSD.S_Last_Name,
	RH.I_Invoice_Header_ID,
	RH.I_PaymentMode_ID,
	RH.Dt_Receipt_Date,
	RH.I_Receipt_Type,
	1
	FROM dbo.T_Receipt_Header RH
	LEFT OUTER JOIN dbo.T_Student_Detail TSD 
	ON RH.I_Student_Detail_ID=TSD.I_Student_Detail_ID
	WHERE 
	RH.I_Centre_Id=@iCenterID AND 
	RH.S_Fund_Transfer_Status='N' AND 
	RH.I_Status=1 AND 
	RH.Dt_Receipt_Date between @dtDateFrom AND @dtDateTo
	
	UNION
	
	SELECT 
	RH.I_Receipt_Header_ID,
	RH.S_Receipt_No,
	RH.N_Receipt_Amount,
	RH.N_Tax_Amount,
	RH.I_Student_Detail_ID,
	TSD.S_Title,
	TSD.S_First_Name,
	TSD.S_Middle_Name,
	TSD.S_Last_Name,
	RH.I_Invoice_Header_ID,
	RH.I_PaymentMode_ID,
	RH.Dt_Receipt_Date,
	RH.I_Receipt_Type,
	0
	FROM 
	dbo.T_Receipt_Header RH 
	LEFT OUTER JOIN dbo.T_Student_Detail TSD 
	ON RH.I_Student_Detail_ID=TSD.I_Student_Detail_ID
	WHERE 
	RH.I_Status=0 AND 
	RH.I_Centre_Id=@iCenterID AND 
	RH.S_Fund_Transfer_Status='Y'



	UPDATE @tblTemp
	SET S_Title = A.S_Title,
	S_FirstName = A.S_First_Name,
	S_MiddleName = A.S_Middle_Name,
	S_LastName = A.S_Last_Name
	FROM dbo.T_Enquiry_Regn_Detail A
	WHERE A.I_Enquiry_Regn_ID in
	(
		SELECT I_Enquiry_Regn_ID FROM dbo.T_Receipt_Header WHERE I_Receipt_Header_ID = I_ReceiptHeaderId
	) 
	AND I_ReceiptType=1

	UPDATE TT
	SET TT.S_InvoiceNo=TIH.S_Invoice_No
	FROM @tblTemp TT,dbo.T_Invoice_Parent TIH
	WHERE TT.I_InvoiceId=TIH.I_Invoice_Header_ID

	SELECT I_ReceiptHeaderId, S_ReceiptNo,Dt_ReceiptDate,ISNULL(N_ReceiptAmount,0) AS N_ReceiptAmount,ISNULL(N_ReceiptTaxAmount,0) AS N_ReceiptTaxAmount,ISNULL(I_InvoiceId,0) AS I_InvoiceId,S_InvoiceNo,ISNULL(I_StudentId,0) AS I_StudentId,S_Title,S_FirstName

	,S_MiddleName,S_LastName,I_PaymentModeId,I_ReceiptType,I_Status
	FROM @tblTemp ORDER BY I_ReceiptHeaderId

	INSERT INTO @tblFC(I_ReceiptHeaderId,I_InvoiceDetailId,I_FeeComponentId,S_FeeComponent_Name,N_Amount)
	SELECT 
	RCD.I_Receipt_Detail_ID as I_ReceiptHeaderId,
	RCD.I_Invoice_Detail_ID as I_InvoiceDetailId,
	TICD.I_Fee_Component_ID as I_FeeComponentId,
	TFCM.S_Component_Name as S_FeeComponent_Name,
	SUM(ISNULL(RCD.N_Amount_Paid,0)) as N_Amount
	FROM 
	dbo.T_Receipt_Component_Detail RCD 
	INNER JOIN dbo.T_Invoice_Child_Detail TICD ON RCD.I_Invoice_Detail_ID=TICD.I_Invoice_Detail_ID
	INNER JOIN dbo.T_Fee_Component_Master TFCM ON TICD.I_Fee_Component_ID=TFCM.I_Fee_Component_ID
	INNER JOIN @tblTemp TT ON TT.I_ReceiptHeaderId=RCD.I_Receipt_Detail_ID
	GROUP BY
	RCD.I_Receipt_Detail_ID,
	RCD.I_Invoice_Detail_ID,
	TICD.I_Fee_Component_ID,
	TFCM.S_Component_Name
	
	SELECT * FROM @tblFC 

END
