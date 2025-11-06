CREATE PROCEDURE [dbo].[uspModifyChequeSettlementDetails]  --[dbo].[uspModifyChequeSettlementDetails] '<Root><StudentCheque I_Student_ID="485" I_Cheque_No="379269" I_Deposite_Date="12/12/2012 12:00:00 AM" I_BankName="1" I_Receipt_Header_ID="1259937" /><StudentCheque I_Student_ID="486" I_Cheque_No="530969" I_Deposite_Date="12/12/2012 12:00:00 AM" I_BankName="1" I_Receipt_Header_ID="1259938" /></Root>' 
(  
  
 @sChequeXML xml 
 )  
  
AS  
BEGIN  
 SET NOCOUNT OFF  
    BEGIN TRY   
        BEGIN TRANSACTION 
        			
        CREATE TABLE #temp1
            (
              I_Student_ID INT ,
              S_Cheque_No nvarchar(max) ,
              Dt_Deposite_Date DATETIME ,
              S_BankName nvarchar(max) ,
              I_Receipt_Header_ID INT          
              )


	DECLARE @DtOracleCutoffDateofCurrentMonth DATETIME = NULL,@DtOracleCutoffDateofPreviousMonth DATETIME;
	DECLARE @n INT = 0; -- Replace with your desired number of months

	-- Get the last day of the nth month from the current month
	SET @DtOracleCutoffDateofCurrentMonth = EOMONTH(DATEADD(MONTH, @n, GETDATE()));

	-- Get the last day of the nth month from the current month
	SET @DtOracleCutoffDateofPreviousMonth = EOMONTH(DATEADD(MONTH, @n-1, GETDATE()));

		select @DtOracleCutoffDateofCurrentMonth DtOracleCutoffDateofCurrentMonth	
		
        INSERT  INTO #temp1
                SELECT  T.c.value('@I_Student_ID', 'INT') ,
                        T.c.value('@I_Cheque_No', 'nvarchar(max)') ,
                        T.c.value('@I_Deposite_Date', 'datetime') ,
                        T.c.value('@I_BankName', 'nvarchar(max)') ,                      
                        T.c.value('@I_Receipt_Header_ID', 'int') 
                FROM    @sChequeXML.nodes('/Root/StudentCheque') T ( c )
                
                
          select * from #temp1      
				INSERT INTO dbo.T_Receipt_Header_Deposit_Audit
				SELECT TRH.*,GETDATE() FROM dbo.T_Receipt_Header AS TRH
				INNER JOIN #temp1 AS T1 ON T1.I_Receipt_Header_ID = TRH.I_Receipt_Header_ID
				WHERE
				TRH.Dt_Deposit_Date IS NOT NULL AND TRH.Bank_Account_Name IS NOT NULL
				AND
				( 
				(MONTH(TRH.Dt_Deposit_Date)<>MONTH(T1.Dt_Deposite_Date) AND YEAR(TRH.Dt_Deposit_Date)<>YEAR(T1.Dt_Deposite_Date)) 
				OR
				(MONTH(TRH.Dt_Deposit_Date)=MONTH(T1.Dt_Deposite_Date) AND YEAR(TRH.Dt_Deposit_Date)<>YEAR(T1.Dt_Deposite_Date))
				OR
				(MONTH(TRH.Dt_Deposit_Date)<>MONTH(T1.Dt_Deposite_Date) AND YEAR(TRH.Dt_Deposit_Date)=YEAR(T1.Dt_Deposite_Date)) 
				)      
				

				IF exists (select * from #temp1)
				BEGIN


				select 
						RH.[I_Receipt_Header_ID],
						RH.[S_Receipt_No],
						RH.[I_Invoice_Header_ID],
						RH.[Dt_Receipt_Date],
						RH.[I_Student_Detail_ID],
						RH.[I_Centre_ID],
						RH.[I_Enquiry_Regn_ID],
						RH.[N_Receipt_Amount],
						RH.[I_Status],
						RH.[Dt_CreditCard_Expiry],
						RH.[S_CreditCard_Issuer],
						RH.[S_Cancellation_Reason],
						RH.[N_CreditCard_No],
						RH.[S_ChequeDD_No],
						RH.[Dt_ChequeDD_Date],
						RH.[S_Bank_Name],
						RH.[S_Branch_Name],
						RH.[I_Receipt_Type],
						RH.[S_Crtd_By],
						RH.[S_Upd_By],
						RH.[Dt_Crtd_On],
						RH.[Dt_Upd_On],
						RH.[N_Tax_Amount],
						RH.[N_Amount_Rff],
						RH.[N_Receipt_Tax_Rff],
						RH.[S_AdjustmentRemarks],
						RH.[Bank_Account_Name],
						RH.[Dt_Deposit_Date],
						RH.[S_Narration],
						GETDATE(),
						T.Dt_Deposite_Date				
						
						from T_Receipt_Header as RH
						INNER JOIN #temp1 AS T ON RH.I_Receipt_Header_ID = T.I_Receipt_Header_ID
						where CONVERT(DATE,RH.Dt_Receipt_Date) <= CONVERT(DATE,@DtOracleCutoffDateofPreviousMonth)
						

						insert into T_Receipt_Header_Backdated_Deposit_Audit
						(
						[I_Receipt_Header_ID],
						[S_Receipt_No],
						[I_Invoice_Header_ID],
						[Dt_Receipt_Date],
						[I_Student_Detail_ID],
						[I_Centre_ID],
						[I_Enquiry_Regn_ID],
						[N_Receipt_Amount],
						[I_Status],
						[Dt_CreditCard_Expiry],
						[S_CreditCard_Issuer],
						[S_Cancellation_Reason],
						[N_CreditCard_No],
						[S_ChequeDD_No],
						[Dt_ChequeDD_Date],
						[S_Bank_Name],
						[S_Branch_Name],
						[I_Receipt_Type],
						[S_Crtd_By],
						[S_Upd_By],
						[Dt_Crtd_On],
						[Dt_Upd_On],
						[N_Tax_Amount],
						[N_Amount_Rff],
						[N_Receipt_Tax_Rff],
						[S_AdjustmentRemarks],
						[Bank_Account_Name],
						[Dt_Deposit_Date],
						[S_Narration],
						[Dt_Audit_Date],
						[Dt_Current_Deposit_Date]
						)
						select 
						RH.[I_Receipt_Header_ID],
						RH.[S_Receipt_No],
						RH.[I_Invoice_Header_ID],
						RH.[Dt_Receipt_Date],
						RH.[I_Student_Detail_ID],
						RH.[I_Centre_ID],
						RH.[I_Enquiry_Regn_ID],
						RH.[N_Receipt_Amount],
						RH.[I_Status],
						RH.[Dt_CreditCard_Expiry],
						RH.[S_CreditCard_Issuer],
						RH.[S_Cancellation_Reason],
						RH.[N_CreditCard_No],
						RH.[S_ChequeDD_No],
						RH.[Dt_ChequeDD_Date],
						RH.[S_Bank_Name],
						RH.[S_Branch_Name],
						RH.[I_Receipt_Type],
						RH.[S_Crtd_By],
						RH.[S_Upd_By],
						RH.[Dt_Crtd_On],
						RH.[Dt_Upd_On],
						RH.[N_Tax_Amount],
						RH.[N_Amount_Rff],
						RH.[N_Receipt_Tax_Rff],
						RH.[S_AdjustmentRemarks],
						RH.[Bank_Account_Name],
						RH.[Dt_Deposit_Date],
						RH.[S_Narration],
						GETDATE(),
						T.Dt_Deposite_Date				
						
						from T_Receipt_Header as RH
						INNER JOIN #temp1 AS T ON RH.I_Receipt_Header_ID = T.I_Receipt_Header_ID
						where CONVERT(DATE,RH.Dt_Receipt_Date) <= CONVERT(DATE,@DtOracleCutoffDateofPreviousMonth)


				END


				
				
                UPDATE dbo.T_Receipt_Header SET Dt_Deposit_Date = t.Dt_Deposite_Date ,Bank_Account_Name= t.S_BankName 
                FROM dbo.T_Receipt_Header AS TRH INNER JOIN #temp1 AS T ON TRH.I_Receipt_Header_ID = T.I_Receipt_Header_ID
                WHERE TRH.I_Status=1
                 
				DROP TABLE #temp1 
                
                COMMIT TRANSACTION
      
    END TRY      
    BEGIN CATCH      
        ROLLBACK TRANSACTION  
        DECLARE @ErrMsg NVARCHAR(max) ,
            @ErrSeverity INT      
        SELECT  @ErrMsg = ERROR_MESSAGE() ,
                @ErrSeverity = ERROR_SEVERITY()      
      
        RAISERROR(@ErrMsg, @ErrSeverity, 1)      
    END CATCH
    END

