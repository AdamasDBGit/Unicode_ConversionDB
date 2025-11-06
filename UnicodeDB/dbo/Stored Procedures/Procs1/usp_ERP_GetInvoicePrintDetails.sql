  --EXEC [usp_ERP_GetInvoicePrintDetails] 92
CREATE PROCEDURE [dbo].[usp_ERP_GetInvoicePrintDetails]  --[dbo].[uspGetInvoiceDetail] 168173         
    (  
      @iInvoiceHeaderID INT              
    )  
AS  
    BEGIN              
        SET NOCOUNT ON;              
        DECLARE @iInvoiceDetailId INT              
        DECLARE @TempTable TABLE  
            (  
              I_Tax_ID INT ,  
              I_Invoice_Detail_ID INT ,  
              N_Tax_Value NUMERIC(18, 6) ,  
              TAX_CODE VARCHAR(20) ,  
              TAX_DESC VARCHAR(50) ,  
              TAX_CHECK INT  
            )   
     
  
DECLARE @DEFAULTCurrencyID INT  
DECLARE @DEFAULTCurrencyCode varchar(max)  
DECLARE @DEFAULTCurrency varchar(50)  
  
  
  
-------------------Default Currency Details---------------------------------  
select   
@DEFAULTCurrencyID=I_Currency_ID,  
@DEFAULTCurrencyCode=S_Currency_Code,  
@DEFAULTCurrency=S_Currency  
from T_Currency_Master where Is_Default=1  
  
---------------------------------------------------------------------------  
  
  
  
  
 -- TABLE[0] RETURNS ALL THE INFORMATION FROM T_INVOICE_PARENT               
        SELECT  TIP.I_Invoice_Header_ID as InvoiceId ,  
    TIP.S_Invoice_No as InvoiceNo ,  
    TIP.I_Student_Detail_ID as StudentDetailId,  
    TIP.I_Centre_Id as CenterID,  
    TIP.N_Invoice_Amount as InvoiceAmount,  
    TIP.N_Tax_Amount as TotalTaxAmount,  
    TIP.Dt_Invoice_Date as InvoiceDate,  
    TIP2.I_Invoice_Header_ID as ParentInvoiceID,  
                TIP2.S_Invoice_No AS ParentInvoiceNumber,  
                CASE WHEN TIP.I_Status = 0 THEN TSIH1.I_Cancellation_Reason_ID  
                     ELSE TSIH.I_Cancellation_Reason_ID  
                END AS CancellationReasonID,  
    ISNULL(CM.I_Currency_ID,@DEFAULTCurrencyID) as CurrencyID,  
    ISNULL(CM.S_Currency_Code,@DEFAULTCurrencyCode) as CurrencyCode,  
    ISNULL(CM.S_Currency,@DEFAULTCurrency) as Currency,
	SASM.I_School_Session_ID as AcademicSessionID,
	SASM.S_Label as AcademicSessionLabel
        FROM    T_Invoice_Parent TIP WITH ( NOLOCK )  
    INNER JOIN dbo.T_Student_Detail TSD WITH ( NOLOCK ) on TIP.I_Student_Detail_ID=TSD.I_Student_Detail_ID  
    INNER JOIN dbo.T_Enquiry_Regn_Detail ERD WITH ( NOLOCK ) on ERD.I_Enquiry_Regn_ID=TSD.I_Enquiry_Regn_ID  
                LEFT OUTER JOIN dbo.T_Student_Invoice_History AS TSIH ON TIP.I_Parent_Invoice_ID = TSIH.I_Invoice_Header_ID  
                LEFT OUTER JOIN dbo.T_Student_Invoice_History AS TSIH1 ON TIP.I_Invoice_Header_ID = TSIH1.I_Invoice_Header_ID  
                LEFT OUTER JOIN dbo.T_Invoice_Parent AS TIP2 ON TSIH.I_Invoice_Header_ID = TIP2.I_Invoice_Header_ID  
    left join T_Currency_Master as CM on CM.I_Currency_ID=ISNULL(TIP.I_Currency_ID,0) 
	left join T_School_Academic_Session_Master as SASM on TIP.I_School_Session_ID=SASM.I_School_Session_ID
      
  WHERE   TIP.I_Invoice_Header_ID = @iInvoiceHeaderID              
   
 -- TABLE[2] RETURNS ALL THE FIELDS FROM Student Enquiry  
  
  
  
 --SELECT   TIP.I_Student_Detail_ID as StudentId,  
 --   TSD.S_Student_ID as StudentCode,  
 --   ERD.I_Enquiry_Regn_ID as EnquiryID,  
 --   ERD.S_First_Name as FirstName,  
 --   ERD.S_Middle_Name as MiddleName,  
 --   ERD.S_Last_Name as LastName,  
 --   ERD.S_Mobile_No as MobileNo,  
 --   ERD.S_Phone_No as PhoneNo,  
 --   ERD.S_Age as Age,  
 --   ERD.S_Curr_Address1 as CurrAddress1,  
 --               ERD.S_Curr_Address2 as CurrAddress2,  
 --               ERD.S_Curr_Pincode as CurrPincode,  
 --               ERD.S_Curr_Area as CurrArea,  
 --               ERD.S_Perm_Address1 as PermAddress1,  
 --               ERD.S_Perm_Address2 as PermAddress2,  
 --               ERD.S_Perm_Pincode as PermPincode,  
 --               ERD.I_Perm_City_ID as PermCityID,  
 --               ERD.I_Perm_State_ID as PermStateID,  
 --               ERD.I_Perm_Country_ID as PermCountryID,  
 --               ERD.S_Perm_Area as  PermArea,  
 --   ERD.I_Curr_City_ID  as CurrCityID ,  
 --               ERD.I_Curr_State_ID as CurrStateID ,  
 --               ERD.I_Curr_Country_ID as CurrCountryID  
      
 --       FROM    T_Invoice_Parent TIP WITH ( NOLOCK )  
 --   INNER JOIN dbo.T_Student_Detail TSD WITH ( NOLOCK ) on TIP.I_Student_Detail_ID=TSD.I_Student_Detail_ID  
 --   INNER JOIN dbo.T_Enquiry_Regn_Detail ERD WITH ( NOLOCK ) on ERD.I_Enquiry_Regn_ID=TSD.I_Enquiry_Regn_ID  
      
 --   WHERE   TIP.I_Invoice_Header_ID = @iInvoiceHeaderID    
  
  
  
  
  
 -- TABLE[2] RETURNS ALL THE FIELDS FROM T_Invoice_Child_Header              
        SELECT  TIVC.I_Invoice_Child_Header_ID InvoiceChildHeaderId,  
                TIVC.I_Invoice_Header_ID InvoiceHeaderID,  
                ISNULL(TIVC.I_Course_ID,0) CourseID,  
                ISNULL(TIVC.I_Course_FeePlan_ID,0) as CourseFeePlanId ,  
                TIVC.C_Is_LumpSum IsLumpSum,  
                TIVC.N_Amount CourseAmount,  
                ISNULL(TIVC.N_Tax_Amount, 0) AS CourseTaxAmount ,  
                TCM.S_Course_Code CourseCode,  
                TCM.S_Course_Name CourseName,  
                ISNULL(TCM.[I_Is_ST_Applicable], 'Y') AS I_Is_ST_Applicable ,  
                ISNULL(TIBM.I_Batch_ID,0) BatchID,  
                TSBM.S_Batch_Name BatchName,  
                --akash 18.12.2017  
                TSBM.Dt_BatchStartDate BatchStartDate,  
                ISNULL(TSBM.Dt_BatchIntroductionDate,'1990-01-01') AS Dt_BatchIntroductionDate,  
                TSBM.s_BatchIntroductionTime  
                --akash 18.12.2017  
        FROM    T_Invoice_Child_Header TIVC  
                LEFT OUTER JOIN T_Course_Master TCM WITH ( NOLOCK ) ON TIVC.I_Course_ID = TCM.I_Course_ID  
                LEFT OUTER JOIN dbo.T_Invoice_Batch_Map TIBM ON TIVC.I_Invoice_Child_Header_ID = TIBM.I_Invoice_Child_Header_ID  
                LEFT JOIN dbo.T_Student_Batch_Master AS TSBM ON TIBM.I_Batch_ID = TSBM.I_Batch_ID  
        WHERE   TIVC.I_Invoice_Header_ID = @iInvoiceHeaderID              
             
              
 -- TABLE[2] RETURNS all the records from T_INVOICE_CHILD_DETAIL and TAX DEATILS ORDER BY DATE              
 --SELECT ICD.* FROM T_Invoice_Child_Detail ICD              
 --INNER JOIN T_Invoice_Child_Header ICH              
 --ON ICD.I_Invoice_Child_Header_ID = ICH.I_Invoice_Child_Header_ID              
 --WHERE I_Invoice_Header_ID = @iInvoiceHeaderID               
 --ORDER BY ICD.I_Fee_Component_ID              
               
               
        SELECT DISTINCT  
                ICD.I_Invoice_Detail_ID InvoiceChildDetailsId,  
    ICD.I_Invoice_Child_Header_ID InvoiceChildHeaderId,  
    ICD.I_Fee_Component_ID as FeeComponentId,  
    ICD.I_Installment_No as InstallmentNo,  
    ICD.Dt_Installment_Date as DueDate,  
    ICD.N_Amount_Due as AmountDue,  
    ICD.N_Due as PayableAmount,  
    ICD.I_Sequence as Sequence  
        FROM    T_Invoice_Child_Detail ICD WITH ( NOLOCK )  
                INNER JOIN T_Invoice_Child_Header ICH WITH ( NOLOCK ) ON ICD.I_Invoice_Child_Header_ID = ICH.I_Invoice_Child_Header_ID  
                LEFT JOIN T_Course_Fee_Plan_Detail TCFPD WITH ( NOLOCK ) ON TCFPD.I_Fee_Component_ID = ICD.I_Fee_Component_ID  
                                                              AND TCFPD.I_Course_Fee_Plan_ID = ICH.I_Course_FeePlan_ID  
        WHERE   ICH.I_Invoice_Header_ID = @iInvoiceHeaderID        
        --ADDITION STARTED ON 26/06/2017    
                AND ISNULL(ICD.Flag_IsAdvanceTax, '') <> 'Y'    
        --ADDITION ENDED ON 26/06/2017    
        ORDER BY ICD.I_Fee_Component_ID              
              
              
        DECLARE TABLE_CURSOR CURSOR  
        FOR  
            SELECT  ICD.I_Invoice_Detail_ID  
            FROM    T_Invoice_Child_Detail ICD WITH ( NOLOCK )  
            WHERE   ICD.I_Invoice_Child_Header_ID IN (  
                    SELECT  I_Invoice_Child_Header_ID  
                    FROM    T_Invoice_Child_Header ICH WITH ( NOLOCK )  
                    WHERE   ICH.I_Invoice_Header_ID = @iInvoiceHeaderID )  
            ORDER BY Dt_Installment_Date   
     
  
---- Switch for GST Change -----  
  
DECLARE @isNewEnv bit=NULL  
  
select @isNewEnv=ISNULL(Is_NewGSTEnvironment,'false') from T_Invoice_Parent where I_Invoice_Header_ID=@iInvoiceHeaderID  
  
  
IF @isNewEnv ='false'  
  BEGIN  
    OPEN TABLE_CURSOR              
    FETCH NEXT FROM TABLE_CURSOR INTO @iInvoiceDetailId              
               
    WHILE @@FETCH_STATUS = 0  
     BEGIN              
      INSERT  INTO @TempTable  
        SELECT  IDT.I_Tax_ID ,  
          IDT.I_Invoice_Detail_ID ,     
          --IDT.N_Tax_Value,       
          IDT.N_Tax_Value N_Tax_Value ,  
          TM.S_Tax_Code AS TAX_CODE ,  
          TM.S_Tax_Desc AS TAX_DESC ,  
          CASE WHEN TM.S_Tax_Code = 'SGST' THEN 1  
            WHEN TM.S_Tax_Code = 'CGST' THEN 2  
            WHEN TM.S_Tax_Code = 'IGST' THEN 3  
            ELSE 0  
          END  
        FROM    T_Invoice_Detail_Tax IDT ,  
          T_Tax_Master TM ,    
          --ADDITION STARTED ON 26/06/2017    
          T_Invoice_Child_Detail ICD       
          --ADDITION ENDED ON 26/06/2017    
        WHERE   IDT.I_Invoice_Detail_ID = @iInvoiceDetailId  
          AND TM.I_Tax_ID = IDT.I_Tax_ID               
          --ADDITION STARTED ON 26/06/2017    
          AND IDT.I_Invoice_Detail_ID = ICD.I_Invoice_Detail_ID  
          AND ISNULL(ICD.Flag_IsAdvanceTax, '') <> 'Y'    
          --ADDITION ENDED ON 26/06/2017    
                 
      FETCH NEXT FROM TABLE_CURSOR INTO @iInvoiceDetailId              
     END              
                  
    CLOSE TABLE_CURSOR              
    DEALLOCATE TABLE_CURSOR   
    
  END  
  ELSE  
   BEGIN  
  
    OPEN TABLE_CURSOR              
    FETCH NEXT FROM TABLE_CURSOR INTO @iInvoiceDetailId              
               
    WHILE @@FETCH_STATUS = 0  
     BEGIN              
      INSERT  INTO @TempTable  
  
        SELECT NULL I_Tax_ID ,  
          SGST.I_Invoice_Detail_ID ,      
          ISNULL(SGST.N_SGST,0) N_Tax_Value ,  
          'SGST' AS TAX_CODE ,  
          'SGST' AS TAX_DESC ,  
          1  
        FROM   T_Invoice_Child_Detail SGST    
        WHERE   SGST.I_Invoice_Detail_ID = @iInvoiceDetailId  
          AND ISNULL(SGST.Flag_IsAdvanceTax, '') <> 'Y'    
        union  
        SELECT NULL I_Tax_ID ,  
          CGST.I_Invoice_Detail_ID ,      
          ISNULL(CGST.N_CGST,0) N_Tax_Value ,  
          'CGST' AS TAX_CODE ,  
          'CGST' AS TAX_DESC ,  
          2  
        FROM   T_Invoice_Child_Detail CGST    
        WHERE   CGST.I_Invoice_Detail_ID = @iInvoiceDetailId  
          AND ISNULL(CGST.Flag_IsAdvanceTax, '') <> 'Y'    
        union  
        SELECT NULL I_Tax_ID ,  
          IGST.I_Invoice_Detail_ID ,      
          ISNULL(IGST.N_IGST,0) N_Tax_Value ,  
          'IGST' AS TAX_CODE ,  
          'IGST' AS TAX_DESC ,  
          3  
        FROM   T_Invoice_Child_Detail IGST    
        WHERE   IGST.I_Invoice_Detail_ID = @iInvoiceDetailId  
          AND ISNULL(IGST.Flag_IsAdvanceTax, '') <> 'Y'   
  
  
                 
      FETCH NEXT FROM TABLE_CURSOR INTO @iInvoiceDetailId              
     END              
                  
    CLOSE TABLE_CURSOR              
    DEALLOCATE TABLE_CURSOR   
  
   END  
 --------------------------------------------------------------------------------             
 --TABLE[3] RETURNS TAX DEATILS               
        SELECT    
  I_Tax_ID TaxID ,  
              I_Invoice_Detail_ID InvoiceChildDetailsId,  
              N_Tax_Value TaxValue,  
              TAX_CODE TaxCode ,  
              TAX_DESC TaxDesc ,  
              TAX_CHECK CGST_SGST_IGST  
        FROM    @TempTable   
    
  
  
  
 SELECT
    CGCM.I_Course_ID                                AS CourseID,
    TC.I_Class_ID                                   AS ClassID,
    TC.S_Class_Name                                 AS ClassName,
    ISNULL(SM.I_Stream_ID, 0)                       AS StreamID,
    SM.S_Stream                                AS StreamName,
	S.I_Section_ID									AS SectionID,
	S.S_Section_Name                                AS SectionName,
	SG.I_School_Group_ID							AS SchoolGroupID,
	SG.S_School_Group_Name							AS SchoolGroupName
FROM T_Invoice_Child_Header AS TICH
INNER JOIN T_Invoice_Parent            AS TP
    ON TP.I_Invoice_Header_ID = TICH.I_Invoice_Header_ID
   AND TP.I_Status = 1
INNER JOIN T_Brand_Center_Details      AS BCD
    ON BCD.I_Centre_Id = TP.I_Centre_Id
   AND BCD.I_Status = 1
INNER JOIN T_Brand_Master              AS BM
    ON BM.I_Brand_ID = BCD.I_Brand_ID
   AND BM.I_Status = 1
INNER JOIN T_Course_Group_Class_Mapping AS CGCM
    ON TICH.I_Course_ID = CGCM.I_Course_ID
   AND CGCM.I_Brand_ID = BM.I_Brand_ID
-- pick exactly one SCS row: active first; otherwise latest inactive by created date
CROSS APPLY (
    SELECT TOP (1) S.*
    FROM T_Student_Class_Section AS S
    WHERE S.I_Student_Detail_ID  = TP.I_Student_Detail_ID
      AND S.I_School_Session_ID  = TP.I_School_Session_ID
    ORDER BY
        CASE WHEN S.I_Status = 1 THEN 0 ELSE 1 END,  -- prefer active
        S.dt_Created_dt DESC,                            -- then most recent
        S.I_Student_Class_Section_ID DESC             -- tie-breaker
) AS SCS
inner join
T_School_Group_Class as SGC on SGC.I_School_Group_Class_ID=SCS.I_School_Group_Class_ID
INNER JOIN T_Class AS TC
    ON SGC.I_Class_ID = TC.I_Class_ID
   AND TC.I_Brand_ID   = BM.I_Brand_ID
   AND TC.I_Status     = 1
inner join T_School_Group as SG
on SGC.I_School_Group_ID=SG.I_School_Group_ID
LEFT JOIN  T_Stream AS SM
    ON SM.I_Stream_ID = SCS.I_Stream_ID
	left join
	T_Section as S on S.I_Section_ID=SCS.I_Section_ID
WHERE TICH.I_Invoice_Header_ID = @iInvoiceHeaderID;

  
     
   END
