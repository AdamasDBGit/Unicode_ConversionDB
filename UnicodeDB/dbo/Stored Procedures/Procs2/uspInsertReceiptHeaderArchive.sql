CREATE PROCEDURE [dbo].[uspInsertReceiptHeaderArchive]      
    (      
      @sReceiptNo NVARCHAR(max) ,      
      @iInvoiceHeaderID INT ,      
      @dReceiptDate DATETIME ,      
      @iStudentDetailID INT ,      
      @iPaymentModeID INT ,      
      @iCentreId INT ,      
      @nReceiptAmount NUMERIC(18, 2) ,      
      @nReceiptTaxAmount NUMERIC(18, 2) ,      
      @sFundTransferStatus CHAR(1) ,      
      @sCrtdBy NVARCHAR(max) ,      
      @dCreatedOn DATETIME ,      
      @nCreditCardNo NUMERIC(18, 0) ,      
      @dCreditCardExpiry NVARCHAR(max) ,      
      @sCreditCardIssuer NVARCHAR(max) ,      
      @sChequeDDNo NVARCHAR(max) ,      
      @dChequeDDDate NVARCHAR(max) ,      
      @sBankName NVARCHAR(max) ,      
      @sBranchName NVARCHAR(max) ,      
      @iReceiptType INT,      
      @iBrandID INT = NULL  ,    
      @sNarration NVARCHAR(max) =null       
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
        
        IF ( @iCentreId IS NULL )       
            SELECT  @iCentreId = I_Centre_Id      
            FROM    dbo.T_Student_Center_Detail A      
            WHERE   I_Student_Detail_ID = @iStudentDetailID      
                    AND I_Status = 1      
                    AND GETDATE() >= ISNULL(A.Dt_Valid_From, GETDATE())      
                    AND GETDATE() <= ISNULL(A.Dt_Valid_To, GETDATE())   
                    
SELECT @iBrandID = i_brand_id FROM dbo.T_Brand_Center_Details AS TBCD WHERE I_Centre_Id=@iCentreId AND I_Status=1                         
        
        INSERT  INTO T_Receipt_Header_archive      
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
                  s_narration      
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
                  @sNarration     
                )        
           
        DECLARE @iReceiptNo BIGINT        
        DECLARE @iReceiptID INT        
        
        SET @iReceiptID = SCOPE_IDENTITY()        
        
  --      SELECT  @iReceiptNo = MAX(CAST(S_Receipt_No AS BIGINT))      
  --      FROM    T_RECEIPT_HEADER_Archive TRH      
  --     WHERE   S_Receipt_No NOT LIKE '%[A-Z]%'        
  --AND TRH.I_Centre_Id IN (SELECT I_Centre_Id FROM dbo.T_Brand_Center_Details AS TBCD WHERE I_Brand_ID = @iBrandID AND I_Status = 1)              
        
        --SET @iReceiptNo = ISNULL(@iReceiptNo, 0) + 1        
        
        --UPDATE  T_RECEIPT_HEADER_archive      
        --SET     S_Receipt_No = CAST(@iReceiptNo AS VARCHAR(20))      
        --WHERE   I_Receipt_Header_ID = @iReceiptID        
         
        SELECT  @iReceiptID        
        COMMIT TRANSACTION        
    END TRY        
        
    BEGIN CATCH        
 --Error occurred:          
        ROLLBACK TRANSACTION        
        DECLARE @ErrMsg NVARCHAR(max) ,      
            @ErrSeverity INT        
        SELECT  @ErrMsg = ERROR_MESSAGE() ,      
                @ErrSeverity = ERROR_SEVERITY()        
        
        RAISERROR(@ErrMsg, @ErrSeverity, 1)        
    END CATCH


