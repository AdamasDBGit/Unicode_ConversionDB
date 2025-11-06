CREATE PROCEDURE [REPORT].[uspGetMonthlyCollectableReportMTFAnalysis]
    (
      @iBrandID INT ,
      @sHierarchyListID VARCHAR(MAX) ,
      @dtStartDate DATE ,
      @dtEndDate DATE
    )
AS
    BEGIN
    
        SET @dtEndDate = DATEADD(d, 1, @dtEndDate)
    
    
        CREATE TABLE #INVDET
            (
              S_Center_Name VARCHAR(MAX) ,
              TypeOfCentre VARCHAR(MAX) ,
              S_Course_Name VARCHAR(MAX) ,
              S_Batch_Name VARCHAR(MAX) ,
              S_Student_ID VARCHAR(MAX) ,
              StudentName VARCHAR(MAX) ,
              ContactNo VARCHAR(MAX) ,
              I_RollNo INT ,
              I_Invoice_Header_ID INT ,
              S_Invoice_No VARCHAR(MAX) ,
			  InvoiceCreationDate DATETIME,
              I_Invoice_Detail_ID INT ,
              I_Installment_No INT ,
              Dt_Installment_Date DATETIME ,
              S_Component_Name VARCHAR(MAX) ,
              N_Amount_Due DECIMAL(14, 2) ,
              TaxDue DECIMAL(14, 2) ,
              TaxPaidAdvBeforeGST DECIMAL(14, 2) ,
              TaxPaidAdvAfterGST DECIMAL(14, 2) ,
              TotalTax DECIMAL(14, 2) ,
              ReceiptCompAmount DECIMAL(14, 2) ,
              ReceiptCompTax DECIMAL(14, 2) ,
              CreditNoteNo VARCHAR(MAX) ,
              CreditNoteDate DATE ,
              CreditNoteAmt DECIMAL(14, 2) ,
              CreditNoteTax DECIMAL(14, 2) ,
              BaseAmtDiff DECIMAL(14, 2) ,
              TaxDiff DECIMAL(14, 2) ,
              TotalDiff DECIMAL(14, 2)
            )

        INSERT  INTO #INVDET
                ( S_Center_Name ,
                  TypeOfCentre ,
                  S_Course_Name ,
                  S_Batch_Name ,
                  S_Student_ID ,
                  StudentName ,
                  ContactNo ,
                  I_RollNo ,
                  I_Invoice_Header_ID ,
                  S_Invoice_No ,
				  InvoiceCreationDate,
                  I_Invoice_Detail_ID ,
                  I_Installment_No ,
                  Dt_Installment_Date ,
                  S_Component_Name ,
                  N_Amount_Due
                )
                SELECT  TCHND.S_Center_Name ,
                        CASE WHEN TCM2.S_Center_Code LIKE 'IAS T%' THEN 'IAS'
                             WHEN TCM2.S_Center_Code LIKE 'Judiciary T%'
                             THEN 'Judiciary'
                             WHEN TCM2.S_Center_Code = 'BRST' THEN 'AIPT'
                             WHEN TCM2.S_Center_Code LIKE 'FR-%'
                             THEN 'Franchise'
                             ELSE 'Own'
                        END AS TypeofCentre ,
                        TCM.S_Course_Name ,
                        REPLACE(REPLACE(REPLACE(TSBM.S_Batch_Name, CHAR(9), ''), CHAR(10), ''), CHAR(13), '') ,
                        TSD.S_Student_ID ,
                        TSD.S_First_Name + ' ' + ISNULL(TSD.S_Middle_Name, '')
                        + ' ' + TSD.S_Last_Name AS StudentName ,
                        TSD.S_Mobile_No AS ContactNo ,
                        TSD.I_RollNo ,
                        TIP.I_Invoice_Header_ID ,
                        TICD.S_Invoice_Number ,
						TIP.Dt_Crtd_On,
                        TICD.I_Invoice_Detail_ID ,
                        TICD.I_Installment_No ,
                        TICD.Dt_Installment_Date ,
                        TFCM.S_Component_Name ,
                        TICD.N_Amount_Due
                FROM    dbo.T_Invoice_Parent TIP
                        INNER JOIN dbo.T_Invoice_Child_Header TICH ON TIP.I_Invoice_Header_ID = TICH.I_Invoice_Header_ID
                        INNER JOIN dbo.T_Invoice_Child_Detail TICD ON TICH.I_Invoice_Child_Header_ID = TICD.I_Invoice_Child_Header_ID
                        INNER JOIN dbo.T_Fee_Component_Master TFCM ON TICD.I_Fee_Component_ID = TFCM.I_Fee_Component_ID
                        INNER JOIN dbo.T_Student_Detail TSD ON TIP.I_Student_Detail_ID = TSD.I_Student_Detail_ID
                        INNER JOIN ( SELECT DISTINCT TIP1.I_Student_Detail_ID ,
                                            TIP1.I_Invoice_Header_ID ,
                                            TIBM.I_Batch_ID
                                     FROM   dbo.T_Invoice_Parent AS TIP1
                                            INNER JOIN dbo.T_Invoice_Child_Header
                                            AS TICH ON TICH.I_Invoice_Header_ID = TIP1.I_Invoice_Header_ID
                                            INNER JOIN dbo.T_Invoice_Batch_Map
                                            AS TIBM ON TIBM.I_Invoice_Child_Header_ID = TICH.I_Invoice_Child_Header_ID AND TIBM.I_Status in (1,0)
                                     WHERE  --TIP.I_Invoice_Header_ID=119262 AND TIP.I_Student_Detail_ID=44346 --AND TIBM.I_Status=1
                                            TIP1.I_Centre_Id IN (
                                            SELECT  FGCFR.centerID
                                            FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
                                                              @iBrandID) AS FGCFR ) --AND TIP1.I_Invoice_Header_ID=260338
                                   ) AS TSBD ON TSBD.I_Invoice_Header_ID = TIP.I_Invoice_Header_ID
                                                AND TSBD.I_Student_Detail_ID = TIP.I_Student_Detail_ID
                                                AND TSBD.I_Student_Detail_ID = TSD.I_Student_Detail_ID
                        INNER JOIN dbo.T_Student_Batch_Master TSBM ON TSBD.I_Batch_ID = TSBM.I_Batch_ID
                        INNER JOIN dbo.T_Course_Master TCM ON TSBM.I_Course_ID = TCM.I_Course_ID
                        INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TIP.I_Centre_Id = TCHND.I_Center_ID
                        INNER JOIN dbo.T_Centre_Master AS TCM2 ON TCM2.I_Centre_Id = TCHND.I_Center_ID
                                                              AND TIP.I_Centre_Id = TCM2.I_Centre_Id
                WHERE   ( TICD.Dt_Installment_Date >= @dtStartDate
                          AND TICD.Dt_Installment_Date < DATEADD(d,1,@dtStartDate)
                        )
                        AND TCHND.I_Center_ID IN (
                        SELECT  FGCFR.centerID
                        FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
                                                           @iBrandID) FGCFR )
                        AND TIP.I_Status=1 OR (TIP.I_Status=0 and (TIP.Dt_Upd_On>=@dtStartDate and TIP.Dt_Upd_On<DATEADD(d,1,@dtEndDate)))
                        AND TICD.I_Installment_No <> 0
                        AND ( TIP.Dt_Upd_On IS NULL
                              OR TIP.Dt_Upd_On >= '2017-07-01'
                            )
                --AND TSD.S_Student_ID = @StudentID
                            
        UPDATE  T1
        SET     T1.TaxDue = T2.TaxDue
        FROM    #INVDET AS T1
                INNER JOIN ( SELECT TIDT.I_Invoice_Detail_ID ,
                                    CASE WHEN TICD.Dt_Installment_Date < '2017-07-01'
                                         THEN ISNULL(SUM(ISNULL(TIDT.N_Tax_Value,
                                                              0)), 0)
                                         ELSE ISNULL(SUM(ISNULL(TIDT.N_Tax_Value_Scheduled,
                                                              0)), 0)
                                    END AS TaxDue
                             FROM   dbo.T_Invoice_Detail_Tax AS TIDT
                                    INNER JOIN dbo.T_Invoice_Child_Detail AS TICD ON TICD.I_Invoice_Detail_ID = TIDT.I_Invoice_Detail_ID
                             GROUP BY TIDT.I_Invoice_Detail_ID ,
                                    TICD.Dt_Installment_Date
                           ) T2 ON T2.I_Invoice_Detail_ID = T1.I_Invoice_Detail_ID


        UPDATE  T1
        SET     T1.TaxPaidAdvBeforeGST = T2.TaxPaidBeforeGST
        FROM    #INVDET AS T1
                INNER JOIN ( SELECT TICD.I_Invoice_Detail_ID ,
                                    ISNULL(SUM(ISNULL(TRTD.N_Tax_Paid, 0)), 0) AS TaxPaidBeforeGST
                             FROM   dbo.T_Receipt_Header AS TRH
                                    INNER JOIN dbo.T_Receipt_Component_Detail
                                    AS TRCD ON TRCD.I_Receipt_Detail_ID = TRH.I_Receipt_Header_ID
                                    INNER JOIN dbo.T_Receipt_Tax_Detail AS TRTD ON TRTD.I_Receipt_Comp_Detail_ID = TRCD.I_Receipt_Comp_Detail_ID
                                                              AND TRTD.I_Invoice_Detail_ID = TRCD.I_Invoice_Detail_ID
                                    INNER JOIN dbo.T_Invoice_Child_Detail AS TICD ON TICD.I_Invoice_Detail_ID = TRCD.I_Invoice_Detail_ID
                                                              AND TICD.I_Invoice_Detail_ID = TRTD.I_Invoice_Detail_ID
                             WHERE  TRH.I_Status = 1
                                    AND TRH.Dt_Crtd_On < '2017-07-01'
                                    AND TICD.Dt_Installment_Date >= '2017-07-01'
                             GROUP BY TICD.I_Invoice_Detail_ID
                           ) T2 ON T2.I_Invoice_Detail_ID = T1.I_Invoice_Detail_ID 


        UPDATE  T1
        SET     T1.TaxPaidAdvAfterGST = T2.TaxPaidAfterGST
        FROM    #INVDET AS T1
                INNER JOIN ( SELECT TICD.I_Invoice_Detail_ID ,
                                    ISNULL(SUM(ISNULL(TRTD.N_Tax_Paid, 0)), 0) AS TaxPaidAfterGST
                             FROM   dbo.T_Receipt_Header AS TRH
                                    INNER JOIN dbo.T_Receipt_Component_Detail
                                    AS TRCD ON TRCD.I_Receipt_Detail_ID = TRH.I_Receipt_Header_ID
                                    INNER JOIN dbo.T_Receipt_Tax_Detail AS TRTD ON TRTD.I_Receipt_Comp_Detail_ID = TRCD.I_Receipt_Comp_Detail_ID
                                                              AND TRTD.I_Invoice_Detail_ID = TRCD.I_Invoice_Detail_ID
                                    INNER JOIN dbo.T_Invoice_Child_Detail AS TICD ON TICD.I_Invoice_Detail_ID = TRCD.I_Invoice_Detail_ID
                                                              AND TICD.I_Invoice_Detail_ID = TRTD.I_Invoice_Detail_ID
                             WHERE  TRH.I_Status = 1
                                    AND TRH.Dt_Crtd_On >= '2017-07-01'
                                    AND TICD.Dt_Installment_Date >= '2017-07-01'
                                    AND CONVERT(DATE, TRH.Dt_Crtd_On) < CONVERT(DATE, TICD.Dt_Installment_Date)
                             GROUP BY TICD.I_Invoice_Detail_ID
                           ) T2 ON T2.I_Invoice_Detail_ID = T1.I_Invoice_Detail_ID 

        UPDATE  #INVDET
        SET     TotalTax = ISNULL(TaxDue, 0) + ISNULL(TaxPaidAdvBeforeGST, 0)
                + ISNULL(TaxPaidAdvAfterGST, 0)

        UPDATE  T1
        SET     T1.ReceiptCompAmount = T2.ReceiptCompAmount
        FROM    #INVDET AS T1
                INNER JOIN ( SELECT TRCD.I_Invoice_Detail_ID ,
                                    ISNULL(SUM(TRCD.N_Amount_Paid), 0.0) AS ReceiptCompAmount
                             FROM   dbo.T_Receipt_Component_Detail TRCD
                                    INNER JOIN dbo.T_Receipt_Header TRH ON TRCD.I_Receipt_Detail_ID = TRH.I_Receipt_Header_ID
                             WHERE  TRH.I_Status = 1 AND TRH.Dt_Crtd_On<@dtStartDate
                             GROUP BY TRCD.I_Invoice_Detail_ID
                           ) T2 ON T2.I_Invoice_Detail_ID = T1.I_Invoice_Detail_ID
                   
        UPDATE  T1
        SET     T1.ReceiptCompTax = T2.ReceiptCompTax
        FROM    #INVDET AS T1
                INNER JOIN ( SELECT TRTD.I_Invoice_Detail_ID ,
                                    ISNULL(SUM(ISNULL(TRTD.N_Tax_Paid, 0.0)),
                                           0.0) AS ReceiptCompTax
                             FROM   dbo.T_Receipt_Tax_Detail TRTD
                                    INNER JOIN dbo.T_Receipt_Component_Detail TRCD ON TRTD.I_Receipt_Comp_Detail_ID = TRCD.I_Receipt_Comp_Detail_ID
                                    INNER JOIN dbo.T_Receipt_Header TRH ON TRCD.I_Receipt_Detail_ID = TRH.I_Receipt_Header_ID
                             WHERE  TRH.I_Status = 1 AND TRH.Dt_Crtd_On<@dtStartDate
                             GROUP BY TRTD.I_Invoice_Detail_ID
                           ) T2 ON T2.I_Invoice_Detail_ID = T1.I_Invoice_Detail_ID
                   
        UPDATE  T1
        SET     T1.CreditNoteAmt = T2.CreditNoteAmt ,
                T1.CreditNoteNo = T2.CreditNoteNo ,
                T1.CreditNoteDate = CASE WHEN CONVERT(DATE, T1.Dt_Installment_Date) > CONVERT(DATE, T2.Dt_Crtd_On)
                                         THEN T1.Dt_Installment_Date
                                         ELSE CONVERT(DATE, T2.Dt_Crtd_On)
                                    END
        FROM    #INVDET AS T1
                INNER JOIN ( SELECT TCNICD.I_Invoice_Detail_ID ,
                                    TCNICD.S_Invoice_Number AS CreditNoteNo ,
                                    TCNICD.Dt_Crtd_On ,
                                    ISNULL(SUM(ISNULL(TCNICD.N_Amount, 0)), 0) AS CreditNoteAmt
                             FROM   dbo.T_Credit_Note_Invoice_Child_Detail AS TCNICD
                                    WITH ( NOLOCK )
							WHERE TCNICD.Dt_Crtd_On<@dtStartDate
                             GROUP BY TCNICD.I_Invoice_Detail_ID ,
                                    TCNICD.S_Invoice_Number ,
                                    TCNICD.Dt_Crtd_On
                           ) T2 ON T2.I_Invoice_Detail_ID = T1.I_Invoice_Detail_ID 


        UPDATE  T1
        SET     T1.CreditNoteTax = T2.CreditNoteTax
        FROM    #INVDET AS T1
                INNER JOIN ( SELECT TCNICD.I_Invoice_Detail_ID ,
                                    TCNICD.S_Invoice_Number AS CreditNoteNo ,
                                    ISNULL(SUM(ISNULL(TCNICDT.N_Tax_Value, 0)),
                                           0) AS CreditNoteTax
                             FROM   dbo.T_Credit_Note_Invoice_Child_Detail_Tax
                                    AS TCNICDT
                                    INNER JOIN dbo.T_Credit_Note_Invoice_Child_Detail
                                    AS TCNICD ON TCNICD.I_Invoice_Detail_ID = TCNICDT.I_Invoice_Detail_ID
                                                 AND TCNICD.I_Credit_Note_Invoice_Child_Detail_ID = TCNICDT.I_Credit_Note_Invoice_Child_Detail_ID
							WHERE TCNICD.Dt_Crtd_On<@dtStartDate
                             GROUP BY TCNICD.I_Invoice_Detail_ID ,
                                    TCNICD.S_Invoice_Number
                           ) T2 ON T2.I_Invoice_Detail_ID = T1.I_Invoice_Detail_ID
                                   AND T2.CreditNoteNo = T1.CreditNoteNo                 
                   
                   
        UPDATE  #INVDET
        SET     BaseAmtDiff = N_Amount_Due - ISNULL(ReceiptCompAmount, 0)
                - ISNULL(CreditNoteAmt, 0)
        UPDATE  #INVDET
        SET     TaxDiff = ISNULL(TotalTax, 0) - ISNULL(ReceiptCompTax, 0)
                - ISNULL(CreditNoteTax, 0)
        UPDATE  #INVDET
        SET     TotalDiff = BaseAmtDiff + TaxDiff
        OPTION  ( RECOMPILE )                                  
                            
        SELECT  *
        FROM    #INVDET AS I
        ORDER BY I.S_Center_Name ,
                I.S_Course_Name ,
                I.S_Batch_Name ,
                I.S_Student_ID ,
                I.I_Invoice_Header_ID ,
                I.I_Installment_No 




--OPTION(RECOMPILE);
    
		




        
        
        
    END
