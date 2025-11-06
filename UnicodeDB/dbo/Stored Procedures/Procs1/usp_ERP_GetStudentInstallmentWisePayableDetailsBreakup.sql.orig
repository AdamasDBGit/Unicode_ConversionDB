

-- exec [SelfService].[uspGetStudentInstallmentPayableDetails] 107,6289687421

CREATE PROCEDURE [dbo].[usp_ERP_GetStudentInstallmentWisePayableDetailsBreakup](@iBrandID INT,@sStudentID varchar(max))
AS
BEGIN

   --   DECLARE @iBrandID INT=107
	  --DECLARE @StudentID VARCHAR(MAX)='20-0001'

	  


	  DECLARE @CentreID INT

	  DECLARE @MobileNo varchar(max)

	  select @CentreID=B.I_Centre_Id ,@MobileNo=TPM.S_Mobile_No from T_Student_Detail A
	  inner join T_Student_Center_Detail B on A.I_Student_Detail_ID=B.I_Student_Detail_ID
	  inner join T_Center_Hierarchy_Name_Details C on B.I_Centre_Id=C.I_Center_ID
	  INNER JOIN dbo.T_Student_Detail D ON D.I_Student_Detail_ID = A.I_Student_Detail_ID
	  INNER JOIN T_Student_Parent_Maps TSPM ON TSPM.S_Student_ID = D.S_Student_ID
	  INNER JOIN T_Parent_Master TPM ON TPM.I_Parent_Master_ID = TSPM.I_Parent_Master_ID
	  where D.S_Student_ID=@sStudentID
	  --TPM.S_Mobile_No=@MobileNo 
	  and B.I_Status=1 and C.I_Brand_ID=@iBrandID


	  

	 


	  DECLARE @FIYear VARCHAR(20)    
    
	  SELECT @FIYear = (CASE WHEN (MONTH(GETDATE())) <= 3 THEN convert(varchar(4), YEAR(GETDATE())-1) + '-' + convert(varchar(4), YEAR(GETDATE())%100)    
							ELSE convert(varchar(4),YEAR(GETDATE()))+ '-' + convert(varchar(4),(YEAR(GETDATE())%100)+1)END)    
    
	  --SELECT SUBSTRING(@FIYear,0,5) AS F_YEAR 

	  SET @FIYear=SUBSTRING(@FIYear,0,5)

		
    
    
        CREATE TABLE #INVDET
            (
			  I_Centre_ID INT,
              S_Center_Name VARCHAR(MAX) ,
              TypeOfCentre VARCHAR(MAX) ,
			  S_Mobile_No VARCHAR(MAX) ,
			  I_Course_ID INT,
              S_Course_Name VARCHAR(MAX) ,
			  S_Course_Name_Current VARCHAR(MAX),
			  S_Student_Photo NVARCHAR(MAX),
              S_Batch_Name VARCHAR(MAX) ,
			  S_Batch_Name_Current VARCHAR(MAX) ,
              S_Student_ID VARCHAR(MAX) ,
              StudentName VARCHAR(MAX) ,
              ContactNo VARCHAR(MAX) ,
              I_RollNo INT ,
              I_Invoice_Header_ID INT ,
              S_Invoice_No VARCHAR(MAX) ,
			  FeeScheduleNo VARCHAR(MAX) ,
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
			  DueType VARCHAR(MAX)
            )

        INSERT  INTO #INVDET
                ( I_Centre_ID,
				  S_Center_Name ,
                  TypeOfCentre ,
				  S_Mobile_No,
				  I_Course_ID,
                  S_Course_Name ,
				  S_Course_Name_Current,
				  S_Student_Photo,
                  S_Batch_Name ,
				  S_Batch_Name_Current,
                  S_Student_ID ,
                  StudentName ,
                  ContactNo ,
                  I_RollNo ,
                  I_Invoice_Header_ID ,
                  S_Invoice_No ,
				  FeeScheduleNo,
				  InvoiceCreationDate,
                  I_Invoice_Detail_ID ,
                  I_Installment_No ,
				  I_Sequence,
                  Dt_Installment_Date ,
				  I_FeeComponent_ID,
                  S_Component_Name ,
                  N_Amount_Due,
				  DueType
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
						TSD.S_Mobile_No,
						TCM.I_Course_ID,
                        TCM.S_Course_Name ,	
						TSCM.S_Course_Name,
						ERD.S_Student_Photo,
                        TSBM.S_Batch_Name ,
						TSBM1.S_Batch_Name ,
                        TSD.S_Student_ID ,
                        TSD.S_First_Name + ' ' + ISNULL(TSD.S_Middle_Name, '')
                        + ' ' + TSD.S_Last_Name AS StudentName ,
                        TSD.S_Mobile_No AS ContactNo ,
                        TSD.I_RollNo ,
                        TIP.I_Invoice_Header_ID ,
                        TICD.S_Invoice_Number ,
						TIP.S_Invoice_No as FeeScheduleNo ,
						TIP.Dt_Crtd_On,
                        TICD.I_Invoice_Detail_ID ,
                        TICD.I_Installment_No ,
						TICD.I_Sequence,
                        TICD.Dt_Installment_Date ,
						TICD.I_Fee_Component_ID,
                        TFCM.S_Component_Name ,
                        TICD.N_Amount_Due,
						CASE WHEN YEAR(TSBM.Dt_BatchStartDate)=@FIYear AND TICD.Dt_Installment_Date <=CAST( GETDATE() AS Date )
						THEN 'Current' 
						WHEN YEAR(TSBM.Dt_BatchStartDate)=@FIYear AND TICD.Dt_Installment_Date >CAST( GETDATE() AS Date )
						THEN 'Upcoming' 
						ELSE 'Previous' END as DueType
                FROM    dbo.T_Invoice_Parent TIP
                        INNER JOIN dbo.T_Invoice_Child_Header TICH ON TIP.I_Invoice_Header_ID = TICH.I_Invoice_Header_ID
                        INNER JOIN dbo.T_Invoice_Child_Detail TICD ON TICH.I_Invoice_Child_Header_ID = TICD.I_Invoice_Child_Header_ID
                        INNER JOIN dbo.T_Fee_Component_Master TFCM ON TICD.I_Fee_Component_ID = TFCM.I_Fee_Component_ID
                        INNER JOIN dbo.T_Student_Detail TSD ON TIP.I_Student_Detail_ID = TSD.I_Student_Detail_ID
						INNER JOIN T_Student_Parent_Maps TSPM ON TSPM.S_Student_ID = TSD.S_Student_ID
						INNER JOIN T_Parent_Master TPM ON TPM.I_Parent_Master_ID = TSPM.I_Parent_Master_ID
						INNER JOIN T_Enquiry_Regn_Detail ERD ON ERD.I_Enquiry_Regn_ID = TSD.I_Enquiry_Regn_ID
                        INNER JOIN ( SELECT DISTINCT TIP1.I_Student_Detail_ID ,
                                            TIP1.I_Invoice_Header_ID ,
                                            TIBM.I_Batch_ID
                                     FROM   dbo.T_Invoice_Parent AS TIP1
                                            INNER JOIN dbo.T_Invoice_Child_Header
                                            AS TICH ON TICH.I_Invoice_Header_ID = TIP1.I_Invoice_Header_ID
                                            INNER JOIN dbo.T_Invoice_Batch_Map
                                            AS TIBM ON TIBM.I_Invoice_Child_Header_ID = TICH.I_Invoice_Child_Header_ID AND TIBM.I_Status in (1,0)
											INNER JOIN dbo.T_Student_Detail TSD1 ON TIP1.I_Student_Detail_ID = TSD1.I_Student_Detail_ID
											 INNER JOIN T_Student_Parent_Maps TSPM ON TSPM.S_Student_ID = TSD1.S_Student_ID
											INNER JOIN T_Parent_Master TPM ON TPM.I_Parent_Master_ID = TSPM.I_Parent_Master_ID
									 WHERE  --TIP.I_Invoice_Header_ID=119262 AND TIP.I_Student_Detail_ID=44346 --AND TIBM.I_Status=1
                                            TIP1.I_Centre_Id IN (@CentreID ) --AND TIP1.I_Invoice_Header_ID=260338
											AND TPM.S_Mobile_No=@MobileNo
                                   ) AS TSBD ON TSBD.I_Invoice_Header_ID = TIP.I_Invoice_Header_ID
                                                AND TSBD.I_Student_Detail_ID = TIP.I_Student_Detail_ID
                                                AND TSBD.I_Student_Detail_ID = TSD.I_Student_Detail_ID
                        INNER JOIN dbo.T_Student_Batch_Master TSBM ON TSBD.I_Batch_ID = TSBM.I_Batch_ID
                        INNER JOIN dbo.T_Course_Master TCM ON TSBM.I_Course_ID = TCM.I_Course_ID
                        INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TIP.I_Centre_Id = TCHND.I_Center_ID
                        INNER JOIN dbo.T_Centre_Master AS TCM2 ON TCM2.I_Centre_Id = TCHND.I_Center_ID
                                                              AND TIP.I_Centre_Id = TCM2.I_Centre_Id
	                    INNER JOIN T_Student_Batch_Details TSBD1 ON TSBD1.I_Student_ID = TSD.I_Student_Detail_ID and TSBD1.I_Status=1
						INNER JOIN dbo.T_Student_Batch_Master TSBM1 ON TSBM1.I_Batch_ID = TSBD1.I_Batch_ID
						INNER JOIN dbo.T_Course_Master TSCM ON TSCM.I_Course_ID = TSBM1.I_Course_ID
						
                WHERE   TCHND.I_Center_ID IN (@CentreID )
                        AND TIP.I_Status IN (0, 1, 3 )
                        AND TICD.I_Installment_No <> 0
                        AND ( TIP.Dt_Upd_On IS NULL
                              OR TIP.Dt_Upd_On >= '2017-07-01'
                            )
						AND TICD.Dt_Installment_Date>='2020-03-18'
						-- AND TSD.S_Student_ID = @StudentID
						AND TPM.S_Mobile_No=@MobileNo
                            
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

-- exec [SelfService].[uspGetStudentInstallmentPayableDetails] 107,6289687421
select * from #INVDET 

INSERT  INTO #INVDET
                ( I_Centre_ID,
				  S_Center_Name ,
                  TypeOfCentre ,
				  S_Mobile_No,
				  I_Course_ID,
                  S_Course_Name ,
				  S_Course_Name_Current,
				  S_Student_Photo,
                  S_Batch_Name ,
				  S_Batch_Name_Current,
                  S_Student_ID ,
                  StudentName ,
                  ContactNo ,
                  I_RollNo ,
                  I_Invoice_Header_ID ,
                  S_Invoice_No ,
				  FeeScheduleNo,
				  InvoiceCreationDate,
                  I_Invoice_Detail_ID ,
                  I_Installment_No ,
				  I_Sequence,
                  Dt_Installment_Date ,
				  I_FeeComponent_ID,
                  S_Component_Name ,
                  N_Amount_Due,
				  DueType,
				  TotalDiff
                )
select max(I_Centre_ID),
				  max(S_Center_Name),
                  max(TypeOfCentre),
				  max(S_Mobile_No),
				  max(I_Course_ID),
                  max(S_Course_Name) ,
				  max(S_Course_Name_Current),
				  max(S_Student_Photo),
                  max(S_Batch_Name) ,
				  max(S_Batch_Name_Current),
                  S_Student_ID ,
                  max(StudentName) ,
                  max(ContactNo) ,
                  max(I_RollNo) ,
                 -- '-1' I_Invoice_Header_ID ,
				 max(I_Invoice_Header_ID) ,
                  S_Invoice_No ,
				  -- '' FeeScheduleNo,
				  FeeScheduleNo,
				  GETDATE()  InvoiceCreationDate,
                 -- '-1' I_Invoice_Detail_ID ,
                 -- '0' I_Installment_No ,
				   max(I_Invoice_Detail_ID) ,
                  max(I_Installment_No) ,
				  '100' I_Sequence,
                  Dt_Installment_Date ,
				  CASE WHEN @iBrandID = 107 THEN 27
                                     WHEN @iBrandID = 110 THEN 55
                                     WHEN @iBrandID = 109 THEN 77
                                END I_FeeComponent_ID,
                  'Fine' S_Component_Name ,
                  dbo.fnGetFineAmountForAPI(@iBrandID,Dt_Installment_Date) AS N_Amount_Due,
				  DueType,
				   dbo.fnGetFineAmountForAPI(@iBrandID,Dt_Installment_Date) AS TotalDiff
				  from #INVDET
				  GROUP BY S_Student_ID, DueType,S_Invoice_No,Dt_Installment_Date,FeeScheduleNo,I_Invoice_Header_ID
HAVING SUM(ISNULL(TotalDiff,0)) >0

-- select * from #INVDET

select t1.*,t2.SummaryTotalPayableAmount,t2.SummaryTotalPaidAmount,t2.SummaryDueAmount
from 
(
select t1.S_Mobile_No MobileNo,t1.S_Student_Photo ProfileImage,t1.S_Student_ID StudentID,t1.StudentName,t1.ContactNo,t1.I_Centre_ID CentreID,t1.S_Center_Name CentreName,t1.S_Course_Name_Current StudentClass,t1.S_Batch_Name_Current
from #INVDET as t1
group by t1.S_Mobile_No,t1.S_Student_Photo,t1.S_Student_ID,t1.StudentName,t1.ContactNo,t1.I_Centre_ID,t1.S_Center_Name,t1.S_Course_Name_Current,t1.S_Batch_Name_Current
) as t1 
left join 
(
SELECT S_Student_ID
,SUM(
case when DueType in('Current','Upcoming') then 
	N_Amount_Due+TotalTax-ISNULL(CreditNoteAmt,0)-ISNULL(CreditNoteTax,0)
	else 0 end

	) AS SummaryTotalPayableAmount
,SUM(
case when DueType in('Current','Upcoming') then 
ISNULL(ReceiptCompAmount,0)+ISNULL(ReceiptCompTax,0)
else 0 end
) AS SummaryTotalPaidAmount
,SUM(
case when DueType in('Current','Upcoming') then 
ISNULL(TotalDiff,0)
else 0 end
) AS SummaryDueAmount
,CASE WHEN SUM(ISNULL(TotalDiff,0))=0 THEN 'Fully Paid' 
WHEN SUM(ISNULL(ReceiptCompAmount,0)+ISNULL(ReceiptCompTax,0)) < SUM(N_Amount_Due+TotalTax-ISNULL(CreditNoteAmt,0)-ISNULL(CreditNoteTax,0)) and SUM(ISNULL(ReceiptCompAmount,0)+ISNULL(ReceiptCompTax,0))>0
THEN 'Partially Paid' 
ELSE 'Not Paid'
END as PaymentStatus
,COUNT( distinct( S_Invoice_No )) as Total_Invoice 
,COUNT(distinct (
CASE WHEN  ISNULL(TotalDiff,0) =0 
THEN S_Invoice_No 
ELSE NULL 
END)
) as Total_Invoice_Paid 
from #INVDET as A
GROUP BY S_Student_ID
) as t2 on t1.StudentID = t2.S_Student_ID


/*select DISTINCT S_Student_ID,S_Course_Name,I_Invoice_Header_ID as FeeScheduleID,CONVERT(DATE,InvoiceCreationDate) as FeeScheduleCreatedOn,AcademicSession 
from #INVDET
*/


SELECT S_Student_ID StudentID,DueType
,SUM(N_Amount_Due+TotalTax-ISNULL(CreditNoteAmt,0)-ISNULL(CreditNoteTax,0)) AS SummaryTotalPayableAmount
,SUM(ISNULL(ReceiptCompAmount,0)+ISNULL(ReceiptCompTax,0)) AS SummaryTotalPaidAmount
,SUM(ISNULL(TotalDiff,0)) AS SummaryDueAmount
,CASE WHEN SUM(ISNULL(TotalDiff,0))=0 THEN 'Fully Paid' 
WHEN SUM(ISNULL(ReceiptCompAmount,0)+ISNULL(ReceiptCompTax,0)) < SUM(N_Amount_Due+TotalTax-ISNULL(CreditNoteAmt,0)-ISNULL(CreditNoteTax,0)) and SUM(ISNULL(ReceiptCompAmount,0)+ISNULL(ReceiptCompTax,0))>0
THEN 'Partially Paid' 
ELSE 'Not Paid'
END as PaymentStatus
,COUNT( distinct( S_Invoice_No )) as Total_Invoice 
,COUNT(distinct (
CASE WHEN  ISNULL(TotalDiff,0) =0 
THEN S_Invoice_No 
ELSE NULL 
END)
) as Total_Invoice_Paid 
from #INVDET as A
GROUP BY S_Student_ID, DueType
ORDER BY S_Student_ID,DueType


SELECT S_Student_ID StudentID,DueType,S_Invoice_No InvoiceNo,Dt_Installment_Date InstallmentDate,FeeScheduleNo,I_Invoice_Header_ID as FeeScheduleID
,SUM(N_Amount_Due+TotalTax-ISNULL(CreditNoteAmt,0)-ISNULL(CreditNoteTax,0)) AS SummaryTotalPayableAmount
,SUM(ISNULL(ReceiptCompAmount,0)+ISNULL(ReceiptCompTax,0)) AS SummaryTotalPaidAmount
,SUM(ISNULL(TotalDiff,0)) AS SummaryDueAmount
,CASE WHEN SUM(ISNULL(TotalDiff,0))=0 THEN 'Fully Paid' 
WHEN SUM(ISNULL(ReceiptCompAmount,0)+ISNULL(ReceiptCompTax,0)) < SUM(N_Amount_Due+TotalTax-ISNULL(CreditNoteAmt,0)-ISNULL(CreditNoteTax,0)) and SUM(ISNULL(ReceiptCompAmount,0)+ISNULL(ReceiptCompTax,0)) > 0
THEN 'Partially Paid' 
ELSE 'Not Paid'
END as PaymentStatus

from #INVDET as A
GROUP BY S_Student_ID, DueType,S_Invoice_No,Dt_Installment_Date,FeeScheduleNo,I_Invoice_Header_ID
HAVING SUM(ISNULL(TotalDiff,0)) >0
ORDER BY S_Student_ID,DueType,S_Invoice_No



select DISTINCT S_Student_ID StudentID,I_Course_ID,S_Course_Name,DueType,I_Invoice_Header_ID as FeeScheduleID,I_Invoice_Detail_ID,S_Invoice_No InvoiceNo,FeeScheduleNo,I_Installment_No as InstallmentNo,Dt_Installment_Date,I_Sequence SequenceNo,I_FeeComponent_ID,
S_Component_Name ComponentName,N_Amount_Due,TotalTax,ISNULL(ReceiptCompAmount,0) as BaseAmountPaid,ISNULL(ReceiptCompTax,0) as TaxPaid,
ISNULL(CreditNoteAmt,0) as CreditNoteAmt,ISNULL(CreditNoteTax,0) as CreditNoteTax,BaseAmtDiff,TaxDiff,
N_Amount_Due-ISNULL(CreditNoteAmt,0) as PayableBaseAmount,TotalTax-ISNULL(CreditNoteTax,0) as PayableTax,
N_Amount_Due+TotalTax-ISNULL(CreditNoteAmt,0)-ISNULL(CreditNoteTax,0) as TotalPayableAmount,
ISNULL(ReceiptCompAmount,0)+ISNULL(ReceiptCompTax,0) as TotalPaidAmount,
TotalDiff as DueAmount,
I_FeeComponent_ID as FeeComponentID
from #INVDET
where ISNULL(TotalDiff,0) >0
order by
S_Student_ID ,
-- I_Invoice_Header_ID ,
Dt_Installment_Date,
-- I_Installment_No,
I_Sequence


-- drop table #INVDET

exec [SelfService].uspGetStudentOnAccDue @iBrandID,@MobileNo

END
