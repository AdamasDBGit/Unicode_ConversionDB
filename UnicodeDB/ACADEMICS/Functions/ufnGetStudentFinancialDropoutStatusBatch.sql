--THE FUNCTION HAS BEEN ALTERED FOR THE ABOVE STORED PROCEDURE   
CREATE FUNCTION [ACADEMICS].[ufnGetStudentFinancialDropoutStatusBatch]  
    (  
      @iStudentID INT,  
      @iCenterID INT,  
      @iAllowedNumberOfNonPaymentDays INT,  
      @dCurrenDate DATETIME,  
      @iNoOfRelaxedInstallment INT              
    )  
RETURNS @InvoiceWiseDropoutTable TABLE  
    (  
      I_Student_Detail_ID INT,  
      I_Center_Id INT,  
      I_Invoice_Header_Id INT,  
      S_Is_Dropout_Invoice CHAR(1),  
      S_Is_Reactivation_Fees_Paid VARCHAR(10)  
    )  
AS -- Returns the Student Financial Status Invoicewise.              
   BEGIN  
              
    SET @dCurrenDate = CAST(SUBSTRING(CAST(@dCurrenDate AS VARCHAR), 1, 11) AS DATETIME)               
              
    DECLARE @cDropoutStatus CHAR(1)              
    DECLARE @iInvoiceHeaderID INT              
    DECLARE @nInstallmentTotal NUMERIC(18, 2)              
    DECLARE @nTotalAmountPaid NUMERIC(18, 2)              
    DECLARE @dCutoffinstallmentDate DATETIME      
    DECLARE @iLeaveStatus INT      
    DECLARE @AllowedNumberOfDays INT  
    DECLARE @iBatchGracePeriod INT  
      
    SELECT @iBatchGracePeriod = MAX(I_Latefee_Grace_Day) FROM dbo.T_Student_Batch_Master AS tsbm  
    INNER JOIN dbo.T_Student_Batch_Details AS tsbd  
    ON tsbm.I_Batch_ID = tsbd.I_Batch_ID  
    WHERE I_Student_ID = @iStudentID  
      
    IF (@iBatchGracePeriod IS NULL)  
  SET @iBatchGracePeriod = 0  
      
    SET @AllowedNumberOfDays = @iAllowedNumberOfNonPaymentDays + @iBatchGracePeriod  
      
-- Create Cursor              
    DECLARE FINANCIAL_DROPOUT_CURSOR CURSOR  
        FOR SELECT  I_Invoice_Header_ID  
            FROM    dbo.T_Invoice_Parent WITH ( NOLOCK )  
            WHERE   I_Student_Detail_ID = @iStudentID  
                    AND I_Centre_Id = @iCenterID              
              
    SET @cDropoutStatus = 'N'              
              
    SET @dCutoffinstallmentDate = ( SELECT  DATEADD(DAY,  
                                                    - @AllowedNumberOfDays,  
                                                    GETDATE())  
                                  )              
    SET @dCutoffinstallmentDate = CAST(SUBSTRING(CAST(@dCutoffinstallmentDate AS VARCHAR),  
                                                 1, 11) AS DATETIME)              
                   
    OPEN FINANCIAL_DROPOUT_CURSOR              
    FETCH NEXT FROM FINANCIAL_DROPOUT_CURSOR INTO @iInvoiceHeaderID              
              
    WHILE @@FETCH_STATUS = 0              
        BEGIN         
            IF EXISTS ( SELECT  1  
                        FROM    dbo.T_Student_Batch_Details AS tsbd WITH ( NOLOCK )  
                        INNER JOIN dbo.T_Student_Center_Detail AS tscd  
                        ON tscd.I_Student_Detail_ID = tsbd.I_Student_ID  
                        INNER JOIN dbo.T_Center_Batch_Details AS tcbd  
                        ON tsbd.I_Batch_ID = tcbd.I_Batch_ID  
                        AND tcbd.I_Centre_Id = tscd.I_Centre_Id  
                        WHERE   tsbd.I_Student_ID = @iStudentID  
                                AND tsbd.I_Status = 1  
                                AND tcbd.I_Status <> 5  
                                AND C_Is_LumpSum = 'N' )   
                BEGIN          
             
                    INSERT  INTO @InvoiceWiseDropoutTable  
                            (  
                              I_Student_Detail_ID,  
                              I_Center_Id,  
                              I_Invoice_Header_Id,  
                              S_Is_Dropout_Invoice,  
                              S_Is_Reactivation_Fees_Paid  
                            )  
                    VALUES  (  
                              @iStudentID,  
                              @iCenterID,  
                              @iInvoiceHeaderID,  
                              'N',  
                              'NA'  
                            )             
             
                    DECLARE @iCurrentInstallmentNo INT          
                    DECLARE @nAmountPaidSoFar NUMERIC(18, 2)          
                    DECLARE @nSumofLastNAmount NUMERIC(18, 2)          
                    DECLARE @nCumAmountRecivable NUMERIC(18, 2)          
                    DECLARE @nOutstandingAmount NUMERIC(18, 2)          
             
             
                    SELECT  @nAmountPaidSoFar = ISNULL(SUM(N_Receipt_Amount),  
                                                       0)  
                    FROM    dbo.T_Receipt_Header  
                    WHERE   I_Invoice_Header_ID = @iInvoiceHeaderID  
                            AND CAST(SUBSTRING(CAST(Dt_Receipt_Date AS VARCHAR),  
                                               1, 11) AS DATETIME) <= @dCurrenDate  
                            AND I_Status <> 0          
             
     --------------------------------------------------          
                    SELECT  @iCurrentInstallmentNo = MAX(DISTINCT TICD.I_Installment_No)  
                    FROM    dbo.T_Invoice_Child_Detail TICD  
                            INNER JOIN dbo.T_Invoice_Child_Header TICH ON TICH.I_Invoice_Child_Header_ID = TICD.I_Invoice_Child_Header_ID  
                            INNER JOIN dbo.T_Invoice_Parent TIP ON TIP.I_Invoice_Header_ID = TICH.I_Invoice_Header_ID          
     --WHERE  TIP.I_Status IN ( 1 , 3) -- 1 IS FOR ACTIVE INVOICE AND 3 IS FOR TRANSFER OUT INVOICES WHICH ARE ACTIVE AS WELL          
                                                                   AND TIP.I_Student_Detail_ID = @iStudentID  
                                                                   AND TIP.I_Invoice_Header_ID = @iInvoiceHeaderID  
                                                                   AND CAST(SUBSTRING(CAST(TICD.Dt_Installment_Date AS VARCHAR), 1, 11) AS DATETIME) <= @dCurrenDate          
               
     --PRINT @iCurrentInstallmentNo          
             
             
                    SELECT  @nSumofLastNAmount = SUM(TICD.N_Amount_Due)  
                    FROM    dbo.T_Invoice_Child_Detail TICD  
                            INNER JOIN dbo.T_Invoice_Child_Header TICH ON TICH.I_Invoice_Child_Header_ID = TICD.I_Invoice_Child_Header_ID  
                            INNER JOIN dbo.T_Invoice_Parent TIP ON TIP.I_Invoice_Header_ID = TICH.I_Invoice_Header_ID          
     --WHERE  TIP.I_Status IN ( 1 , 3)          
                                                                   AND TIP.I_Student_Detail_ID = @iStudentID  
                                                                   AND TIP.I_Invoice_Header_ID = @iInvoiceHeaderID  
                                                                   AND CAST(SUBSTRING(CAST(TICD.Dt_Installment_Date AS VARCHAR), 1, 11) AS DATETIME) <= @dCurrenDate  
                                                                   AND TICD.I_Installment_No > = ( @iCurrentInstallmentNo - @iNoOfRelaxedInstallment)  
                                                                   AND TICD.I_Installment_No <= @iCurrentInstallmentNo          
               
                    SELECT  @nCumAmountRecivable = SUM(TICD.N_Amount_Due)  
                    FROM    dbo.T_Invoice_Child_Detail TICD  
                            INNER JOIN dbo.T_Invoice_Child_Header TICH ON TICH.I_Invoice_Child_Header_ID = TICD.I_Invoice_Child_Header_ID  
                            INNER JOIN dbo.T_Invoice_Parent TIP ON TIP.I_Invoice_Header_ID = TICH.I_Invoice_Header_ID          
     --WHERE  TIP.I_Status IN ( 1 , 3)          
                                                                   AND TIP.I_Student_Detail_ID = @iStudentID  
                                                                   AND TIP.I_Invoice_Header_ID = @iInvoiceHeaderID  
                                                                   AND CAST(SUBSTRING(CAST(TICD.Dt_Installment_Date AS VARCHAR), 1, 11) AS DATETIME) <= @dCurrenDate  
                                                                   AND TICD.I_Installment_No <= @iCurrentInstallmentNo          
               
                    SET @nOutstandingAmount = @nCumAmountRecivable  
                        - @nAmountPaidSoFar          
             
     --***********************************************************          
                  
     -- Check if Student is Financial Dropout              
                    IF @nOutstandingAmount > @nSumofLastNAmount   
                        BEGIN              
           -- Check if Student is on leave               
                      
                            IF NOT EXISTS ( SELECT  A.I_Student_Leave_ID  
                                            FROM    dbo.T_Student_Leave_Request A  
                                                    WITH ( NOLOCK )  
                                                    INNER JOIN dbo.T_Student_Center_Detail B  
                                                    WITH ( NOLOCK ) ON A.I_Student_Detail_ID = B.I_Student_Detail_ID  
                                            WHERE   A.I_Student_Detail_ID = @iStudentID  
                                                    AND DATEDIFF(DAY, A.Dt_From_Date, @dCurrenDate) >= 0  
                                                    AND DATEDIFF(DAY, @dCurrenDate, A.Dt_To_Date) >= 0  
                                                    AND A.I_Status = 1  
                                                    AND B.I_Status = 1  
                                                    AND B.I_Centre_ID = @iCenterID )   
                                BEGIN                 
                                    UPDATE  @InvoiceWiseDropoutTable  
                                    SET     S_Is_Dropout_Invoice = 'Y',  
                                            S_Is_Reactivation_Fees_Paid = 'NA'  
                                    WHERE   I_Student_Detail_ID = @iStudentID  
                                            AND I_Center_Id = @iCenterID  
                                            AND I_Invoice_Header_Id = @iInvoiceHeaderID              
                                END       
                        END      
                    ELSE   
                        BEGIN      
          -- Check if Student Has Paid The Reactivation Fees        
                            IF EXISTS ( SELECT  'TRUE'  
                                        FROM    ACADEMICS.T_Dropout_Details TDD  
                                                WITH ( NOLOCK )  
                                                INNER JOIN dbo.T_Invoice_Parent TIP  
                                                WITH ( NOLOCK ) ON TIP.I_Invoice_Header_ID = TDD.I_Invoice_Header_ID  
                                        WHERE   TIP.I_Invoice_Header_Id = @iInvoiceHeaderID  
                                                AND TDD.I_Dropout_Status = 1 )   
                                BEGIN      
                                    IF NOT EXISTS ( SELECT  'TRUE'  
                                                    FROM    dbo.T_Receipt_Header RH  
                                                            WITH ( NOLOCK )  
                                                            INNER JOIN ACADEMICS.T_Dropout_Details TDD  
                                                            WITH ( NOLOCK ) ON TDD.I_Student_Detail_ID = RH.I_Student_Detail_ID  
                                                    WHERE   RH.I_Invoice_Header_ID IS NULL  
                                                            AND RH.I_Receipt_Type = 12  
                                                            AND RH.I_Student_Detail_ID = @iStudentID  
                                                            AND RH.Dt_Crtd_On > ISNULL(TDD.Dt_Upd_On, TDD.Dt_Crtd_On) )   
                                        BEGIN                 
                                            UPDATE  @InvoiceWiseDropoutTable  
                                            SET     S_Is_Dropout_Invoice = 'Y',  
                                                    S_Is_Reactivation_Fees_Paid = 'No'  
                                            WHERE   I_Student_Detail_ID = @iStudentID  
                                                    AND I_Center_Id = @iCenterID  
                                                    AND I_Invoice_Header_Id = @iInvoiceHeaderID              
                                        END      
                                    ELSE   
                                        BEGIN                 
                                            UPDATE  @InvoiceWiseDropoutTable  
                                            SET     S_Is_Dropout_Invoice = 'N',  
                                                    S_Is_Reactivation_Fees_Paid = 'Yes'  
                                            WHERE   I_Student_Detail_ID = @iStudentID  
                                                    AND I_Center_Id = @iCenterID  
                                                    AND I_Invoice_Header_Id = @iInvoiceHeaderID              
                                        END       
               
                                END      
                   
                    
                        END                    
                END        
            ELSE   
                BEGIN        
                    INSERT  INTO @InvoiceWiseDropoutTable  
                            (  
                              I_Student_Detail_ID,  
                              I_Center_Id,  
                              I_Invoice_Header_Id,  
                              S_Is_Dropout_Invoice,  
                              S_Is_Reactivation_Fees_Paid  
                            )  
                    VALUES  (  
                              @iStudentID,  
                              @iCenterID,  
                              @iInvoiceHeaderID,  
                              'N',  
                              'NA'  
                            )         
                END        
            FETCH NEXT FROM FINANCIAL_DROPOUT_CURSOR INTO @iInvoiceHeaderID              
        END              
               
    CLOSE FINANCIAL_DROPOUT_CURSOR              
    DEALLOCATE FINANCIAL_DROPOUT_CURSOR                   
              
-- Return the information to the caller              
    RETURN ;            
   END