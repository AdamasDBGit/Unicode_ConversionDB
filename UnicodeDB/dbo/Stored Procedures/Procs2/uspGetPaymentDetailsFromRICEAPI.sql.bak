CREATE PROCEDURE [dbo].[uspGetPaymentDetailsFromRICEAPI]
    (
      @sBrandName NVARCHAR(MAX) ,
      @sStudentID NVARCHAR(MAX) ,
      --@iInvoiceHeaderID INT ,
      @dReceiptDate DATETIME ,
      @iCentreId INT ,
      @ReceiptAmount NUMERIC(18, 2) ,
      @ReceiptTaxAmount NUMERIC(18, 2) ,
      @iReceiptType INT = 2 ,
      @sPaymentDetailsXML XML ,
      @sTransactionCode NVARCHAR(MAX) ,
      @sExtReceiptNo NVARCHAR(MAX) ,
      @sSource NVARCHAR(MAX)
    )
AS
    SET NOCOUNT ON 
    
    --SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
   



 
    BEGIN TRY
    
    
       DECLARE @iBrandID INT= NULL

        BEGIN TRANSACTION
        
        

        
        DECLARE @sReceiptNo VARCHAR(MAX)= NULL
        DECLARE @iStudentDetailID INT
        DECLARE @iReceiptHeader INT= NULL
        DECLARE @chkdue DECIMAL(14, 2)= 0.00
        DECLARE @currDate DATETIME = GETDATE()
        DECLARE @PaymentDetailsXML XML= @sPaymentDetailsXML
        DECLARE @countInvHeader INT= 0
        DECLARE @startpos INT= 1
        DECLARE @paymentmodeid INT
		DECLARE @rdate DATETIME=GETDATE()
        
        
        
        insert into T_Online_Payment_Audit
        (
        BrandName,
		StudentID,
		ReceiptDate,
		CentreID,
		PaymentDetailsXML,
		ReceiptAmount,
		ReceiptTaxAmount,
		ReceiptType,
		TransactionCode,
		ExtReceiptNo,
		SourceName,
		CreatedOn
        )
        values
        (
        @sBrandName,
        @sStudentID,
        @dReceiptDate,
        @iCentreId,
        @sPaymentDetailsXML,
        @ReceiptAmount,
        @ReceiptTaxAmount,
        @iReceiptType,
        @sTransactionCode,
        @sExtReceiptNo,
        @sSource,
        GETDATE()
        )
        
        
        IF @sSource='PAYTM'
			SET @paymentmodeid=24
		IF @sSource='ONLINE-HDFC'
			SET @paymentmodeid=25
		IF @sSource='INDNET'
			SET @paymentmodeid=26		
        
        
        


        IF @sBrandName = 'RICE'
            SET @iBrandID = 109
        ELSE IF @sBrandName='AIS'
			SET @iBrandID=107
		ELSE IF @sBrandName='AWS'
			SET @iBrandID=110	    
        ELSE
            RAISERROR('Wrong Brand Name',11,1)
            
            
            
        IF NOT EXISTS(SELECT * FROM dbo.T_Student_Detail AS TSD
                INNER JOIN dbo.T_Student_Center_Detail AS TSCD ON TSCD.I_Student_Detail_ID = TSD.I_Student_Detail_ID
                INNER JOIN dbo.T_Center_Hierarchy_Name_Details AS TCHND ON TCHND.I_Center_ID=TSCD.I_Centre_Id
                WHERE   TSD.S_Student_ID = @sStudentID AND TSD.I_Status=1 AND TCHND.I_Brand_ID=@iBrandID AND TSCD.I_Status=1)
        BEGIN
        
        RAISERROR('Invalid Student ID! Please contact your institution.',11,1) 
        
        END
        
           
            
            
        IF EXISTS ( SELECT  *
                    FROM    dbo.T_OnlinePayment_Receipt_Mapping AS TOPRM
                    WHERE   TOPRM.S_Transaction_No = @sTransactionCode
                            AND TOPRM.S_Crtd_By = @sSource )
            RAISERROR('Duplicate Transaction Code',11,1) 
            
            
            
                 
	
	
        IF ( @iBrandID IS NOT NULL )
            BEGIN
                 
		
                SELECT  @iStudentDetailID = TSD.I_Student_Detail_ID
                FROM    dbo.T_Student_Detail AS TSD
                INNER JOIN dbo.T_Student_Center_Detail AS TSCD ON TSCD.I_Student_Detail_ID = TSD.I_Student_Detail_ID
                INNER JOIN dbo.T_Center_Hierarchy_Name_Details AS TCHND ON TCHND.I_Center_ID=TSCD.I_Centre_Id
                WHERE   TSD.S_Student_ID = @sStudentID AND TSD.I_Status=1 AND TCHND.I_Brand_ID=@iBrandID AND TSCD.I_Status=1
                        --AND @sStudentID LIKE '%/RICE/%'
                
                
                CREATE TABLE #CHKDUE
                    (
                      S_Brand_Name VARCHAR(MAX) ,
                      I_Center_ID INT ,
                      S_Center_Name VARCHAR(MAX) ,
                      S_Course_Name VARCHAR(MAX) ,
                      S_Batch_Name VARCHAR(MAX) ,
                      S_Student_ID VARCHAR(MAX) ,
                      S_Student_Name VARCHAR(MAX) ,
                      I_Invoice_Header_ID INT ,
                      S_Invoice_No VARCHAR(MAX) ,
                      I_Invoice_Child_Header_ID INT ,
                      I_Invoice_Detail_ID INT ,
                      Dt_Installment_Date DATETIME ,
                      I_Installment_No INT ,
                      I_Fee_Component_ID INT ,
                      S_Component_Name VARCHAR(MAX) ,
                      BaseAmountDue DECIMAL(14, 2) ,
                      TaxDue DECIMAL(14, 2) ,
                      TotalAmtPayable DECIMAL(14, 2) ,
                      Amount_Paid DECIMAL(14, 2) ,
                      Tax_Paid DECIMAL(14, 2) ,
                      Total_Paid DECIMAL(14, 2) ,
                      CurrentDue DECIMAL(14, 2)
                    )
       
                INSERT  INTO #CHKDUE
                        EXEC dbo.uspGetIndividualStudentDueForRICEAPI @sBrandName = @sBrandName, -- varchar(max)
                            @StudentID = @sStudentID -- varchar(max)
                            
                            
                            
           
                SELECT  @chkdue = ISNULL(SUM(ISNULL(T1.CurrentDue, 0.00)),
                                         0.00)
                FROM    #CHKDUE T1
                WHERE   T1.S_Student_ID = @sStudentID
                        --AND T1.I_Invoice_Header_ID = @iInvoiceHeaderID
                GROUP BY T1.S_Student_ID 
                        --T1.I_Invoice_Header_ID    
           
                IF ( ( @chkdue = ISNULL(@ReceiptAmount, 0.00)
                       + ISNULL(@ReceiptTaxAmount, 0.00) )
                     AND @chkdue > 0.00
                   )
                    BEGIN
                    
                         
                    
                        SET @countInvHeader = @PaymentDetailsXML.value('count((TblRctInvDtl/TblRctCompDtl))',
                                                              'int')
                        WHILE ( @startpos <= @countInvHeader )
                            BEGIN
                        
                                DECLARE @InvXML XML
                                DECLARE @InvoiceHeaderID INT
                                DECLARE @ReceiptAmt DECIMAL(14, 2)
                                DECLARE @TaxAmt DECIMAL(14, 2)
                                DECLARE @chkcurrbasedue DECIMAL(14, 2)
                                DECLARE @chkcurrtaxdue DECIMAL(14, 2)
                        
                                --PRINT 'Start position'
                                --    + CAST(@startpos AS VARCHAR)
                        
                                SET @InvXML = @PaymentDetailsXML.query('TblRctInvDtl/TblRctCompDtl[position()=sql:variable("@startpos")]') 
                                
                                --SELECT  @InvXML
                        
                                SET @InvoiceHeaderID = ( SELECT
                                                              T.a.value('@I_Invoice_Header_ID',
                                                              'int')
                                                         FROM @InvXML.nodes('/TblRctCompDtl') T ( a )
                                                       ) 
                                                       
                                --PRINT @InvoiceHeaderID                        
                        
                                SELECT  @chkcurrbasedue = ISNULL(SUM(ISNULL(T1.BaseAmountDue
                                                              - T1.Amount_Paid,
                                                              0.00)), 0.00)
                                FROM    #CHKDUE T1
                                WHERE   T1.S_Student_ID = @sStudentID
                                        AND T1.I_Invoice_Header_ID = @InvoiceHeaderID
                                GROUP BY T1.S_Student_ID ,
                                        T1.I_Invoice_Header_ID 
                                        
                                        
                                SELECT  @chkcurrtaxdue = ISNULL(SUM(ISNULL(T1.TaxDue
                                                              - T1.Tax_Paid,
                                                              0.00)), 0.00)
                                FROM    #CHKDUE T1
                                WHERE   T1.S_Student_ID = @sStudentID
                                        AND T1.I_Invoice_Header_ID = @InvoiceHeaderID
                                GROUP BY T1.S_Student_ID ,
                                        T1.I_Invoice_Header_ID        
                                        
                                --PRINT @chkcurrbasedue 
                                --PRINT @chkcurrtaxdue       
                                        
                                        
                                SET @ReceiptAmt = dbo.fnGetReceiptAmtfromXML(@InvXML)
                                SET @TaxAmt = dbo.fnGetReceiptTaxAmtfromXML(@InvXML)
                                
                                
                                --PRINT @ReceiptAmt
                                --PRINT @TaxAmt
                                
                                
                                IF ( @chkcurrbasedue = @ReceiptAmt
                                     AND @chkcurrtaxdue = @TaxAmt
                                     AND ( @chkcurrbasedue + @chkcurrtaxdue ) > 0
                                     AND @chkcurrbasedue > 0
                                   )
                                    BEGIN
                                    
                                        IF (@InvoiceHeaderID>0 )
                                        
                                        BEGIN
                                
                                        EXEC dbo.uspInsertReceiptHeaderFromAPI @sReceiptNo, -- varchar(20)
                                            @InvoiceHeaderID, -- int
                                            @rdate, -- datetime
                                            @iStudentDetailID, -- int
                                            @paymentmodeid, -- int
                                            @iCentreId, -- int
                                            @ReceiptAmt, -- numeric
                                            @TaxAmt, -- numeric
                                            'N', -- char(1)
                                            'rice-group-admin', -- varchar(20)
                                            @rdate, -- datetime
                                            NULL, -- numeric
                                            NULL, -- varchar(12)
                                            NULL, -- varchar(500)
                                            NULL, -- varchar(20)
                                            NULL, -- varchar(12)
                                            NULL, -- varchar(50)
                                            NULL, -- varchar(20)
                                            2, -- int
                                            @iBrandID, -- int
                                            '', -- varchar(500)
                                            @InvXML, @iReceiptHeader OUTPUT
                                            
                                            
                                         PRINT @iReceiptHeader
   
            
                                        IF ( @iReceiptHeader <> 0
                                             AND @iReceiptHeader IS NOT NULL
                                           )
                                            BEGIN
                                            
                                                IF ( ( @ReceiptAmt = ( SELECT
                                                              ISNULL(SUM(ISNULL(A.N_Amount_Paid,
                                                              0)), 0)
                                                              FROM
                                                              dbo.T_Receipt_Component_Detail A
                                                              WHERE
                                                              A.I_Receipt_Detail_ID = @iReceiptHeader
                                                              ) )
                                                     AND ( ABS(@TaxAmt - ( SELECT
                                                              ISNULL(SUM(ISNULL(B.N_Tax_Paid,
                                                              0)), 0)
                                                              FROM
                                                              dbo.T_Receipt_Component_Detail A
                                                              INNER JOIN dbo.T_Receipt_Tax_Detail B ON B.I_Receipt_Comp_Detail_ID = A.I_Receipt_Comp_Detail_ID
                                                              WHERE
                                                              A.I_Receipt_Detail_ID = @iReceiptHeader
                                                              ) )<=0.02)
                                                   )
                                                    BEGIN
            
                                                        
                                                        
                                                        
                                                        
                                                        
                                                        INSERT
                                                              INTO dbo.T_OnlinePayment_Receipt_Mapping
                                                              (
                                                              I_Receipt_Header_ID ,
                                                              S_Receipt_No ,
                                                              S_Transaction_No ,
                                                              S_Ext_Receipt_No ,
                                                              N_Amount ,
                                                              N_Tax ,
                                                              Dt_Crtd_On ,
                                                              S_Crtd_By ,
                                                              Dt_ActualReceiptDate
                                                              )
                                                        VALUES
                                                              (
                                                              @iReceiptHeader , -- I_Receipt_Header_ID - int
                                                              NULL , -- S_Receipt_No - varchar(max)
                                                              @sTransactionCode , -- S_Transaction_No - varchar(max)
                                                              @sExtReceiptNo , -- S_Ext_Receipt_No - varchar(max)
                                                              @ReceiptAmt ,
                                                              @TaxAmt ,
                                                              @currDate , -- Dt_Crtd_On - datetime
                                                              @sSource ,  -- Dt_Crtd_By - varchar(max)
                                                              @dReceiptDate
                                                              )
                                                              
                                                          
                                                              
                                                        
                                                    END
                                                 
                                                ELSE
                                                    BEGIN
                                                 
                                                        RAISERROR('TRANSACTION ERROR(3)!!',11,1)
                                                 
                                                    END
                                                        
                                
                                                --SELECT  TOPRM.I_Receipt_Header_ID AS ReceiptHeader ,
                                                --        TOPRM.N_Amount AS AmountPaid ,
                                                --        N_Tax AS TaxPaid
                                                --FROM    dbo.T_OnlinePayment_Receipt_Mapping
                                                --        AS TOPRM
                                                --WHERE   TOPRM.I_Receipt_Header_ID = @iReceiptHeader
                    
                                            END 
                                            
                                        ELSE
                                            BEGIN
                                            
                                                RAISERROR('TRANSACTION ERROR(2)!!',11,1)
                                            
                                            END 
                                            
                                    END 
                                    
                                    IF ( @InvoiceHeaderID <0 )
                                                BEGIN
                                         
                                                    DECLARE @receipttype INT
                                                    DECLARE @cgst DECIMAL(14,2)=0
                                                    DECLARE @sgst DECIMAL(14,2)=0
                                                    DECLARE @OnAccTaxXML XML='<ReceiptTax />'
                                                    
                                                    
                                                    IF (@TaxAmt IS NOT NULL AND @TaxAmt>0)
                                                    
                                                    BEGIN
														SET @cgst=ROUND((@TaxAmt/2),2)
														SET @sgst=@TaxAmt-@cgst
														
														SET @OnAccTaxXML='<ReceiptTax><TaxDetails TaxID="7" TaxPaid="'+CAST(@cgst AS VARCHAR)+'"/>
														<TaxDetails TaxID="8" TaxPaid="'+CAST(@sgst AS VARCHAR)+'"/></ReceiptTax>'
														
													END
													
													
													
														
													IF(@InvoiceHeaderID=-1)
													BEGIN
                                                    SET @receipttype = CASE
                                                              WHEN @iBrandID = 107
                                                              THEN 27
                                                              WHEN @iBrandID=110 THEN 55
                                                              WHEN @iBrandID=109 THEN 77
                                                              END
													END
													ELSE IF(@InvoiceHeaderID=-2)
													BEGIN

														SET @receipttype=62

													END
                                
                                                    EXEC uspGenerateReceiptForOnAccountAPI @iCenterId = @iCentreId,
                                                        @iAmount = @ReceiptAmt,
                                                        @iStudentDetailId = @iStudentDetailID,
                                                        @iReceiptDate = @rdate,
                                                        @iPaymentModeId = @paymentmodeid,
                                                        @sChequeDDno = NULL,
                                                        @dChequeDate = NULL,
                                                        @sBankName = NULL,
                                                        @sBranchName = NULL,
                                                        @iCreditCardNo = NULL,
                                                        @sCreditCardIssuer = NULL,
                                                        @dCardExpiryDate = NULL,
                                                        @sCrtdBy = 'rice-group-admin',
                                                        @iReceiptType = @receipttype,
                                                        @dTaxAmount = @TaxAmt,
                                                        @TaxXML = @OnAccTaxXML,
                                                        @iBrandID = @iBrandID,
                                                        @iEnquiryID = NULL,
                                                        @sFormNo = NULL,
                                                        @sNarration = '',
                                                        @iReceiptHeader = @iReceiptHeader OUTPUT
                                            
														
													PRINT @iReceiptHeader
            
                                                    IF ( @iReceiptHeader <> 0
                                                         AND @iReceiptHeader IS NOT NULL
                                                       )
                                                        BEGIN
                                            
                                                            IF ( ( @ReceiptAmt = ( SELECT
                                                              ISNULL(SUM(ISNULL(A.N_Receipt_Amount,
                                                              0)), 0)
                                                              FROM
                                                              dbo.T_Receipt_Header A
                                                              WHERE
                                                              A.I_Receipt_Header_ID = @iReceiptHeader
                                                              ) )
                                                              AND ( @TaxAmt = ( SELECT
                                                              ISNULL(SUM(ISNULL(B.N_Tax_Paid,
                                                              0)), 0)
                                                              FROM
                                                              dbo.T_Receipt_Header A
                                                              INNER JOIN dbo.T_OnAccount_Receipt_Tax B ON B.I_Receipt_Header_ID = A.I_Receipt_Header_ID
                                                              WHERE
                                                              A.I_Receipt_Header_ID = @iReceiptHeader
                                                              ) )
                                                              )
                                                              BEGIN
            
                                                        
                                                        
                                                        
                                                        
                                                        
                                                              INSERT
                                                              INTO dbo.T_OnlinePayment_Receipt_Mapping
                                                              (
                                                              I_Receipt_Header_ID ,
                                                              S_Receipt_No ,
                                                              S_Transaction_No ,
                                                              S_Ext_Receipt_No ,
                                                              N_Amount ,
                                                              N_Tax ,
                                                              Dt_Crtd_On ,
                                                              S_Crtd_By ,
                                                              Dt_ActualReceiptDate
                                                              )
                                                              VALUES
                                                              (
                                                              @iReceiptHeader , -- I_Receipt_Header_ID - int
                                                              NULL , -- S_Receipt_No - varchar(max)
                                                              @sTransactionCode , -- S_Transaction_No - varchar(max)
                                                              @sExtReceiptNo , -- S_Ext_Receipt_No - varchar(max)
                                                              @ReceiptAmt ,
                                                              @TaxAmt ,
                                                              @currDate , -- Dt_Crtd_On - datetime
                                                              @sSource ,  -- Dt_Crtd_By - varchar(max)
                                                              @dReceiptDate
                                                              )
                                                              
                                                          
                                                              
                                                        
                                                              END
                                                 
                                                            ELSE
                                                              BEGIN
                                                 
                                                              RAISERROR('TRANSACTION ERROR(3)!!',11,1)
                                                 
                                                              END
                                                        
                                
                                                --SELECT  TOPRM.I_Receipt_Header_ID AS ReceiptHeader ,
                                                --        TOPRM.N_Amount AS AmountPaid ,
                                                --        N_Tax AS TaxPaid
                                                --FROM    dbo.T_OnlinePayment_Receipt_Mapping
                                                --        AS TOPRM
                                                --WHERE   TOPRM.I_Receipt_Header_ID = @iReceiptHeader
                    
                                                        END 
                                            
                                                    ELSE
                                                        BEGIN
                                            
                                                            RAISERROR('TRANSACTION ERROR(2)!!',11,1)
                                            
                                                        END
                                            
                                                END           
									--------------------

									







                                    END
                                --PRINT 'End position'
                                --    + CAST(@startpos AS VARCHAR)  
                                
                                SET @startpos = @startpos + 1                        
                                
                            END
                            
                        DECLARE @chkAmt DECIMAL(14, 2)
                            
                        SELECT  @chkAmt = ISNULL(T1.TotalTransactionAmount, 0)
                        FROM    ( SELECT    TOPRM.S_Transaction_No ,
                                            SUM(ISNULL(TOPRM.N_Amount, 0)
                                                + ISNULL(TOPRM.N_Tax, 0)) AS TotalTransactionAmount
                                  FROM      dbo.T_OnlinePayment_Receipt_Mapping
                                            AS TOPRM
                                  WHERE     TOPRM.S_Transaction_No = @sTransactionCode
                                            AND TOPRM.S_Crtd_By = @sSource
                                  GROUP BY  TOPRM.S_Transaction_No
                                ) T1
                                
                        PRINT @chkAmt        
                            
                        IF ( @chkAmt <> @ReceiptAmount + @ReceiptTaxAmount )
                            BEGIN
                            
                                UPDATE  dbo.T_Receipt_Header
                                SET     I_Status = 0 ,
                                        Dt_Upd_On = GETDATE() ,
                                        S_Upd_By = 'rice-group-admin'
                                WHERE   I_Receipt_Header_ID IN (
                                        SELECT  TOPRM.I_Receipt_Header_ID
                                        FROM    dbo.T_OnlinePayment_Receipt_Mapping
                                                AS TOPRM
                                        WHERE   TOPRM.S_Transaction_No = @sTransactionCode
                                                AND TOPRM.S_Crtd_By = @sSource --GROUP BY TOPRM.S_Transaction_No
                            )
                            
                                RAISERROR('TRANSACTION ERROR(1)!!',11,1)
                            
                            END
                            
                            
                            
                            
                            
                    END
                    
                    
                ELSE
                    BEGIN
                        RAISERROR('Transaction Amount Does Not match With Due Amount',11,1)
                    
                    END    
                   
            END
            
            

        --EXEC dbo.uspGetPaymentDetailsByTransactionCode @sBrandName = @sBrandName, -- varchar(max)
        --    @sStudentID = @sStudentID, -- varchar(max)
        --    @sTransactionCode = @sTransactionCode, -- varchar(max)
        --    @sExtReceiptNo = @sExtReceiptNo, -- varchar(max)
        --    @sSource = 'PAYTM', -- varchar(max)
        --    @RAmount = @ReceiptAmount, -- decimal
        --    @RTax = @ReceiptTaxAmount, -- decimal
        --    @sStatus = NULL -- varchar(10)
                
                
        --INSERT  INTO dbo.T_SP_Transaction_Log
        --        ( CreatedOn ,
        --          LogText
        --        )
        --VALUES  ( GETDATE() , -- CreatedOn - datetime
        --          'Executed uspGetPaymentDetailsByTransactionCode' -- LogText - varchar(max)
        --        )        

        COMMIT TRANSACTION
        
        EXEC dbo.uspSendSMSForOnlinePayments @iBrandID = @iBrandID, -- int
            @sTransactionNo = @sTransactionCode -- varchar(max) 
        
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

