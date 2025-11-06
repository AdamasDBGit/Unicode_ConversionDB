
--EXEC InsertFeeDataset_NEWS @StudentIds='24-0492'

CREATE procedure [insertfeedataset]
	@StudentIds NVARCHAR(MAX) = NULL

AS
BEGIN
Select IDENTITY(INT,1,1) AS ID,
student_id
,current_due_date
,last_payment_id
,last_payment_status
,current_installment_fees
,last_payment_received_date
,current_balance_amount
,current_late_fee
,current_due_payment_link
INTO #ALLSTUDENT 
from (
SELECT DISTINCT 
					TSD.S_Student_ID AS student_id,
					COALESCE(IC.N_Invoice_Amount, 0) - COALESCE(SUM(RH.N_Receipt_Amount), 0) AS Paid_due_amount,
					subqt.Dt_Installment_Date AS current_due_date,
					RH.I_Receipt_Header_ID AS last_payment_id,				
					CASE WHEN
						RH.Dt_Receipt_Date is not Null
					THEN 1 
					ELSE 0 
					END
					AS last_payment_status,
					NULL AS current_installment_fees,
					RH.Dt_Receipt_Date AS last_payment_received_date,
					IC.N_Invoice_Amount AS current_balance_amount,
					NULL AS current_late_fee,
					NULL AS current_due_payment_link
				FROM 
					T_Student_Detail TSD 				
				LEFT JOIN
					T_Invoice_Parent IC ON  IC.I_Student_Detail_ID = TSD.I_Student_Detail_ID        
				LEFT JOIN	
					T_Receipt_Header RH ON 
					RH.I_Student_Detail_ID = IC.I_Student_Detail_ID AND RH.I_Invoice_Header_ID = IC.I_Invoice_Header_ID	 AND RH.I_Status =1
				JOIN T_Student_Class_Section SCS ON SCS.I_Student_Detail_ID = TSD.I_Student_Detail_ID AND SCS.I_Status = 1 AND SCS.I_Brand_ID = 107
					AND SCS.I_School_Session_ID = IC.I_School_Session_ID 
				Left Join (
					SELECT TOP 1 cd.Dt_Installment_Date,iv.I_Invoice_Header_ID  
					FROM T_Invoice_Child_Detail  cd
						inner Join T_Invoice_Child_Header  ch ON ch.I_Invoice_Child_Header_ID=cd.I_Invoice_Child_Header_ID
						inner join T_Invoice_Parent iv ON iv.I_Invoice_Header_ID=ch.I_Invoice_Header_ID
						WHERE convert(DATE,cd.Dt_Installment_Date) <=convert(DATE,GETDATE())
				) AS subqt ON subqt.I_Invoice_Header_ID = IC.I_Invoice_Header_ID
				WHERE
					IC.N_Invoice_Amount > 0 --AND TSD.S_Student_ID='24-0471'
					AND (@StudentIds IS NOT NULL AND TSD.S_Student_ID IN (SELECT Value FROM dbo.ERP_SplitString(@StudentIds, ',')))
						OR @StudentIds IS NULL

				GROUP BY 
					TSD.S_Student_ID,
					IC.N_Invoice_Amount,
					TSD.I_Student_Detail_ID,
					RH.I_Receipt_Header_ID,
					RH.Dt_Receipt_Date,
					subqt.Dt_Installment_Date
					) as TT

					--select * from #ALLSTUDENT
----Staring Process to calculate Currentdue

Declare @ID int=1 ,@LST int ,@studentID varchar(100)
SET @LST=(select MAX(ID) from #ALLSTUDENT)
Create Table #StudentCurrDue (StudentID varchar(100),Currentdue Numeric(12,2))
Create Table #StudentupcomingDue (StudentID varchar(100),Upcomingdue Numeric(12,2))
Create Table #curr_Installmentdt (StudentID varchar(100),CurrInstallmentDt date)

While @ID<=@LST
Begin
SET @studentID=(select student_id from #ALLSTUDENT where ID=@ID)
      DECLARE @iBrandID INT=107                      
      DECLARE @sStudentID VARCHAR(MAX)=@studentID                   
                      
                         
  SET NOCOUNT ON  ;                  
                      
   DECLARE @CentreID INT                      
                      
   DECLARE @MobileNo varchar(max)  
   DECLARE @StudentDetailID int
                      
   select @CentreID=B.I_Centre_Id ,@MobileNo=TPM.S_Mobile_No,@StudentDetailID=D.I_Student_Detail_ID from T_Student_Detail A                      
   inner join T_Student_Center_Detail B on A.I_Student_Detail_ID=B.I_Student_Detail_ID                      
   inner join T_Center_Hierarchy_Name_Details C on B.I_Centre_Id=C.I_Center_ID                      
   INNER JOIN dbo.T_Student_Detail D ON D.I_Student_Detail_ID = A.I_Student_Detail_ID                      
   INNER JOIN T_Student_Parent_Maps TSPM ON TSPM.S_Student_ID = D.S_Student_ID                      
   INNER JOIN T_Parent_Master TPM ON TPM.I_Parent_Master_ID = TSPM.I_Parent_Master_ID                      
   where D.S_Student_ID=@sStudentID                      
   --TPM.S_Mobile_No=@MobileNo                       
   and B.I_Status=1 and C.I_Brand_ID=@iBrandID                      
   --Select @CentreID,@MobileNo  
   print @MobileNo

 Declare @FStartYear  VARCHAR(10) ,@FEndYear Varchar(10),@sessionID int 
 SET @sessionID=(
 select top 1 I_School_Session_ID from T_Student_Class_Section where S_Student_ID=@sStudentID --and I_Status=1 
and I_Brand_ID=@iBrandID order by I_School_Session_ID desc
)
select Top 1  @FStartYear=YEAR(Dt_Session_Start_Date),@FEndYear=YEAR(Dt_Session_End_Date )
from T_School_Academic_Session_Master 
where i_brand_id=@iBrandID and I_School_Session_ID=@sessionID
              
   DECLARE @FIYear VARCHAR(20)                          
                          
   SELECT @FIYear = (CASE WHEN (MONTH(GETDATE())) <= 3 THEN convert(varchar(4), YEAR(GETDATE())-1) + '-' + convert(varchar(4), YEAR(GETDATE())%100)                          
       ELSE convert(varchar(4),YEAR(GETDATE()))+ '-' + convert(varchar(4),(YEAR(GETDATE())%100)+1)END)                          
                          
   --SELECT SUBSTRING(@FIYear,0,5) AS F_YEAR                       
                      
   SET @FIYear=SUBSTRING(@FIYear,0,5)          
        print @FIYear
   Declare @EnquiryID int   
   Declare @studentStatus int
   set @studentStatus = (select top 1 I_Status from T_Student_Class_Section where S_Student_ID=@sStudentID)
    print 'status'
	print    @studentStatus     
        
   select @EnquiryID=e.I_Enquiry_Regn_ID from T_student_detail s        
   Inner Join T_Enquiry_Regn_Detail e on s.I_Enquiry_Regn_ID=e.I_Enquiry_Regn_ID        
   where s.S_Student_ID=@sStudentID        
    --Print @EnquiryID                  
  -- Select @FIYear                    
                      
                        
                          
                          
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
     DueType VARCHAR(MAX) ,                    
  CGST_Amt Numeric(18,2),                    
  CGST_Per Numeric(10,2),                    
  SGST_Amt numeric(18,2),                    
  SGST_Per Numeric(10,2),                    
  IGST_Amt Numeric(18,2),                    
  IGST_Per Numeric(10,2)             
  ,Batch_ID int
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
   ,Batch_ID    
   --,Status
                )                      
                SELECT distinct TCHND.I_Center_ID,TCHND.S_Center_Name ,                      
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
      CASE WHEN YEAR(GETDATE()) between @FStartYear and @FEndYear             
   AND TICD.Dt_Installment_Date <=CAST( GETDATE() AS Date )                      
      THEN 'Current'                       
      WHEN YEAR(GETDATE())between @FStartYear and @FEndYear          
   AND TICD.Dt_Installment_Date >CAST( GETDATE() AS Date )                      
      THEN 'Upcoming'                       
      ELSE 'Previous' END as DueType             
   ,TSBM.I_Batch_ID      
   --,@studentStatus 
 FROM    dbo.T_Invoice_Parent TIP                      
                        INNER JOIN dbo.T_Invoice_Child_Header TICH ON TIP.I_Invoice_Header_ID = TICH.I_Invoice_Header_ID                      
                        INNER JOIN dbo.T_Invoice_Child_Detail TICD ON TICH.I_Invoice_Child_Header_ID = TICD.I_Invoice_Child_Header_ID                      
                        INNER JOIN dbo.T_Fee_Component_Master TFCM ON TICD.I_Fee_Component_ID = TFCM.I_Fee_Component_ID                      
                        INNER JOIN dbo.T_Student_Detail TSD ON TIP.I_Student_Detail_ID = TSD.I_Student_Detail_ID     
      and TSD.I_Status=1  
      Inner JOIN T_Student_Parent_Maps TSPM ON TSPM.S_Student_ID = TSD.S_Student_ID                      
      INNER JOIN T_Parent_Master TPM ON TPM.I_Parent_Master_ID = TSPM.I_Parent_Master_ID                      
      INNER JOIN T_Enquiry_Regn_Detail ERD ON ERD.I_Enquiry_Regn_ID = TSD.I_Enquiry_Regn_ID                      
                        Inner JOIN ( SELECT DISTINCT TIP1.I_Student_Detail_ID ,                      
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
                        Left JOIN dbo.T_Student_Batch_Master TSBM ON TSBD.I_Batch_ID = TSBM.I_Batch_ID                      
                        Left JOIN dbo.T_Course_Master TCM ON TSBM.I_Course_ID = TCM.I_Course_ID                      
                 INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TIP.I_Centre_Id = TCHND.I_Center_ID                      
                        INNER JOIN dbo.T_Centre_Master AS TCM2 ON TCM2.I_Centre_Id = TCHND.I_Center_ID                      
                                                              AND TIP.I_Centre_Id = TCM2.I_Centre_Id                      
                  Inner JOIN T_Student_Batch_Details TSBD1 ON TSBD1.I_Student_ID = TSD.I_Student_Detail_ID and TSBD1.I_Status=1                      
      Left JOIN dbo.T_Student_Batch_Master TSBM1 ON TSBM1.I_Batch_ID = TSBD1.I_Batch_ID                      
      Left JOIN dbo.T_Course_Master TSCM ON TSCM.I_Course_ID = TSBM1.I_Course_ID                      
                            
                WHERE          
   TCHND.I_Center_ID IN (@CentreID )                      
                        AND TIP.I_Status IN (0, 1, 3 )                      
                        AND TICD.I_Installment_No <> 0                      
                        AND ( TIP.Dt_Upd_On IS NULL                      
                              OR TIP.Dt_Upd_On >= '2010-07-01'                      
                            )                      
      AND TICD.Dt_Installment_Date>='2010-03-18'                      
      AND                     
   TSD.S_Student_ID = @sStudentID                      
      AND                     
  TPM.S_Mobile_No=@MobileNo  and ISNULL(TIP.I_Status,0)<>0   
  ----Print '101'  
 --select * from #INVDET   where DueType='Current'
      --select * from #INVDET   where Dt_Installment_Date >convert(date,getdate())            
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
------------------------------------------------------                    
         
                      
                      
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
        SET     TotalTax =                   
   ISNULL(TaxDue, 0)                   
    + ISNULL(TaxPaidAdvBeforeGST, 0)                      
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

		--select * from #INVDET where dueType='Current'
		Insert Into #StudentcurrDue(StudentID,Currentdue)
		select S_Student_ID,SUM(Totaldiff) as CurrentDue
		from #INVDET 
		where dueType='Current'
		Group By S_Student_ID,DueType
		-------------------------------------------------
				Insert Into #StudentupcomingDue(StudentID,upcomingdue)

			select S_Student_ID,SUM(Totaldiff) as UpcomingDue 
		from #INVDET 
		where dueType='Upcoming'
		Group By S_Student_ID,DueType

		Insert Into #curr_Installmentdt(StudentID,CurrInstallmentDt)
	    select S_Student_ID, MIN(Dt_Installment_Date) as Curr_InstallmentDt
		from #INVDET where DueType='Current'
		Group By S_Student_ID
		--drop table #INVDET

		Drop Table #INVDET
		SET @ID=@ID+1
		End
		--Select * from #StudentDue --where studentID='24-0471'
----main Select to show data.
	
--		Select 
--		mt.student_id,
--		sdue.Currentdue as current_due_amount
--        ,currinst.CurrInstallmentDt as current_due_date
--,mt.last_payment_id
--,mt.last_payment_status
--,mt.current_installment_fees
--,mt.last_payment_received_date
--, sdue.Currentdue+updue.upcomingdue as  current_balance_amount
--,mt.current_late_fee
--,mt.current_due_payment_link
--		from #ALLSTUDENT  mt
--		Inner Join #StudentcurrDue sdue on sdue.StudentID=mt.student_id
--		Inner Join #StudentupcomingDue  updue on updue.StudentID=mt.student_id
--		Inner Join #curr_Installmentdt currinst On currinst.StudentID=mt.student_id
		--where mt.student_id='24-0457'
		 TRUNCATE TABLE Temp_Fees_Details;
	INSERT INTO Temp_Fees_Details (
    student_id, 
    current_due_amount, 
    current_due_date, 
    last_payment_id, 
    last_payment_status, 
    current_installment_fees, 
    last_payment_received_date, 
    current_balance_amount, 
    current_late_fee, 
    current_due_payment_link
)
SELECT 
    mt.student_id,
    sdue.Currentdue AS current_due_amount,
    currinst.CurrInstallmentDt AS current_due_date,
    mt.last_payment_id,
    mt.last_payment_status,
    mt.current_installment_fees,
    mt.last_payment_received_date,
    (sdue.Currentdue + updue.upcomingdue) AS current_balance_amount,
    mt.current_late_fee,
    mt.current_due_payment_link
FROM #ALLSTUDENT mt
INNER JOIN #StudentcurrDue sdue ON sdue.StudentID = mt.student_id
INNER JOIN #StudentupcomingDue updue ON updue.StudentID = mt.student_id
INNER JOIN #curr_Installmentdt currinst ON currinst.StudentID = mt.student_id;

-- Drop Temporary Tables (if they exist)
IF OBJECT_ID('tempdb..#StudentcurrDue') IS NOT NULL 
    DROP TABLE #StudentcurrDue;

IF OBJECT_ID('tempdb..#ALLSTUDENT') IS NOT NULL 
    DROP TABLE #ALLSTUDENT;

IF OBJECT_ID('tempdb..#StudentupcomingDue') IS NOT NULL 
    DROP TABLE #StudentupcomingDue;

IF OBJECT_ID('tempdb..#curr_Installmentdt') IS NOT NULL 
    DROP TABLE #curr_Installmentdt;


				

	 --   Drop table #StudentcurrDue
		--drop table #ALLSTUDENT
		--drop table #StudentupcomingDue
		--Drop Table #curr_Installmentdt


		--select * from Temp_Fees_Details


	end
