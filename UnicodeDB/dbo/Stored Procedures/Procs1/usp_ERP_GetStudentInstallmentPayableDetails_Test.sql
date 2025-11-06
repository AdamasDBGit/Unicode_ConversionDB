
    
                    
-- EXEC usp_ERP_GetStudentInstallmentPayableDetails 107,'24-0303'                   
                 
CREATE PROCEDURE [dbo].[usp_ERP_GetStudentInstallmentPayableDetails_Test]          
(@iBrandID INT,@sStudentID NVARCHAR(MAX))                    
AS                    
BEGIN                    
                    
      --DECLARE @iBrandID INT=107                    
      --DECLARE @sStudentID VARCHAR(MAX)='24-0303'                    
                    
                       
                    
                    
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
   --Select @CentreID,@MobileNo                  
               
                 
   DECLARE @FIYear VARCHAR(20)                        
                        
   SELECT @FIYear = (CASE WHEN (MONTH(GETDATE())) <= 3 THEN convert(varchar(4), YEAR(GETDATE())-1) + '-' + convert(varchar(4), YEAR(GETDATE())%100)                        
       ELSE convert(varchar(4),YEAR(GETDATE()))+ '-' + convert(varchar(4),(YEAR(GETDATE())%100)+1)END)                        
                        
   --SELECT SUBSTRING(@FIYear,0,5) AS F_YEAR                     
                    
   SET @FIYear=SUBSTRING(@FIYear,0,5)        
      
   Declare @EnquiryID int      
      
      
   select @EnquiryID=e.I_Enquiry_Regn_ID from T_student_detail s      
   Inner Join T_Enquiry_Regn_Detail e on s.I_Enquiry_Regn_ID=e.I_Enquiry_Regn_ID      
   where s.S_Student_ID=@sStudentID      
     print @EnquiryID                
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
      CASE WHEN YEAR(GETDATE())=@FIYear           
   AND TICD.Dt_Installment_Date <=CAST( GETDATE() AS Date )                    
      THEN 'Current'                     
      WHEN YEAR(GETDATE())=@FIYear           
   AND TICD.Dt_Installment_Date >CAST( GETDATE() AS Date )                    
      THEN 'Upcoming'                     
      ELSE 'Previous' END as DueType           
   ,TSBM.I_Batch_ID          
 FROM    dbo.T_Invoice_Parent TIP                    
                        INNER JOIN dbo.T_Invoice_Child_Header TICH ON TIP.I_Invoice_Header_ID = TICH.I_Invoice_Header_ID                    
                        INNER JOIN dbo.T_Invoice_Child_Detail TICD ON TICH.I_Invoice_Child_Header_ID = TICD.I_Invoice_Child_Header_ID                    
                        INNER JOIN dbo.T_Fee_Component_Master TFCM ON TICD.I_Fee_Component_ID = TFCM.I_Fee_Component_ID                    
                        INNER JOIN dbo.T_Student_Detail TSD ON TIP.I_Student_Detail_ID = TSD.I_Student_Detail_ID                    
      Inner JOIN T_Student_Parent_Maps TSPM ON TSPM.S_Student_ID = TSD.S_Student_ID                    
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
                              OR TIP.Dt_Upd_On >= '2017-07-01'                    
                            )                    
      AND TICD.Dt_Installment_Date>='2020-03-18'                    
      AND                   
   TSD.S_Student_ID = @sStudentID                    
      AND                   
  TPM.S_Mobile_No=@MobileNo    
 select * from #INVDET  
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
------New Implement TAXID----------                  
 --UPDATE  T1                    
 --       SET     T1.I_TAX_ID = T2.TaxID                    
 --       FROM    #INVDET AS T1                    
 --               INNER JOIN ( SELECT TIDT.I_Invoice_Detail_ID ,                    
 --                                   TIDT.I_Tax_ID                  
 --                                   as TaxID                    
 --                            FROM   dbo.T_Invoice_Detail_Tax AS TIDT                    
 --                                   INNER JOIN dbo.T_Invoice_Child_Detail AS TICD ON TICD.I_Invoice_Detail_ID = TIDT.I_Invoice_Detail_ID                    
 --                            GROUP BY TIDT.I_Invoice_Detail_ID ,                    
 --                                   TICD.Dt_Installment_Date ,TIDT.I_Tax_ID                   
 --                          ) T2 ON T2.I_Invoice_Detail_ID = T1.I_Invoice_Detail_ID                   
         ----------------------------                  
                    
                    
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
       select * from   #INVDET  --TaxPaidAdvBeforeGST          
                    
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
                                       
           
		     select * from   #INVDET  --TaxPaidAdvBeforeGST


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
    --        I.I_Installment_No,                    
    --I.I_Sequence                    
                    
-- exec [SelfService].[uspGetStudentInstallmentPayableDetails] 107,6289687421                    
 --select * from #INVDET                     
                    
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
      --CASE WHEN @iBrandID = 107 THEN 27                    
      --                               WHEN @iBrandID = 110 THEN 55                    
      --                               WHEN @iBrandID = 109 THEN 77                    
      --                          END I_FeeComponent_ID,      
   (select top 1 I_Status_Value from T_Status_Master where I_Brand_ID=@iBrandID) as I_FeeComponent_ID ,                    
                  'Fine' S_Component_Name ,                    
                  dbo.fnGetFineAmountForAPI(@iBrandID,Dt_Installment_Date) AS N_Amount_Due,                    
      DueType,                    
       dbo.fnGetFineAmountForAPI(@iBrandID,Dt_Installment_Date) AS TotalDiff                    
      from #INVDET                    
      GROUP BY S_Student_ID, DueType,S_Invoice_No,Dt_Installment_Date,FeeScheduleNo,I_Invoice_Header_ID                    
HAVING SUM(ISNULL(TotalDiff,0)) >0                    
                    
-- select * from #INVDET                    
   Print 'Resultset 1'                 
select t1.*,t2.SummaryTotalPayableAmount,t2.SummaryTotalPaidAmount,t2.SummaryDueAmount ,0 as Adhoc_TotalAmount, 0 as AdhocTotalPaidAmount      
Into #PayableHeader1      
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
     Print 'Resultset 2'                 
                    
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
,0 as FineAmountL1      
Into #PayableHeader2      
from #INVDET as A                    
GROUP BY S_Student_ID, DueType                    
ORDER BY S_Student_ID,DueType        
------------Start Merging New Fine Stored Procedures From here----------      
Declare @F_paymentdate date      
SET @F_paymentdate=(select convert(date, Getdate()))      
--SET @F_paymentdate='2024-10-28'      
IF OBJECT_ID('tempdb..#StudentFine') IS NOT NULL      
BEGIN      
    DROP TABLE #StudentFine;      
END;      
Create Table #StudentFine(      
      
StudentID Varchar(20),      
InvoiceID Bigint,      
T_Invoice_Child_Header bigint,      
Dt_Installment_Date date,      
InstallmentNo int,      
FineAmount numeric(18,2)      
)      
Insert Into #StudentFine(      
StudentID,InvoiceID,T_Invoice_Child_Header,Dt_Installment_Date,InstallmentNo,FineAmount      
)      
   EXEC usp_ERP_Fine_CalculateBased_On_Frequency @iBrandID,@sStudentID,@F_paymentdate      
   Declare @finecomponentID int,@AdhocCompName Varchar(100)      
   SEt @finecomponentID= (select top 1 I_Status_Value from T_Status_Master       
   where I_Brand_ID=1 and Status_Type=2)  -----If Status_Type=2 Then Fine ,If Status_Type=1 Then  Prospectus    
   Set @AdhocCompName=(select Top 1 S_Status_Desc from T_Status_Master     
   where I_Status_Value=@finecomponentID)    
      
  ------Start Merging Fine with this Block 1st--------        
  Print 'Resultset 3'        
SELECT S_Student_ID StudentID,DueType,S_Invoice_No InvoiceNo,Dt_Installment_Date InstallmentDate,FeeScheduleNo,I_Invoice_Header_ID as FeeScheduleID                    
,SUM(N_Amount_Due+TotalTax-ISNULL(CreditNoteAmt,0)-ISNULL(CreditNoteTax,0)) AS SummaryTotalPayableAmount                    
,SUM(ISNULL(ReceiptCompAmount,0)+ISNULL(ReceiptCompTax,0)) AS SummaryTotalPaidAmount                    
,SUM(ISNULL(TotalDiff,0)) AS SummaryDueAmount                    
,CASE WHEN SUM(ISNULL(TotalDiff,0))=0 THEN 'Fully Paid'                     
WHEN SUM(ISNULL(ReceiptCompAmount,0)+ISNULL(ReceiptCompTax,0)) < SUM(N_Amount_Due+TotalTax-ISNULL(CreditNoteAmt,0)-ISNULL(CreditNoteTax,0)) and SUM(ISNULL(ReceiptCompAmount,0)+ISNULL(ReceiptCompTax,0)) > 0                    
THEN 'Partially Paid'                     
ELSE 'Not Paid'                    
END as PaymentStatus       
,0 as FineAmountL2      
into #PayableHeader3      
                    
from #INVDET as A                    
GROUP BY S_Student_ID, DueType,S_Invoice_No,Dt_Installment_Date,FeeScheduleNo,I_Invoice_Header_ID                    
HAVING SUM(ISNULL(TotalDiff,0)) >0                    
ORDER BY S_Student_ID,DueType,S_Invoice_No                    
                    
                    
--Select 'Details'                  
select  DISTINCT S_Student_ID StudentID,I_Course_ID,S_Course_Name,DueType,I_Invoice_Header_ID as FeeScheduleID,I_Invoice_Detail_ID,S_Invoice_No InvoiceNo,FeeScheduleNo,I_Installment_No as InstallmentNo,Dt_Installment_Date,I_Sequence SequenceNo,I_FeeComponent_ID,                    
S_Component_Name ComponentName,N_Amount_Due,TotalTax,ISNULL(ReceiptCompAmount,0) as BaseAmountPaid,ISNULL(ReceiptCompTax,0) as TaxPaid,                    
ISNULL(CreditNoteAmt,0) as CreditNoteAmt,ISNULL(CreditNoteTax,0) as CreditNoteTax,BaseAmtDiff,TaxDiff,                    
N_Amount_Due-ISNULL(CreditNoteAmt,0) as PayableBaseAmount,TotalTax-ISNULL(CreditNoteTax,0) as PayableTax,                    
N_Amount_Due+TotalTax-ISNULL(CreditNoteAmt,0)-ISNULL(CreditNoteTax,0) as TotalPayableAmount,                    
ISNULL(ReceiptCompAmount,0)+ISNULL(ReceiptCompTax,0) as TotalPaidAmount,                    
TotalDiff as DueAmount,                    
I_FeeComponent_ID as FeeComponentID                  
--Null as CGST,                  
--Null as SGST,                  
--Null as IGST,                  
--Null as CGST_Per,                  
--Null as SGST_Per,                  
--Null as IGST_Per                  
                  
                  
Into #INVDET_GST                  
from #INVDET                    
where ISNULL(TotalDiff,0) >0                    
order by                    
S_Student_ID ,                    
-- I_Invoice_Header_ID ,                    
Dt_Installment_Date,                    
-- I_Installment_No,                    
I_Sequence                   
--Select * from #INVDET_GST                  
                  
                  
                  
Select IDENTITY(INT,1,1) AS ID, a.*,b.I_GST_FeeComponent_Catagory_ID                  
Into #LoopGSTCal                  
from #INVDET_GST a                  
Inner Join T_ERP_GST_Item_Category b on a.I_FeeComponent_ID=b.I_Fee_Component_ID and b.Is_Active=1                  
Alter Table #LoopGSTCal                  
Add CGST numeric(18,2)                  
                  
Alter Table #LoopGSTCal                  
Add SGST numeric(18,2)                  
Alter Table #LoopGSTCal                  
Add IGST Numeric(18,2)                  
Alter Table #LoopGSTCal                  
add CGST_Per numeric(18,2)                  
Alter table #LoopGSTCal                  
add SGST_Per numeric(18,2)                  
Alter Table #LoopGSTCal                  
Add IGST_Per numeric(18,2)                  
--Select * from #LoopGSTCal                  
------GST Implementation New Structure---------------                  
Declare @GSTCategoryID int,@Fee_Component_Amount Numeric(18,2),                  
@SGST_Per numeric(10,2), @SGST_Value numeric(18,2),                  
@CGST_Per numeric(10,2), @CGST_Value numeric(18,2),                  
@IGST_Per numeric(10,2), @IGST_Value numeric(18,2),                  
@Fee_ComponentID int,                  
@PayableTAX numeric(18,2)                  
                  
Declare @ID int=1                  
Declare @Lst Int                  
SET @Lst=(SElect MAX(ID) from #LoopGSTCal)                  
                  
While @ID<=@Lst                  
Begin                   
SET @GSTCategoryID=(                  
Select I_GST_FeeComponent_Catagory_ID from #LoopGSTCal where ID=@ID                  
)                  
SET @Fee_Component_Amount=(                  
Select PayableBaseAmount from #LoopGSTCal where ID=@ID                  
)                  
SET @Fee_ComponentID=(                  
Select Top 1 I_FeeComponent_ID from #LoopGSTCal where ID=@ID                  
)                  
                  
SET @PayableTAX =(                  
Select Top 1 PayableTax from #LoopGSTCal where ID=@ID                  
)                  
                
SET @IGST_Per =                  
(                  
Select Top 1 N_IGST from T_ERP_GST_Configuration_Details                   
where I_GST_FeeComponent_Catagory_ID=@GSTCategoryID                  
and @Fee_Component_Amount between N_Start_Amount and N_End_Amount                  
)                  
                  
SET @CGST_Per =(                  
Select Top 1 N_CGST from T_ERP_GST_Configuration_Details where I_GST_FeeComponent_Catagory_ID=@GSTCategoryID                  
and @Fee_Component_Amount between N_Start_Amount and N_End_Amount                  
)                  
                  
SET @SGST_Per =(                  
Select Top 1 N_SGST from T_ERP_GST_Configuration_Details where I_GST_FeeComponent_Catagory_ID=@GSTCategoryID                  
and @Fee_Component_Amount between N_Start_Amount and N_End_Amount                  
)                  
                  
--SET @SGST_Value=(@Fee_Component_Amount * @SGST_Per / 100)                   
--SET @CGST_Value=(@Fee_Component_Amount * @CGST_Per / 100)                   
--SET @IGST_Value=(@Fee_Component_Amount * @IGST_Per / 100)                   
                  
--Select @GSTCategoryID                  
--Select @Fee_Component_Amount                  
--Select @IGST_Per,@CGST_Per,@SGST_Per               
--Select @IGST_Value,@SGST_Value,@CGST_Value                  
--select @PayableTAX                  
Update #LoopGSTCal set                   
                  
 CGST_Per=Convert(Numeric(18,2),@CGST_Per),                  
 SGST_Per=Convert(Numeric(18,2),@SGST_Per),                  
 IGST_Per=Convert(Numeric(18,2),@IGST_Per),                  
 CGST=Convert(numeric(18,2),@PayableTAX/2),                  
 SGST=Convert(Numeric(18,2),@PayableTAX/2),                  
 IGST=Convert(Numeric(18,2),@PayableTAX)                  
                  
 Where ID=@ID                   
                  
SET @ID=@ID+1                  
End         
---------CalculateFine Due amount      
Declare @FineDue numeric(18,2),@TotalFinePaid Numeric(18,2)      
      
select @TotalFinePaid=Sum(isnull(N_Receipt_Amount,0)) from T_Receipt_Header       
where I_Centre_Id=@CentreID and I_Enquiry_Regn_ID=@EnquiryID      
and I_Receipt_Type=@finecomponentID      
Group by I_Centre_Id, I_Enquiry_Regn_ID,I_Receipt_Type      
      
Select * Into #FineCalculate from #LoopGSTCal          
Print 'Resultset 4'        
Select       
ID,      
StudentID,      
I_Course_ID,      
S_Course_Name,      
DueType,      
FeeScheduleID,      
I_Invoice_Detail_ID,      
InvoiceNo,      
FeeScheduleNo,      
InstallmentNo,      
Dt_Installment_Date,      
SequenceNo,      
I_FeeComponent_ID,      
ComponentName,      
N_Amount_Due,      
TotalTax,      
BaseAmountPaid,      
TaxPaid,      
CreditNoteAmt,      
CreditNoteTax,      
BaseAmtDiff,      
TaxDiff,      
PayableBaseAmount,      
PayableTax,      
TotalPayableAmount,      
TotalPaidAmount,      
DueAmount,      
FeeComponentID,      
I_GST_FeeComponent_Catagory_ID,      
CGST,      
SGST,      
IGST,      
CGST_Per,      
SGST_Per,      
IGST_Per,    
0 as IsAdhoc    
Into #finalDetails      
from #LoopGSTCal       
Union       
Select       
ID,      
sf.StudentID,      
I_Course_ID,      
S_Course_Name,      
DueType,      
FeeScheduleID,      
I_Invoice_Detail_ID,      
InvoiceNo,      
FeeScheduleNo,      
sf.InstallmentNo,      
sf.Dt_Installment_Date,      
SequenceNo,      
@finecomponentID as I_FeeComponent_ID,      
@AdhocCompName as ComponentName,      
sf.FineAmount as N_Amount_Due,      
TotalTax,      
BaseAmountPaid,      
TaxPaid,      
CreditNoteAmt,      
CreditNoteTax,      
sf.FineAmount as BaseAmtDiff,      
0 as TaxDiff,      
sf.FineAmount as PayableBaseAmount,      
PayableTax,      
sf.FineAmount as TotalPayableAmount,      
TotalPaidAmount,      
sf.FineAmount as DueAmount,      
@finecomponentID as FeeComponentID,      
0 as I_GST_FeeComponent_Catagory_ID,      
0 as CGST,      
0 as SGST,      
0 as IGST,      
0 as CGST_Per,      
0 as SGST_Per,      
0 as IGST_Per,    
1 as IsAdhoc    
from #FineCalculate f      
Inner Join #StudentFine sf       
on f.InstallmentNo=sf.InstallmentNo and convert(date,f.Dt_Installment_Date)=sf.Dt_Installment_Date      
where sf.FineAmount >0      
order by InstallmentNo,I_Invoice_Detail_ID      
Declare @TotalFineHeader1 Numeric(18,2),@TotalFineHeader2 numeric(18,2)      
set @TotalFineHeader1=(select  isnull(Sum(n_amount_due),0) as TotalFineHeader1 from #finalDetails where ComponentName='Late Fine')      
Update #PayableHeader1 set Adhoc_TotalAmount=@TotalFineHeader1,AdhocTotalPaidAmount=isnull(@TotalFinePaid,0)      
Select * from #PayableHeader1--------Showing 1      
      
update t2 set t2.FineAmountL1=isnull(ft2.TotalFineHeader2,0) from #PayableHeader2  t2      
Left Join (      
select isnull(Sum(n_amount_due),0) as TotalFineHeader2 ,duetype from #finalDetails       
where ComponentName=@AdhocCompName      
Group By  duetype      
) as Ft2 on t2.DueType=ft2.DueType      
Select * from #PayableHeader2------showing 2      
      
Update t3 set t3.FineAmountL2 =isnull(ft3.TotalFineHeader3,0)  from #PayableHeader3 t3      
Left Join      
(      
select isnull(Sum(n_amount_due),0) as TotalFineHeader3 ,duetype,InvoiceNo from #finalDetails       
where ComponentName=@AdhocCompName      
Group By  duetype,InvoiceNo      
) ft3 on ft3.InvoiceNo=t3.InvoiceNo      
      
Select distinct p3.*,ICCD.is_Freezed as Freezed from #PayableHeader3 p3----Showing 3      
Left Join T_Invoice_Child_Detail ICCD       
on convert(date,ICCD.Dt_Installment_Date)=convert(date,p3.InstallmentDate)      
and p3.InvoiceNo=ICCD.S_Invoice_Number       
Left Join T_Invoice_Child_Header ICCH on ICCH.I_Invoice_Child_Header_ID=ICCD.I_Invoice_Child_Header_ID      
and ICCH.I_Invoice_Header_ID=p3.FeeScheduleID      
      
------Freezed Column Added for Payment Gateway Implement     
---If IsAdhoc =0 Then from Structure If 1 Then Adhoc     
select DISTINCT p4.*,ICCD.is_Freezed as Freezed from #finalDetails p4---showing 4      
Left Join T_Invoice_Child_Detail ICCD       
on convert(date,ICCD.Dt_Installment_Date)=convert(date,p4.Dt_Installment_Date)      
and p4.InvoiceNo=ICCD.S_Invoice_Number       
Left Join T_Invoice_Child_Header ICCH on ICCH.I_Invoice_Child_Header_ID=ICCD.I_Invoice_Child_Header_ID      
and ICCH.I_Invoice_Header_ID=p4.FeeScheduleID      
         
---------                  
                  
                    
                    
-- drop table #INVDET                    
                    
--exec [SelfService].uspGetStudentOnAccDue @iBrandID,@MobileNo                    
                    
END

