CREATE PROCEDURE [dbo].[uspServiceTaxCalculate_temp1]
    (
      -- Add the parameters for the stored procedure here
      @I_Invoice_Header_ID INT
    )
AS 
     BEGIN

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON

  

        DECLARE @N_Receipt_Amount AS DECIMAL(18, 6)
        DECLARE @totIntamnt AS DECIMAL(18, 6)
        DECLARE @totIntamntTillDate AS DECIMAL(18, 6)
		
		--Akash 28.8.2017
        DECLARE @TempTableAdvTax TABLE
        (
        InvDetID INT,
        DtInstalmentDate DATETIME,
        FeeComponentID INT,
        TaxPaid NUMERIC(18,6)
        )
        --Akash 28.8.2017
       
			DECLARE @TempTable TABLE
            (
              SRLNo INT IDENTITY(1, 1) ,
              N_Amount_Due NUMERIC(18, 6) ,
              N_Tax_Rate NUMERIC(18, 6) ,
              Dt_InstDate DATETIME ,
              I_Fee_Component_ID INT
            ) 
            
        --Akash 28.8.2017    
        INSERT INTO @TempTableAdvTax
                ( InvDetID ,
                  DtInstalmentDate ,
                  FeeComponentID ,
                  TaxPaid
                )
        SELECT T1.I_Invoice_Detail_ID,T1.Dt_Installment_Date,T1.I_Fee_Component_ID,ISNULL(SUM(ISNULL(T1.TaxPaid,0)),0) AS TaxPaid FROM
        (        
        SELECT  TICD.I_Invoice_Detail_ID ,TICD.Dt_Installment_Date,TICD.I_Fee_Component_ID,
                            --ISNULL(SUM(ISNULL(TRCD.N_Amount_Paid, 0)), 0) AS AmtPaidAdv ,
                            ISNULL(SUM(ISNULL(TRTD.N_Tax_Paid, 0)), 0) AS TaxPaid
                    FROM    dbo.T_Receipt_Header AS TRH WITH (NOLOCK)
                            INNER JOIN dbo.T_Receipt_Component_Detail AS TRCD WITH (NOLOCK) ON TRCD.I_Receipt_Detail_ID = TRH.I_Receipt_Header_ID
                            INNER JOIN dbo.T_Invoice_Child_Detail AS TICD WITH (NOLOCK) ON TICD.I_Invoice_Detail_ID = TRCD.I_Invoice_Detail_ID
                            LEFT JOIN dbo.T_Receipt_Tax_Detail AS TRTD WITH (NOLOCK) ON TRTD.I_Receipt_Comp_Detail_ID = TRCD.I_Receipt_Comp_Detail_ID
                    WHERE   TRH.I_Status = 1
                            AND TRH.I_Invoice_Header_ID = @I_Invoice_Header_ID
                            AND TICD.Dt_Installment_Date >= '2017-07-01'
                            AND TRH.Dt_Crtd_On < '2017-07-01'
                    GROUP BY TICD.I_Invoice_Detail_ID,TICD.Dt_Installment_Date,TICD.I_Fee_Component_ID
                    
                    UNION ALL
                    
                            SELECT  TICD.I_Invoice_Detail_ID ,TICD.Dt_Installment_Date,TICD.I_Fee_Component_ID,
                            --ISNULL(SUM(ISNULL(TRCD.N_Amount_Paid, 0)), 0) AS AmtPaidAdv ,
                            ISNULL(SUM(ISNULL(TRTD.N_Tax_Paid, 0)), 0) AS TaxPaid
                    FROM    dbo.T_Receipt_Header AS TRH WITH (NOLOCK)
                            INNER JOIN dbo.T_Receipt_Component_Detail AS TRCD WITH (NOLOCK) ON TRCD.I_Receipt_Detail_ID = TRH.I_Receipt_Header_ID
                            INNER JOIN dbo.T_Invoice_Child_Detail AS TICD WITH (NOLOCK) ON TICD.I_Invoice_Detail_ID = TRCD.I_Invoice_Detail_ID
                            LEFT JOIN dbo.T_Receipt_Tax_Detail AS TRTD WITH (NOLOCK) ON TRTD.I_Receipt_Comp_Detail_ID = TRCD.I_Receipt_Comp_Detail_ID
                    WHERE   TRH.I_Status = 1
                            AND TRH.I_Invoice_Header_ID = @I_Invoice_Header_ID
                            AND TICD.Dt_Installment_Date >= '2017-07-01'
                            AND (TRH.Dt_Crtd_On >= '2017-07-01' AND CONVERT(DATE,TRH.Dt_Crtd_On)<CONVERT(DATE,TICD.Dt_Installment_Date))
                    GROUP BY TICD.I_Invoice_Detail_ID,TICD.Dt_Installment_Date,TICD.I_Fee_Component_ID
                    ) T1
                    GROUP BY T1.I_Invoice_Detail_ID,T1.Dt_Installment_Date,T1.I_Fee_Component_ID
                    
                    --Akash 28.8.2017  

        INSERT  INTO @TempTable
        
        --Akash 25.8.2017
        
        SELECT DISTINCT
        ICD.N_Amount_Due,
        CASE WHEN ISNULL(SUM(ISNULL(TTAT.TaxPaid, 0)), 0)<>0 THEN ISNULL(SUM(ISNULL(ITD.N_Tax_Value_Scheduled, 0)), 0)--+ISNULL(SUM(ISNULL(Adv.TaxPaid, 0)), 0)
        ELSE ISNULL(SUM(ISNULL(ITD.N_Tax_Value, 0)), 0) END ,
        ICD.Dt_Installment_Date ,
        ICD.I_Fee_Component_ID
FROM    T_Invoice_Child_Detail ICD WITH ( NOLOCK )
        INNER JOIN T_Invoice_Child_Header ICH WITH ( NOLOCK ) ON ICD.I_Invoice_Child_Header_ID = ICH.I_Invoice_Child_Header_ID
        INNER JOIN dbo.T_Invoice_Parent AS TIP WITH (NOLOCK) ON TIP.I_Invoice_Header_ID = ICH.I_Invoice_Header_ID--03-01-2018
        LEFT JOIN dbo.T_Invoice_Detail_Tax ITD ON ITD.I_Invoice_Detail_ID = ICD.I_Invoice_Detail_ID
        LEFT JOIN @TempTableAdvTax AS TTAT ON TTAT.InvDetID = ICD.I_Invoice_Detail_ID
WHERE   TIP.I_Invoice_Header_ID = @I_Invoice_Header_ID
        AND ICD.I_Installment_No <> 0  --Akash Saha 24.8.2017
        AND TIP.S_Cancel_Type IS NULL--03-01-2018
GROUP BY ICD.N_Amount_Due,
        ICD.Dt_Installment_Date ,
        ICD.I_Fee_Component_ID
        
--03-01-2018
UNION ALL

SELECT DISTINCT
        ICD.N_Amount_Due,
        CASE WHEN ISNULL(SUM(ISNULL(TTAT.TaxPaid, 0)), 0)<>0 THEN ISNULL(SUM(ISNULL(ITD.N_Tax_Value_Scheduled, 0)), 0)--+ISNULL(SUM(ISNULL(Adv.TaxPaid, 0)), 0)
        ELSE ISNULL(SUM(ISNULL(ITD.N_Tax_Value, 0)), 0) END ,
        ICD.Dt_Installment_Date ,
        ICD.I_Fee_Component_ID
FROM    T_Invoice_Child_Detail ICD WITH ( NOLOCK )
        INNER JOIN T_Invoice_Child_Header ICH WITH ( NOLOCK ) ON ICD.I_Invoice_Child_Header_ID = ICH.I_Invoice_Child_Header_ID
        INNER JOIN dbo.T_Invoice_Parent AS TIP WITH (NOLOCK) ON TIP.I_Invoice_Header_ID = ICH.I_Invoice_Header_ID--03-01-2018
        LEFT JOIN dbo.T_Invoice_Detail_Tax ITD ON ITD.I_Invoice_Detail_ID = ICD.I_Invoice_Detail_ID
        LEFT JOIN @TempTableAdvTax AS TTAT ON TTAT.InvDetID = ICD.I_Invoice_Detail_ID
WHERE   TIP.I_Invoice_Header_ID = @I_Invoice_Header_ID
        AND ICD.I_Installment_No <> 0  --Akash Saha 24.8.2017
        AND TIP.S_Cancel_Type=1
        --AND ICD.Dt_Installment_Date<TIP.Dt_Upd_On
        AND TIP.Dt_Upd_On>='2017-07-01'
GROUP BY ICD.N_Amount_Due,
        ICD.Dt_Installment_Date ,
        ICD.I_Fee_Component_ID
        
UNION ALL

SELECT DISTINCT
        -TCNICD.N_Amount AS N_Amount_Due,
        CASE WHEN ISNULL(SUM(ISNULL(TCNICDT.N_Tax_Value, 0)), 0)<>0 THEN -ISNULL(SUM(ISNULL(TCNICDT.N_Tax_Value, 0)),0) END ,
        TICD.Dt_Installment_Date ,
        TICD.I_Fee_Component_ID
FROM    dbo.T_Credit_Note_Invoice_Child_Detail AS TCNICD WITH (NOLOCK)
		INNER JOIN dbo.T_Invoice_Child_Detail AS TICD WITH (NOLOCK) ON TICD.I_Invoice_Detail_ID = TCNICD.I_Invoice_Detail_ID
		LEFT JOIN dbo.T_Credit_Note_Invoice_Child_Detail_Tax AS TCNICDT WITH (NOLOCK) ON TCNICDT.I_Invoice_Detail_ID = TCNICD.I_Invoice_Detail_ID AND TCNICDT.I_Credit_Note_Invoice_Child_Detail_ID = TCNICD.I_Credit_Note_Invoice_Child_Detail_ID       
		WHERE
		TCNICD.I_Invoice_Header_ID=@I_Invoice_Header_ID
		AND TICD.I_Installment_No<>0
		GROUP BY TCNICD.N_Amount,
        TICD.Dt_Installment_Date ,
        TICD.I_Fee_Component_ID
--03-01-2018        
        
 --Akash 25.8.2017 
 SELECT * FROM @TempTableAdvTax AS TTAT
 SELECT * FROM @TempTable AS TT
 
 --Akash 28.8.2017
 UPDATE T1
 SET T1.N_Tax_Rate=T1.N_Tax_Rate+ T2.TaxPaid
 FROM
 (SELECT TTAT.InvDetID,TTAT.DtInstalmentDate,TTAT.FeeComponentID,SUM(ISNULL(TTAT.TaxPaid,0)) AS TaxPaid FROM @TempTableAdvTax AS TTAT
 GROUP BY TTAT.InvDetID,TTAT.DtInstalmentDate,TTAT.FeeComponentID) T2
 INNER JOIN @TempTable AS T1 ON T1.Dt_InstDate=T2.DtInstalmentDate AND T1.I_Fee_Component_ID=T2.FeeComponentID 
 AND T1.N_Amount_Due>0--03-01-2018
 --Akash 28.8.2017     
 -- SELECT * FROM @TempTableAdvTax AS TTAT
 --SELECT * FROM @TempTable AS TT       
        
        /* Akash 25.8.2017
                SELECT DISTINCT
                        ICD.N_Amount_Due-ICD.N_Amount_Adv_Coln AS N_Amount_Due,
                        ISNULL(SUM(ISNULL(ITD.N_Tax_Value_Scheduled, 0)), 0) ,
                        ICD.Dt_Installment_Date ,
                        ICD.I_Fee_Component_ID
                FROM    T_Invoice_Child_Detail ICD WITH ( NOLOCK )
                        INNER JOIN T_Invoice_Child_Header ICH WITH ( NOLOCK ) ON ICD.I_Invoice_Child_Header_ID = ICH.I_Invoice_Child_Header_ID
                        LEFT JOIN dbo.T_Invoice_Detail_Tax ITD ON ITD.I_Invoice_Detail_ID = ICD.I_Invoice_Detail_ID
                WHERE   I_Invoice_Header_ID = @I_Invoice_Header_ID
						AND ICD.I_Installment_No<>0  --Akash Saha 24.8.2017
                GROUP BY ICD.N_Amount_Due ,
                        ICD.Dt_Installment_Date ,
                        ICD.I_Fee_Component_ID
                        
          */              
                
        --SELECT  *
        --FROM    @TempTable TT --;--akash

        SELECT  @totIntamnt = SUM(ISNULL((N_Amount_Due),0.0)) + SUM(ISNULL(N_Tax_Rate,0.0))
        FROM    @TempTable
        ----akash 14.7.2015
        --WHERE Dt_InstDate<=
        --(
        --SELECT TOP 1
        --                TICD.Dt_Installment_Date
        --       FROM     dbo.T_Invoice_Parent TIP
        --                INNER JOIN dbo.T_Invoice_Child_Header TICH ON TIP.I_Invoice_Header_ID = TICH.I_Invoice_Header_ID
        --                INNER JOIN dbo.T_Invoice_Child_Detail TICD ON TICH.I_Invoice_Child_Header_ID = TICD.I_Invoice_Child_Header_ID
        --       WHERE    TICD.I_Installment_No = 1
        --                AND TIP.I_Invoice_Header_ID = @I_Invoice_Header_ID
        --)
        --AND Dt_InstDate<=GETDATE()
        --PRINT @totIntamnt;
        --akash 14.7.2015
       
        SELECT  @N_Receipt_Amount = SUM(N_Receipt_Amount) + SUM(N_Tax_Amount)
        FROM    dbo.T_Receipt_Header A WITH ( NOLOCK )
        WHERE   ISNULL(A.I_Invoice_Header_ID, '') = ISNULL(ISNULL(@I_Invoice_Header_ID,
                                                              A.I_Invoice_Header_ID),
                                                           '')
                AND A.I_Status = 1

--AKASH

        IF ( ( SELECT TOP 1
                        TICD.Dt_Installment_Date
               FROM     dbo.T_Invoice_Parent TIP
                        INNER JOIN dbo.T_Invoice_Child_Header TICH ON TIP.I_Invoice_Header_ID = TICH.I_Invoice_Header_ID
                        INNER JOIN dbo.T_Invoice_Child_Detail TICD ON TICH.I_Invoice_Child_Header_ID = TICD.I_Invoice_Child_Header_ID
               WHERE    TICD.I_Installment_No = 1
                        AND TIP.I_Invoice_Header_ID = @I_Invoice_Header_ID
             ) > GETDATE() ) 
            BEGIN
                SELECT  @totIntamntTillDate = SUM(ISNULL(N_Amount_Due,0.0))
                        + SUM(ISNULL(N_Tax_Rate,0.0))
                FROM    @TempTable
                WHERE   Dt_InstDate <= CONVERT(DATE, ( SELECT TOP 1
                                                              TICD.Dt_Installment_Date
                                                       FROM   dbo.T_Invoice_Parent TIP
                                                              INNER JOIN dbo.T_Invoice_Child_Header TICH ON TIP.I_Invoice_Header_ID = TICH.I_Invoice_Header_ID
                                                              INNER JOIN dbo.T_Invoice_Child_Detail TICD ON TICH.I_Invoice_Child_Header_ID = TICD.I_Invoice_Child_Header_ID
                                                       WHERE  TICD.I_Installment_No = 1
                                                              AND TIP.I_Invoice_Header_ID = @I_Invoice_Header_ID
                                                     )) 
                                                     AND Dt_InstDate<=GETDATE()--akash 14.7.2015
            END
        ELSE 
            BEGIN
                SELECT  @totIntamntTillDate = SUM(N_Amount_Due)
                        + SUM(N_Tax_Rate)
                FROM    @TempTable
                WHERE   Dt_InstDate <= CONVERT(DATE, GETDATE())
            END
--AKASH

        SET @N_Receipt_Amount = ( SELECT    SUM(ISNULL(RC.N_Amount_Paid, 0))
                                  FROM      dbo.T_Receipt_Header A WITH ( NOLOCK )
                                            INNER JOIN dbo.T_Receipt_Component_Detail RC
                                            WITH ( NOLOCK ) ON A.I_Receipt_Header_ID = RC.I_Receipt_Detail_ID
                                  WHERE     ISNULL(A.I_Invoice_Header_ID, '') = ISNULL(ISNULL(@I_Invoice_Header_ID,
                                                              A.I_Invoice_Header_ID),
                                                              '')
                                            AND A.I_Status = 1
                                )
            + ( SELECT  ISNULL(SUM(ISNULL(RTD.N_Tax_Paid, 0)),0)--akash
                FROM    dbo.T_Receipt_Header A WITH ( NOLOCK )
                        INNER JOIN dbo.T_Receipt_Component_Detail RC WITH ( NOLOCK ) ON A.I_Receipt_Header_ID = RC.I_Receipt_Detail_ID
                        INNER JOIN dbo.T_Receipt_Tax_Detail RTD WITH ( NOLOCK ) ON RC.I_Receipt_Comp_Detail_ID = RTD.I_Receipt_Comp_Detail_ID
                                                              AND RC.I_Invoice_Detail_ID = RTD.I_Invoice_Detail_ID
                WHERE   ISNULL(A.I_Invoice_Header_ID, '') = ISNULL(ISNULL(@I_Invoice_Header_ID,
                                                              A.I_Invoice_Header_ID),
                                                              '')
                        AND A.I_Status = 1
              )
              
              --PRINT @totIntamntTillDate
              --PRINT @totIntamnt
              --PRINT @N_Receipt_Amount

        SELECT  CASE WHEN ( ISNULL(@totIntamntTillDate,0) - ISNULL(@N_Receipt_Amount, 0) ) < 0
                     THEN 0.0
                     ELSE ( ISNULL(@totIntamntTillDate,0) - ISNULL(@N_Receipt_Amount, 0) )
                END TotalDueAmntTillDate ,
                CASE WHEN ( ISNULL(@totIntamnt,0) - ISNULL(@N_Receipt_Amount, 0) ) < 0
                     THEN 0.0
                     ELSE ( ISNULL(@totIntamnt,0) - ISNULL(@N_Receipt_Amount, 0) )
                END AS TotalAmntDue

--SELECT  *
--FROM    @TempTable 

	
    END
