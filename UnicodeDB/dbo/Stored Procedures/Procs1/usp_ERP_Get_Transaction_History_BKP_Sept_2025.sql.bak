
CREATE PROCEDURE [dbo].[usp_ERP_Get_Transaction_History_BKP_Sept_2025]      
    @sStudentID NVARCHAR(MAX) = NULL,      
    @dtValidFrom DATETIME = NULL,      
    @dtValidTo DATETIME = NULL,      
    @BrandID INT = NULL,      
    @receiptNo INT = NULL,      
    @iPaymentStatusID INT = NULL,    
    @iReceiptType INT = NULL,    
    @bIsAdhoc BIT = NULL ,  
 @sStudentName NVARCHAR(MAX) = NULL  
AS      
BEGIN      
    SET NOCOUNT ON;      
    
    CREATE TABLE #Transaction_History      
    (      
        ID INT IDENTITY(1,1),      
        StudentID VARCHAR(MAX),      
        S_First_Name VARCHAR(MAX),      
        S_Middle_Name VARCHAR(MAX),      
        S_Last_Name VARCHAR(MAX),      
        EnquiryNo VARCHAR(MAX),      
        ReceiptHeaderID INT,      
        ReceiptNo INT,      
        ReceiptType VARCHAR(MAX),      
        TransactionNo VARCHAR(MAX),      
        PaymentMethod VARCHAR(MAX),      
        PaymentMode VARCHAR(MAX),      
        SMSPaymentModeID INT,      
        SMSPaymentMode VARCHAR(MAX),      
        isAdhoc BIT,      
        AdhocInvoiceNo VARCHAR(MAX),      
        TransactionDate DATETIME,      
        ReceiptDate DATETIME,      
        TotalTransactionAmount DECIMAL(8,2),      
        AmountBreakupReceiptWise DECIMAL(8,2),      
        TaxBreakupReceiptWise DECIMAL(8,2),      
        PaymentStatus INT,      
        ReceiptStatus INT,      
        SattlementDate DATETIME,      
        SattlementBankAccount VARCHAR(MAX),      
        PaymnentGatewayID INT,      
        BrandID INT,      
        ExternalPurchasedMobileNo VARCHAR(MAX),      
        OrderID VARCHAR(MAX),      
        ReceiptStatusType VARCHAR(MAX)      
    );      
    
    DECLARE @PaymentStatusTable TABLE       
    (      
        PaymentStatusID INT,      
        StatusDescription VARCHAR(255),      
        StatusColour VARCHAR(255)      
    );      
    
    INSERT INTO @PaymentStatusTable      
    SELECT * FROM dbo.usp_ERP_GetTransactionStatus(NULL, NULL);      
    
    -- Insert Offline + Online Transactions      
    INSERT INTO #Transaction_History      
    (    
        StudentID, S_First_Name, S_Middle_Name, S_Last_Name, EnquiryNo,    
        ReceiptHeaderID, ReceiptNo, ReceiptType, TransactionNo,    
        PaymentMethod, PaymentMode, SMSPaymentModeID, SMSPaymentMode,    
        isAdhoc, AdhocInvoiceNo, TransactionDate, ReceiptDate,    
        TotalTransactionAmount, AmountBreakupReceiptWise, TaxBreakupReceiptWise,    
        PaymentStatus, ReceiptStatus, SattlementDate, SattlementBankAccount,    
        PaymnentGatewayID, BrandID, ExternalPurchasedMobileNo, OrderID, ReceiptStatusType    
    )      
    SELECT DISTINCT      
        SD.S_Student_ID, SD.S_First_Name, ISNULL(SD.S_Middle_Name,''), ISNULL(SD.S_Last_Name,''), SD.I_Enquiry_Regn_ID,      
        RH.I_Receipt_Header_ID, RH.S_Receipt_No, RT.S_Status_Desc, TM.I_ERP_TransactionNo,      
        CASE WHEN TID.I_ERP_Transaction_Master_ID IS NULL THEN 'Offline' ELSE 'Online' END,      
        CASE WHEN TID.I_ERP_Transaction_Master_ID IS NULL THEN PMM.S_PaymentMode_Name ELSE TM.S_TransactionMode END,      
        PMM.I_PaymentMode_ID, PMM.S_PaymentMode_Name,      
        CASE WHEN IOD.I_OnAccount_Ivoice_ID IS NOT NULL OR RH.I_Invoice_Header_ID IS NOT NULL THEN 0 ELSE 1 END,      
        IOD.S_Invoice_Number, TM.Dt_TransactionDate, RH.Dt_Receipt_Date,      
        TM.I_TransactionTotalAmount, RH.N_Receipt_Amount, RH.N_Tax_Amount,      
        CASE       
            WHEN TM.S_TransactionStatus = 'Initiated' AND DATEDIFF(MINUTE, TM.Dt_TransactionDate, GETDATE()) > 60 THEN 2      
            WHEN TM.S_TransactionStatus = 'Initiated' THEN 1      
            WHEN TM.S_TransactionStatus = 'Success' THEN 3      
            WHEN TM.S_TransactionStatus = 'Failure' THEN 4      
            WHEN TM.S_TransactionStatus IS NULL AND RH.I_Receipt_Header_ID IS NOT NULL THEN 3      
            ELSE NULL      
        END,      
        RH.I_Status, RH.Dt_Deposit_Date, RH.Bank_Account_Name,      
        TM.I_ERP_Brand_PaymentGateway_Map_id, BCD.I_Brand_ID,      
        TM.S_Mobile_No, TM.Order_ID,      
        CASE WHEN IOD.I_OnAccount_Ivoice_ID IS NOT NULL OR RH.I_Invoice_Header_ID IS NOT NULL THEN 'Scheduled' ELSE 'Adhoc' END      
    FROM T_Receipt_Header RH WITH (NOLOCK)      
    INNER JOIN dbo.T_PaymentMode_Master PMM WITH (NOLOCK) ON RH.I_PaymentMode_ID = PMM.I_PaymentMode_ID      
    INNER JOIN dbo.T_Status_Master RT WITH (NOLOCK) ON RT.S_Status_Type = 'ReceiptType' AND RH.I_Receipt_Type = RT.I_Status_Value      
    INNER JOIN dbo.T_Centre_Master CEM WITH (NOLOCK) ON RH.I_Centre_Id = CEM.I_Centre_Id      
    INNER JOIN dbo.T_Brand_Center_Details BCD WITH (NOLOCK) ON CEM.I_Centre_Id = BCD.I_Centre_Id      
    INNER JOIN dbo.T_Brand_Master BM WITH (NOLOCK) ON BCD.I_Brand_ID = BM.I_Brand_ID AND BM.I_Brand_ID = ISNULL(@BrandID, BM.I_Brand_ID)      
    INNER JOIN dbo.T_Student_Detail SD WITH (NOLOCK) ON RH.I_Student_Detail_ID = SD.I_Student_Detail_ID OR RH.I_Enquiry_Regn_ID = SD.I_Enquiry_Regn_ID      
    LEFT JOIN dbo.T_Invoice_OnAccount_Details IOD WITH (NOLOCK) ON IOD.I_Receipt_Header_ID = RH.I_Receipt_Header_ID      
    LEFT JOIN T_ERP_Transaction_Invoice_Details TID ON TID.ReceiptHeaderID = RH.I_Receipt_Header_ID      
    LEFT JOIN T_ERP_Transaction_Master TM ON TM.I_ERP_Transaction_Master_ID = TID.I_ERP_Transaction_Master_ID      
    WHERE SD.S_Student_ID = ISNULL(@sStudentID, SD.S_Student_ID)      
      AND CONVERT(DATE, RH.Dt_Receipt_Date) BETWEEN CONVERT(DATE, @dtValidFrom) AND CONVERT(DATE, @dtValidTo)      
      AND (RH.S_Receipt_No = ISNULL(@receiptNo, RH.S_Receipt_No) OR @receiptNo IS NULL)    
     AND (RH.I_Receipt_Type = ISNULL(@iReceiptType, RH.I_Receipt_Type))    
      AND (CASE WHEN IOD.I_OnAccount_Ivoice_ID IS NOT NULL OR RH.I_Invoice_Header_ID IS NOT NULL THEN 0 ELSE 1 END = ISNULL(@bIsAdhoc, CASE WHEN IOD.I_OnAccount_Ivoice_ID IS NOT NULL OR RH.I_Invoice_Header_ID IS NOT NULL THEN 0 ELSE 1 END));    
    
    -- Add Failed Transactions      
    INSERT INTO #Transaction_History      
    (    
        StudentID, S_First_Name, S_Middle_Name, S_Last_Name, EnquiryNo,    
        ReceiptHeaderID, ReceiptNo, ReceiptType, TransactionNo,    
        PaymentMethod, PaymentMode, SMSPaymentModeID, SMSPaymentMode,    
        isAdhoc, AdhocInvoiceNo, TransactionDate, ReceiptDate,    
        TotalTransactionAmount, AmountBreakupReceiptWise, TaxBreakupReceiptWise,    
        PaymentStatus, ReceiptStatus, SattlementDate, SattlementBankAccount,    
        PaymnentGatewayID, BrandID, ExternalPurchasedMobileNo, OrderID, ReceiptStatusType    
    )      
    SELECT DISTINCT      
        SD.S_Student_ID, SD.S_First_Name, ISNULL(SD.S_Middle_Name,''), ISNULL(SD.S_Last_Name,''), SD.I_Enquiry_Regn_ID,      
        NULL, NULL, NULL, TM.I_ERP_TransactionNo,      
        CASE WHEN TID.I_ERP_Transaction_Master_ID IS NULL THEN 'Offline' ELSE 'Online' END,      
        CASE WHEN TID.I_ERP_Transaction_Master_ID IS NULL THEN NULL ELSE TM.S_TransactionMode END,      
        NULL, NULL,      
        NULL, NULL, TM.Dt_TransactionDate, NULL,      
        TM.I_TransactionTotalAmount, 0, 0,      
        CASE       
            WHEN TM.S_TransactionStatus = 'Initiated' AND DATEDIFF(MINUTE, TM.Dt_TransactionDate, GETDATE()) > 60 THEN 2      
            WHEN TM.S_TransactionStatus = 'Initiated' THEN 1      
            WHEN TM.S_TransactionStatus = 'Success' THEN 3      
            WHEN TM.S_TransactionStatus = 'Failure' THEN 4      
            ELSE NULL      
        END,      
        NULL, NULL, NULL,      
        TM.I_ERP_Brand_PaymentGateway_Map_id, TM.I_BrandID,      
        TM.S_Mobile_No, TM.Order_ID, '-'      
    FROM T_ERP_Transaction_Invoice_Details TID      
    INNER JOIN T_ERP_Transaction_Master TM ON TM.I_ERP_Transaction_Master_ID = TID.I_ERP_Transaction_Master_ID      
    INNER JOIN T_Invoice_Parent TIP ON TIP.I_Invoice_Header_ID = TID.I_Invoice_Header_ID      
    INNER JOIN T_Student_Detail SD ON SD.I_Student_Detail_ID = TIP.I_Student_Detail_ID      
    WHERE TID.ReceiptHeaderID IS NULL      
      AND SD.S_Student_ID = ISNULL(@sStudentID, SD.S_Student_ID) 
     AND (SD.S_Student_ID=@sStudentID OR @sStudentID IS NULL)
      AND CONVERT(DATE, TM.Dt_TransactionDate) 
      BETWEEN CONVERT(DATE, @dtValidFrom) AND CONVERT(DATE, @dtValidTo)      
      AND @receiptNo IS NULL      
      AND TM.I_BrandID = @BrandID    
	  union all
	   SELECT DISTINCT      
        SD.S_Student_ID, SD.S_First_Name, ISNULL(SD.S_Middle_Name,''), ISNULL(SD.S_Last_Name,''), SD.I_Enquiry_Regn_ID,      
        NULL, NULL, NULL, TM.I_ERP_TransactionNo,      
        CASE WHEN TID.I_ERP_Transaction_Master_ID IS NULL THEN 'Offline' ELSE 'Online' END,      
        CASE WHEN TID.I_ERP_Transaction_Master_ID IS NULL THEN NULL ELSE TM.S_TransactionMode END,      
        NULL, NULL,      
        NULL, NULL, TM.Dt_TransactionDate, NULL,      
        TM.I_TransactionTotalAmount, 0, 0,      
        CASE       
            WHEN TM.S_TransactionStatus = 'Initiated' AND DATEDIFF(MINUTE, TM.Dt_TransactionDate, GETDATE()) > 60 THEN 2      
            WHEN TM.S_TransactionStatus = 'Initiated' THEN 1      
            WHEN TM.S_TransactionStatus = 'Success' THEN 3      
            WHEN TM.S_TransactionStatus = 'Failure' THEN 4      
            ELSE NULL      
        END,      
        NULL, NULL, NULL,      
        TM.I_ERP_Brand_PaymentGateway_Map_id, TM.I_BrandID,      
        TM.S_Mobile_No, TM.Order_ID, '-'      
    FROM T_ERP_Transaction_Invoice_Details TID      
    INNER JOIN T_ERP_Transaction_Master TM ON TM.I_ERP_Transaction_Master_ID = TID.I_ERP_Transaction_Master_ID           
    INNER JOIN T_Student_Detail SD ON SD.S_Student_ID = TID.StudentID      
    WHERE TID.ReceiptHeaderID IS NULL      
      AND SD.S_Student_ID = ISNULL(@sStudentID, SD.S_Student_ID) 
     AND (SD.S_Student_ID=@sStudentID OR @sStudentID IS NULL)
      AND CONVERT(DATE, TM.Dt_TransactionDate) 
      BETWEEN CONVERT(DATE, @dtValidFrom) AND CONVERT(DATE, @dtValidTo)      
      AND @receiptNo IS NULL AND  TID.I_Invoice_Header_ID = 0    
      AND TM.I_BrandID = @BrandID; 
    
    -- Final output      
    SELECT       
        TH.*,      
       LTRIM(RTRIM(
			TH.S_First_Name 
			+ ' ' + ISNULL(TH.S_Middle_Name + ' ', '') 
			+ ISNULL(TH.S_Last_Name, '')
		)) AS StudentName,      
        ExternalStatus.StatusDescription,      
        ExternalStatus.StatusColour      
    FROM #Transaction_History TH      
    LEFT JOIN @PaymentStatusTable ExternalStatus ON TH.PaymentStatus = ExternalStatus.PaymentStatusID      
    WHERE TH.PaymentStatus = ISNULL(@iPaymentStatusID, TH.PaymentStatus)      
      AND (TH.ReceiptNo = ISNULL(@receiptNo, TH.ReceiptNo) OR @receiptNo IS NULL)      
     -- AND (TH.isAdhoc = ISNULL(@bIsAdhoc, TH.isAdhoc))  
      AND (TH.isAdhoc=@bIsAdhoc OR @bIsAdhoc IS NULL)
     AND (  
        @sStudentName IS NULL OR   
        (TH.S_First_Name + ' ' + ISNULL(TH.S_Middle_Name, '') + ' ' + TH.S_Last_Name) LIKE '%' + @sStudentName + '%'  
    )     
    ORDER BY TH.ReceiptDate DESC;  
	

	select 
   TH.TransactionNo TransactionNo,
   TM.Order_ID as OrderID,
   ICD.S_Invoice_Number as InstallmentInvoiceNo,
   ICD.Dt_Installment_Date as InstallmentDate,
   TID.TotalAmoutPaid as TotalAmoutPaid,
   CASE WHEN TID.StatusValue IS NOT NULL THEN 'true' else 'false' end IsAdhoc,
   ICD.is_Freezed as IsFreeze
   from 
   T_ERP_Transaction_Invoice_Details as TID
   inner join
   T_ERP_Transaction_Master as TM on TID.I_ERP_Transaction_Master_ID=TM.I_ERP_Transaction_Master_ID
   inner join
   #Transaction_History as TH on TM.I_ERP_TransactionNo=TH.TransactionNo
   inner join
   T_Invoice_Child_Detail as ICD on ICD.S_Invoice_Number=TID.S_Installment_invoice_NO
    
    DROP TABLE #Transaction_History;      
END 

