CREATE   PROCEDURE [dbo].[uspInsertReceiptHeader]          
    (          
      @sReceiptNo Nnvarchar(max) ,          
      @iInvoiceHeaderID INT ,          
      @dReceiptDate DATETIME ,          
      @iStudentDetailID INT ,          
      @iPaymentModeID INT ,          
      @iCentreId INT ,          
      @nReceiptAmount NUMERIC(18, 2) ,          
      @nReceiptTaxAmount NUMERIC(18, 2) ,          
      @sFundTransferStatus CHAR(1) ,          
      @sCrtdBy Nnvarchar(max) ,          
      @dCreatedOn DATETIME ,          
      @nCreditCardNo NUMERIC(18, 0) ,          
      @dCreditCardExpiry Nnvarchar(max) ,          
      @sCreditCardIssuer Nnvarchar(max) ,          
      @sChequeDDNo Nnvarchar(max) ,          
      @dChequeDDDate Nnvarchar(max) ,          
      @sBankName Nnvarchar(max) ,          
      @sBranchName Nnvarchar(max) ,          
      @iReceiptType INT,          
      @iBrandID INT = NULL  ,        
      @sNarration Nnvarchar(max) =null,    
      @UTRNo Nnvarchar(max)=null,    
      @PrayerAccountNo Nnvarchar(max)=null    
          
    )          
AS           
    SET NOCOUNT ON            
    BEGIN TRY             
        BEGIN TRANSACTION            
        IF @iStudentDetailID IS NOT NULL           
            BEGIN            
                IF ( CONVERT(INT, ( SELECT  dbo.fnCheckReceiptValidity(@iStudentDetailID,          
                                                              NULL, NULL,          
                                                              @nReceiptAmount)          
                                  )) = 0 )           
                    BEGIN            
                        SELECT  -1            
                        RETURN ;            
                    END            
            END            
            
        Set @iCentreId=(    
 select top 1 I_Centre_Id from T_Brand_Center_Details where I_Brand_ID=@iBrandID  )          
            
        INSERT  INTO T_Receipt_Header          
                ( S_Receipt_No ,          
                  I_Invoice_Header_ID ,          
                  Dt_Receipt_Date ,          
                  I_Student_Detail_ID ,          
                  I_PaymentMode_ID ,          
                  N_Receipt_Amount ,          
                  N_Tax_Amount ,          
                  S_Fund_Transfer_Status ,          
                  S_Crtd_By ,          
                  Dt_Crtd_On ,          
                  N_CreditCard_No ,          
                  Dt_CreditCard_Expiry ,          
                  S_CreditCard_Issuer ,          
                  S_ChequeDD_No ,          
                  Dt_ChequeDD_Date ,          
                  S_Bank_Name ,          
                  S_Branch_Name ,          
                  I_Centre_Id ,          
                  I_Status ,          
                  I_Receipt_Type  ,        
                  s_narration ,    
                  S_Utr_No,    
                  S_Prayer_Account_No    
                      
                )          
        VALUES  ( @sReceiptNo ,          
                  @iInvoiceHeaderID ,          
                  @dReceiptDate ,          
                  @iStudentDetailID ,          
                  @iPaymentModeID ,          
                  @nReceiptAmount - @nReceiptTaxAmount ,          
                  @nReceiptTaxAmount ,          
                  @sFundTransferStatus ,          
                  @sCrtdBy ,          
                  @dCreatedOn ,          
                  @nCreditCardNo ,          
                  @dCreditCardExpiry ,          
                  @sCreditCardIssuer ,          
                  @sChequeDDNo ,          
                  @dChequeDDDate ,          
       @sBankName ,          
                  @sBranchName ,          
                  @iCentreId ,          
                  1 ,          
                  @iReceiptType   ,        
         @sNarration ,    
                  @UTRNo,    
                  @PrayerAccountNo    
                      
                )            
               
        DECLARE @iReceiptNo BIGINT            
        DECLARE @iReceiptID INT            
            
        SET @iReceiptID = SCOPE_IDENTITY()            
            
        SELECT  @iReceiptNo = MAX(CAST(S_Receipt_No AS BIGINT))          
        FROM    T_RECEIPT_HEADER TRH          
        WHERE   S_Receipt_No NOT LIKE '%[A-Z]%'            
  AND TRH.I_Centre_Id IN (SELECT I_Centre_Id FROM dbo.T_Brand_Center_Details AS TBCD WHERE I_Brand_ID = @iBrandID AND I_Status = 1)                  
            
        SET @iReceiptNo = ISNULL(@iReceiptNo, 0) + 1            
            
        UPDATE  T_RECEIPT_HEADER          
        SET     S_Receipt_No = CAST(@iReceiptNo AS VARCHAR(20))          
        WHERE   I_Receipt_Header_ID = @iReceiptID     
  -----Implementing Currency ----------    
  Declare @currency_ID int     
  SET @currency_ID=(Select top 1 I_Currency_Id from T_Invoice_Parent where I_Invoice_Header_ID=@iInvoiceHeaderID)    
            UPDATE  T_RECEIPT_HEADER          
        SET     I_Currency_ID = @currency_ID          
        WHERE   I_Receipt_Header_ID = @iReceiptID    
  --------------------------------------------------------------------    
        SELECT  @iReceiptID            
        COMMIT TRANSACTION            
    END TRY            
            
    BEGIN CATCH            
 --Error occurred:              
        ROLLBACK TRANSACTION            
        DECLARE @ErrMsg Nnvarchar(max) ,          
            @ErrSeverity INT            
        SELECT  @ErrMsg = ERROR_MESSAGE() ,          
                @ErrSeverity = ERROR_SEVERITY()            
            
        RAISERROR(@ErrMsg, @ErrSeverity, 1)            
    END CATCH 
