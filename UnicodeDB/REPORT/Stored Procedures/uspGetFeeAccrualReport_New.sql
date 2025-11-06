CREATE PROCEDURE [REPORT].[uspGetFeeAccrualReport_New]
    (
      @sHierarchyList VARCHAR(MAX) ,
      @iBrandID INT ,
      @dtFromDate DATETIME ,
      @dtToDate DATETIME
    )
AS
    BEGIN


        DECLARE @dtExecutionDate DATE

        SET @dtExecutionDate = @dtFromDate


        CREATE TABLE #temp
            (
              I_Brand_ID INT ,
              S_Brand_Name VARCHAR(MAX) ,
              I_Centre_ID INT ,
              S_Centre_Name VARCHAR(MAX) ,
              I_Student_Detail_ID INT ,
              FeeComponentName VARCHAR(MAX) ,
              Amount DECIMAL(14, 2) ,
              InstallmentDate DATETIME ,
              MonthYear VARCHAR(MAX)
            )

        WHILE ( DATEDIFF(d, @dtExecutionDate, @dtToDate) >= 0 )
            BEGIN

                INSERT  INTO #temp
                        ( I_Brand_ID ,
                          S_Brand_Name ,
                          I_Centre_ID ,
                          S_Centre_Name ,
                          I_Student_Detail_ID ,
                          FeeComponentName ,
                          Amount ,
                          InstallmentDate ,
                          MonthYear
                        )
                        SELECT  tbcd.I_Brand_ID ,
                                TCHND.S_Brand_Name ,
                                tip.I_Centre_Id ,
                                TCHND.S_Center_Name ,
                                tip.I_Student_Detail_ID ,
                                TFCM.S_Component_Name ,
                                ticd.N_Amount_Due ,
                                @dtExecutionDate ,
                                DATENAME(MONTH, @dtExecutionDate) + ' '
                                + CAST(DATEPART(YYYY, @dtExecutionDate) AS VARCHAR)
                        FROM    dbo.T_Invoice_Parent AS tip
                                INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON tip.I_Centre_Id = TCHND.I_Center_ID
                                INNER JOIN dbo.T_Brand_Center_Details AS tbcd ON tip.I_Centre_Id = tbcd.I_Centre_Id
                                                              AND tbcd.I_Status = 1
                                INNER JOIN dbo.T_Invoice_Child_Header AS tich ON tip.I_Invoice_Header_ID = tich.I_Invoice_Header_ID
                                INNER JOIN dbo.T_Invoice_Child_Detail AS ticd ON tich.I_Invoice_Child_Header_ID = ticd.I_Invoice_Child_Header_ID
                                INNER JOIN dbo.T_Fee_Component_Master TFCM ON ticd.I_Fee_Component_ID = TFCM.I_Fee_Component_ID
                        WHERE   tip.I_Status IN ( 0, 1, 2, 3 )
                                AND DATEDIFF(dd,
                                             CASE WHEN ticd.Dt_Installment_Date >= tip.Dt_Crtd_On
                                                  THEN ticd.Dt_Installment_Date
                                                  ELSE CONVERT(DATE, tip.Dt_Crtd_On)
                                             END, @dtExecutionDate) = 0
                                AND ISNULL(ticd.Flag_IsAdvanceTax, 'N') <> 'Y'
                                AND tip.I_Centre_Id IN (
                                SELECT  FGCFR.centerID
                                FROM    dbo.fnGetCentersForReports(@sHierarchyList,
                                                              @iBrandID) FGCFR )
                        UNION ALL
                        SELECT  tbcd.I_Brand_ID ,
                                TCHND.S_Brand_Name ,
                                TCHND.I_Center_ID ,
                                TCHND.S_Center_Name ,
                                tip.I_Student_Detail_ID ,
                                TTM.S_Tax_Desc AS S_Component_Name ,
                                ABS(ISNULL(tidt.N_Tax_Value_Scheduled, 0)) AS N_Amount_Due ,
                                @dtExecutionDate ,
                                DATENAME(MONTH, @dtExecutionDate) + ' '
                                + CAST(DATEPART(YYYY, @dtExecutionDate) AS VARCHAR)
                        FROM    dbo.T_Invoice_Parent AS tip
                                INNER JOIN dbo.T_Center_Hierarchy_Name_Details
                                AS TCHND ON tip.I_Centre_Id = TCHND.I_Center_ID
                                INNER JOIN dbo.T_Brand_Center_Details AS tbcd ON tip.I_Centre_Id = tbcd.I_Centre_Id
                                                              AND tbcd.I_Status = 1
                                INNER JOIN dbo.T_Invoice_Child_Header AS tich ON tip.I_Invoice_Header_ID = tich.I_Invoice_Header_ID	
	--INNER JOIN dbo.T_Invoice_Batch_Map AS tibm ON tich.I_Invoice_Child_Header_ID = tibm.I_Invoice_Child_Header_ID AND tibm.I_Status = 1
                                INNER JOIN dbo.T_Invoice_Child_Detail AS ticd ON tich.I_Invoice_Child_Header_ID = ticd.I_Invoice_Child_Header_ID
                                INNER JOIN dbo.T_Invoice_Detail_Tax AS tidt ON ticd.I_Invoice_Detail_ID = tidt.I_Invoice_Detail_ID
                                INNER JOIN dbo.T_Tax_Master AS TTM ON TTM.I_Tax_ID = tidt.I_Tax_ID
                        WHERE   --DATEDIFF(dd,ticd.Dt_Installment_Date,@dtExecutionDate) = 0 
                                DATEDIFF(dd,
                                         CASE WHEN ticd.Dt_Installment_Date >= CONVERT(DATE, tip.Dt_Crtd_On)
                                              THEN ticd.Dt_Installment_Date
                                              ELSE CONVERT(DATE, tip.Dt_Crtd_On)
                                         END, @dtExecutionDate) = 0
                                AND tip.I_Status IN ( 1, 3, 0, 2 )
                                AND ISNULL(ticd.Flag_IsAdvanceTax, 'N') <> 'Y'
                                AND tip.I_Centre_Id IN (
                                SELECT  FGCFR.centerID
                                FROM    dbo.fnGetCentersForReports(@sHierarchyList,
                                                              @iBrandID) FGCFR )
                        UNION ALL
                        SELECT  tbcd.I_Brand_ID ,
                                TCHND.S_Brand_Name ,
                                TCHND.I_Center_ID ,
                                TCHND.S_Center_Name ,
                                tip.I_Student_Detail_ID ,
                                A.S_Tax_Desc AS S_Component_Name ,
                                ABS(ISNULL(A.N_Tax_Value, 0)) AS N_Amount_Due ,
                                @dtExecutionDate ,
                                DATENAME(MONTH, @dtExecutionDate) + ' '
                                + CAST(DATEPART(YYYY, @dtExecutionDate) AS VARCHAR)
                        FROM    ( SELECT    taicd.I_Advance_Ref_Invoice_Child_Detail_ID ,
                                            SUM(ISNULL(taidt.N_Tax_Value, 0)) N_Tax_Value ,
                                            taidt.I_Tax_ID ,
                                            TTM.S_Tax_Desc
                                  FROM      T_Invoice_Child_Detail icd
                                            INNER JOIN T_Advance_Invoice_Child_Detail_Mapping taicd ON icd.I_Invoice_Detail_ID = taicd.I_Advance_Ref_Invoice_Child_Detail_ID
                                            INNER JOIN T_Advance_Invoice_Detail_Tax_Mapping taidt ON taicd.I_Advance_Invoice_Child_Detail_Map_ID = taidt.I_Advance_Invoice_Detail_Map_ID
                                            INNER JOIN dbo.T_Tax_Master AS TTM ON TTM.I_Tax_ID = taidt.I_Tax_ID
                                  WHERE     ISNULL(icd.Flag_IsAdvanceTax, 'N') = 'Y'
                                            AND DATEDIFF(dd,
                                                         CONVERT(DATE, icd.Dt_Installment_Date),
                                                         @dtExecutionDate) = 0
                                  GROUP BY  taicd.I_Advance_Ref_Invoice_Child_Detail_ID ,
                                            taidt.I_Tax_ID ,
                                            TTM.S_Tax_Desc
                                ) A
                                INNER JOIN dbo.T_Invoice_Child_Detail AS ticd ON A.I_Advance_Ref_Invoice_Child_Detail_ID = ticd.I_Invoice_Detail_ID
                                INNER JOIN dbo.T_Invoice_Child_Header AS tich ON ticd.I_Invoice_Child_Header_ID = tich.I_Invoice_Child_Header_ID
                                INNER JOIN dbo.T_Invoice_Parent AS tip ON tich.I_Invoice_Header_ID = tip.I_Invoice_Header_ID
                                INNER JOIN dbo.T_Center_Hierarchy_Name_Details
                                AS TCHND ON tip.I_Centre_Id = TCHND.I_Center_ID
                                INNER JOIN dbo.T_Brand_Center_Details AS tbcd ON tip.I_Centre_Id = tbcd.I_Centre_Id
                                                              AND tbcd.I_Status = 1
                        WHERE   tip.I_Centre_Id IN (
                                SELECT  FGCFR.centerID
                                FROM    dbo.fnGetCentersForReports(@sHierarchyList,
                                                              @iBrandID) FGCFR )                                              
        

---Accrual Cancellation---
                        UNION ALL
                        SELECT  tbcd.I_Brand_ID ,
                                TCHND.S_Brand_Name ,
                                tip.I_Centre_Id ,
                                TCHND.S_Center_Name ,
                                tip.I_Student_Detail_ID ,
                                TFCM.S_Component_Name ,
                                -ticd.N_Amount_Due ,
                                @dtExecutionDate ,
                                DATENAME(MONTH, @dtExecutionDate) + ' '
                                + CAST(DATEPART(YYYY, @dtExecutionDate) AS VARCHAR)
                        FROM    dbo.T_Invoice_Parent AS tip
                                INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON tip.I_Centre_Id = TCHND.I_Center_ID
                                INNER JOIN dbo.T_Brand_Center_Details AS tbcd ON tip.I_Centre_Id = tbcd.I_Centre_Id
                                                              AND tbcd.I_Status = 1
                                INNER JOIN dbo.T_Invoice_Child_Header AS tich ON tip.I_Invoice_Header_ID = tich.I_Invoice_Header_ID
                                INNER JOIN dbo.T_Invoice_Child_Detail AS ticd ON tich.I_Invoice_Child_Header_ID = ticd.I_Invoice_Child_Header_ID
                                INNER JOIN dbo.T_Fee_Component_Master TFCM ON ticd.I_Fee_Component_ID = TFCM.I_Fee_Component_ID
                        WHERE   tip.I_Status = 0
                                AND CONVERT(DATE, tip.Dt_Upd_On) < CONVERT(DATE, '2017-07-01')
                                AND DATEDIFF(dd,
                                             CASE WHEN ticd.Dt_Installment_Date > tip.Dt_Upd_On
                                                  THEN ticd.Dt_Installment_Date
                                                  ELSE tip.Dt_Upd_On
                                             END, @dtExecutionDate) = 0
                                AND tip.I_Centre_Id IN (
                                SELECT  FGCFR.centerID
                                FROM    dbo.fnGetCentersForReports(@sHierarchyList,
                                                              @iBrandID) FGCFR )
                        UNION ALL
                        SELECT  tbcd.I_Brand_ID ,
                                TCHND.S_Brand_Name ,
                                tip.I_Centre_Id ,
                                TCHND.S_Center_Name ,
                                tip.I_Student_Detail_ID ,
                                TTM.S_Tax_Desc AS S_Component_Name ,
                                -TIDT.N_Tax_Value AS N_Amount_Due ,
                                @dtExecutionDate ,
                                DATENAME(MONTH, @dtExecutionDate) + ' '
                                + CAST(DATEPART(YYYY, @dtExecutionDate) AS VARCHAR)
                        FROM    dbo.T_Invoice_Parent AS tip
                                INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON tip.I_Centre_Id = TCHND.I_Center_ID
                                INNER JOIN dbo.T_Brand_Center_Details AS tbcd ON tip.I_Centre_Id = tbcd.I_Centre_Id
                                                              AND tbcd.I_Status = 1
                                INNER JOIN dbo.T_Invoice_Child_Header AS tich ON tip.I_Invoice_Header_ID = tich.I_Invoice_Header_ID
                                INNER JOIN dbo.T_Invoice_Child_Detail AS ticd ON tich.I_Invoice_Child_Header_ID = ticd.I_Invoice_Child_Header_ID
                                INNER JOIN dbo.T_Invoice_Detail_Tax TIDT ON ticd.I_Invoice_Detail_ID = TIDT.I_Invoice_Detail_ID
                                INNER JOIN dbo.T_Tax_Master TTM ON TIDT.I_Tax_ID = TTM.I_Tax_ID
                        WHERE   tip.I_Status = 0
                                AND CONVERT(DATE, tip.Dt_Upd_On) < CONVERT(DATE, '2017-07-01')
                                AND DATEDIFF(dd,
                                             CASE WHEN ticd.Dt_Installment_Date > tip.Dt_Upd_On
                                                  THEN ticd.Dt_Installment_Date
                                                  ELSE tip.Dt_Upd_On
                                             END, @dtExecutionDate) = 0
                                AND tip.I_Centre_Id IN (
                                SELECT  FGCFR.centerID
                                FROM    dbo.fnGetCentersForReports(@sHierarchyList,
                                                              @iBrandID) FGCFR )
                        UNION ALL
                        SELECT  tbcd.I_Brand_ID ,
                                TCHND.S_Brand_Name ,
                                TCHND.I_Center_ID ,
                                TCHND.S_Center_Name ,
                                tip.I_Student_Detail_ID ,
                                TFCM.S_Component_Name AS S_Component_Name ,
                                -ABS(ISNULL(tcnicd.N_Amount_Due, 0)) AS N_Amount_Due ,
                                @dtExecutionDate ,
                                DATENAME(MONTH, @dtExecutionDate) + ' '
                                + CAST(DATEPART(YYYY, @dtExecutionDate) AS VARCHAR)
                        FROM    dbo.T_Invoice_Parent AS tip
                                INNER JOIN dbo.T_Center_Hierarchy_Name_Details
                                AS TCHND ON tip.I_Centre_Id = TCHND.I_Center_ID
                                INNER JOIN dbo.T_Brand_Center_Details AS tbcd ON tip.I_Centre_Id = tbcd.I_Centre_Id
                                                              AND tbcd.I_Status = 1
                                INNER JOIN T_Credit_Note_Invoice_Child_Detail tcnicd ON tip.I_Invoice_Header_ID = tcnicd.I_Invoice_Header_ID
                                INNER JOIN dbo.T_Invoice_Child_Detail AS ticd ON tcnicd.I_Invoice_Detail_ID = ticd.I_Invoice_Detail_ID
                                INNER JOIN dbo.T_Fee_Component_Master AS TFCM ON TFCM.I_Fee_Component_ID = ticd.I_Fee_Component_ID
                        WHERE   tip.I_Status = 0
                                AND DATEDIFF(dd,
                                             CASE WHEN ticd.Dt_Installment_Date > tip.Dt_Upd_On
                                                  THEN ticd.Dt_Installment_Date
                                                  ELSE tip.Dt_Upd_On
                                             END, @dtExecutionDate) = 0
                                AND ISNULL(ticd.Flag_IsAdvanceTax, 'N') <> 'Y'
                                AND tip.I_Centre_Id IN (
                                SELECT  FGCFR.centerID
                                FROM    dbo.fnGetCentersForReports(@sHierarchyList,
                                                              @iBrandID) FGCFR )
                        UNION ALL
                        SELECT  tbcd.I_Brand_ID ,
                                TCHND.S_Brand_Name ,
                                TCHND.I_Center_ID ,
                                TCHND.S_Center_Name ,
                                tip.I_Student_Detail_ID ,
                                TTM.S_Tax_Desc AS S_Component_Name ,
                                -ABS(ISNULL(tcnidt.N_Tax_Value, 0)) AS N_Amount_Due ,
                                @dtExecutionDate ,
                                DATENAME(MONTH, @dtExecutionDate) + ' '
                                + CAST(DATEPART(YYYY, @dtExecutionDate) AS VARCHAR)
                        FROM    dbo.T_Invoice_Parent AS tip
                                INNER JOIN dbo.T_Center_Hierarchy_Name_Details
                                AS TCHND ON tip.I_Centre_Id = TCHND.I_Center_ID
                                INNER JOIN dbo.T_Brand_Center_Details AS tbcd ON tip.I_Centre_Id = tbcd.I_Centre_Id
                                                              AND tbcd.I_Status = 1
                                INNER JOIN T_Credit_Note_Invoice_Child_Detail tcnicd ON tip.I_Invoice_Header_ID = tcnicd.I_Invoice_Header_ID
                                INNER JOIN dbo.T_Invoice_Child_Detail AS ticd ON tcnicd.I_Invoice_Detail_ID = ticd.I_Invoice_Detail_ID
                                INNER JOIN dbo.T_Credit_Note_Invoice_Child_Detail_Tax
                                AS tcnidt ON ticd.I_Invoice_Detail_ID = tcnidt.I_Invoice_Detail_ID
                                INNER JOIN dbo.T_Tax_Master AS TTM ON TTM.I_Tax_ID = tcnidt.I_Tax_ID
                        WHERE   tip.I_Status = 0
                                AND DATEDIFF(dd,
                                             CASE WHEN ticd.Dt_Installment_Date > tip.Dt_Upd_On
                                                  THEN ticd.Dt_Installment_Date
                                                  ELSE tip.Dt_Upd_On
                                             END, @dtExecutionDate) = 0
                                AND ISNULL(ticd.Flag_IsAdvanceTax, 'N') <> 'Y'
                                AND tip.I_Centre_Id IN (
                                SELECT  FGCFR.centerID
                                FROM    dbo.fnGetCentersForReports(@sHierarchyList,
                                                              @iBrandID) FGCFR )
                        UNION ALL
                        SELECT  tbcd.I_Brand_ID ,
                                TCHND.S_Brand_Name ,
                                TCHND.I_Center_ID ,
                                TCHND.S_Center_Name ,
                                TIP.I_Student_Detail_ID ,
                                TTM.S_Tax_Desc AS S_Component_Name ,
                                -ABS(ISNULL(trtd.N_Tax_Paid, 0)) AS N_Amount_Due ,
                                @dtExecutionDate ,
                                DATENAME(MONTH, @dtExecutionDate) + ' '
                                + CAST(DATEPART(YYYY, @dtExecutionDate) AS VARCHAR)
                        FROM    dbo.T_Receipt_Header AS trh
                                INNER JOIN dbo.T_Receipt_Component_Detail AS trcd ON trh.I_Receipt_Header_ID = trcd.I_Receipt_Detail_ID
                                INNER JOIN dbo.T_Receipt_Tax_Detail AS trtd ON trcd.I_Receipt_Comp_Detail_ID = trtd.I_Receipt_Comp_Detail_ID
                                INNER JOIN dbo.T_Invoice_Child_Detail AS ticd ON trcd.I_Invoice_Detail_ID = ticd.I_Invoice_Detail_ID
                                INNER JOIN dbo.T_Invoice_Parent TIP ON TIP.I_Invoice_Header_ID = trh.I_Invoice_Header_ID
                                INNER JOIN dbo.T_Center_Hierarchy_Name_Details
                                AS TCHND ON TIP.I_Centre_Id = TCHND.I_Center_ID
                                INNER JOIN dbo.T_Brand_Center_Details AS tbcd ON TCHND.I_Center_ID = tbcd.I_Centre_Id
                                                              AND tbcd.I_Status = 1
                                INNER JOIN dbo.T_Tax_Master AS TTM ON trtd.I_Tax_ID = TTM.I_Tax_ID
                        WHERE   trh.I_Status = 0
                                AND CONVERT(DATE, ticd.Dt_Installment_Date) >= CONVERT(DATE, '2017-07-01')
                                AND CONVERT(DATE, trh.Dt_Receipt_Date) < CONVERT(DATE, ticd.Dt_Installment_Date)
                                AND DATEDIFF(dd, trh.Dt_Upd_On,
                                             @dtExecutionDate) = 0
                                AND trh.I_Invoice_Header_ID IS NOT NULL
                                AND TIP.I_Centre_Id IN (
                                SELECT  FGCFR.centerID
                                FROM    dbo.fnGetCentersForReports(@sHierarchyList,
                                                              @iBrandID) FGCFR )                                        
	
                SET @dtExecutionDate = DATEADD(d, 1, @dtExecutionDate)
	
            END
            
            --SELECT * FROM #temp T1
	
        SELECT  T1.I_Brand_ID ,
                T1.S_Brand_Name ,
                T1.I_Centre_ID ,
                T1.S_Centre_Name ,
                TCM.I_Course_ID ,
                TCM.S_Course_Name ,
                TSBD.I_Batch_ID ,
                TSBM.S_Batch_Name ,
                T1.I_Student_Detail_ID ,
                TSD.S_Student_ID ,
                TSD.S_First_Name + ' ' + ISNULL(TSD.S_Middle_Name, '') + ' '
                + TSD.S_Last_Name AS StudentName ,
                TSD.I_RollNo ,
                T1.MonthYear ,
                T1.InstallmentDate ,
                T1.FeeComponentName ,
                SUM(ISNULL(T1.Amount, 0.0)) AS AccrualAmount
        FROM    #temp T1
                INNER JOIN dbo.T_Student_Detail TSD ON T1.I_Student_Detail_ID = TSD.I_Student_Detail_ID
                INNER JOIN ( SELECT DISTINCT
                                    TSBD1.I_Student_ID ,
                                    MAX(TSBD1.I_Batch_ID) AS I_Batch_ID
                             FROM   dbo.T_Student_Batch_Details TSBD1
                             WHERE  TSBD1.I_Status IN ( 1, 3 )
                             GROUP BY TSBD1.I_Student_ID
                           ) TSBD ON TSD.I_Student_Detail_ID = TSBD.I_Student_ID
                                     AND T1.I_Student_Detail_ID = TSBD.I_Student_ID
                INNER JOIN dbo.T_Student_Batch_Master TSBM ON TSBD.I_Batch_ID = TSBM.I_Batch_ID
                INNER JOIN dbo.T_Course_Master TCM ON TSBM.I_Course_ID = TCM.I_Course_ID
        --WHERE   TSBD.I_Status IN ( 1, 3 )
        GROUP BY T1.I_Brand_ID ,
                T1.S_Brand_Name ,
                T1.I_Centre_ID ,
                T1.S_Centre_Name ,
                TCM.I_Course_ID ,
                TCM.S_Course_Name ,
                TSBD.I_Batch_ID ,
                TSBM.S_Batch_Name ,
                T1.I_Student_Detail_ID ,
                TSD.S_Student_ID ,
                TSD.S_First_Name + ' ' + ISNULL(TSD.S_Middle_Name, '') + ' '
                + TSD.S_Last_Name ,
                TSD.I_RollNo ,
                T1.MonthYear ,
                T1.InstallmentDate ,
                T1.FeeComponentName
	
	
    END
