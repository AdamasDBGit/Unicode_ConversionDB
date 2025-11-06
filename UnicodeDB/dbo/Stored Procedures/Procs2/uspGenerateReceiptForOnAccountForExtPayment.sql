CREATE PROCEDURE [dbo].[uspGenerateReceiptForOnAccountForExtPayment]  
    (  
      @iCenterId INT ,  
      @iAmount NUMERIC(18, 2) ,  
      @iStudentDetailId INT = NULL ,  
      @iReceiptDate DATETIME ,  
      @iPaymentModeId INT ,  
      @sChequeDDno NVARCHAR(MAX) ,  
      @dChequeDate DATETIME ,  
      @sBankName NVARCHAR(MAX) ,  
      @sBranchName NVARCHAR(MAX) ,  
      @iCreditCardNo NUMERIC(18, 0) ,  
      @sCreditCardIssuer NVARCHAR(MAX) ,  
      @dCardExpiryDate DATETIME ,  
      @sCrtdBy NVARCHAR(MAX) ,  
      @iReceiptType INT ,  
      @dTaxAmount NUMERIC(12, 6) ,  
      @TaxXML XML ,  
      @iEnquiryID INT = NULL ,  
      @sFormNo NVARCHAR(MAX) = NULL ,  
      @iBrandID INT = NULL ,  
      @sNarration NVARCHAR(MAX) = NULL          
    )  
AS   
    BEGIN TRY            
        SET NOCOUNT ON ;             
            
        DECLARE @CompanyShare NUMERIC(8, 4)            
        DECLARE @TaxShare NUMERIC(18, 2)            
        DECLARE @bUseCenterServiceTax BIT            
            
        BEGIN TRANSACTION            
 --This checks whether the receipt for this student entered within 5 minutes from now            
        --IF @iStudentDetailID IS NOT NULL   
        --    BEGIN            
        --        IF ( CONVERT(INT, ( SELECT  dbo.fnCheckReceiptValidity(@iStudentDetailID,  
        --                                                      NULL, NULL,  
        --                                                      @iAmount)  
        --                          )) = 0 )   
        --            BEGIN            
        --                SELECT  -1            
        --                RETURN ;            
        --            END            
        --    END            
            
        SELECT  @CompanyShare = [dbo].fnGetCompanyShareOnAccountReceipts(@iReceiptDate,  
                                                              CM.I_Country_ID,  
                                                              CM.I_Centre_Id,  
                                                              @iReceiptType,  
                                                              BCD.I_Brand_ID)  
        FROM    dbo.T_Centre_Master CM  
                INNER JOIN dbo.T_Brand_Center_Details BCD ON BCD.I_Centre_Id = CM.I_Centre_Id  
                                                             AND BCD.I_Status = 1  
        WHERE   CM.I_Centre_ID = @iCenterId            
             
        SELECT  @bUseCenterServiceTax = ISNULL(CM.I_Is_Center_Serv_Tax_Reqd,  
                                               'False')  
        FROM    dbo.T_Centre_Master CM WITH ( NOLOCK )  
        WHERE   CM.I_Centre_ID = @iCenterId            
             
        IF ( @bUseCenterServiceTax = 'TRUE' )   
            BEGIN            
                SET @TaxShare = @CompanyShare            
            END            
        ELSE   
            BEGIN            
                SET @TaxShare = 100            
            END            
        IF @iStudentDetailId IS NOT NULL   
            BEGIN          
                INSERT  INTO T_RECEIPT_HEADER  
                        ( I_Centre_Id ,  
                          N_Receipt_Amount ,  
                          I_Student_Detail_ID ,  
                          Dt_Receipt_Date ,  
                          I_PaymentMode_ID ,  
                          S_ChequeDD_No ,  
                          Dt_ChequeDD_Date ,  
                          S_Bank_Name ,  
                          S_Branch_Name ,  
                          N_CreditCard_No ,  
                          S_CreditCard_Issuer ,  
                          Dt_CreditCard_Expiry ,  
                          S_Crtd_By ,  
                          Dt_Crtd_On ,  
                          I_Status ,  
                          S_Fund_Transfer_Status ,  
                          I_Receipt_Type ,  
                          N_Tax_Amount ,  
                          N_Amount_Rff ,  
                          N_Receipt_Tax_Rff ,  
                          s_narration          
  )  
                VALUES  ( @iCenterId ,  
                          @iAmount ,  
                          @iStudentDetailId ,  
                          @iReceiptDate ,  
                          @iPaymentModeId ,  
                          @sChequeDDno ,  
                          @dChequeDate ,  
                          @sBankName ,  
                          @sBranchName ,  
                          @iCreditCardNo ,  
                          @sCreditCardIssuer ,  
                          @dCardExpiryDate ,  
                          @sCrtdBy ,  
                          @iReceiptDate ,  
                          1 ,  
                          'N' ,  
                          @iReceiptType ,  
                          @dTaxAmount ,  
                          @iAmount * @CompanyShare / 100 ,  
                          @CompanyShare * @dTaxAmount / 100 ,  
                          @sNarration       
                        )            
            END          
        ELSE   
            BEGIN          
                INSERT  INTO T_RECEIPT_HEADER  
                        ( I_Centre_Id ,  
                          N_Receipt_Amount ,  
                          I_Enquiry_Regn_ID ,  
                          Dt_Receipt_Date ,  
                          I_PaymentMode_ID ,  
                          S_ChequeDD_No ,  
                          Dt_ChequeDD_Date ,  
                          S_Bank_Name ,  
                          S_Branch_Name ,  
                          N_CreditCard_No ,  
                          S_CreditCard_Issuer ,  
                          Dt_CreditCard_Expiry ,  
                          S_Crtd_By ,  
                          Dt_Crtd_On ,  
                          I_Status ,  
                          S_Fund_Transfer_Status ,  
                          I_Receipt_Type ,  
                          N_Tax_Amount ,  
                          N_Amount_Rff ,  
                          N_Receipt_Tax_Rff ,  
                          s_Narration       
                        )  
                VALUES  ( @iCenterId ,  
                          @iAmount ,  
                          @iEnquiryID ,  
                          @iReceiptDate ,  
                          @iPaymentModeId ,  
                          @sChequeDDno ,  
                          @dChequeDate ,  
                          @sBankName ,  
                          @sBranchName ,  
                          @iCreditCardNo ,  
                          @sCreditCardIssuer ,  
                          @dCardExpiryDate ,  
                          @sCrtdBy ,  
                          @iReceiptDate ,  
                          1 ,  
                          'N' ,  
                          @iReceiptType ,  
                          @dTaxAmount ,  
                          @iAmount * @CompanyShare / 100 ,  
                          @CompanyShare * @dTaxAmount / 100 ,  
                          @sNarration       
                        )        
                        
                IF @sFormNo IS NOT NULL   
                    BEGIN        
                        UPDATE  dbo.T_Enquiry_Regn_Detail  
                        SET     S_Form_No = @sFormNo  
                        WHERE   I_Enquiry_Regn_ID = @iEnquiryID         
                    END            
            END          
            
        DECLARE @iReceiptIDnew INT            
        SET @iReceiptIDnew = SCOPE_IDENTITY()            
            
        DECLARE @iReceiptNo BIGINT            
            
        SELECT  @iReceiptNo = MAX(CAST(S_Receipt_No AS BIGINT))  
        FROM    T_RECEIPT_HEADER TRH  
        WHERE   S_Receipt_No NOT LIKE '%[A-Z]'  
                AND TRH.I_Centre_Id IN (  
                SELECT  I_Centre_Id  
                FROM    dbo.T_Brand_Center_Details AS TBCD  
                WHERE   I_Brand_ID = @iBrandID  
                        AND I_Status = 1 )      
            
        SET @iReceiptNo = ISNULL(@iReceiptNo, 0) + 1            
    
        UPDATE  T_RECEIPT_HEADER  
        SET    S_Receipt_No = @iReceiptNo  
        WHERE   I_Receipt_Header_ID = @iReceiptIDnew            
            
        CREATE TABLE #TEMPTABLE  
            (  
              I_Tax_ID INT ,  
              N_Tax_Paid NUMERIC(18, 2)  
            )            
              
        INSERT  INTO #TEMPTABLE  
                SELECT  T.c.value('@TaxID', 'int') ,  
                        T.c.value('@TaxPaid', 'numeric(18,2)')  
                FROM    @TaxXML.nodes('/ReceiptTax/TaxDetails') T ( c )            
            
        INSERT  INTO dbo.T_OnAccount_Receipt_Tax  
                SELECT  @iReceiptIDnew ,  
                        I_Tax_ID ,  
                        N_Tax_Paid ,  
                        N_Tax_Paid * @TaxShare / 100  
                FROM    #TEMPTABLE            
            
        DROP TABLE #TEMPTABLE
        
        exec dbo.uspInsertInvoiceDetailsForOnAccountReceipt @iReceiptIDnew
                  
        --SELECT  @iReceiptIDnew            
        COMMIT TRANSACTION              
    END TRY            
            
            
    BEGIN CATCH            
 --Error occurred:              
        ROLLBACK TRANSACTION            
        DECLARE @ErrMsg NVARCHAR(4000) ,  
            @ErrSeverity INT            
        SELECT  @ErrMsg = ERROR_MESSAGE() ,  
                @ErrSeverity = ERROR_SEVERITY()            
            
        RAISERROR(@ErrMsg, @ErrSeverity, 1)            
    END CATCH

