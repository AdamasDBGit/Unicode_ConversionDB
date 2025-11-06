CREATE PROCEDURE [ECOMMERCE].[uspGetStudentPayoutPayableDetails](@CustomerID VARCHAR(MAX))
AS
BEGIN

   --   DECLARE @iBrandID INT=107
	  --DECLARE @StudentID VARCHAR(MAX)='20-0001'

	  DECLARE @DueDate DATETIME=GETDATE()


	  DECLARE @CentreID INT

	  --select @CentreID=B.I_Centre_Id from T_Student_Detail A
	  --inner join T_Student_Center_Detail B on A.I_Student_Detail_ID=B.I_Student_Detail_ID
	  --inner join T_Center_Hierarchy_Name_Details C on B.I_Centre_Id=C.I_Center_ID
	  --where A.S_Student_ID=@StudentID and B.I_Status=1 and C.I_Brand_ID=@iBrandID


	  DECLARE @FIYear VARCHAR(20)    
    
	  SELECT @FIYear = (CASE WHEN (MONTH(GETDATE())) <= 3 THEN convert(varchar(4), YEAR(GETDATE())-1) + '-' + convert(varchar(4), YEAR(GETDATE())%100)    
							ELSE convert(varchar(4),YEAR(GETDATE()))+ '-' + convert(varchar(4),(YEAR(GETDATE())%100)+1)END)    
    
	  --SELECT SUBSTRING(@FIYear,0,5) AS F_YEAR 

	  SET @FIYear=SUBSTRING(@FIYear,0,5)

	  CREATE TABLE #Students
	  (
		CustomerID VARCHAR(MAX),
		StudentDetailID INT
	  )
	  
		
    
    
        CREATE TABLE #INVDET
            (
			  I_Centre_ID INT,
              S_Center_Name VARCHAR(MAX) ,
              TypeOfCentre VARCHAR(MAX) ,
              S_Course_Name VARCHAR(MAX) ,
              S_Batch_Name VARCHAR(MAX) ,
			  CustomerID VARCHAR(MAX),
			  TransactionNo VARCHAR(MAX),
			  PlanID INT,
			  ProductID INT,
              S_Student_ID VARCHAR(MAX) ,
              StudentName VARCHAR(MAX) ,
              ContactNo VARCHAR(MAX) ,
              I_RollNo INT ,
              I_Invoice_Header_ID INT ,
              S_Invoice_No VARCHAR(MAX) ,
			  InvoiceCreationDate DATETIME,
              I_Invoice_Detail_ID INT ,
              I_Installment_No INT ,
			  I_Sequence INT,
              Dt_Installment_Date DATETIME ,
			  I_FeeComponent_ID INT,
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
              TotalDiff DECIMAL(14, 2),
			  AcademicSession VARCHAR(MAX)
            )


		insert into #Students
		select DISTINCT A.CustomerID,C.I_Student_Detail_ID from ECOMMERCE.T_Registration A
		inner join ECOMMERCE.T_Registration_Enquiry_Map B on A.RegID=B.RegID
		inner join T_Student_Detail C on B.EnquiryID=C.I_Enquiry_Regn_ID
		where
		A.CustomerID=@CustomerID and A.StatusID=1 and B.StatusID=1




        INSERT  INTO #INVDET
                ( I_Centre_ID,
				  S_Center_Name ,
                  TypeOfCentre ,
                  S_Course_Name ,
                  S_Batch_Name ,
				  TransactionNo,
				  CustomerID,
				  PlanID,
				  ProductID,
                  S_Student_ID ,
                  StudentName ,
                  ContactNo ,
                  I_RollNo ,
                  I_Invoice_Header_ID ,
                  S_Invoice_No ,
				  InvoiceCreationDate,
                  I_Invoice_Detail_ID ,
                  I_Installment_No ,
				  I_Sequence,
                  Dt_Installment_Date ,
				  I_FeeComponent_ID,
                  S_Component_Name ,
                  N_Amount_Due
                )
                SELECT  TCHND.I_Center_ID,TCHND.S_Center_Name ,
                        CASE WHEN TCM2.S_Center_Code LIKE 'IAS T%' THEN 'IAS'
                             WHEN TCM2.S_Center_Code LIKE 'Judiciary T%'
                             THEN 'Judiciary'
                             WHEN TCM2.S_Center_Code = 'BRST' THEN 'AIPT'
                             WHEN TCM2.S_Center_Code LIKE 'FR-%'
                             THEN 'Franchise'
                             ELSE 'Own'
                        END AS TypeofCentre ,
                        TCM.S_Course_Name ,
                        TSBM.S_Batch_Name ,
						ISNULL(SUB.TransactionNo,''),
						TR.CustomerID,
						ISNULL(SUB.PlanID,0),
						ISNULL(SUB.ProductID,0),
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
						TICD.I_Sequence,
                        TICD.Dt_Installment_Date ,
						TICD.I_Fee_Component_ID,
                        TFCM.S_Component_Name ,
                        ISNULL(TICD.N_Due,TICD.N_Amount_Due)
                FROM    dbo.T_Invoice_Parent TIP
                        INNER JOIN dbo.T_Invoice_Child_Header TICH ON TIP.I_Invoice_Header_ID = TICH.I_Invoice_Header_ID
                        INNER JOIN dbo.T_Invoice_Child_Detail TICD ON TICH.I_Invoice_Child_Header_ID = TICD.I_Invoice_Child_Header_ID
                        INNER JOIN dbo.T_Fee_Component_Master TFCM ON TICD.I_Fee_Component_ID = TFCM.I_Fee_Component_ID
                        INNER JOIN dbo.T_Student_Detail TSD ON TIP.I_Student_Detail_ID = TSD.I_Student_Detail_ID
						--INNER JOIN ECOMMERCE.T_Registration_Enquiry_Map TREM on TSD.I_Enquiry_Regn_ID=TREM.EnquiryID and TREM.StatusID=1
						--INNER JOIN ECOMMERCE.T_Registration TR on TR.RegID=TREM.RegID and TR.StatusID=1
						INNER JOIN #Students TR on TSD.I_Student_Detail_ID=TR.StudentDetailID
                        INNER JOIN ( SELECT DISTINCT TIP1.I_Student_Detail_ID ,
                                            TIP1.I_Invoice_Header_ID ,
                                            TIBM.I_Batch_ID
                                     FROM   dbo.T_Invoice_Parent AS TIP1
                                            INNER JOIN dbo.T_Invoice_Child_Header
                                            AS TICH ON TICH.I_Invoice_Header_ID = TIP1.I_Invoice_Header_ID
                                            INNER JOIN dbo.T_Invoice_Batch_Map
                                            AS TIBM ON TIBM.I_Invoice_Child_Header_ID = TICH.I_Invoice_Child_Header_ID AND TIBM.I_Status in (1,0)
                                   ) AS TSBD ON TSBD.I_Invoice_Header_ID = TIP.I_Invoice_Header_ID
                                                AND TSBD.I_Student_Detail_ID = TIP.I_Student_Detail_ID
                                                AND TSBD.I_Student_Detail_ID = TSD.I_Student_Detail_ID
                        INNER JOIN dbo.T_Student_Batch_Master TSBM ON TSBD.I_Batch_ID = TSBM.I_Batch_ID
                        INNER JOIN dbo.T_Course_Master TCM ON TSBM.I_Course_ID = TCM.I_Course_ID
						LEFT JOIN 
						(
							select A.CustomerID,C.StudentID,E.I_Course_ID,B.PlanID as PlanID,ISNULL(C.ProductID,0) as  ProductID, ISNULL(D.SubscriptionDetailID,0) as SubscriptionID,A.TransactionNo
							from ECOMMERCE.T_Transaction_Master A
							inner join ECOMMERCE.T_Transaction_Plan_Details B on A.TransactionID=B.TransactionID
							inner join ECOMMERCE.T_Transaction_Product_Details C on B.TransactionPlanDetailID=C.TransactionPlanDetailID
							inner join ECOMMERCE.T_Transaction_Product_Subscription_Details D on C.TransactionProductDetailID=D.TransactionProductDetailID and ISNULL(SubscriptionStatus,'NA')!='Success'
							inner join T_Student_Batch_Master E on C.BatchID=E.I_Batch_ID
							where
							A.StatusID=1 and (C.StudentID IS NOT NULL and C.StudentID!='') 
						) SUB on TSD.S_Student_ID=SUB.StudentID and TSBM.I_Course_ID=SUB.I_Course_ID AND ISNULL(SUB.SubscriptionID,0)=0
                        INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TIP.I_Centre_Id = TCHND.I_Center_ID
                        INNER JOIN dbo.T_Centre_Master AS TCM2 ON TCM2.I_Centre_Id = TCHND.I_Center_ID
                                                              AND TIP.I_Centre_Id = TCM2.I_Centre_Id
                WHERE   TIP.I_Status IN (1, 3 )
                        AND TICD.I_Installment_No <> 0
						AND TICH.C_Is_LumpSum='N'
                        AND ( TIP.Dt_Upd_On IS NULL
                              OR TIP.Dt_Upd_On >= '2017-07-01'
                            )
						AND CONVERT(DATE,TICD.Dt_Installment_Date)<=CONVERT(DATE,@DueDate)
						--AND TR.CustomerID=@CustomerID
						--AND TSD.S_Student_ID = '2122/RICE/2273'



				


						--select * from #INVDET
                            
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
									INNER JOIN T_Invoice_Child_Header TICH on TICD.I_Invoice_Child_Header_ID=TICH.I_Invoice_Child_Header_ID
									INNER JOIN T_Invoice_Parent TIP on TICH.I_Invoice_Header_ID=TIP.I_Invoice_Header_ID
									INNER JOIN #Students TS on TIP.I_Student_Detail_ID=TS.StudentDetailID
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
									INNER JOIN #Students TS on TRH.I_Student_Detail_ID=TS.StudentDetailID
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
									INNER JOIN #Students TS on TRH.I_Student_Detail_ID=TS.StudentDetailID
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
									INNER JOIN #Students TS on TRH.I_Student_Detail_ID=TS.StudentDetailID
                             WHERE  TRH.I_Status = 1 --AND TRH.Dt_Crtd_On>='2019-02-01'
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
									INNER JOIN #Students TS on TRH.I_Student_Detail_ID=TS.StudentDetailID
                             WHERE  TRH.I_Status = 1 --AND TRH.Dt_Crtd_On>='2019-02-01'
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
									INNER JOIN T_Invoice_Parent TIP WITH (NOLOCK) on TCNICD.I_Invoice_Header_ID=TIP.I_Invoice_Header_ID
									INNER JOIN #Students TS on TIP.I_Student_Detail_ID=TS.StudentDetailID
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
									INNER JOIN T_Invoice_Parent TIP WITH (NOLOCK) on TCNICD.I_Invoice_Header_ID=TIP.I_Invoice_Header_ID
									INNER JOIN #Students TS on TIP.I_Student_Detail_ID=TS.StudentDetailID
                             GROUP BY TCNICD.I_Invoice_Detail_ID ,
                                    TCNICD.S_Invoice_Number
                           ) T2 ON T2.I_Invoice_Detail_ID = T1.I_Invoice_Detail_ID
                                   AND T2.CreditNoteNo COLLATE DATABASE_DEFAULT = T1.CreditNoteNo COLLATE DATABASE_DEFAULT               
                   
                   
        UPDATE  #INVDET
        SET     BaseAmtDiff = N_Amount_Due - ISNULL(ReceiptCompAmount, 0)
                - ISNULL(CreditNoteAmt, 0)
        UPDATE  #INVDET
        SET     TaxDiff = ISNULL(TotalTax, 0) - ISNULL(ReceiptCompTax, 0)
                - ISNULL(CreditNoteTax, 0)
        UPDATE  #INVDET
        SET     TotalDiff = BaseAmtDiff + TaxDiff
        OPTION  ( RECOMPILE )                                  
                            
    --    SELECT  *
    --    FROM    #INVDET AS I
    --    ORDER BY I.S_Center_Name ,
    --            I.S_Course_Name ,
    --            I.S_Batch_Name ,
    --            I.S_Student_ID ,
    --            I.I_Invoice_Header_ID ,
    --            I.I_Installment_No,
				--I.I_Sequence

--select * from #INVDET

select DISTINCT CustomerID from #INVDET

select DISTINCT CustomerID,S_Student_ID,TransactionNo,PlanID,ProductID,S_Course_Name,I_Invoice_Header_ID as FeeScheduleID,CONVERT(DATE,InvoiceCreationDate) as FeeScheduleCreatedOn 
from #INVDET

select DISTINCT CustomerID,
S_Student_ID,
I_Invoice_Header_ID as FeeScheduleID,
I_Invoice_Detail_ID,
S_Invoice_No,
I_Installment_No,
Dt_Installment_Date,
I_Sequence,
I_FeeComponent_ID,
S_Component_Name,
N_Amount_Due,
TotalTax,
ISNULL(ReceiptCompAmount,0) as BaseAmountPaid,
ISNULL(ReceiptCompTax,0) as TaxPaid,
ISNULL(CreditNoteAmt,0) as CreditNoteAmt,
ISNULL(CreditNoteTax,0) as CreditNoteTax,
BaseAmtDiff,
TaxDiff,
N_Amount_Due-ISNULL(CreditNoteAmt,0) as PayableBaseAmount,
TotalTax-ISNULL(CreditNoteTax,0) as PayableTax,
N_Amount_Due+TotalTax-ISNULL(CreditNoteAmt,0)-ISNULL(CreditNoteTax,0) as TotalPayableAmount,
ISNULL(ReceiptCompAmount,0)+ISNULL(ReceiptCompTax,0) as TotalPaidAmount,
TotalDiff as DueAmount
from #INVDET
where TotalDiff>0
order by
S_Student_ID ,
I_Invoice_Header_ID ,
I_Installment_No,
I_Sequence


drop table #INVDET

END
