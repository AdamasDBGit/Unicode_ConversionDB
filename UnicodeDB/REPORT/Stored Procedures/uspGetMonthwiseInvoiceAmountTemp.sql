CREATE PROCEDURE [REPORT].[uspGetMonthwiseInvoiceAmountTemp]
(
@iBrandID INT,
@sHierarchyListID VARCHAR(MAX),
@dtStartDate DATE,
@dtEndDate DATE
)

AS 
    BEGIN

        CREATE TABLE #temp
            (
              BrandName VARCHAR(MAX) ,
              CenterName VARCHAR(MAX) ,
              CourseName VARCHAR(MAX) ,
              BatchID INT,
              BatchName VARCHAR(MAX) ,
              BatchStartDate DATE ,
              BatchStartMonth VARCHAR(MAX),
              StudentID VARCHAR(MAX) ,
              --AdmissionDate DATE,
              --AdmissionMonth VARCHAR(MAX),
              InvoiceHeaderID INT ,
              InvoiceDate DATE ,
              InvoiceNo VARCHAR(MAX) ,
              InvoiceAmount DECIMAL(14, 2) ,
              AmountPaidBeforeBatchStart DECIMAL(14, 2) ,
              AmountPaidAtBatchStart DECIMAL(14, 2) ,
              AmountPaidAfterBatchStart DECIMAL(14, 2) ,
              AmountRemaining DECIMAL(14, 2)
            )

        INSERT  INTO #temp
                ( BrandName ,
                  CenterName ,
                  CourseName ,
                  BatchID,
                  BatchName ,
                  BatchStartDate ,
                  BatchStartMonth,
                  StudentID ,
                  --AdmissionDate,
                  --AdmissionMonth,
                  InvoiceHeaderID ,
                  InvoiceDate ,
                  InvoiceNo ,
                  InvoiceAmount
                )
                SELECT	DISTINCT
                        TCHND.S_Brand_Name ,
                        TCHND.S_Center_Name ,
                        TCM.S_Course_Name ,
                        TSBM.I_Batch_ID,
                        TSBM.S_Batch_Name ,
                        CONVERT(DATE, TSBM.Dt_BatchStartDate) AS BatchStartDate ,
                        CAST(DATENAME(MONTH,TSBM.Dt_BatchStartDate)+' '+CAST(DATEPART(YYYY,TSBM.Dt_BatchStartDate) AS VARCHAR) AS VARCHAR) AS BatchStartMonth,
                        TSD.S_Student_ID ,
                        --CONVERT(DATE, TSD.Dt_Crtd_On) AS AdmissionDate ,
                        --CAST(DATENAME(MONTH,TSD.Dt_Crtd_On)+' '+CAST(DATEPART(YYYY,TSD.Dt_Crtd_On) AS VARCHAR) AS VARCHAR) AS AdmissionMonth,
                        TIP.I_Invoice_Header_ID ,
                        CONVERT(DATE, TIP.Dt_Crtd_On) AS InvoiceDate ,
                        TIP.S_Invoice_No ,
                        TIP.N_Invoice_Amount
                FROM    dbo.T_Student_Batch_Master TSBM
                        INNER JOIN dbo.T_Invoice_Batch_Map TIBM ON TSBM.I_Batch_ID = TIBM.I_Batch_ID
                        INNER JOIN dbo.T_Invoice_Child_Header TICH ON TIBM.I_Invoice_Child_Header_ID = TICH.I_Invoice_Child_Header_ID
                        INNER JOIN dbo.T_Invoice_Parent TIP ON TICH.I_Invoice_Header_ID = TIP.I_Invoice_Header_ID
                        INNER JOIN dbo.T_Student_Batch_Details TSBD ON TSBM.I_Batch_ID = TSBD.I_Batch_ID
                                                              AND TIBM.I_Batch_ID = TSBD.I_Batch_ID
                        INNER JOIN dbo.T_Student_Detail TSD ON TIP.I_Student_Detail_ID = TSD.I_Student_Detail_ID
                                                              AND TSBD.I_Student_ID = TSD.I_Student_Detail_ID
                        INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TIP.I_Centre_Id = TCHND.I_Center_ID
                        INNER JOIN dbo.T_Course_Master TCM ON TSBM.I_Course_ID = TCM.I_Course_ID
                        --INNER JOIN dbo.T_Invoice_Child_Detail TICD ON TICH.I_Invoice_Child_Header_ID=TICD.I_Invoice_Child_Header_ID
                    --INNER JOIN dbo.T_Receipt_Header TRH ON TIP.I_Invoice_Header_ID = TRH.I_Invoice_Header_ID
                WHERE   TCHND.I_Brand_ID =@iBrandID
                        AND TIP.I_Status IN ( 1, 3 )
                        AND TSBD.I_Status = 1
                        AND ( TSBM.Dt_BatchStartDate >= @dtStartDate
                              AND TSBM.Dt_BatchStartDate < DATEADD(d,1,@dtEndDate)
                            )
                        AND TCHND.I_Center_ID IN (SELECT FGCFR.centerID FROM dbo.fnGetCentersForReports(@sHierarchyListID,@iBrandID) FGCFR)    
                ORDER BY TCHND.S_Brand_Name ,
                        TCHND.S_Center_Name ,
                        TCM.S_Course_Name ,
                        TSBM.S_Batch_Name ,
                        TSD.S_Student_ID
                    
        UPDATE  T2
        SET     T2.AmountPaidBeforeBatchStart = T3.ReceiptAmountBeforeBatchStart
        FROM    #temp T2
                INNER JOIN ( 
                
                SELECT TRH.I_Invoice_Header_ID ,
                                    SUM(ISNULL(TRH.N_Receipt_Amount, 0.00)) AS ReceiptAmountBeforeBatchStart
                             FROM   dbo.T_Receipt_Header TRH
                                    INNER JOIN #temp T1 ON TRH.I_Invoice_Header_ID = T1.InvoiceHeaderID
                             WHERE  TRH.I_Status = 1
                                    AND DATEDIFF(m, T1.BatchStartDate,
                                                 TRH.Dt_Receipt_Date) < 0
                             GROUP BY TRH.I_Invoice_Header_ID
                             
                            
                           ) T3 ON T2.InvoiceHeaderID = T3.I_Invoice_Header_ID
                           
                           
                           
                           
                    
                    
        UPDATE  T2
        SET     T2.AmountPaidAtBatchStart = T3.ReceiptAmountAtBatchStart
        FROM    #temp T2
                INNER JOIN ( SELECT TRH.I_Invoice_Header_ID ,
                                    SUM(ISNULL(TRH.N_Receipt_Amount, 0.00)) AS ReceiptAmountAtBatchStart
                             FROM   dbo.T_Receipt_Header TRH
                                    INNER JOIN #temp T1 ON TRH.I_Invoice_Header_ID = T1.InvoiceHeaderID
                             WHERE  TRH.I_Status = 1
                                    AND DATEDIFF(m, T1.BatchStartDate,
                                                 TRH.Dt_Receipt_Date) = 0
                             GROUP BY TRH.I_Invoice_Header_ID
                           ) T3 ON T2.InvoiceHeaderID = T3.I_Invoice_Header_ID
                    
                    
        UPDATE  T2
        SET     T2.AmountPaidAfterBatchStart = T3.ReceiptAmountAfterBatchStart
        FROM    #temp T2
                INNER JOIN ( SELECT TRH.I_Invoice_Header_ID ,
                                    SUM(ISNULL(TRH.N_Receipt_Amount, 0.00)) AS ReceiptAmountAfterBatchStart
                             FROM   dbo.T_Receipt_Header TRH
                                    INNER JOIN #temp T1 ON TRH.I_Invoice_Header_ID = T1.InvoiceHeaderID
                             WHERE  TRH.I_Status = 1
                                    AND DATEDIFF(m, T1.BatchStartDate,
                                                 TRH.Dt_Receipt_Date) > 0
                             GROUP BY TRH.I_Invoice_Header_ID
                           ) T3 ON T2.InvoiceHeaderID = T3.I_Invoice_Header_ID
                    
                    
        UPDATE  #temp
        SET     AmountRemaining = InvoiceAmount
                - ISNULL(AmountPaidBeforeBatchStart, 0.00)
                - ISNULL(AmountPaidAtBatchStart, 0.00)
                - ISNULL(AmountPaidAfterBatchStart, 0.00)
                        
                        
                        
        SELECT  *
        FROM    #temp T1
 
    END
