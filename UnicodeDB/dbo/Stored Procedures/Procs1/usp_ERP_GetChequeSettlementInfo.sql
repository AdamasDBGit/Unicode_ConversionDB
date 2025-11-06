


CREATE PROCEDURE [dbo].[usp_ERP_GetChequeSettlementInfo]  --[uspGetChequeSettlement] null,NULL,794,1     
    (
      @iAcademicSession int,
	  @iMonthNo int,
      @iBrandID INT = NULL ,
      @IsSettlement BIT=NULL,
	  @IsCurrentMonth BIT='true'
    )
AS
    BEGIN          
        SET NOCOUNT ON;

		---- Calculation of Range----

		DECLARE @StartDate DATE = '2024-03-01';
		DECLARE @EndDate DATE = '2025-04-01';
		DECLARE @TargetMonth INT = @iMonthNo; -- November

		DECLARE @dtDateTo datetime=NULL,@dtDateFrom datetime=NULL

		DECLARE @DtOracleCutoffDateofPreviosMonth DATETIME = NULL;
		DECLARE @DtOracleCutoffDateofCurrentMonth DATETIME = NULL;
		DECLARE @n INT = 0; -- Replace with your desired number of months




		select @StartDate=Dt_Session_Start_Date,@EndDate=Dt_Session_End_Date from T_School_Academic_Session_Master 
		where I_School_Session_ID=@iAcademicSession and I_Brand_ID=@iBrandID 

		-- Calculate the year for the target month (November) within the range
		DECLARE @Year INT = YEAR(@StartDate);
		DECLARE @FirstDayOfTargetMonth DATE = DATEFROMPARTS(@Year, @TargetMonth, 1);

		-- If the first day of the target month is before the start date, move to the next year
		IF @FirstDayOfTargetMonth < @StartDate
			SET @FirstDayOfTargetMonth = DATEADD(YEAR, 1, @FirstDayOfTargetMonth);

		-- Calculate the last day of the target month
		DECLARE @LastDayOfTargetMonth DATE = EOMONTH(@FirstDayOfTargetMonth);

		-- Check if the calculated dates fall within the range
		IF @FirstDayOfTargetMonth BETWEEN @StartDate AND @EndDate AND @LastDayOfTargetMonth BETWEEN @StartDate AND @EndDate
		BEGIN
			set @dtDateFrom=@FirstDayOfTargetMonth
			set @dtDateTo=@LastDayOfTargetMonth
		END


		
		--select @dtDateTo,@dtDateFrom
		

		-- Get the last day of the nth month from the current month
		SET @DtOracleCutoffDateofPreviosMonth = EOMONTH(DATEADD(MONTH, (@n-1), GETDATE()));
		set @DtOracleCutoffDateofCurrentMonth = EOMONTH(DATEADD(MONTH, (@n), GETDATE()));

		-------------------------------

		IF @IsSettlement IS NOT NULL
		BEGIN
		

		IF @IsCurrentMonth = 'true'

			BEGIN

				IF @IsSettlement = 0
					BEGIN  
									

						SELECT  RH.N_Receipt_Amount + RH.N_Tax_Amount AS N_Receipt_Amount ,
								RH.I_Receipt_Header_ID ,
								SD.S_First_Name ,
								SD.S_Middle_Name ,
								SD.S_Last_Name ,
								RH.I_Enquiry_Regn_ID ,
								RH.I_Student_Detail_ID ,
								SD.S_Student_ID as StudentID,
								RH.S_Receipt_No ,
								RH.I_Receipt_Type ,
								RH.I_Centre_Id ,
								RH.I_PaymentMode_ID ,
								 CASE WHEN RH.I_PaymentMode_ID=27 THEN ISNULL(RH.S_ChequeDD_No,'NEFT/IMPS')+'('+RH.S_Bank_Name+')' 
							 WHEN RH.I_PaymentMode_ID=31 THEN ISNULL(RH.S_ChequeDD_No,'Online transfer-Loan')+'('+RH.S_Bank_Name+')'--adding Loan Payment : susmita : 2023-Jan-27
						ELSE ISNULL(RH.S_ChequeDD_No,'NEFT/IMPS') END as  S_ChequeDD_No,
								RH.Bank_Account_Name ,
								RH.Dt_Deposit_Date,
								RH.Dt_Receipt_Date,
							CASE WHEN CONVERT(DATE,RH.Dt_Receipt_Date) <= CONVERT(DATE,@LastDayOfTargetMonth) and 
								 CONVERT(DATE,@DtOracleCutoffDateofCurrentMonth) >= CONVERT(DATE,GETDATE()) 
								 and  CONVERT(DATE,@LastDayOfTargetMonth) >= CONVERT(DATE,GETDATE())
								 THEN 'true'
								 ELSE 'false' END IsEditable



						FROM    dbo.T_Receipt_Header RH WITH ( NOLOCK )
								INNER JOIN dbo.T_Student_Detail SD WITH ( NOLOCK ) ON SD.I_Student_Detail_ID = RH.I_Student_Detail_ID
								INNER JOIN dbo.T_PaymentMode_Master AS TPMM WITH (NOLOCK) ON TPMM.I_PaymentMode_ID = RH.I_PaymentMode_ID
								INNER JOIN dbo.T_Brand_Center_Details as BCD WITH (NOLOCK) ON BCD.I_Centre_Id=RH.I_Centre_Id -- added for eliminate for remove arivoo's centre depenedency  
						WHERE TPMM.ISAllowedForSattlement = 'true'
						AND TPMM.IsAllowedForCheque = 'true'
								AND ( RH.Bank_Account_Name IS NULL
									  OR RH.Dt_Deposit_Date IS NULL
									)
								AND CONVERT(DATE,RH.Dt_Receipt_Date) BETWEEN @dtDateFrom
													   AND     @dtDateTo
								AND RH.I_Status = 1
								AND BCD.I_Brand_ID=@iBrandID
						UNION ALL
						SELECT  RH.N_Receipt_Amount + RH.N_Tax_Amount AS N_Receipt_Amount ,
								RH.I_Receipt_Header_ID ,
								TERD.S_First_Name ,
								TERD.S_Middle_Name ,
								TERD.S_Last_Name ,
								RH.I_Enquiry_Regn_ID ,
								RH.I_Student_Detail_ID ,
								NULL as StudentID,
								RH.S_Receipt_No ,
								RH.I_Receipt_Type ,
								RH.I_Centre_Id ,
								RH.I_PaymentMode_ID ,
								 CASE WHEN RH.I_PaymentMode_ID=27 THEN ISNULL(RH.S_ChequeDD_No,'NEFT/IMPS')+'('+RH.S_Bank_Name+')' 
							 WHEN RH.I_PaymentMode_ID=31 THEN ISNULL(RH.S_ChequeDD_No,'Online transfer-Loan')+'('+RH.S_Bank_Name+')'--adding Loan Payment : susmita : 2023-Jan-27
						ELSE ISNULL(RH.S_ChequeDD_No,'NEFT/IMPS') END as  S_ChequeDD_No,
								RH.Bank_Account_Name ,
								RH.Dt_Deposit_Date,
								RH.Dt_Receipt_Date,
								CASE WHEN CONVERT(DATE,RH.Dt_Receipt_Date) <= CONVERT(DATE,@LastDayOfTargetMonth) and 
								 CONVERT(DATE,@DtOracleCutoffDateofCurrentMonth) >= CONVERT(DATE,GETDATE()) 
								 and  CONVERT(DATE,@LastDayOfTargetMonth) >= CONVERT(DATE,GETDATE())
								 THEN 'true'
								 ELSE 'false' END IsEditable
						FROM    dbo.T_Receipt_Header RH WITH ( NOLOCK )
								INNER JOIN dbo.T_Enquiry_Regn_Detail TERD WITH ( NOLOCK ) ON TERD.I_Enquiry_Regn_ID = RH.I_Enquiry_Regn_ID
								INNER JOIN dbo.T_PaymentMode_Master AS TPMM WITH (NOLOCK) ON TPMM.I_PaymentMode_ID = RH.I_PaymentMode_ID
								INNER JOIN dbo.T_Brand_Center_Details as BCD WITH (NOLOCK) ON BCD.I_Centre_Id=RH.I_Centre_Id -- added for eliminate for remove arivoo's centre depenedency
						WHERE  TPMM.ISAllowedForSattlement = 'true'
						AND TPMM.IsAllowedForCheque = 'true'
								AND ( RH.Bank_Account_Name IS NULL
									  OR RH.Dt_Deposit_Date IS NULL
									)
								AND CONVERT(DATE,RH.Dt_Receipt_Date) BETWEEN @dtDateFrom
													   AND     @dtDateTo
								AND RH.I_Status = 1 
								AND BCD.I_Brand_ID=@iBrandID
  
  
					END    
				ELSE
					BEGIN    
						SELECT  RH.N_Receipt_Amount + RH.N_Tax_Amount AS N_Receipt_Amount ,
								RH.I_Receipt_Header_ID ,
								SD.S_First_Name ,
								SD.S_Middle_Name ,
								SD.S_Last_Name ,
								RH.I_Enquiry_Regn_ID ,
								RH.I_Student_Detail_ID ,
								SD.S_Student_ID as StudentID,
								RH.S_Receipt_No ,
								RH.I_Receipt_Type ,
								RH.I_Centre_Id ,
								RH.I_PaymentMode_ID ,
								 CASE WHEN RH.I_PaymentMode_ID=27 THEN ISNULL(RH.S_ChequeDD_No,'NEFT/IMPS')+'('+RH.S_Bank_Name+')' 
							 WHEN RH.I_PaymentMode_ID=31 THEN ISNULL(RH.S_ChequeDD_No,'Online transfer-Loan')+'('+RH.S_Bank_Name+')'--adding Loan Payment : susmita : 2023-Jan-27
						ELSE ISNULL(RH.S_ChequeDD_No,'NEFT/IMPS') END as  S_ChequeDD_No,
								RH.Bank_Account_Name ,
								RH.Dt_Deposit_Date,
								RH.Dt_Receipt_Date ,
								CASE WHEN CONVERT(DATE,RH.Dt_Receipt_Date) <= CONVERT(DATE,@LastDayOfTargetMonth) and 
								 CONVERT(DATE,@DtOracleCutoffDateofCurrentMonth) >= CONVERT(DATE,GETDATE()) 
								 and  CONVERT(DATE,@LastDayOfTargetMonth) >= CONVERT(DATE,GETDATE())
								 THEN 'true'
								 ELSE 'false' END IsEditable
						FROM    dbo.T_Receipt_Header RH WITH ( NOLOCK )
								INNER JOIN dbo.T_Student_Detail SD WITH ( NOLOCK ) ON SD.I_Student_Detail_ID = RH.I_Student_Detail_ID
								INNER JOIN dbo.T_PaymentMode_Master AS TPMM WITH (NOLOCK) ON TPMM.I_PaymentMode_ID = RH.I_PaymentMode_ID
								INNER JOIN dbo.T_Brand_Center_Details as BCD WITH (NOLOCK) ON BCD.I_Centre_Id=RH.I_Centre_Id -- added for eliminate for remove arivoo's centre depenedency
						WHERE  TPMM.ISAllowedForSattlement = 'true'
						AND TPMM.IsAllowedForCheque = 'true'
								AND DATEDIFF(dd, Dt_Deposit_Date, @dtDateFrom) <= 0
								AND DATEDIFF(dd, Dt_Deposit_Date, @dtDateTo) >= 0 
								AND convert(date,RH.Dt_Receipt_Date) BETWEEN @dtDateFrom AND @dtDateTo
								AND RH.I_Status = 1
								AND BCD.I_Brand_ID=@iBrandID
                        
								UNION ALL
                        
								SELECT  RH.N_Receipt_Amount + RH.N_Tax_Amount AS N_Receipt_Amount ,
								RH.I_Receipt_Header_ID ,
								TERD.S_First_Name ,
								TERD.S_Middle_Name ,
								TERD.S_Last_Name ,
								RH.I_Enquiry_Regn_ID ,
								RH.I_Student_Detail_ID ,
								NULL as StudentID,
								RH.S_Receipt_No ,
								RH.I_Receipt_Type ,
								RH.I_Centre_Id ,
								RH.I_PaymentMode_ID ,
								 CASE WHEN RH.I_PaymentMode_ID=27 THEN ISNULL(RH.S_ChequeDD_No,'NEFT/IMPS')+'('+RH.S_Bank_Name+')' 
							 WHEN RH.I_PaymentMode_ID=31 THEN ISNULL(RH.S_ChequeDD_No,'Online transfer-Loan')+'('+RH.S_Bank_Name+')'--adding Loan Payment : susmita : 2023-Jan-27
						ELSE ISNULL(RH.S_ChequeDD_No,'NEFT/IMPS') END as  S_ChequeDD_No,
								RH.Bank_Account_Name ,
								RH.Dt_Deposit_Date,
								RH.Dt_Receipt_Date ,
								CASE WHEN CONVERT(DATE,RH.Dt_Receipt_Date) <= CONVERT(DATE,@LastDayOfTargetMonth) and 
								 CONVERT(DATE,@DtOracleCutoffDateofCurrentMonth) >= CONVERT(DATE,GETDATE()) 
								 and  CONVERT(DATE,@LastDayOfTargetMonth) >= CONVERT(DATE,GETDATE())
								 THEN 'true'
								 ELSE 'false' END IsEditable
						FROM    dbo.T_Receipt_Header RH WITH ( NOLOCK )
								--INNER JOIN dbo.T_Student_Detail SD WITH ( NOLOCK ) ON SD.I_Student_Detail_ID = RH.I_Student_Detail_ID
								INNER JOIN dbo.T_Enquiry_Regn_Detail AS TERD WITH (NOLOCK) ON TERD.I_Enquiry_Regn_ID = RH.I_Enquiry_Regn_ID
								INNER JOIN dbo.T_PaymentMode_Master AS TPMM WITH (NOLOCK) ON TPMM.I_PaymentMode_ID = RH.I_PaymentMode_ID
								INNER JOIN dbo.T_Brand_Center_Details as BCD WITH (NOLOCK) ON BCD.I_Centre_Id=RH.I_Centre_Id -- added for eliminate for remove arivoo's centre depenedency
					   WHERE   TPMM.ISAllowedForSattlement = 'true'
						AND TPMM.IsAllowedForCheque = 'true'
								AND DATEDIFF(dd, Dt_Deposit_Date, @dtDateFrom) <= 0
								AND DATEDIFF(dd, Dt_Deposit_Date, @dtDateTo) >= 0 
								AND convert(date,RH.Dt_Receipt_Date) BETWEEN @dtDateFrom AND @dtDateTo
								AND RH.I_Status = 1
								AND BCD.I_Brand_ID=@iBrandID
					END  


			END

		ELSE
				BEGIN

						IF @IsSettlement = 0
							BEGIN  
									

								SELECT  RH.N_Receipt_Amount + RH.N_Tax_Amount AS N_Receipt_Amount ,
								RH.I_Receipt_Header_ID ,
								SD.S_First_Name ,
								SD.S_Middle_Name ,
								SD.S_Last_Name ,
								RH.I_Enquiry_Regn_ID ,
								RH.I_Student_Detail_ID ,
								SD.S_Student_ID as StudentID,
								RH.S_Receipt_No ,
								RH.I_Receipt_Type ,
								RH.I_Centre_Id ,
								RH.I_PaymentMode_ID ,
								 CASE WHEN RH.I_PaymentMode_ID=27 THEN ISNULL(RH.S_ChequeDD_No,'NEFT/IMPS')+'('+RH.S_Bank_Name+')' 
							 WHEN RH.I_PaymentMode_ID=31 THEN ISNULL(RH.S_ChequeDD_No,'Online transfer-Loan')+'('+RH.S_Bank_Name+')'--adding Loan Payment : susmita : 2023-Jan-27
						ELSE ISNULL(RH.S_ChequeDD_No,'NEFT/IMPS') END as  S_ChequeDD_No,
								RH.Bank_Account_Name ,
								RH.Dt_Deposit_Date,
								RH.Dt_Receipt_Date ,
								CASE WHEN CONVERT(DATE,RH.Dt_Receipt_Date) <= CONVERT(DATE,@LastDayOfTargetMonth) and 
								 CONVERT(DATE,@DtOracleCutoffDateofCurrentMonth) >= CONVERT(DATE,GETDATE()) 
								 and  CONVERT(DATE,@LastDayOfTargetMonth) >= CONVERT(DATE,GETDATE())
								 THEN 'true'
								 ELSE 'false' END IsEditable
						FROM    dbo.T_Receipt_Header RH WITH ( NOLOCK )
								INNER JOIN dbo.T_Student_Detail SD WITH ( NOLOCK ) ON SD.I_Student_Detail_ID = RH.I_Student_Detail_ID
								INNER JOIN dbo.T_PaymentMode_Master AS TPMM WITH (NOLOCK) ON TPMM.I_PaymentMode_ID = RH.I_PaymentMode_ID
								INNER JOIN dbo.T_Brand_Center_Details as BCD WITH (NOLOCK) ON BCD.I_Centre_Id=RH.I_Centre_Id -- added for eliminate for remove arivoo's centre depenedency  
						WHERE TPMM.ISAllowedForSattlement = 'true'
						AND TPMM.IsAllowedForCheque = 'true'
								AND (RH.Bank_Account_Name IS NULL OR RH.Dt_Deposit_Date IS NULL)
								AND CONVERT(DATE,RH.Dt_Receipt_Date) <= CONVERT(DATE,@DtOracleCutoffDateofPreviosMonth)
								AND RH.I_Status = 1
								AND BCD.I_Brand_ID = @iBrandID
						UNION ALL
						SELECT  RH.N_Receipt_Amount + RH.N_Tax_Amount AS N_Receipt_Amount ,
								RH.I_Receipt_Header_ID ,
								TERD.S_First_Name ,
								TERD.S_Middle_Name ,
								TERD.S_Last_Name ,
								RH.I_Enquiry_Regn_ID ,
								RH.I_Student_Detail_ID ,
								NULL as StudentID,
								RH.S_Receipt_No ,
								RH.I_Receipt_Type ,
								RH.I_Centre_Id ,
								RH.I_PaymentMode_ID ,
								 CASE WHEN RH.I_PaymentMode_ID=27 THEN ISNULL(RH.S_ChequeDD_No,'NEFT/IMPS')+'('+RH.S_Bank_Name+')' 
							 WHEN RH.I_PaymentMode_ID=31 THEN ISNULL(RH.S_ChequeDD_No,'Online transfer-Loan')+'('+RH.S_Bank_Name+')'--adding Loan Payment : susmita : 2023-Jan-27
						ELSE ISNULL(RH.S_ChequeDD_No,'NEFT/IMPS') END as  S_ChequeDD_No,
								RH.Bank_Account_Name ,
								RH.Dt_Deposit_Date,
								RH.Dt_Receipt_Date,
								CASE WHEN CONVERT(DATE,RH.Dt_Receipt_Date) <= CONVERT(DATE,@LastDayOfTargetMonth) and 
								 CONVERT(DATE,@DtOracleCutoffDateofCurrentMonth) >= CONVERT(DATE,GETDATE()) 
								 and  CONVERT(DATE,@LastDayOfTargetMonth) >= CONVERT(DATE,GETDATE())
								 THEN 'true'
								 ELSE 'false' END IsEditable
						FROM    dbo.T_Receipt_Header RH WITH ( NOLOCK )
								INNER JOIN dbo.T_Enquiry_Regn_Detail TERD WITH ( NOLOCK ) ON TERD.I_Enquiry_Regn_ID = RH.I_Enquiry_Regn_ID
								INNER JOIN dbo.T_PaymentMode_Master AS TPMM WITH (NOLOCK) ON TPMM.I_PaymentMode_ID = RH.I_PaymentMode_ID
								INNER JOIN dbo.T_Brand_Center_Details as BCD WITH (NOLOCK) ON BCD.I_Centre_Id=RH.I_Centre_Id -- added for eliminate for remove arivoo's centre depenedency
						WHERE  TPMM.ISAllowedForSattlement = 'true'
						AND TPMM.IsAllowedForCheque = 'true'
								AND (RH.Bank_Account_Name IS NULL OR RH.Dt_Deposit_Date IS NULL)
								AND CONVERT(DATE,RH.Dt_Receipt_Date) <= CONVERT(DATE,@DtOracleCutoffDateofPreviosMonth)
								AND RH.I_Status = 1
								AND BCD.I_Brand_ID = @iBrandID
  
  
							END    
						ELSE
							BEGIN    
								SELECT  RH.N_Receipt_Amount + RH.N_Tax_Amount AS N_Receipt_Amount ,
								RH.I_Receipt_Header_ID ,
								SD.S_First_Name ,
								SD.S_Middle_Name ,
								SD.S_Last_Name ,
								RH.I_Enquiry_Regn_ID ,
								RH.I_Student_Detail_ID ,
								SD.S_Student_ID as StudentID,
								RH.S_Receipt_No ,
								RH.I_Receipt_Type ,
								RH.I_Centre_Id ,
								RH.I_PaymentMode_ID ,
								 CASE WHEN RH.I_PaymentMode_ID=27 THEN ISNULL(RH.S_ChequeDD_No,'NEFT/IMPS')+'('+RH.S_Bank_Name+')' 
							 WHEN RH.I_PaymentMode_ID=31 THEN ISNULL(RH.S_ChequeDD_No,'Online transfer-Loan')+'('+RH.S_Bank_Name+')'--adding Loan Payment : susmita : 2023-Jan-27
						ELSE ISNULL(RH.S_ChequeDD_No,'NEFT/IMPS') END as  S_ChequeDD_No,
								RH.Bank_Account_Name ,
								RH.Dt_Deposit_Date,
								RH.Dt_Receipt_Date ,
								CASE WHEN CONVERT(DATE,RH.Dt_Receipt_Date) <= CONVERT(DATE,@LastDayOfTargetMonth) and 
								 CONVERT(DATE,@DtOracleCutoffDateofCurrentMonth) >= CONVERT(DATE,GETDATE()) 
								 and  CONVERT(DATE,@LastDayOfTargetMonth) >= CONVERT(DATE,GETDATE())
								 THEN 'true'
								 ELSE 'false' END IsEditable
						FROM    dbo.T_Receipt_Header RH WITH ( NOLOCK )
								INNER JOIN dbo.T_Student_Detail SD WITH ( NOLOCK ) ON SD.I_Student_Detail_ID = RH.I_Student_Detail_ID
								INNER JOIN dbo.T_PaymentMode_Master AS TPMM WITH (NOLOCK) ON TPMM.I_PaymentMode_ID = RH.I_PaymentMode_ID
								INNER JOIN dbo.T_Brand_Center_Details as BCD WITH (NOLOCK) ON BCD.I_Centre_Id=RH.I_Centre_Id -- added for eliminate for remove arivoo's centre depenedency
						WHERE  TPMM.ISAllowedForSattlement = 'true'
						AND TPMM.IsAllowedForCheque = 'true'
								AND DATEDIFF(dd, Dt_Deposit_Date, @dtDateFrom) <= 0
									AND DATEDIFF(dd, Dt_Deposit_Date, @dtDateTo) >= 0 
								AND CONVERT(DATE,RH.Dt_Receipt_Date) <= CONVERT(DATE,@DtOracleCutoffDateofPreviosMonth)
								AND RH.I_Status = 1
								AND BCD.I_Brand_ID = @iBrandID
                        
								UNION ALL
                        
								SELECT  RH.N_Receipt_Amount + RH.N_Tax_Amount AS N_Receipt_Amount ,
								RH.I_Receipt_Header_ID ,
								TERD.S_First_Name ,
								TERD.S_Middle_Name ,
								TERD.S_Last_Name ,
								RH.I_Enquiry_Regn_ID ,
								RH.I_Student_Detail_ID ,
								NULL as StudentID,
								RH.S_Receipt_No ,
								RH.I_Receipt_Type ,
								RH.I_Centre_Id ,
								RH.I_PaymentMode_ID ,
								 CASE WHEN RH.I_PaymentMode_ID=27 THEN ISNULL(RH.S_ChequeDD_No,'NEFT/IMPS')+'('+RH.S_Bank_Name+')' 
							 WHEN RH.I_PaymentMode_ID=31 THEN ISNULL(RH.S_ChequeDD_No,'Online transfer-Loan')+'('+RH.S_Bank_Name+')'--adding Loan Payment : susmita : 2023-Jan-27
						ELSE ISNULL(RH.S_ChequeDD_No,'NEFT/IMPS') END as  S_ChequeDD_No,
								RH.Bank_Account_Name ,
								RH.Dt_Deposit_Date,
								RH.Dt_Receipt_Date ,
								CASE WHEN CONVERT(DATE,RH.Dt_Receipt_Date) <= CONVERT(DATE,@LastDayOfTargetMonth) and 
								 CONVERT(DATE,@DtOracleCutoffDateofCurrentMonth) >= CONVERT(DATE,GETDATE()) 
								 and  CONVERT(DATE,@LastDayOfTargetMonth) >= CONVERT(DATE,GETDATE())
								 THEN 'true'
								 ELSE 'false' END IsEditable
						FROM    dbo.T_Receipt_Header RH WITH ( NOLOCK )
								--INNER JOIN dbo.T_Student_Detail SD WITH ( NOLOCK ) ON SD.I_Student_Detail_ID = RH.I_Student_Detail_ID
								INNER JOIN dbo.T_Enquiry_Regn_Detail AS TERD WITH (NOLOCK) ON TERD.I_Enquiry_Regn_ID = RH.I_Enquiry_Regn_ID
								INNER JOIN dbo.T_PaymentMode_Master AS TPMM WITH (NOLOCK) ON TPMM.I_PaymentMode_ID = RH.I_PaymentMode_ID
								INNER JOIN dbo.T_Brand_Center_Details as BCD WITH (NOLOCK) ON BCD.I_Centre_Id=RH.I_Centre_Id -- added for eliminate for remove arivoo's centre depenedency
					   WHERE  TPMM.ISAllowedForSattlement = 'true'
						AND TPMM.IsAllowedForCheque = 'true'
								AND DATEDIFF(dd, Dt_Deposit_Date, @dtDateFrom) <= 0
									AND DATEDIFF(dd, Dt_Deposit_Date, @dtDateTo) >= 0 
								AND CONVERT(DATE,RH.Dt_Receipt_Date) <= CONVERT(DATE,@DtOracleCutoffDateofPreviosMonth)
								AND RH.I_Status = 1
								AND BCD.I_Brand_ID = @iBrandID
							END 



				END

			
		END
		ELSE
		BEGIN


			SELECT  RH.N_Receipt_Amount + RH.N_Tax_Amount AS N_Receipt_Amount ,
							RH.I_Receipt_Header_ID ,
							CASE 
    WHEN SD.S_Student_ID IS NOT NULL THEN SD.S_First_Name 
    ELSE ERD.S_First_Name 
END AS S_First_Name,

CASE 
    WHEN SD.S_Student_ID IS NOT NULL THEN SD.S_Middle_Name 
    ELSE ERD.S_Middle_Name 
END AS S_Middle_Name,

CASE 
    WHEN SD.S_Student_ID IS NOT NULL THEN SD.S_Last_Name 
    ELSE ERD.S_Last_Name 
END AS S_Last_Name,

							RH.I_Enquiry_Regn_ID ,
							RH.I_Student_Detail_ID ,
							SD.S_Student_ID as StudentID,
							RH.S_Receipt_No ,
							RH.I_Receipt_Type ,
							RH.I_Centre_Id ,
							RH.I_PaymentMode_ID ,
							 CASE WHEN RH.I_PaymentMode_ID=27 THEN ISNULL(RH.S_ChequeDD_No,'NEFT/IMPS')+'('+RH.S_Bank_Name+')' 
							 WHEN RH.I_PaymentMode_ID=31 THEN ISNULL(RH.S_ChequeDD_No,'Online transfer-Loan')+'('+RH.S_Bank_Name+')'--adding Loan Payment : susmita : 2023-Jan-27
						ELSE ISNULL(RH.S_ChequeDD_No,'NEFT/IMPS') END as  S_ChequeDD_No,
							RH.Bank_Account_Name ,
							RH.Dt_Deposit_Date,
							RH.Dt_Receipt_Date ,
							CASE WHEN CONVERT(DATE,RH.Dt_Receipt_Date) <= CONVERT(DATE,@LastDayOfTargetMonth) and 
								 CONVERT(DATE,@DtOracleCutoffDateofCurrentMonth) >= CONVERT(DATE,GETDATE()) 
								 and  CONVERT(DATE,@LastDayOfTargetMonth) >= CONVERT(DATE,GETDATE())
								 THEN 'true'
								 ELSE 'false' END IsEditable
					FROM     dbo.T_Receipt_Header RH WITH ( NOLOCK )
							left JOIN dbo.T_Student_Detail SD WITH ( NOLOCK ) ON SD.I_Student_Detail_ID = RH.I_Student_Detail_ID
							left join dbo.T_Enquiry_Regn_Detail as ERD WITH ( NOLOCK ) ON RH.I_Enquiry_Regn_ID=ERD.I_Enquiry_Regn_ID
							INNER JOIN dbo.T_PaymentMode_Master AS TPMM WITH (NOLOCK) ON TPMM.I_PaymentMode_ID = RH.I_PaymentMode_ID
							INNER JOIN dbo.T_Brand_Center_Details as BCD WITH (NOLOCK) ON BCD.I_Centre_Id=RH.I_Centre_Id -- added for eliminate for remove arivoo's centre depenedency  
					WHERE  TPMM.ISAllowedForSattlement = 'true'
						AND TPMM.IsAllowedForCheque = 'true'
							
							AND convert(date,RH.Dt_Receipt_Date) BETWEEN @dtDateFrom
												   AND     @dtDateTo
							AND RH.I_Status = 1
							AND BCD.I_Brand_ID=@iBrandID
			

		END

    END 
  
