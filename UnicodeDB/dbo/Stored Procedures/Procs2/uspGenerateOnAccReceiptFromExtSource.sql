CREATE PROCEDURE [dbo].[uspGenerateOnAccReceiptFromExtSource]
    (
      @iCenterId INT ,
      @iAmount NUMERIC(18, 2) = NULL ,
      @iReceiptDate DATETIME = NULL ,
      @iEnquiryID INT = NULL ,
      @sFormNo NVARCHAR(max) = NULL ,
      @iBrandID INT = NULL ,
      @TransactionNo NVARCHAR(max) = NULL ,
      @ExtReceiptNo NVARCHAR(max) = NULL ,
      @ExtReceiptDate NVARCHAR(max) = NULL ,
      @Source NVARCHAR(max) = NULL ,
      @DepositAccNo NVARCHAR(max) = NULL ,
      @CrtdBy NVARCHAR(max) ,
      @CrtdOn DATETIME
    )
AS
    BEGIN
    
        DECLARE @currDate DATETIME= GETDATE()

        IF ( @iCenterId IS NOT NULL
             AND @iAmount IS NOT NULL
             AND @iEnquiryID IS NOT NULL
             AND @sFormNo IS NOT NULL
             AND @iBrandID IS NOT NULL
             AND @TransactionNo IS NOT NULL
             AND @ExtReceiptDate IS NOT NULL
             AND @Source IS NOT NULL
           )
            BEGIN

                DECLARE @TaxXML XML= NULL
                DECLARE @TaxAmount DECIMAL= NULL
                DECLARE @BaseReceiptAmt DECIMAL= NULL
                DECLARE @ReceiptType INT

                IF ( @iAmount = 1000.00
                     AND @iBrandID = 107
                   )
                    BEGIN

                        SET @TaxXML = '<ReceiptTax>
<TaxDetails TaxID="7" TaxPaid="23.81" />
<TaxDetails TaxID="8" TaxPaid="23.81" />
</ReceiptTax>'

                        SET @TaxAmount = 23.81 + 23.81;
                        
                        SET @BaseReceiptAmt = @iAmount - @TaxAmount
                        
                        SET @ReceiptType = 31

                    END
                    
                ELSE
                    IF ( @iAmount = 1000.00
                         AND @iBrandID = 110
                       )
                        BEGIN

                            SET @TaxXML = '<ReceiptTax>
<TaxDetails TaxID="7" TaxPaid="23.81" />
<TaxDetails TaxID="8" TaxPaid="23.81" />
</ReceiptTax>'

                            SET @TaxAmount = 23.81 + 23.81;
                        
                            SET @BaseReceiptAmt = @iAmount - @TaxAmount
                        
                            SET @ReceiptType = 51

                        END

                BEGIN
                
                    IF ( @BaseReceiptAmt IS NOT NULL
                         AND @TaxAmount IS NOT NULL
                         AND @TaxXML IS NOT NULL
                       )
                        BEGIN
							
							DECLARE @dtDate DATETIME=GETDATE()
                            EXEC dbo.uspGenerateReceiptForOnAccountForExtPayment @iCenterId = @iCenterId, -- int
                                @iAmount = @BaseReceiptAmt, -- numeric
                                @iStudentDetailId = NULL, -- int
                                @iReceiptDate = @dtDate, -- datetime
                                @iPaymentModeId = 23, -- int
                                @sChequeDDno = NULL, -- nvarchar(max)
                                @dChequeDate = NULL, -- datetime
                                @sBankName = NULL, -- nvarchar(max)
                                @sBranchName = NULL, -- nvarchar(max)
                                @iCreditCardNo = NULL, -- numeric
                                @sCreditCardIssuer = NULL, -- nvarchar(max)
                                @dCardExpiryDate = NULL, -- datetime
                                @sCrtdBy = @CrtdBy, -- nvarchar(max)
                                @iReceiptType = @ReceiptType, -- int
                                @dTaxAmount = @TaxAmount, -- numeric
                                @TaxXML = @TaxXML, -- xml
                                @iEnquiryID = @iEnquiryID, -- int
                                @sFormNo = @sFormNo, -- nvarchar(max)
                                @iBrandID = @iBrandID, -- int
                                @sNarration = NULL -- nvarchar(max)
                        
                        
                            DECLARE @ReceiptNo nvarchar(max)= NULL
                            SET @ReceiptNo = ( SELECT   S_Receipt_No
                                               FROM     dbo.T_Receipt_Header
                                               WHERE    I_Enquiry_Regn_ID = @iEnquiryID
                                                        AND I_Receipt_Type = @ReceiptType
                                                        AND I_Centre_Id = @iCenterId
                                                        AND I_Status = 1
                                                        AND N_Receipt_Amount = @BaseReceiptAmt
                                                        AND N_Tax_Amount = @TaxAmount
                                             )
														
                            DECLARE @ReceiptHeaderID INT= NULL 
                            SET @ReceiptHeaderID = ( SELECT I_Receipt_Header_ID
                                                     FROM   dbo.T_Receipt_Header
                                                     WHERE  I_Enquiry_Regn_ID = @iEnquiryID
                                                            AND I_Receipt_Type = @ReceiptType
                                                            AND I_Centre_Id = @iCenterId
                                                            AND I_Status = 1
                                                            AND N_Receipt_Amount = @BaseReceiptAmt
                                                            AND N_Tax_Amount = @TaxAmount
                                                   )								
														
                            IF ( @ReceiptNo IS NOT NULL
                                 AND @ReceiptHeaderID IS NOT NULL
                               )
                                BEGIN
									
                                    IF ( @DepositAccNo IS NOT NULL )
                                        BEGIN
                                            UPDATE  dbo.T_Receipt_Header
                                            SET     Bank_Account_Name = @DepositAccNo ,
                                                    Dt_Deposit_Date = GETDATE()
                                            WHERE   I_Receipt_Header_ID = @ReceiptHeaderID
                                        END
										
                                    ELSE IF (@iBrandID=107)
                                        BEGIN
                                            UPDATE  dbo.T_Receipt_Header
                                            SET     Bank_Account_Name = 'BANK OF INDIA 415620110000014' ,
                                                    Dt_Deposit_Date = GETDATE()
                                            WHERE   I_Receipt_Header_ID = @ReceiptHeaderID	
                                        END
                                    ELSE IF  (@iBrandID =110)
                                        BEGIN
                                            UPDATE  dbo.T_Receipt_Header
                                            SET     Bank_Account_Name = 'BANK OF INDIA - A/C-415620110000003' ,
                                                    Dt_Deposit_Date = GETDATE()
                                            WHERE   I_Receipt_Header_ID = @ReceiptHeaderID	
                                        END
										--BANK OF INDIA - A/C-415620110000003
						
                                    INSERT  INTO dbo.T_OnlinePayment_Receipt_Mapping
                                            ( I_Receipt_Header_ID ,
                                              S_Receipt_No ,
                                              S_Transaction_No ,
                                              S_Ext_Receipt_No ,
                                              Dt_Crtd_On ,
                                              S_Crtd_By ,
                                              N_Amount ,
                                              N_Tax ,
                                              Dt_ActualReceiptDate
						                    )
                                    VALUES  ( @ReceiptHeaderID , -- I_Receipt_Header_ID - int
                                              @ReceiptNo , -- S_Receipt_No - nvarchar(max)
                                              @TransactionNo , -- S_Transaction_No - nvarchar(max)
                                              @ExtReceiptNo , -- S_Ext_Receipt_No - nvarchar(max)
                                              @CrtdOn , -- Dt_Crtd_On - datetime
                                              @Source , -- S_Crtd_By - nvarchar(max)
                                              @BaseReceiptAmt , -- N_Amount - decimal
                                              @TaxAmount , -- N_Tax - decimal
                                              @ExtReceiptDate  -- Dt_ActualReceiptDate - datetime
						                    )
						
                                END
														
                        
                        
                        END
                        


                END

            END

    END


