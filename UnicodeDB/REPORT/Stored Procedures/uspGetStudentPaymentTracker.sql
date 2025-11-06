CREATE PROCEDURE [REPORT].[uspGetStudentPaymentTracker]
    (
      @iBrandID INT ,
      @sHierarchyListID VARCHAR(MAX) ,
      @dtStartDate DATETIME ,
      @dtEndDate DATETIME
    )
AS
    BEGIN

        CREATE TABLE #RHDet
            (
			  Center VARCHAR(MAX),
              StudentID VARCHAR(MAX) ,
              StudentName VARCHAR(MAX) ,
              AdmissionDate DATETIME,
              InvHeaderID INT ,
              MonthYear VARCHAR(MAX) ,
              YearNum INT,
              MonthNum INT,
              AmountPaid DECIMAL(14, 2)
            )

        INSERT  INTO #RHDet
                SELECT  TCHND.S_Center_Name,
						TSD.S_Student_ID ,
                        TSD.S_First_Name + ' ' + ISNULL(TSD.S_Middle_Name, '')
                        + ' ' + TSD.S_Last_Name AS StudentName ,
                        TSD.Dt_Crtd_On,
                        TRH.I_Invoice_Header_ID ,
                        DATENAME(MONTH, TRH.Dt_Crtd_On) + ' '
                        + CAST(DATEPART(YEAR, TRH.Dt_Crtd_On) AS VARCHAR) AS MonthYear ,
                        DATEPART(YYYY,TRH.Dt_Crtd_On) AS YNum,
                        DATEPART(m,TRH.Dt_Crtd_On) AS MNum,
                        SUM(TRH.N_Receipt_Amount) AS AmountPaid
                FROM    dbo.T_Receipt_Header AS TRH
                        INNER JOIN dbo.T_Student_Detail AS TSD ON TSD.I_Student_Detail_ID = TRH.I_Student_Detail_ID
                        INNER JOIN dbo.T_Center_Hierarchy_Name_Details AS TCHND ON TRH.I_Centre_Id = TCHND.I_Center_ID
                WHERE   TRH.I_Status = 1
                        AND ( TSD.Dt_Crtd_On >= @dtStartDate
                              AND TSD.Dt_Crtd_On < DATEADD(d, 1, @dtEndDate)
                            )
                        AND TCHND.I_Center_ID IN (
                        SELECT  FGCFR.centerID
                        FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
                                                           @iBrandID) AS FGCFR )
                        AND TRH.I_Invoice_Header_ID IS NOT NULL
GROUP BY                TCHND.S_Center_Name,
						TSD.S_Student_ID ,
                        TSD.S_First_Name + ' ' + ISNULL(TSD.S_Middle_Name, '')
                        + ' ' + TSD.S_Last_Name ,
                        TSD.Dt_Crtd_On,
                        TRH.I_Invoice_Header_ID ,
                        DATENAME(MONTH, TRH.Dt_Crtd_On) + ' '
                        + CAST(DATEPART(YEAR, TRH.Dt_Crtd_On) AS VARCHAR),
                        DATEPART(YYYY,TRH.Dt_Crtd_On),
                        DATEPART(m,TRH.Dt_Crtd_On)
                        
                        UNION ALL
                        
                        SELECT  TCHND.S_Center_Name,
						TSD.S_Student_ID ,
                        TSD.S_First_Name + ' ' + ISNULL(TSD.S_Middle_Name, '')
                        + ' ' + TSD.S_Last_Name AS StudentName ,
                        TSD.Dt_Crtd_On,
                        TRH.I_Invoice_Header_ID ,
                        'On Admission Date' AS MonthYear ,
                        DATEPART(YYYY,TRH.Dt_Crtd_On) AS YNum,
                        DATEPART(m,TRH.Dt_Crtd_On) AS MNum,
                        SUM(TRH.N_Receipt_Amount) AS AmountPaid
                FROM    dbo.T_Receipt_Header AS TRH
                        INNER JOIN dbo.T_Student_Detail AS TSD ON TSD.I_Student_Detail_ID = TRH.I_Student_Detail_ID
                        INNER JOIN dbo.T_Center_Hierarchy_Name_Details AS TCHND ON TRH.I_Centre_Id = TCHND.I_Center_ID
                WHERE   TRH.I_Status = 1
                        AND ( TSD.Dt_Crtd_On >= @dtStartDate
                              AND TSD.Dt_Crtd_On < DATEADD(d, 1, @dtEndDate)
                            )
                        AND CONVERT(DATE,TRH.Dt_Crtd_On)=CONVERT(DATE,TSD.Dt_Crtd_On)    
                        AND TCHND.I_Center_ID IN (
                        SELECT  FGCFR.centerID
                        FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
                                                           @iBrandID) AS FGCFR )
                        AND TRH.I_Invoice_Header_ID IS NOT NULL
GROUP BY                TCHND.S_Center_Name,
						TSD.S_Student_ID ,
                        TSD.S_First_Name + ' ' + ISNULL(TSD.S_Middle_Name, '')
                        + ' ' + TSD.S_Last_Name ,
                        TSD.Dt_Crtd_On,
                        TRH.I_Invoice_Header_ID ,
                        --DATENAME(MONTH, TRH.Dt_Crtd_On) + ' '
                        --+ CAST(DATEPART(YEAR, TRH.Dt_Crtd_On) AS VARCHAR),
                        DATEPART(YYYY,TRH.Dt_Crtd_On),
                        DATEPART(m,TRH.Dt_Crtd_On)


        SELECT  RD.Center,
				RD.StudentID ,
                RD.StudentName ,
                RD.AdmissionDate,
                TX.S_Batch_Name ,
                TX.BatchStartDate ,
                TX.S_Invoice_No ,
                TX.InitialFeeSchAmount ,
                TX.TotalCreditNoteAmount ,
                TX.FinalInvoiceAmount ,
                RD.MonthYear ,
                RD.YearNum,
                RD.MonthNum,
                RD.AmountPaid
        FROM    ( SELECT    T1.I_Invoice_Header_ID ,
                            T1.S_Invoice_No ,
                            T1.S_Batch_Name ,
                            CONVERT(DATE, T1.Dt_BatchStartDate) AS BatchStartDate ,
                            ISNULL(SUM(ISNULL(T1.N_Amount_Due, 0.00)), 0.00) AS InitialFeeSchAmount ,
                            ISNULL(SUM(ISNULL(T1.CreditNoteAmount, 0.00)),
                                   0.00) AS TotalCreditNoteAmount ,
                            ISNULL(SUM(ISNULL(T1.N_Amount_Due, 0.00)
                                       - ISNULL(T1.CreditNoteAmount, 0.00)),
                                   0.00) AS FinalInvoiceAmount
                  FROM      ( SELECT    TIP.I_Invoice_Header_ID ,
                                        TIP.S_Invoice_No ,
                                        TSBM.I_Batch_ID ,
                                        TSBM.S_Batch_Name ,
                                        TSBM.Dt_BatchStartDate ,
                                        TICD.I_Invoice_Detail_ID ,
                                        TICD.N_Amount_Due ,
                                        ISNULL(TCNICD.N_Amount, 0.00) AS CreditNoteAmount
                              FROM      dbo.T_Invoice_Parent AS TIP
                                        INNER JOIN dbo.T_Invoice_Child_Header
                                        AS TICH ON TICH.I_Invoice_Header_ID = TIP.I_Invoice_Header_ID
                                        INNER JOIN dbo.T_Invoice_Child_Detail
                                        AS TICD ON TICD.I_Invoice_Child_Header_ID = TICH.I_Invoice_Child_Header_ID
                                        LEFT JOIN dbo.T_Credit_Note_Invoice_Child_Detail
                                        AS TCNICD ON TCNICD.I_Invoice_Detail_ID = TICD.I_Invoice_Detail_ID
                                                     AND TCNICD.I_Invoice_Header_ID = TIP.I_Invoice_Header_ID
                                        INNER JOIN dbo.T_Center_Hierarchy_Name_Details
                                        AS TCHND ON TIP.I_Centre_Id = TCHND.I_Center_ID
                                        INNER JOIN dbo.T_Invoice_Batch_Map AS TIBM ON TIBM.I_Invoice_Child_Header_ID = TICH.I_Invoice_Child_Header_ID
                                                              AND TIBM.I_Status = 1
                                        INNER JOIN dbo.T_Student_Batch_Master
                                        AS TSBM ON TSBM.I_Batch_ID = TIBM.I_Batch_ID
                              WHERE     TCHND.I_Center_ID IN (
                                        SELECT  FGCFR.centerID
                                        FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
                                                              @iBrandID) AS FGCFR )
                                        AND ( TIP.Dt_Crtd_On >= @dtStartDate
                                              AND TIP.Dt_Crtd_On < DATEADD(d,
                                                              1, @dtEndDate)
                                            )
                                        AND TIP.I_Status IN ( 1, 0, 3 )
                                        AND TICD.I_Installment_No > 0
                            ) T1
                  GROUP BY  T1.I_Invoice_Header_ID ,
                            T1.S_Invoice_No ,
                            T1.S_Batch_Name ,
                            CONVERT(DATE, T1.Dt_BatchStartDate)
                ) TX
                INNER JOIN #RHDet AS RD ON TX.I_Invoice_Header_ID = RD.InvHeaderID
        ORDER BY RD.Center,RD.StudentID


        DROP TABLE #RHDet


    END
