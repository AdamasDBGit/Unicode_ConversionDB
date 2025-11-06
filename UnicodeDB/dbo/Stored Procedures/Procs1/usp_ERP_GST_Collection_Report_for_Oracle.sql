CREATE PROCEDURE [dbo].[usp_ERP_GST_Collection_Report_for_Oracle]
    @iBrandID INT,
    @dtGSTStartDate DATETIME = '2017-07-01',
    @dtStartDate DATETIME = NULL,
    @dtEndDate DATETIME = NULL 
AS
BEGIN
    SET NOCOUNT ON;

    --DECLARE @StatusFlag INT;
    --DECLARE @Message VARCHAR(MAX);

    BEGIN TRY
        BEGIN TRANSACTION;

        -- temp tables (kept same structure)
        CREATE TABLE #Adv
        (
            I_Student_Detail_ID INT ,
            S_Mobile_No VARCHAR(50) ,
            S_Student_ID VARCHAR(100) ,
            I_Roll_No INT ,
            S_Student_Name VARCHAR(200) ,
            S_Invoice_No VARCHAR(100) ,
            S_Receipt_No VARCHAR(100) ,
            Dt_Invoice_Date DATETIME ,
            S_Component_Name VARCHAR(100) ,
            S_Batch_Name VARCHAR(100) ,
            S_Course_Name VARCHAR(100) ,
            I_Center_ID INT ,
            S_Center_Name VARCHAR(100) ,
            S_Brand_Name VARCHAR(100) ,
            S_Cost_Center VARCHAR(100) ,
            Due_Value REAL ,
            Dt_Installment_Date DATETIME ,
            I_Installment_No INT ,
            I_Parent_Invoice_ID INT ,
            I_Invoice_Detail_ID INT ,
            Revised_Invoice_Date DATETIME ,
            Tax_Value DECIMAL(14, 2) ,
            Total_Value DECIMAL(14, 2) ,
            Amount_Paid DECIMAL(14, 2) ,
            Tax_Paid DECIMAL(14, 2) ,
            Total_Paid DECIMAL(14, 2),
            Effective_Advance DECIMAL(14, 2),
            MonthYear VARCHAR(MAX),
            instanceChain VARCHAR(MAX),
            OrgInvoiceNo VARCHAR(MAX),
            AdvanceInvoiceNo VARCHAR(MAX),
            StateNameAndCode VARCHAR(MAX),
            TaxType VARCHAR(MAX),
            AdvanceInvoiceDate DATETIME,
            CGST DECIMAL(14,2),
            SGST DECIMAL(14,2)
        );

        CREATE TABLE #GSTCollectable
        (
          BrandName VARCHAR(MAX) ,
          StateNameAndCode VARCHAR(MAX) ,
          TaxType INT ,
          InvoiceOrReceiptNumber VARCHAR(MAX) ,
          InvoiceDate DATE ,
          TaxableAmount DECIMAL(18, 2) ,
          AmountPaidinAdvanceBeforeGST DECIMAL(18, 2) ,
          CreditNoteAmount DECIMAL(18, 2) ,
          FinalTaxableAmount DECIMAL(18, 2) ,
          SGST DECIMAL(18, 2) ,
          CGST DECIMAL(18, 2) ,
          AdvanceAdjusted DECIMAL(18, 2) ,
          InvoiceType VARCHAR(MAX)
        );

        -- populate #Adv via existing report proc (brand passed as parameter)
        INSERT INTO #Adv
        EXEC REPORT.uspGetAdvanceFromStudentWithInvoiceNo '54', @iBrandID, @dtEndDate, 'ALL', @dtStartDate;

        -- populate #GSTCollectable (brand filtered by @iBrandID)
        INSERT INTO #GSTCollectable
        ( BrandName ,
          StateNameAndCode ,
          TaxType ,
          InvoiceOrReceiptNumber ,
          InvoiceDate ,
          TaxableAmount ,
          InvoiceType
        )
        SELECT  
                TCHND.S_Brand_Name ,
                TGCM.S_State_Code + '-' + TSM.S_State_Name AS StateNameAndCode ,
                18 AS TaxType ,
                TICD.S_Invoice_Number ,
                CONVERT(DATE, TICD.Dt_Installment_Date) ,
                SUM(ISNULL(TICD.N_Amount_Due, 0)) / 2 AS TaxableAmount ,
                CASE WHEN TICD.I_Installment_No = 0 THEN 'Advance'
                     ELSE 'Invoice'
                END AS InvoiceType
        FROM    dbo.T_Invoice_Child_Detail AS TICD
                INNER JOIN dbo.T_Invoice_Detail_Tax AS TIDT ON TIDT.I_Invoice_Detail_ID = TICD.I_Invoice_Detail_ID
                INNER JOIN dbo.T_Invoice_Child_Header AS TICH ON TICH.I_Invoice_Child_Header_ID = TICD.I_Invoice_Child_HEADER_ID
                INNER JOIN dbo.T_Invoice_Parent AS TIP ON TIP.I_Invoice_Header_ID = TICH.I_Invoice_HEADER_ID
                INNER JOIN dbo.T_Center_Hierarchy_Name_Details AS TCHND ON TIP.I_Centre_Id = TCHND.I_Center_ID
                INNER JOIN NETWORK.T_Center_Address AS TCA ON TCA.I_Centre_Id = TIP.I_Centre_Id
                                                              AND TCA.I_Centre_Id = TCHND.I_Center_ID
                INNER JOIN dbo.T_GST_Code_Master AS TGCM ON TCA.I_State_ID = TGCM.I_State_ID
                                                            AND TGCM.I_Brand_ID = TCHND.I_Brand_ID
                INNER JOIN dbo.T_State_Master AS TSM ON TSM.I_State_ID = TCA.I_State_ID
                                                        AND TSM.I_State_ID = TGCM.I_State_ID
        WHERE   TCHND.I_Brand_ID = @iBrandID
                AND TICD.I_Installment_No <> 0
                AND ( TICD.Dt_Installment_Date >= @dtStartDate
                      AND TICD.Dt_Installment_Date < DATEADD(d, 1, @dtEndDate)
                    )
        GROUP BY TCHND.S_Brand_Name ,
                TGCM.S_State_Code + '-' + TSM.S_State_Name ,
                TICD.S_Invoice_Number ,
                CONVERT(DATE, TICD.Dt_Installment_Date) ,
                CASE WHEN TICD.I_Installment_No = 0 THEN 'Advance'
                     ELSE 'Invoice'
                END;

        -- update amount paid in advance before GST
        UPDATE  T1
        SET     T1.AmountPaidinAdvanceBeforeGST = T2.AmtPaidBeforeGST
        FROM    ( SELECT    TICD.S_Invoice_Number ,
                            SUM(TRCD.N_Amount_Paid) AS AmtPaidBeforeGST
                  FROM      dbo.T_Receipt_Header AS TRH
                            INNER JOIN dbo.T_Receipt_Component_Detail AS TRCD ON TRCD.I_Receipt_Detail_ID = TRH.I_Receipt_Header_ID
                            INNER JOIN dbo.T_Invoice_Child_Detail AS TICD ON TICD.I_Invoice_Detail_ID = TRCD.I_Invoice_Detail_ID
                            INNER JOIN dbo.T_Center_Hierarchy_Name_Details AS TCHND ON TRH.I_Centre_Id = TCHND.I_Center_ID
                  WHERE     TRH.I_Status = 1
                            AND ( TICD.Dt_Installment_Date >= @dtStartDate
                                  AND TICD.Dt_Installment_Date < DATEADD(d, 1,
                                                                      @dtEndDate)
                                )
                            AND TRH.Dt_Crtd_On < @dtGSTStartDate
                            AND TCHND.I_Brand_ID = @iBrandID
                  GROUP BY  TICD.S_Invoice_Number
                ) T2
        INNER JOIN #GSTCollectable AS T1 ON T1.InvoiceOrReceiptNumber = T2.S_Invoice_Number;

        -- cap advance paid to taxable amount
        UPDATE  #GSTCollectable
        SET     AmountPaidinAdvanceBeforeGST = TaxableAmount
        WHERE   AmountPaidinAdvanceBeforeGST > TaxableAmount;

        -- compute FinalTaxableAmount
        UPDATE  #GSTCollectable
        SET     FinalTaxableAmount = ( ISNULL(TaxableAmount, 0)
                                       - ISNULL(AmountPaidinAdvanceBeforeGST, 0)
                                       - ISNULL(CreditNoteAmount, 0) );

        -- CGST collectable
        UPDATE  T1
        SET     T1.CGST = T2.CGSTCollectable
        FROM    ( SELECT    TICD.S_Invoice_Number ,
                            SUM(CASE WHEN TIDT.N_Tax_Value_Scheduled = 0
                                     THEN TIDT.N_Tax_Value_Scheduled
                                     ELSE TIDT.N_Tax_Value_Scheduled
                                END) AS CGSTCollectable
                  FROM      dbo.T_Invoice_Child_Detail AS TICD
                            INNER JOIN dbo.T_Invoice_Detail_Tax AS TIDT ON TIDT.I_Invoice_Detail_ID = TICD.I_Invoice_Detail_ID
                  WHERE     ( TICD.Dt_Installment_Date >= @dtStartDate
                              AND TICD.Dt_Installment_Date < DATEADD(d, 1, @dtEndDate)
                            )
                            AND TIDT.I_Tax_ID = 7
                  GROUP BY  TICD.S_Invoice_Number
                ) T2
        INNER JOIN #GSTCollectable AS T1 ON T1.InvoiceOrReceiptNumber = T2.S_Invoice_Number;

        -- SGST collectable
        UPDATE  T1
        SET     T1.SGST = T2.SGSTCollectable
        FROM    ( SELECT    TICD.S_Invoice_Number ,
                            SUM(CASE WHEN TIDT.N_Tax_Value_Scheduled = 0
                                     THEN TIDT.N_Tax_Value_Scheduled
                                     ELSE TIDT.N_Tax_Value_Scheduled
                                END) AS SGSTCollectable
                  FROM      dbo.T_Invoice_Child_Detail AS TICD
                            INNER JOIN dbo.T_Invoice_Detail_Tax AS TIDT ON TIDT.I_Invoice_Detail_ID = TICD.I_Invoice_Detail_ID
                  WHERE     ( TICD.Dt_Installment_Date >= @dtStartDate
                              AND TICD.Dt_Installment_Date < DATEADD(d, 1, @dtEndDate)
                            )
                            AND TIDT.I_Tax_ID = 8
                  GROUP BY  TICD.S_Invoice_Number
                ) T2
        INNER JOIN #GSTCollectable AS T1 ON T1.InvoiceOrReceiptNumber = T2.S_Invoice_Number;

        -- add SGST paid in GST regime
        UPDATE  T1
        SET     T1.SGST = T1.SGST + T2.SGCTPaidinGSTRegime
        FROM    ( SELECT    TICD.S_Invoice_Number ,
                            SUM(ISNULL(TRTD.N_Tax_Paid, 0)) AS SGCTPaidinGSTRegime
                  FROM      dbo.T_Receipt_Header AS TRH
                            INNER JOIN dbo.T_Receipt_Component_Detail AS TRCD ON TRCD.I_Receipt_Detail_ID = TRH.I_Receipt_Header_ID
                            INNER JOIN dbo.T_Receipt_Tax_Detail AS TRTD ON TRTD.I_Receipt_Comp_Detail_ID = TRCD.I_Receipt_Comp_Detail_ID
                                                              AND TRTD.I_Invoice_Detail_ID = TRCD.I_Invoice_Detail_ID
                            INNER JOIN dbo.T_Invoice_Child_Detail AS TICD ON TICD.I_Invoice_Detail_ID = TRCD.I_Invoice_Detail_ID
                                                              AND TICD.I_Invoice_Detail_ID = TRTD.I_Invoice_Detail_ID
                  WHERE     TRH.I_Status = 1
                            AND ( TRH.Dt_Crtd_On >= @dtGSTStartDate
                                  AND TRH.Dt_Crtd_On < DATEADD(d, 1, @dtEndDate)
                                )
                            AND ( TICD.Dt_Installment_Date >= @dtStartDate
                                  AND TICD.Dt_Installment_Date < DATEADD(d, 1,
                                                                      @dtEndDate)
                                )
                            AND TRTD.I_Tax_ID = 7
                            AND CONVERT(DATE, TRH.Dt_Crtd_On) < CONVERT(DATE, TICD.Dt_Installment_Date)
                            AND EXISTS (SELECT 1 FROM dbo.T_Center_Hierarchy_Name_Details TCHND2 WHERE TCHND2.I_Center_ID = TICD.I_Invoice_Detail_ID AND TCHND2.I_Brand_ID = @iBrandID) 
                            -- note: this query originally filtered receipts by brand list; ensure receipt/invoice mapping filters by brand as needed
                  GROUP BY  TICD.S_Invoice_Number
                ) T2
        INNER JOIN #GSTCollectable AS T1 ON T1.InvoiceOrReceiptNumber = T2.S_Invoice_Number;

        -- add CGST paid in GST regime
        UPDATE  T1
        SET     T1.CGST = T1.CGST + T2.CGCTPaidinGSTRegime
        FROM    ( SELECT    TICD.S_Invoice_Number ,
                            SUM(ISNULL(TRTD.N_Tax_Paid, 0)) AS CGCTPaidinGSTRegime
                  FROM      dbo.T_Receipt_Header AS TRH
                            INNER JOIN dbo.T_Receipt_Component_Detail AS TRCD ON TRCD.I_Receipt_Detail_ID = TRH.I_Receipt_Header_ID
                            INNER JOIN dbo.T_Receipt_Tax_Detail AS TRTD ON TRTD.I_Receipt_Comp_Detail_ID = TRCD.I_Receipt_Comp_Detail_ID
                                                              AND TRTD.I_Invoice_Detail_ID = TRCD.I_Invoice_Detail_ID
                            INNER JOIN dbo.T_Invoice_Child_Detail AS TICD ON TICD.I_Invoice_Detail_ID = TRCD.I_Invoice_Detail_ID
                                                              AND TICD.I_Invoice_Detail_ID = TRTD.I_Invoice_Detail_ID
                  WHERE     TRH.I_Status = 1
                            AND ( TRH.Dt_Crtd_On >= @dtGSTStartDate
                                  AND TRH.Dt_Crtd_On < DATEADD(d, 1, @dtEndDate)
                                )
                            AND ( TICD.Dt_Installment_Date >= @dtStartDate
                                  AND TICD.Dt_Installment_Date < DATEADD(d, 1,
                                                                      @dtEndDate)
                                )
                            AND TRTD.I_Tax_ID = 8
                            AND CONVERT(DATE, TRH.Dt_Crtd_On) < CONVERT(DATE, TICD.Dt_Installment_Date)
                            AND EXISTS (SELECT 1 FROM dbo.T_Center_Hierarchy_Name_Details TCHND3 WHERE TCHND3.I_Center_ID = TICD.I_Invoice_Detail_ID AND TCHND3.I_Brand_ID = @iBrandID) 
                            -- note: added brand existence check to keep brand scoping consistent for receipts
                  GROUP BY  TICD.S_Invoice_Number
                ) T2
        INNER JOIN #GSTCollectable AS T1 ON T1.InvoiceOrReceiptNumber = T2.S_Invoice_Number;

        -- return GSTCollectable resultset (identical ordering)
        SELECT  *
        FROM    #GSTCollectable AS GC
        ORDER BY GC.BrandName ,
                GC.StateNameAndCode ,
                GC.InvoiceOrReceiptNumber;

        -- drop the temp used for this part
        IF OBJECT_ID('tempdb..#GSTCollectable') IS NOT NULL
            DROP TABLE #GSTCollectable;

        ---------------------------------------------------------------------
        -- Credit note report (kept exactly) but filtered where TCHND.I_Brand_ID = @iBrandID
        ---------------------------------------------------------------------
        SELECT  CreditNoteBase.S_Brand_Name ,
                CreditNoteBase.CreditNoteNumber ,
                CreditNoteBase.CreditNoteDate ,
                CreditNoteBase.InvoiceNumber ,
                CreditNoteBase.InvoiceDate ,
                CreditNoteBase.PlaceOfSupply ,
                CreditNoteBase.Rate ,
                CreditNoteBase.TaxableAmount ,
                CreditNoteCGST.CGSTTax ,
                CreditNoteSGST.SGSTTax
        FROM    ( SELECT    TCHND.S_Brand_Name ,
                            TCNICD.I_Invoice_Detail_ID ,
                            TCNICD.S_Invoice_Number AS CreditNoteNumber ,
                            CASE WHEN CONVERT(DATE, TICD.Dt_Installment_Date) > CONVERT(DATE, TCNICD.Dt_Crtd_On)
                                 THEN CONVERT(DATE, TICD.Dt_Installment_Date)
                                 ELSE CONVERT(DATE, TCNICD.Dt_Crtd_On)
                            END AS CreditNoteDate ,
                            TICD.S_Invoice_Number AS InvoiceNumber ,
                            TICD.Dt_Installment_Date AS InvoiceDate ,
                            TGCM.S_State_Code + '-' + TSM.S_State_Name AS PlaceOfSupply ,
                            18 AS Rate ,
                            SUM(ISNULL(TCNICD.N_Amount, 0)) AS TaxableAmount 
                  FROM      dbo.T_Credit_Note_Invoice_Child_Detail AS TCNICD
                            INNER JOIN dbo.T_Invoice_Child_Detail AS TICD ON TICD.I_Invoice_Detail_ID = TCNICD.I_Invoice_Detail_ID
                            INNER JOIN dbo.T_Invoice_Child_Header AS TICH ON TICH.I_Invoice_Child_HEADER_ID = TICD.I_Invoice_Child_HEADER_ID
                            INNER JOIN dbo.T_Invoice_Parent AS TIP ON TIP.I_Invoice_HEADER_ID = TICH.I_Invoice_HEADER_ID
                            INNER JOIN dbo.T_Center_Hierarchy_Name_Details AS TCHND ON TCHND.I_Center_ID = TIP.I_Centre_Id
                            INNER JOIN NETWORK.T_Center_Address AS TCA ON TCA.I_Centre_Id = TIP.I_Centre_Id
                            INNER JOIN dbo.T_GST_Code_Master AS TGCM ON TGCM.I_State_ID = TCA.I_State_ID
                                                                      AND TGCM.I_Brand_ID = TCHND.I_Brand_ID
                            INNER JOIN dbo.T_State_Master AS TSM ON TSM.I_State_ID = TCA.I_State_ID
                  WHERE     ( TICD.Dt_Installment_Date >= @dtGSTStartDate
                              AND TICD.Dt_Installment_Date < DATEADD(d, 1, @dtEndDate)
                            )
                            AND ( CASE WHEN CONVERT(DATE, TICD.Dt_Installment_Date) > CONVERT(DATE, TCNICD.Dt_Crtd_On)
                                       THEN CONVERT(DATE, TICD.Dt_Installment_Date)
                                       ELSE CONVERT(DATE, TCNICD.Dt_Crtd_On)
                                  END >= @dtStartDate
                                  AND CASE WHEN CONVERT(DATE, TICD.Dt_Installment_Date) > CONVERT(DATE, TCNICD.Dt_Crtd_On)
                                           THEN CONVERT(DATE, TICD.Dt_Installment_Date)
                                           ELSE CONVERT(DATE, TCNICD.Dt_Crtd_On)
                                      END < DATEADD(d,1,@dtEndDate)
                        )
                        AND TCHND.I_Brand_ID = @iBrandID
                  GROUP BY  TCHND.S_Brand_Name ,
                            TCNICD.I_Invoice_Detail_ID ,
                            TCNICD.S_Invoice_Number ,
                            CASE WHEN CONVERT(DATE, TICD.Dt_Installment_Date) > CONVERT(DATE, TCNICD.Dt_Crtd_On)
                                 THEN CONVERT(DATE, TICD.Dt_Installment_Date)
                                 ELSE CONVERT(DATE, TCNICD.Dt_Crtd_On)
                            END ,
                            TICD.S_Invoice_Number ,
                            TICD.Dt_Installment_Date ,
                            TGCM.S_State_Code + '-' + TSM.S_State_Name
            ) CreditNoteBase
            LEFT JOIN ( SELECT  TCNICDT.I_Invoice_Detail_ID ,
                                SUM(ISNULL(TCNICDT.N_Tax_Value, 0)) AS SGSTTax
                        FROM    dbo.T_Credit_Note_Invoice_Child_Detail_Tax AS TCNICDT
                        WHERE   TCNICDT.I_Tax_ID = 7
                        GROUP BY TCNICDT.I_Invoice_Detail_ID
                      ) CreditNoteSGST ON CreditNoteSGST.I_Invoice_Detail_ID = CreditNoteBase.I_Invoice_Detail_ID
            LEFT JOIN ( SELECT  TCNICDT.I_Invoice_Detail_ID ,
                                SUM(ISNULL(TCNICDT.N_Tax_Value, 0)) AS CGSTTax
                        FROM    dbo.T_Credit_Note_Invoice_Child_Detail_Tax AS TCNICDT
                        WHERE   TCNICDT.I_Tax_ID = 8
                        GROUP BY TCNICDT.I_Invoice_Detail_ID
                      ) CreditNoteCGST ON CreditNoteCGST.I_Invoice_Detail_ID = CreditNoteBase.I_Invoice_Detail_ID
        ORDER BY CreditNoteBase.S_Brand_Name ,
                CreditNoteBase.PlaceOfSupply ,
                CreditNoteBase.CreditNoteNumber;

        ---------------------------------------------------------------------
        -- select from #Adv as in original script (brand data already returned by the report proc)
        ---------------------------------------------------------------------
        SELECT S_Brand_Name,StateNameAndCode,TaxType,AdvanceInvoiceNo,AdvanceInvoiceDate,OrgInvoiceNo,Dt_Installment_Date as OrgInvoiceDate,Effective_Advance as N_Advance_Amount,CGST,SGST 
        FROM #Adv
        ORDER BY S_Brand_Name,StateNameAndCode,AdvanceInvoiceNo;

        ---------------------------------------------------------------------
        -- OnAccount Invoice / OnAccount Credit Note (brand filtered by @iBrandID)
        ---------------------------------------------------------------------
        SELECT DISTINCT
                TCHND.S_Brand_Name ,
                18 AS TaxType ,
                TRH.S_Receipt_No ,
                TSM.S_Status_Desc AS OnAccountComponent ,
                ISNULL(TRH.N_Receipt_Amount, 0) AS TaxableAmount ,
                ISNULL(TRH.N_Tax_Amount, 0) AS Tax ,
                TIOAD.S_Invoice_Number AS InvoiceNo,
                TRH.Dt_Crtd_On AS InvoiceDate,
                'Receipt' AS Type
        FROM    dbo.T_Receipt_Header AS TRH
                INNER JOIN dbo.T_Status_Master AS TSM ON TRH.I_Receipt_Type = TSM.I_Status_Value
                INNER JOIN dbo.T_Tax_Country_ReceiptType AS TTCRT ON TTCRT.I_Receipt_Type = TRH.I_Receipt_Type
                INNER JOIN dbo.T_Center_Hierarchy_Name_Details AS TCHND ON TRH.I_Centre_Id = TCHND.I_Center_ID
                LEFT JOIN dbo.T_Invoice_OnAccount_Details AS TIOAD ON TRH.I_Receipt_Header_ID=TIOAD.I_Receipt_Header_ID AND (TIOAD.S_Invoice_Type='RI' OR TIOAD.S_Invoice_Type='BS')
        WHERE   TRH.I_Invoice_HEADER_ID IS NULL
                AND TRH.I_Status IN (1,0)
                AND ( TRH.Dt_Crtd_On >= @dtStartDate
                      AND TRH.Dt_Crtd_On < DATEADD(d, 1, @dtEndDate)
                    )
                AND TTCRT.N_Tax_Rate = 9
                AND TCHND.I_Brand_ID = @iBrandID
        UNION ALL
        SELECT DISTINCT
                TCHND.S_Brand_Name ,
                5 AS TaxType ,
                TRH.S_Receipt_No ,
                TSM.S_Status_Desc AS OnAccountComponent ,
                ISNULL(TRH.N_Receipt_Amount, 0) AS TaxableAmount ,
                ISNULL(TRH.N_Tax_Amount, 0) AS Tax ,
                TIOAD.S_Invoice_Number AS InvoiceNo,
                TRH.Dt_Crtd_On AS InvoiceDate,
                'Receipt' AS Type
        FROM    dbo.T_Receipt_Header AS TRH
                INNER JOIN dbo.T_Status_Master AS TSM ON TRH.I_Receipt_Type = TSM.I_Status_VALUE
                INNER JOIN dbo.T_Tax_Country_ReceiptType AS TTCRT ON TTCRT.I_Receipt_Type = TRH.I_Receipt_Type
                INNER JOIN dbo.T_Center_Hierarchy_Name_Details AS TCHND ON TRH.I_Centre_Id = TCHND.I_Center_ID
                LEFT JOIN dbo.T_Invoice_OnAccount_Details AS TIOAD ON TRH.I_Receipt_Header_ID=TIOAD.I_Receipt_Header_ID AND (TIOAD.S_Invoice_Type='RI' OR TIOAD.S_Invoice_Type='BS')
        WHERE   TRH.I_Invoice_HEADER_ID IS NULL
                AND TRH.I_Status IN ( 1,0)
                AND ( TRH.Dt_Crtd_On >= @dtStartDate
                      AND TRH.Dt_Crtd_On < DATEADD(d, 1, @dtEndDate)
                    )
                AND TTCRT.N_Tax_Rate = 2.5
                AND TCHND.I_Brand_ID = @iBrandID;

        ---OnAccount Credit Note
        SELECT DISTINCT
                TCHND.S_Brand_Name ,
                18 AS TaxType ,
                TRH.S_Receipt_No ,
                TSM.S_Status_Desc AS OnAccountComponent ,
                ISNULL(TRH.N_Receipt_Amount, 0) AS TaxableAmount ,
                ISNULL(TRH.N_Tax_Amount, 0) AS Tax ,
                TIOAD.S_Invoice_Number AS CreditNoteNo,
                TRH.Dt_Upd_On AS CreditNoteDate,
                'Receipt' AS Type
        FROM    dbo.T_Receipt_Header AS TRH
                INNER JOIN dbo.T_Status_Master AS TSM ON TRH.I_Receipt_Type = TSM.I_Status_Value
                INNER JOIN dbo.T_Tax_Country_ReceiptType AS TTCRT ON TTCRT.I_Receipt_Type = TRH.I_Receipt_Type
                INNER JOIN dbo.T_Center_Hierarchy_Name_Details AS TCHND ON TRH.I_Centre_Id = TCHND.I_Center_ID
                INNER JOIN NETWORK.T_Center_Address AS TCA ON TCA.I_Centre_Id = TRH.I_Centre_Id
                                                      AND TCA.I_Centre_Id = TCHND.I_Center_ID
                LEFT JOIN dbo.T_Invoice_OnAccount_Details AS TIOAD ON TRH.I_Receipt_Header_ID=TIOAD.I_Receipt_Header_ID AND TIOAD.S_Invoice_Type='RC'
        WHERE   TRH.I_Invoice_HEADER_ID IS NULL
                AND TRH.I_Status IN (0)
                AND ( TRH.Dt_Upd_On >= @dtStartDate
                      AND TRH.Dt_Upd_On < DATEADD(d, 1, @dtEndDate)
                    )
                AND TTCRT.N_Tax_Rate = 9
                AND TCHND.I_Brand_ID = @iBrandID
        UNION ALL
        SELECT DISTINCT
                TCHND.S_Brand_Name ,
                5 AS TaxType ,
                TRH.S_Receipt_No ,
                TSM.S_Status_Desc AS OnAccountComponent ,
                ISNULL(TRH.N_Receipt_Amount, 0) AS TaxableAmount ,
                ISNULL(TRH.N_Tax_Amount, 0) AS Tax ,
                TIOAD.S_Invoice_Number AS CreditNoteNo,
                TRH.Dt_Upd_On AS CreditNoteDate,
                'Receipt' AS Type
        FROM    dbo.T_Receipt_Header AS TRH
                INNER JOIN dbo.T_Status_Master AS TSM ON TRH.I_Receipt_Type = TSM.I_Status_Value
                INNER JOIN dbo.T_Tax_Country_ReceiptType AS TTCRT ON TTCRT.I_Receipt_Type = TRH.I_Receipt_Type
                INNER JOIN dbo.T_Center_Hierarchy_Name_Details AS TCHND ON TRH.I_Centre_Id = TCHND.I_Center_ID
                INNER JOIN NETWORK.T_Center_Address AS TCA ON TCA.I_Centre_Id = TRH.I_Centre_Id
                                                      AND TCA.I_Centre_Id = TCHND.I_Center_ID
                INNER JOIN dbo.T_GST_Code_Master AS TGCM ON TCA.I_State_ID = TGCM.I_State_ID
                                                    AND TGCM.I_Brand_ID = TCHND.I_Brand_ID
                INNER JOIN dbo.T_State_Master AS TSM1 ON TSM1.I_State_ID = TCA.I_State_ID
                                                 AND TSM1.I_State_ID = TGCM.I_State_ID
                LEFT JOIN dbo.T_Invoice_OnAccount_Details AS TIOAD ON TRH.I_Receipt_Header_ID=TIOAD.I_Receipt_Header_ID AND TIOAD.S_Invoice_Type='RC'
        WHERE   TRH.I_Invoice_HEADER_ID IS NULL
                AND TRH.I_Status IN ( 0)
                AND ( TRH.Dt_Upd_On >= @dtStartDate
                      AND TRH.Dt_Upd_On < DATEADD(d, 1, @dtEndDate)
                    )
                AND TTCRT.N_Tax_Rate = 2.5
                AND TCHND.I_Brand_ID = @iBrandID;

        ---------------------------------------------------------------------
        -- final select from #Adv and cleanup (kept same as script)
        ---------------------------------------------------------------------
        SELECT * FROM #Adv;

        IF OBJECT_ID('tempdb..#Adv') IS NOT NULL
            DROP TABLE #Adv;

        COMMIT TRANSACTION;

        --SET @StatusFlag = 1;
        --SET @Message = 'Success';

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        -- attempt cleanup of temp tables if exist
        IF OBJECT_ID('tempdb..#GSTCollectable') IS NOT NULL
            DROP TABLE #GSTCollectable;

        IF OBJECT_ID('tempdb..#Adv') IS NOT NULL
            DROP TABLE #Adv;

        --SET @StatusFlag = 0;
        --SET @Message = CONCAT(
        --    'Error: ', ERROR_NUMBER(), ' - ', ERROR_SEVERITY(), ' - ', ERROR_STATE(), ' - ',
        --    ISNULL(ERROR_PROCEDURE(),''), ' - ', ISNULL(CAST(ERROR_LINE() AS VARCHAR(10)),''), ' - ', ISNULL(ERROR_MESSAGE(),'')
        --);
    END CATCH;

    --SELECT @StatusFlag AS StatusFlag, @Message AS Message;
END;
