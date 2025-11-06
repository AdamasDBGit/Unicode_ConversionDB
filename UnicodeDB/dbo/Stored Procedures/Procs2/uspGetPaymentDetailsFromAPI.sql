CREATE PROCEDURE [dbo].[uspGetPaymentDetailsFromAPI]
    (
      @sBrandName NVARCHAR(max) ,
      @sStudentID NVARCHAR(max) ,
      --@iInvoiceHeaderID INT ,
      @dReceiptDate DATETIME ,
      @iCentreId INT ,
      @ReceiptAmount NUMERIC(18, 2) ,
      @ReceiptTaxAmount NUMERIC(18, 2) ,
      @iReceiptType INT = 2 ,
      @sPaymentDetailsXML XML ,
      @sTransactionCode NVARCHAR(max) ,
      @sExtReceiptNo NVARCHAR(max) ,
      @sSource NVARCHAR(max)
    )
AS
    SET NOCOUNT ON 
    
    --SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
   



 
    BEGIN TRY
    
    
       DECLARE @iBrandID INT= NULL

        BEGIN TRANSACTION
        
        

        
        DECLARE @sReceiptNo nvarchar(max)= NULL
        DECLARE @iStudentDetailID INT
        DECLARE @iReceiptHeader INT= NULL
        DECLARE @chkdue DECIMAL(14, 2)= 0.00
        DECLARE @currDate DATETIME = GETDATE()
        DECLARE @PaymentDetailsXML XML= @sPaymentDetailsXML
        DECLARE @countInvHeader INT= 0
        DECLARE @startpos INT= 1
        
        
        


        IF @sBrandName = 'RICE'
            SET @iBrandID = 109
        ELSE
            RAISERROR('Wrong Brand Name',11,1)
            
            
            
        IF NOT EXISTS(SELECT * FROM dbo.T_Student_Detail AS TSD WHERE TSD.S_Student_ID=@sStudentID AND TSD.I_Status=1)
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
                WHERE   TSD.S_Student_ID = @sStudentID
                        AND @sStudentID LIKE '%/RICE/%'
                
                
                CREATE TABLE #CHKDUE
                    (
                      S_Brand_Name nvarchar(max) ,
                      I_Center_ID INT ,
                      S_Center_Name nvarchar(max) ,
                      S_Course_Name nvarchar(max) ,
                      S_Batch_Name nvarchar(max) ,
                      S_Student_ID nvarchar(max) ,
                      S_Student_Name nvarchar(max) ,
                      I_Invoice_Header_ID INT ,
                      S_Invoice_No nvarchar(max) ,
                      I_Invoice_Child_Header_ID INT ,
                      I_Invoice_Detail_ID INT ,
                      Dt_Installment_Date DATETIME ,
                      I_Installment_No INT ,
                      I_Fee_Component_ID INT ,
                      S_Component_Name nvarchar(max) ,
                      BaseAmountDue DECIMAL(14, 2) ,
                      TaxDue DECIMAL(14, 2) ,
                      TotalAmtPayable DECIMAL(14, 2) ,
                      Amount_Paid DECIMAL(14, 2) ,
                      Tax_Paid DECIMAL(14, 2) ,
                      Total_Paid DECIMAL(14, 2) ,
                      CurrentDue DECIMAL(14, 2)
                    )
       
                INSERT  INTO #CHKDUE
                        EXEC dbo.uspGetIndividualStudentDueForPAYTM @sBrandName = @sBrandName, -- nvarchar(max)
                            @StudentID = @sStudentID -- nvarchar(max)
                            
                            
                            
           
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
                                    
                                        
                                
                                        EXEC dbo.uspInsertReceiptHeaderFromAPI @sReceiptNo, -- nvarchar(max)
                                            @InvoiceHeaderID, -- int
                                            @dReceiptDate, -- datetime
                                            @iStudentDetailID, -- int
                                            24, -- int
                                            @iCentreId, -- int
                                            @ReceiptAmt, -- numeric
                                            @TaxAmt, -- numeric
                                            'N', -- char(1)
                                            'rice-group-admin', -- nvarchar(max)
                                            @dReceiptDate, -- datetime
                                            NULL, -- numeric
                                            NULL, -- nvarchar(max)
                                            NULL, -- nvarchar(max)
                                            NULL, -- nvarchar(max)
                                            NULL, -- nvarchar(max)
                                            NULL, -- nvarchar(max)
                                            NULL, -- nvarchar(max)
                                            2, -- int
                                            @iBrandID, -- int
                                            '', -- nvarchar(max)
                                            @InvXML, @iReceiptHeader OUTPUT
                                            
                                            
                                             
            
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
                                                     AND ( @TaxAmt = ( SELECT
                                                              ISNULL(SUM(ISNULL(B.N_Tax_Paid,
                                                              0)), 0)
                                                              FROM
                                                              dbo.T_Receipt_Component_Detail A
                                                              INNER JOIN dbo.T_Receipt_Tax_Detail B ON B.I_Receipt_Comp_Detail_ID = A.I_Receipt_Comp_Detail_ID
                                                              WHERE
                                                              A.I_Receipt_Detail_ID = @iReceiptHeader
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
                                                              NULL , -- S_Receipt_No - nvarchar(max)
                                                              @sTransactionCode , -- S_Transaction_No - nvarchar(max)
                                                              @sExtReceiptNo , -- S_Ext_Receipt_No - nvarchar(max)
                                                              @ReceiptAmt ,
                                                              @TaxAmt ,
                                                              @currDate , -- Dt_Crtd_On - datetime
                                                              @sSource ,  -- Dt_Crtd_By - nvarchar(max)
                                                              @dReceiptDate
                                                              )
                                                              
               --                                           IF @iBrandID=109
															--UPDATE dbo.T_Receipt_Header SET Bank_Account_Name='BANK OF INDIA - A/C-415620110000009',Dt_Deposit_Date=@dReceiptDate WHERE I_Receipt_Header_ID= @iReceiptHeader  
                                                        
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
            @sTransactionNo = @sTransactionCode -- nvarchar(max)
         
        
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


