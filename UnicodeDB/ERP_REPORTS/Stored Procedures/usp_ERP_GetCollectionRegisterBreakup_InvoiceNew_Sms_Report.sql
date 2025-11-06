CREATE  PROCEDURE [ERP_REPORTS].[usp_ERP_GetCollectionRegisterBreakup_InvoiceNew_Sms_Report]          
    (          
      @sHierarchyList VARCHAR(MAX)=NULL ,          
      @iBrandID INT ,       
   @iSchoolGroupID INT,      
   --@iClassID INT,      
   @strclass varchar(100),----1,2,3      
      @startDate DATE ,          
      @endDate DATE          
          
    )          
AS           
    BEGIN        
 --step1      
 IF OBJECT_ID('tempdb..#Courses') IS NULL      
 BEGIN     CREATE TABLE #Courses (         Id INT IDENTITY(1,1), CourseID INT     )      
 END        
 --step2      
INSERT INTO #Courses (CourseID) -- Adjust ColumnName to match your table's column                                        
SELECT Value                                        
FROM dbo.ERP_SplitString(@strclass, ',');         
      
      
 DECLARE @SessionID INT      
      
 select @SessionID=I_School_Session_ID from T_School_Academic_Session_Master where       
 CONVERT(DATE,@startDate) between CONVERT(DATE,Dt_Session_Start_Date) and CONVERT(DATE,Dt_Session_End_Date)       
 and CONVERT(DATE,@endDate) between CONVERT(DATE,Dt_Session_Start_Date) and CONVERT(DATE,Dt_Session_End_Date)       
 and I_Status=1 and I_Brand_ID=@iBrandID      
      
      
      
      
          
        SELECT        
    BM.S_Brand_Name as Brand,      
    SG.S_School_Group_Name as SchoolProgram,      
    ASM.S_Label as AcademicSession,      
    C.S_Class_Name as Class,      
    S.S_Section_Name as Section,      
      
    ----RH.I_Centre_Id ,          
    ----            TCHND.S_Center_Name ,          
    ----            SD.I_Student_Detail_ID ,          
                SD.S_Student_ID StudentID,          
                SD.S_First_Name + ' ' + ISNULL(SD.S_Middle_Name, '') + ' '          
                + SD.S_Last_Name AS StudentName ,          
                FCM.S_Component_Name ComponentName,          
                ISNULL(RCD.N_Amount_Paid, 0.0) AS TotalReceiptAmountPaid_Excl_of_Taxes,          
                SUM(ISNULL(RTD.N_Tax_Paid, 0.0)) AS TaxPaid ,       
    ISNULL(RCD.N_Amount_Paid, 0.0) + SUM(ISNULL(RTD.N_Tax_Paid, 0.0)) AS TotalReceiptAmountPaid_Incl_of_Taxes ,       
    TICD.Dt_Installment_Date InstallmentDueDate,      
    RH.S_Receipt_No ReceiptNo,        
--TM.S_Tax_Desc,          
                DATENAME(m,RH.Dt_Receipt_Date)+CAST(DATEPART(YYYY,RH.Dt_Receipt_Date) AS VARCHAR) AS ReceiptDate ,      
    CM.S_Currency_Name Currency,      
                RH.S_ChequeDD_No "ChequeOrDDNo",       
    CASE WHEN TID.ReceiptHeaderID IS NULL THEN 'Offline('+PM.S_PaymentMode_Name+')'      
    ELSE 'Online('+TID.S_TransactionMode+')' END "PaymentMode",      
    CASE WHEN AICD.I_Advance_Invoice_Child_Detail_Map_ID IS NULL THEN 'Current'      
    ELSE 'Advance' END "PaymentType",      
    RH.S_Bank_Name "BankName",      
    TID.I_ERP_TransactionNo "TransactionRefno.",      
    TIP.S_Invoice_No As "InvoiceNo.",      
                RH.Dt_ChequeDD_Date as "ChequeDraftDate",        
    RH.Dt_Deposit_Date as "SettlementDate",      
    CASE WHEN TID.ReceiptHeaderID IS NULL THEN 'Offline'      
    ELSE 'Online' END "ModeOfPayment",      
                --RH.S_Narration ,          
                --PM.S_PaymentMode_Name ,          
                --RH.I_Status ,          
                --RH.Dt_Crtd_On ,       
    RH.S_Crtd_By "CreatedBy",      
                RH.Dt_Upd_On "CancelledOn",          
                          
                NULL          
        FROM    T_Receipt_Header RH          
                LEFT JOIN T_Receipt_Component_Detail RCD ON RCD.I_Receipt_Detail_ID = RH.I_Receipt_Header_ID          
                INNER JOIN T_Student_Detail SD ON RH.I_Student_Detail_ID = SD.I_Student_Detail_ID          
                INNER JOIN T_Invoice_Child_Detail ICD ON ICD.I_Invoice_Detail_ID = RCD.I_Invoice_Detail_ID          
                INNER JOIN T_Fee_Component_Master FCM ON FCM.I_Fee_Component_ID = ICD.I_Fee_Component_ID          
                LEFT JOIN T_Receipt_Tax_Detail RTD ON RCD.I_Receipt_Comp_Detail_ID = RTD.I_Receipt_Comp_Detail_ID          
                LEFT JOIN T_Tax_Master TM ON TM.I_Tax_ID = RTD.I_Tax_ID          
   INNER JOIN T_Center_Hierarchy_Name_Details TCHND ON TCHND.I_Center_ID = RH.I_Centre_Id          
                LEFT JOIN T_PaymentMode_Master PM ON PM.I_PaymentMode_ID = RH.I_PaymentMode_ID          
                INNER JOIN dbo.T_Invoice_Child_Detail TICD ON TICD.I_Invoice_Detail_ID = RCD.I_Invoice_Detail_ID      
    INNER JOIN T_Student_Class_Section as SCS on SCS.I_Student_Detail_ID=SD.I_Student_Detail_ID       
    INNER JOIN T_School_Group_Class as SGC on SGC.I_School_Group_Class_ID=SCS.I_School_Group_Class_ID      
    INNER JOIN T_School_Group as SG on SGC.I_School_Group_ID=SG.I_School_Group_ID      
    Inner Join #Courses ct on ct.CourseID=SGC.I_Class_ID      
    INNER JOIN T_School_Academic_Session_Master as ASM on ASM.I_School_Session_ID=SCS.I_School_Session_ID      
    INNER JOIN T_Class as C on C.I_Class_ID=SGC.I_Class_ID      
    INNER JOIN T_Section as S on SCS.I_Section_ID=S.I_Section_ID      
    LEFT JOIN T_Currency_Master as CM on RH.I_Currency_ID=CM.I_Currency_ID      
    LEFT JOIN       
    (      
    select TM.S_TransactionMode,TID.ReceiptHeaderID,TM.I_ERP_TransactionNo from       
    T_ERP_Transaction_Master as TM       
    inner join T_ERP_Transaction_Invoice_Details as TID on TM.I_ERP_Transaction_Master_ID=TID.I_ERP_Transaction_Master_ID      
    where ReceiptHeaderID IS NOT NULL      
    )      
     as TID on TID.ReceiptHeaderID=RH.I_Receipt_Header_ID      
    LEFT JOIN T_Advance_Invoice_Child_Detail_Mapping as AICD on AICD.I_Receipt_Component_Detail_ID=RCD.I_Receipt_Comp_Detail_ID      
    LEFT JOIN T_Invoice_Child_Header as ICH on ICD.I_Invoice_Child_Header_ID=ICH.I_Invoice_Child_Header_ID      
    LEFT JOIN T_Invoice_Parent as TIP on ICH.I_Invoice_Header_ID=TIP.I_Invoice_Header_ID      
      
    CROSS JOIN T_Brand_Master BM      
        WHERE   FCM.I_Brand_ID = @iBrandID and BM.I_Brand_ID=@iBrandID          
                AND RH.I_Centre_Id IN (          
                SELECT  CenterList.centerID          
                FROM    dbo.fnGetCentreIdByBrandId(@iBrandID) CenterList )          
                AND DATEDIFF(dd, @startDate, Dt_Receipt_Date) >= 0          
                AND DATEDIFF(dd, @endDate, Dt_Receipt_Date) <= 0        
    AND SCS.I_School_Session_ID=@SessionID         
    --and SGC.I_Class_ID=@iClassID       
    and SGC.I_School_Group_ID=@iSchoolGroupID      
--and RCD.N_Amount_Paid>0.5          
GROUP BY         RH.I_Centre_Id,      
    TCHND.S_Center_Name,      
    SD.I_Student_Detail_ID,      
    SD.S_Student_ID,      
    SD.S_First_Name + ' ' + ISNULL(SD.S_Middle_Name, '') + ' ' + SD.S_Last_Name,      
    FCM.S_Component_Name,      
    RH.S_Receipt_No,      
    RCD.N_Amount_Paid,      
    DATENAME(m, RH.Dt_Receipt_Date) + CAST(DATEPART(YYYY, RH.Dt_Receipt_Date) AS VARCHAR),      
    RH.S_Bank_Name,      
    RH.S_ChequeDD_No,      
    RH.Dt_ChequeDD_Date,      
    RH.S_Narration,      
    PM.S_PaymentMode_Name,      
    RH.I_Status,      
    RH.Dt_Crtd_On,      
    RH.Dt_Upd_On,      
    TICD.Dt_Installment_Date,      
    RH.S_Cancellation_Reason,      
    BM.S_Brand_Name,      
    SG.S_School_Group_Name,      
    ASM.S_Label,      
 C.S_Class_Name,      
 S.S_Section_Name,         
    CM.S_Currency_Name,      
 TID.ReceiptHeaderID,      
AICD.I_Advance_Invoice_Child_Detail_Map_ID,      
TID.I_ERP_TransactionNo,      
TIP.S_Invoice_No,      
RH.Dt_Deposit_Date,      
TID.ReceiptHeaderID,      
TID.S_TransactionMode,      
RH.S_Crtd_By,      
RH.Dt_Upd_On      
        UNION ALL          
        SELECT        
    BM.S_Brand_Name as Brand,      
    SG.S_School_Group_Name as SchoolProgram,      
    ASM.S_Label as AcademicSession,      
    C.S_Class_Name as Class,      
    S.S_Section_Name as Section,      
      
    ----RH.I_Centre_Id ,          
    ----            TCHND.S_Center_Name ,          
    ----            SD.I_Student_Detail_ID ,   
                SD.S_Student_ID StudentID,          
                SD.S_First_Name + ' ' + ISNULL(SD.S_Middle_Name, '') + ' '          
                + SD.S_Last_Name AS StudentName ,          
                FCM.S_Component_Name ComponentName,          
                ISNULL(RCD.N_Amount_Paid, 0.0) AS TotalReceiptAmountPaid_Excl_of_Taxes,          
                SUM(ISNULL(RTD.N_Tax_Paid, 0.0)) AS TaxPaid ,       
    ISNULL(RCD.N_Amount_Paid, 0.0) + SUM(ISNULL(RTD.N_Tax_Paid, 0.0)) AS TotalReceiptAmountPaid_Incl_of_Taxes ,       
    TICD.Dt_Installment_Date InstallmentDueDate,      
    RH.S_Receipt_No ReceiptNo,        
--TM.S_Tax_Desc,          
   DATENAME(m,RH.Dt_Receipt_Date)+CAST(DATEPART(YYYY,RH.Dt_Receipt_Date) AS VARCHAR) AS ReceiptDate ,      
    CM.S_Currency_Name Currency,      
                RH.S_ChequeDD_No "Cheque/DD No",       
    CASE WHEN TID.ReceiptHeaderID IS NULL THEN 'Offline('+PM.S_PaymentMode_Name+')'      
    ELSE 'Online('+TID.S_TransactionMode+')' END "Payment Mode",      
    CASE WHEN AICD.I_Advance_Invoice_Child_Detail_Map_ID IS NULL THEN 'Current'      
    ELSE 'Advance' END "Payment Type",      
    RH.S_Bank_Name "Bank Name",      
    TID.I_ERP_TransactionNo "Transaction Ref no.",      
    TIP.S_Invoice_No As "Invoice No.",      
                RH.Dt_ChequeDD_Date as "Cheque/Draft Date",        
    RH.Dt_Deposit_Date as "Settlement Date",      
    CASE WHEN TID.ReceiptHeaderID IS NULL THEN 'Offline'      
    ELSE 'Online' END "Mode of Payment",      
                --RH.S_Narration ,          
                --PM.S_PaymentMode_Name ,          
                --RH.I_Status ,          
                --RH.Dt_Crtd_On ,       
    RH.S_Crtd_By "Created By",      
                RH.Dt_Upd_On "Cancelled On",          
                              
                RH.S_Cancellation_Reason          
        FROM    T_Receipt_Header RH          
                LEFT JOIN T_Receipt_Component_Detail RCD ON RCD.I_Receipt_Detail_ID = RH.I_Receipt_Header_ID          
                INNER JOIN T_Student_Detail SD ON RH.I_Student_Detail_ID = SD.I_Student_Detail_ID          
                INNER JOIN T_Invoice_Child_Detail ICD ON ICD.I_Invoice_Detail_ID = RCD.I_Invoice_Detail_ID          
                INNER JOIN T_Fee_Component_Master FCM ON FCM.I_Fee_Component_ID = ICD.I_Fee_Component_ID          
                LEFT JOIN T_Receipt_Tax_Detail RTD ON RCD.I_Receipt_Comp_Detail_ID = RTD.I_Receipt_Comp_Detail_ID          
                LEFT JOIN T_Tax_Master TM ON TM.I_Tax_ID = RTD.I_Tax_ID          
                INNER JOIN T_Center_Hierarchy_Name_Details TCHND ON TCHND.I_Center_ID = RH.I_Centre_Id          
                LEFT JOIN T_PaymentMode_Master PM ON PM.I_PaymentMode_ID = RH.I_PaymentMode_ID          
                INNER JOIN dbo.T_Invoice_Child_Detail TICD ON TICD.I_Invoice_Detail_ID = RCD.I_Invoice_Detail_ID       
    INNER JOIN T_Student_Class_Section as SCS on SCS.I_Student_Detail_ID=SD.I_Student_Detail_ID       
    INNER JOIN T_School_Group_Class as SGC on SGC.I_School_Group_Class_ID=SCS.I_School_Group_Class_ID      
    INNER JOIN T_School_Group as SG on SGC.I_School_Group_ID=SG.I_School_Group_ID      
    Inner Join #Courses ct1 on ct1.CourseID=SGC.I_Class_ID      
    INNER JOIN T_School_Academic_Session_Master as ASM on ASM.I_School_Session_ID=SCS.I_School_Session_ID      
    INNER JOIN T_Class as C on C.I_Class_ID=SGC.I_Class_ID      
    INNER JOIN T_Section as S on SCS.I_Section_ID=S.I_Section_ID      
    LEFT JOIN T_Currency_Master as CM on RH.I_Currency_ID=CM.I_Currency_ID      
    LEFT JOIN       
    (      
    select TM.S_TransactionMode,TID.ReceiptHeaderID,TM.I_ERP_TransactionNo from       
    T_ERP_Transaction_Master as TM       
    inner join T_ERP_Transaction_Invoice_Details as TID on TM.I_ERP_Transaction_Master_ID=TID.I_ERP_Transaction_Master_ID      
    where ReceiptHeaderID IS NOT NULL      
    )      
     as TID on TID.ReceiptHeaderID=RH.I_Receipt_Header_ID      
    LEFT JOIN T_Advance_Invoice_Child_Detail_Mapping as AICD on AICD.I_Receipt_Component_Detail_ID=RCD.I_Receipt_Comp_Detail_ID      
    LEFT JOIN T_Invoice_Child_Header as ICH on ICD.I_Invoice_Child_Header_ID=ICH.I_Invoice_Child_Header_ID      
    LEFT JOIN T_Invoice_Parent as TIP on ICH.I_Invoice_Header_ID=TIP.I_Invoice_Header_ID      
      
    CROSS JOIN T_Brand_Master BM      
        WHERE   FCM.I_Brand_ID = @iBrandID and BM.I_Brand_ID=@iBrandID       
    AND SCS.I_School_Session_ID=@SessionID         
    --and SGC.I_Class_ID=@iClassID       
    and SGC.I_School_Group_ID=@iSchoolGroupID      
                AND RH.I_Centre_Id IN (          
                SELECT  CenterList.centerID          
                FROM    dbo.fnGetCentreIdByBrandId(@iBrandID) CenterList )          
                AND DATEDIFF(dd, @startDate, RH.Dt_Upd_On) >= 0          
                AND DATEDIFF(dd, @endDate, RH.Dt_Upd_On) <= 0          
--and RCD.N_Amount_Paid>0.5          
                AND RH.I_Status = 0          
        GROUP BY  RH.I_Centre_Id,      
    TCHND.S_Center_Name,      
    SD.I_Student_Detail_ID,      
    SD.S_Student_ID,      
    SD.S_First_Name + ' ' + ISNULL(SD.S_Middle_Name, '') + ' ' + SD.S_Last_Name,      
    FCM.S_Component_Name,      
    RH.S_Receipt_No,      
    RCD.N_Amount_Paid,      
    DATENAME(m, RH.Dt_Receipt_Date) + CAST(DATEPART(YYYY, RH.Dt_Receipt_Date) AS VARCHAR),      
    RH.S_Bank_Name,      
    RH.S_ChequeDD_No,      
    RH.Dt_ChequeDD_Date,      
    RH.S_Narration,      
    PM.S_PaymentMode_Name,      
    RH.I_Status,      
    RH.Dt_Crtd_On,      
    RH.Dt_Upd_On,      
    TICD.Dt_Installment_Date,      
    RH.S_Cancellation_Reason,      
    BM.S_Brand_Name,      
    SG.S_School_Group_Name,      
    ASM.S_Label,      
 C.S_Class_Name,      
 S.S_Section_Name,        
    CM.S_Currency_Name,      
 TID.ReceiptHeaderID,      
AICD.I_Advance_Invoice_Child_Detail_Map_ID,      
TID.I_ERP_TransactionNo,      
TIP.S_Invoice_No,      
RH.Dt_Deposit_Date,      
TID.ReceiptHeaderID,      
TID.S_TransactionMode,      
RH.S_Crtd_By,      
RH.Dt_Upd_On      
        ORDER BY SD.S_First_Name + ' ' + ISNULL(SD.S_Middle_Name, '') + ' '          
                + SD.S_Last_Name ,          
                S_Receipt_No          
          
          
    END 