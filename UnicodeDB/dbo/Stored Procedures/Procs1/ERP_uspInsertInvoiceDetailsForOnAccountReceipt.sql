
CREATE PROCEDURE [dbo].[ERP_uspInsertInvoiceDetailsForOnAccountReceipt] --exec dbo.uspInsertInvoiceDetailsForOnAccountReceipt 763876  
(  
 @iReceiptHeaderId INT  
)  
AS  
BEGIN  
 SET NOCOUNT ON;  
  
 IF EXISTS  
 (  
  SELECT 1  
  FROM T_Receipt_Header RH
  INNER JOIN T_Status_Master SM ON SM.I_Status_Value=RH.I_Receipt_Type
  WHERE RH.I_Invoice_Header_ID IS NULL  
  AND RH.I_Receipt_Header_ID = @iReceiptHeaderId 
  AND SM.S_Invoice_Required = 'I' 
 )  
 BEGIN  
  
  CREATE TABLE #IDFOAR(  
   ID int IDENTITY(1,1) NOT NULL,  
   I_Receipt_Header_ID int NULL,  
   S_Receipt_No varchar(20) NULL,  
   Dt_Receipt_Date datetime NULL,  
   I_Student_Detail_ID int NULL,  
   I_Enquiry_Regn_ID int NULL,  
   I_Centre_Id int NULL,  
   I_Status int NULL,  
   I_Receipt_Type smallint NULL,  
   N_Receipt_Amount numeric(18, 2) NULL,  
   N_Tax_Amount numeric(18, 2) NULL,  
   S_Invoice_Type char(10) NULL,  
   S_Invoice_Number varchar(100) NULL,  
   Dt_Crtd_On datetime NULL,  
   Dt_Upd_On datetime NULL  
  )  
  
  CREATE TABLE #IDOAT(  
   ID int IDENTITY(1,1) NOT NULL,  
   I_Receipt_Header_ID int NULL,  
   I_Tax_ID int NULL,  
   N_Tax_Paid numeric(18, 2) NULL  
  )  
  
  INSERT INTO #IDFOAR(I_Receipt_Header_ID,S_Receipt_No,Dt_Receipt_Date,I_Student_Detail_ID,I_Enquiry_Regn_ID,I_Centre_Id,I_Status,  
      I_Receipt_Type,N_Receipt_Amount,N_Tax_Amount,Dt_Crtd_On,Dt_Upd_On,S_Invoice_Type)   
  SELECT I_Receipt_Header_ID,S_Receipt_No,Dt_Receipt_Date,I_Student_Detail_ID,I_Enquiry_Regn_ID,I_Centre_Id,I_Status,  
      I_Receipt_Type,N_Receipt_Amount,N_Tax_Amount,Dt_Crtd_On,Dt_Upd_On,  
      CASE WHEN I_Status = 1 THEN CASE WHEN ISNULL(N_Tax_Amount,0) = 0 THEN 'BS'  
            ELSE 'RI'  
             END  
     ELSE 'RC'  
      END S_Invoice_Type  
  FROM T_Receipt_Header  
  WHERE I_Invoice_Header_ID IS NULL  
  AND I_Receipt_Header_ID = @iReceiptHeaderId  
  
  INSERT INTO #IDOAT(I_Receipt_Header_ID,I_Tax_ID,N_Tax_Paid)  
  SELECT I_Receipt_Header_ID, I_Tax_ID, N_Tax_Paid  
  FROM T_OnAccount_Receipt_Tax  
  WHERE I_Receipt_Header_ID = @iReceiptHeaderId  
  
  DECLARE @CenterID INT  
  DECLARE @S_Short_Code VARCHAR(10)  
  DECLARE @S_State_Code INT  
  DECLARE @invoiceSequence INT  
  DECLARE @Year INT  
  DECLARE @stateID INT  
  DECLARE @brandID INT  
  DECLARE @I_OnAccount_Ivoice_ID INT  
  DECLARE @invoiceType VARCHAR(10)  
  DECLARE @InvoiceNumber VARCHAR(100)  
  SET @Year = RIGHT(CONVERT(VARCHAR(8), GETDATE(), 1),2)  
  
  SELECT @CenterID = I_Centre_Id, @invoiceType = S_Invoice_Type  
  FROM #IDFOAR  
  
  SELECT TOP(1) @S_Short_Code = BM.S_Short_Code, @S_State_Code = GCM.S_State_Code, @stateID = TSM.I_State_ID, @brandID = BM.I_Brand_ID  
  FROM dbo.T_Centre_Master AS TCM  
  INNER JOIN NETWORK.T_Center_Address AS TCA ON TCM.I_Centre_Id = TCA.I_Centre_Id  
  INNER JOIN dbo.T_State_Master AS TSM ON TCA.I_State_ID = TSM.I_State_ID  
  INNER JOIN dbo.T_Brand_Center_Details AS BCM ON BCM.I_Centre_Id = TCM.I_Centre_Id  
  INNER JOIN dbo.T_Brand_Master AS BM ON BM.I_Brand_ID = BCM.I_Brand_ID  
  INNER JOIN dbo.T_GST_Code_Master AS GCM ON GCM.I_State_ID = TSM.I_State_ID AND GCM.I_Brand_ID = BCM.I_Brand_ID  
  WHERE TCM.I_Centre_Id = @CenterID  
  
  EXEC @invoiceSequence = dbo.uspGetInvoiceSequenceNumber @I_Brand_ID = @brandID, @I_State_ID = @stateID, @S_Invoice_Type = @invoiceType  
  
  SET @InvoiceNumber = @S_Short_Code+CONVERT(VARCHAR(50),@S_State_Code)+'-'+CONVERT(VARCHAR(50),@Year)+LTRIM(RTRIM(@invoiceType))+'-'+CONVERT(VARCHAR(50),RIGHT('00000'+CAST(@invoiceSequence AS VARCHAR(50)),5))  
  
  INSERT INTO T_Invoice_OnAccount_Details(I_Receipt_Header_ID,S_Receipt_No,Dt_Receipt_Date,I_Student_Detail_ID,I_Enquiry_Regn_ID,I_Centre_Id,I_Status,  
      I_Receipt_Type,N_Receipt_Amount,N_Tax_Amount,Dt_Crtd_On,Dt_Upd_On,S_Invoice_Type,S_Invoice_Number)  
  SELECT I_Receipt_Header_ID,S_Receipt_No,Dt_Receipt_Date,I_Student_Detail_ID,I_Enquiry_Regn_ID,I_Centre_Id,I_Status,  
      I_Receipt_Type,N_Receipt_Amount,N_Tax_Amount,Dt_Crtd_On,Dt_Upd_On,S_Invoice_Type,@InvoiceNumber  
  FROM #IDFOAR  
  
  SET @I_OnAccount_Ivoice_ID = SCOPE_IDENTITY()  
  
  INSERT INTO T_Invoice_OnAccount_Details_Tax(I_OnAccount_Ivoice_ID,I_Tax_ID,N_Tax_Paid)  
  SELECT @I_OnAccount_Ivoice_ID, I_Tax_ID,N_Tax_Paid  
  FROM #IDOAT  
  
  DROP TABLE #IDFOAR  
  DROP TABLE #IDOAT  
 END  
END  

