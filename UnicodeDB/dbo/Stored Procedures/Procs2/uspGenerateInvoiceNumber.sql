--declare @invno varchar(100)
--EXEC [uspGenerateInvoiceNumber] 419930,2,'2025-04-28','I',@InvoiceNumber=@invno
--select @invno
CREATE PROCEDURE [dbo].[uspGenerateInvoiceNumber] --151102,1,'2017-08-01 00:00:00.000','A'  
(  
 @invoiceHeaderID INT,  
 @installmentNo INT,  
 @dtInstallmentDate DATETIME,  
 @invoiceType NVARCHAR(MAX),  
 @InvoiceNumber NVARCHAR(MAX) OUTPUT  
)   
AS  
BEGIN   
   
 DECLARE @invoiceSequence INT  
 DECLARE @brandCode VARCHAR(50),@stateCode VARCHAR(50),@stateID INT, @brandID INT  
   
 DECLARE @Month INT, @Year INT   
  
 SET @Month = DATEPART(M,GETDATE())  
 SET @Year = DATEPART(YYYY,GETDATE())  
  
 SELECT TOP 1  
  @brandCode = BM.S_Short_Code,  
  @stateCode = GCM.S_State_Code,  
  @stateID = TSM.I_State_ID,  
  @brandID = BM.I_Brand_ID  
 FROM dbo.T_Centre_Master AS TCM  
 INNER JOIN NETWORK.T_Center_Address AS TCA  ON TCM.I_Centre_Id = TCA.I_Centre_Id  
 INNER JOIN dbo.T_State_Master AS TSM ON TCA.I_State_ID = TSM.I_State_ID  
 INNER JOIN dbo.T_Invoice_Parent AS IP ON TCM.I_Centre_Id = IP.I_Centre_Id  
 INNER JOIN dbo.T_Brand_Center_Details AS BCM ON BCM.I_Centre_Id = TCM.I_Centre_Id  
 INNER JOIN dbo.T_Brand_Master AS BM ON BM.I_Brand_ID = BCM.I_Brand_ID  
 INNER JOIN dbo.T_Invoice_Child_Header AS ICH ON IP.I_Invoice_Header_ID = ICH.I_Invoice_Header_ID  
 INNER JOIN dbo.T_GST_Code_Master AS GCM ON GCM.I_State_ID = TSM.I_State_ID  
 AND GCM.I_Brand_ID = BCM.I_Brand_ID  
 WHERE IP.I_Invoice_Header_ID = @invoiceHeaderID  
 --ICH.I_Invoice_Child_Header_ID = @invoiceChildHeaderID  
 --Select @brandCode,@stateCode,@stateID,@brandID  
 IF(@invoiceType = 'I')  
 Begin  
 Print 'Inv I'  
  IF EXISTS  
  (  
   SELECT 1 FROM T_Invoice_Child_Detail AS ICD  
   INNER JOIN T_Invoice_Child_Header AS ICH  
   ON ICD.I_Invoice_Child_Header_ID = ICH.I_Invoice_Child_Header_ID    
   WHERE ICH.I_Invoice_Header_ID = @invoiceHeaderID     
   AND ICD.I_Installment_No = @installmentNo  
   AND ICD.S_Invoice_Number IS NOT NULL  
   AND (ICD.Flag_IsAdvanceTax <> 'Y' OR ICD.Flag_IsAdvanceTax IS NULL)  
  )  
  BEGIN   
  Print 'Exists'  
   SELECT TOP 1 @InvoiceNumber = ICD.S_Invoice_Number FROM T_Invoice_Child_Detail AS ICD  
   INNER JOIN T_Invoice_Child_Header AS ICH  
   ON ICD.I_Invoice_Child_Header_ID = ICH.I_Invoice_Child_Header_ID    
   WHERE ICH.I_Invoice_Header_ID = @invoiceHeaderID     
   AND ICD.I_Installment_No = @installmentNo   
   AND ICD.S_Invoice_Number IS NOT NULL    
      
  END  
  ELSE  
  BEGIN  
  Print 'Installment begin '  
   IF(@dtInstallmentDate < DATEADD(DAY,1,DATEADD(day,-1,DATEADD(month,@Month,DATEADD(year,@Year-1900,0)))))  
   BEGIN  
     Print 'Installment else '  
    EXEC @invoiceSequence = dbo.uspGetInvoiceSequenceNumber @I_Brand_ID = @brandID, @I_State_ID = @stateID, @S_Invoice_Type = @invoiceType  
  
    SET @InvoiceNumber = @brandCode+@stateCode+@invoiceType+CONVERT(VARCHAR(50),RIGHT('00' + CAST(DATEPART(MM,@dtInstallmentDate) AS varchar(50)),2))+CONVERT(VARCHAR(50),RIGHT(CAST(DATEPART(YY,@dtInstallmentDate) AS VARCHAR(50)),2))+CONVERT(VARCHAR(50),RIGHT('0000000'+CAST(@invoiceSequence AS VARCHAR(50)),7))  
     
   END  
   ELSE  
   BEGIN   
    Print 'Temp Installment'  
    EXEC @invoiceSequence = dbo.uspGetInvoiceSequenceNumber @I_Brand_ID = NULL, @I_State_ID = NULL, @S_Invoice_Type = 'T'  
      
    SET @InvoiceNumber = 'TEMP/'+CONVERT(VARCHAR(50),RIGHT('0000000'+CAST(@invoiceSequence AS VARCHAR(50)),7))    
      
   END  
   --SELECT @InvoiceNumber  
  END  
 END  
 ELSE  
 BEGIN  
 Print 'I Else'  
  IF(@dtInstallmentDate < DATEADD(DAY,1,DATEADD(day,-1,DATEADD(month,@Month,DATEADD(year,@Year-1900,0)))))  
  BEGIN  
   Print 'I Else else'  
   EXEC @invoiceSequence = dbo.uspGetInvoiceSequenceNumber @I_Brand_ID = @brandID, @I_State_ID = @stateID, @S_Invoice_Type= @invoiceType  
  
   SET @InvoiceNumber = @brandCode+@stateCode+@invoiceType+CONVERT(VARCHAR(50),RIGHT('00' + CAST(DATEPART(MM,@dtInstallmentDate) AS varchar(50)),2))+CONVERT(VARCHAR(50),RIGHT(CAST(DATEPART(YY,@dtInstallmentDate) AS VARCHAR(50)),2))+CONVERT(VARCHAR(50),RIGHT('0000000'+CAST(@invoiceSequence AS VARCHAR(50)),7))  
    
  END  
  ELSE  
  BEGIN   
     
   EXEC @invoiceSequence = dbo.uspGetInvoiceSequenceNumber @I_Brand_ID = NULL, @I_State_ID = NULL, @S_Invoice_Type = 'T'  
     
   SET @InvoiceNumber = 'TEMP/'+CONVERT(VARCHAR(50),RIGHT('0000000'+CAST(@invoiceSequence AS VARCHAR(50)),7))    
     
  END  
 END  
   
END
