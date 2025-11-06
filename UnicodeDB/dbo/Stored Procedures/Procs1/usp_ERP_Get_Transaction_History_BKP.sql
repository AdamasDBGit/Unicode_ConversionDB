

-- =============================================
-- Author:		<Susmita Paul>
-- Create date: <2024-June-05>
-- Description:	<Get Transaction History>
-- =============================================
CREATE   PROCEDURE [dbo].[usp_ERP_Get_Transaction_History_BKP]
	-- Add the parameters for the stored procedure here
	@sStudentID NVARCHAR(MAX)=NULL,
	@dtValidFrom datetime =NULL,
	@dtValidTo datetime= NULL,
	@BrandID INT=NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	

		Create Table #Transaction_History
	(
	ID INT IDENTITY(1,1),
	StudentID varchar(max),
	S_First_Name varchar(max),
	S_Middle_Name varchar(max),
	S_Last_Name varchar(max),
	EnquiryNo varchar(max),
	ReceiptHeaderID INT,
	ReceiptNo INT,
	ReceiptType varchar(max),
	TransactionNo varchar(max),
	PaymentMethod varchar(max),
	PaymentMode varchar(max),
	SMSPaymentModeID INT,
	SMSPaymentMode varchar(max),
	isAdhoc bit,
	AdhocInvoiceNo varchar(max),
	TransactionDate datetime,
	ReceiptDate datetime,
	TotalTransactionAmount decimal(8,2),
	AmountBreakupReceiptWise decimal(8,2),
	TaxBreakupReceiptWise decimal(8,2),
	PaymentStatus INT,
	ReceiptStatus INT,
	SattlementDate datetime,
	SattlementBankAccount varchar(max),
	PaymnentGatewayID INT,
	BrandID INT,
	ExternalPurchasedMobileNo varchar(max)
	)


		DECLARE @PaymentStatusTable TABLE 
(
	PaymentStatusID INT,
    StatusDescription VARCHAR(255),
    StatusColour VARCHAR(255)
);

---- Step 2: Insert the function result into the table variable
INSERT INTO @PaymentStatusTable
SELECT * 
FROM dbo.usp_ERP_GetTransactionStatus(NULL, NULL);

	--select * from @PaymentStatusTable

------------- OffLine + Online --------------

INSERT INTO #Transaction_History
(
    StudentID,
    S_First_Name,
    S_Middle_Name,
    S_Last_Name,
    EnquiryNo,
    ReceiptHeaderID,
    ReceiptNo,
    ReceiptType,
    TransactionNo,
    PaymentMethod,
    PaymentMode,
    SMSPaymentModeID,
    SMSPaymentMode,
    isAdhoc,
    AdhocInvoiceNo,
    TransactionDate,
    ReceiptDate,
    TotalTransactionAmount,
    AmountBreakupReceiptWise,
    TaxBreakupReceiptWise,
    PaymentStatus,
    ReceiptStatus,
    SattlementDate,
    SattlementBankAccount,
	PaymnentGatewayID,
	BrandID,
	ExternalPurchasedMobileNo
)
SELECT 
    DISTINCT
    SD.S_Student_ID,
    SD.S_First_Name,
    SD.S_Middle_Name,
    SD.S_Last_Name,
    SD.I_Enquiry_Regn_ID,
    RH.I_Receipt_Header_ID,
    RH.S_Receipt_No,
    RT.S_Status_Desc,
    TM.I_ERP_TransactionNo,
    CASE
        WHEN TID.I_ERP_Transaction_Master_ID IS NULL THEN 'Offline'
        ELSE 'Online'
    END AS PaymentMethod,
    CASE 
        WHEN TID.I_ERP_Transaction_Master_ID IS NULL THEN PMM.S_PaymentMode_Name 
        ELSE TM.S_TransactionMode 
    END AS PaymentMode,
    PMM.I_PaymentMode_ID AS SMSPaymentModeID,
    PMM.S_PaymentMode_Name AS SMSPaymentMode,
    CASE 
        WHEN IOD.I_OnAccount_Ivoice_ID IS NOT NULL OR RH.I_Invoice_Header_ID IS NOT NULL THEN 'false'
        ELSE 'true' 
    END AS isAdhoc,
    IOD.S_Invoice_Number,
    TM.Dt_TransactionDate,
    RH.Dt_Receipt_Date,
    TM.I_TransactionTotalAmount,
    RH.N_Receipt_Amount,
    RH.N_Tax_Amount,
    CASE 
        WHEN TM.S_TransactionStatus = 'Initiated' THEN 1
        WHEN TM.S_TransactionStatus = 'Initiated' AND DATEDIFF(MINUTE, TM.Dt_TransactionDate, GETDATE()) > 60 THEN 2
        WHEN TM.S_TransactionStatus = 'Success' THEN 3
        WHEN TM.S_TransactionStatus = 'Failure' THEN 4 
		WHEN TM.S_TransactionStatus IS NULL AND RH.I_Receipt_Header_ID IS NOT NULL THEN 3
        ELSE NULL
    END AS ExternalPaymentStatus,
    RH.I_Status,
    RH.Dt_Deposit_Date,
    RH.Bank_Account_Name,
	TM.I_ERP_Brand_PaymentGateway_Map_id,
	BCD.I_Brand_ID,
	TM.S_Mobile_No as ExternalPurchasedMobileNo
FROM 
    T_Receipt_Header  AS RH with (NOLOCK)
INNER JOIN 
    dbo.T_PaymentMode_Master PMM WITH (NOLOCK) ON RH.I_PaymentMode_ID = PMM.I_PaymentMode_ID
INNER JOIN 
    dbo.T_Status_Master RT WITH (NOLOCK) ON [S_Status_Type] = 'ReceiptType' AND RH.I_Receipt_Type = RT.I_Status_Value
INNER JOIN 
    dbo.T_Centre_Master CEM WITH (NOLOCK) ON RH.I_Centre_Id = CEM.I_Centre_Id
INNER JOIN 
    dbo.T_Brand_Center_Details AS BCD WITH (NOLOCK) ON CEM.I_Centre_Id = BCD.I_Centre_Id
INNER JOIN 
    dbo.T_Brand_Master AS BM WITH (NOLOCK) ON BCD.I_Brand_ID = BM.I_Brand_ID AND BM.I_Brand_ID = ISNULL(@BrandID, BM.I_Brand_ID)
INNER JOIN 
    dbo.T_Student_Detail AS SD WITH (NOLOCK) ON RH.I_Student_Detail_ID = SD.I_Student_Detail_ID OR RH.I_Enquiry_Regn_ID=SD.I_Enquiry_Regn_ID
LEFT JOIN 
    dbo.T_Invoice_OnAccount_Details AS IOD WITH (NOLOCK) ON IOD.I_Receipt_Header_ID = RH.I_Receipt_Header_ID
LEFT JOIN 
    T_ERP_Transaction_Invoice_Details AS TID ON TID.ReceiptHeaderID = RH.I_Receipt_Header_ID
LEFT JOIN 
    T_ERP_Transaction_Master AS TM ON TM.I_ERP_Transaction_Master_ID = TID.I_ERP_Transaction_Master_ID
WHERE 
    SD.S_Student_ID = ISNULL(@sStudentID, SD.S_Student_ID)
    AND (
        CONVERT(DATE, RH.Dt_Receipt_Date) BETWEEN CONVERT(DATE, @dtValidFrom) AND CONVERT(DATE, @dtValidTo)
		
    )
UNION
-- Failed Transactions ---
SELECT 
    DISTINCT
    SD.S_Student_ID,
    SD.S_First_Name,
    SD.S_Middle_Name,
    SD.S_Last_Name,
    SD.I_Enquiry_Regn_ID,
    NULL AS ReceiptHeaderID,
    NULL AS ReceiptNo,
    NULL AS ReceiptType,
    TM.I_ERP_TransactionNo,
    CASE
        WHEN TID.I_ERP_Transaction_Master_ID IS NULL THEN 'Offline'
        ELSE 'Online'
    END AS PaymentMethod,
    CASE 
        WHEN TID.I_ERP_Transaction_Master_ID IS NULL THEN NULL
        ELSE TM.S_TransactionMode 
    END AS PaymentMode,
    NULL AS SMSPaymentModeID,
    NULL AS SMSPaymentMode,
    NULL AS isAdhoc,
    NULL AS AdhocInvoiceNo,
    TM.Dt_TransactionDate,
    NULL AS ReceiptDate,
    TM.I_TransactionTotalAmount,
    0 AS AmountBreakupReceiptWise,
    0 AS TaxBreakupReceiptWise,
    CASE 
        WHEN TM.S_TransactionStatus = 'Initiated' THEN 1
        WHEN TM.S_TransactionStatus = 'Initiated' AND DATEDIFF(MINUTE, TM.Dt_TransactionDate, GETDATE()) > 60 THEN 2
        WHEN TM.S_TransactionStatus = 'Success' THEN 3
        WHEN TM.S_TransactionStatus = 'Failure' THEN 4 
        ELSE NULL
    END AS ExternalPaymentStatus,
    NULL AS ReceiptStatus,
    NULL AS SattlementDate,
    NULL AS SattlementBankAccount,
	TM.I_ERP_Brand_PaymentGateway_Map_id,
	TM.I_BrandID,
	TM.S_Mobile_No ExternalPurchasedMobileNo
FROM 
    T_ERP_Transaction_Invoice_Details AS TID 
INNER JOIN
    T_ERP_Transaction_Master AS TM ON TM.I_ERP_Transaction_Master_ID = TID.I_ERP_Transaction_Master_ID
INNER JOIN
    T_Invoice_Parent AS TIP ON TIP.I_Invoice_Header_ID = TID.I_Invoice_Header_ID
INNER JOIN
    T_Student_Detail AS SD ON SD.I_Student_Detail_ID = TIP.I_Student_Detail_ID
WHERE 
    TID.ReceiptHeaderID IS NULL 
    AND SD.S_Student_ID = ISNULL(@sStudentID, SD.S_Student_ID)
    AND (
        CONVERT(DATE, TM.Dt_TransactionDate) BETWEEN CONVERT(DATE, @dtValidFrom) AND CONVERT(DATE, @dtValidTo)
    );

	

	--select * from @PaymentStatusTable

	--select * from #Transaction_History

	select 
	TH.*,
	ExternalStatus.StatusDescription,
	ExternalStatus.StatusColour
	from 
	#Transaction_History as TH
	LEFT join
	@PaymentStatusTable as ExternalStatus on TH.PaymentStatus=ExternalStatus.PaymentStatusID

	drop table #Transaction_History

END

