CREATE PROCEDURE [ERP_REPORTS].[usp_ERP_GetCollectionRegisterBreakup_OnAccountNew_bak_2125]        
(        
   @sHierarchyList VARCHAR(MAX)=NULL ,        
      @iBrandID INT ,     
   @iSchoolGroupID INT,    
   @iClassID INT,    
      @startDate DATE ,        
      @endDate DATE         
)        
        
AS        
BEGIN        
        
    
 DECLARE @SessionID INT    
    
 select @SessionID=I_School_Session_ID from T_School_Academic_Session_Master where     
 CONVERT(DATE,@startDate) between CONVERT(DATE,Dt_Session_Start_Date) and CONVERT(DATE,Dt_Session_End_Date)     
 and CONVERT(DATE,@endDate) between CONVERT(DATE,Dt_Session_Start_Date) and CONVERT(DATE,Dt_Session_End_Date)     
 and I_Status=1 and I_Brand_ID=@iBrandID    
    
    
    
    
SELECT     
BM.S_Brand_Name Brand,    
ERD.S_Enquiry_No "Enquiry Id",    
SD.S_First_Name+' '+ISNULL(SD.S_Middle_Name,'')+' '+SD.S_Last_Name AS "Student Name",     
SM.S_Status_Desc "Receipt Type",    
RH.S_Receipt_No "Receipt No",    
DATENAME(m,RH.Dt_Receipt_Date)+CAST(DATEPART(YYYY,RH.Dt_Receipt_Date) AS VARCHAR) AS "Receipt Date",      
 RH.S_ChequeDD_No "Cheque/DD No",     
CASE WHEN TID.ReceiptHeaderID IS NULL THEN 'Offline('+PM.S_PaymentMode_Name+')'    
ELSE 'Online('+TID.S_TransactionMode+')' END "Payment Mode",    
CASE WHEN receipt.I_Receipt_Header_ID IS NULL THEN 'Current'    
    ELSE 'Advance' END "Payment Type",    
    
RH.S_Bank_Name "Bank Name",    
TID.I_ERP_TransactionNo "Transaction Ref no.",    
TIP.S_Invoice_No As "Invoice No.",    
RH.S_Narration Remarks    
    
    
    
--RH.I_Centre_Id,        
--TCHND.S_Center_Name,        
--SD.I_Student_Detail_ID,        
--SD.S_Student_ID,        
--SD.S_First_Name+' '+ISNULL(SD.S_Middle_Name,'')+' '+SD.S_Last_Name AS NAME,        
--SM.S_Status_Desc,        
--RH.S_Receipt_No,        
--RH.N_Receipt_Amount,        
--RH.N_Tax_Amount,        
--DATENAME(m,RH.Dt_Receipt_Date)+CAST(DATEPART(YYYY,RH.Dt_Receipt_Date) AS VARCHAR) AS ReceiptDate,        
--RH.S_Bank_Name,        
--RH.S_ChequeDD_No,        
--RH.Dt_ChequeDD_Date,        
--PM.S_PaymentMode_Name,        
--RH.S_Narration,        
--RH.I_Status,        
--RH.Dt_Crtd_On,        
--RH.Dt_Upd_On        
FROM         
T_Receipt_Header RH        
left join T_Status_Master SM   on SM.I_Status_Value=RH.I_Receipt_Type        
inner join T_Student_Detail SD   on RH.I_Student_Detail_ID=SD.I_Student_Detail_ID        
inner join T_Center_Hierarchy_Name_Details  TCHND on TCHND.I_Center_Id=RH.I_Centre_Id        
inner join T_PaymentMode_Master PM  on PM.I_PaymentMode_ID=RH.I_PaymentMode_ID       
inner join T_Enquiry_Regn_Detail as ERD on SD.I_Enquiry_Regn_ID=ERD.I_Enquiry_Regn_ID    
LEFT JOIN     
    (    
    select TM.S_TransactionMode,TID.ReceiptHeaderID,TM.I_ERP_TransactionNo from     
    T_ERP_Transaction_Master as TM     
    inner join T_ERP_Transaction_Invoice_Details as TID on TM.I_ERP_Transaction_Master_ID=TID.I_ERP_Transaction_Master_ID    
    where ReceiptHeaderID IS NOT NULL    
    )    
     as TID on TID.ReceiptHeaderID=RH.I_Receipt_Header_ID    
LEFT JOIN     
(select RH.I_Receipt_Header_ID  from  T_Receipt_Header RH        
inner JOIN T_Receipt_Component_Detail RCD ON RCD.I_Receipt_Detail_ID = RH.I_Receipt_Header_ID     
inner join T_Advance_Invoice_Child_Detail_Mapping as AICD on AICD.I_Receipt_Component_Detail_ID=RCD.I_Receipt_Comp_Detail_ID    
) as receipt on receipt.I_Receipt_Header_ID=RH.I_Receipt_Header_ID    
LEFT JOIN T_Invoice_Parent as TIP on RH.I_Invoice_Header_ID=TIP.I_Invoice_Header_ID    
CROSS JOIN T_Brand_Master BM    
WHERE        
S_Status_Type='ReceiptType'         
and RH.I_Receipt_Type<>2        
and SM.I_Brand_ID=@iBrandID        
AND RH.I_Centre_Id IN (SELECT CenterList.centerID       
FROM dbo.fnGetCentreIdByBrandId(@iBrandID) CenterList)        
and DATEDIFF(dd,@startDate,Dt_Receipt_Date)>=0 and DATEDIFF(dd,@endDate,Dt_Receipt_Date)<=0        
and BM.I_Brand_ID=@iBrandID        
        
UNION ALL        
        
SELECT     
BM.S_Brand_Name Brand,    
ERD.S_Enquiry_No "Enquiry Id",    
SD.S_First_Name+' '+ISNULL(SD.S_Middle_Name,'')+' '+SD.S_Last_Name AS "Student Name",     
SM.S_Status_Desc "Receipt Type",    
RH.S_Receipt_No "Receipt No",    
DATENAME(m,RH.Dt_Receipt_Date)+CAST(DATEPART(YYYY,RH.Dt_Receipt_Date) AS VARCHAR) AS "Receipt Date",      
 RH.S_ChequeDD_No "Cheque/DD No",     
CASE WHEN TID.ReceiptHeaderID IS NULL THEN 'Offline('+PM.S_PaymentMode_Name+')'    
ELSE 'Online('+TID.S_TransactionMode+')' END "Payment Mode",    
CASE WHEN receipt.I_Receipt_Header_ID IS NULL THEN 'Current'    
    ELSE 'Advance' END "Payment Type",    
    
RH.S_Bank_Name "Bank Name",    
TID.I_ERP_TransactionNo "Transaction Ref no.",    
TIP.S_Invoice_No As "Invoice No.",    
RH.S_Narration Remarks    
    
    
    
--RH.I_Centre_Id,        
--TCHND.S_Center_Name,        
--SD.I_Student_Detail_ID,        
--SD.S_Student_ID,        
--SD.S_First_Name+' '+ISNULL(SD.S_Middle_Name,'')+' '+SD.S_Last_Name AS NAME,        
--SM.S_Status_Desc,        
--RH.S_Receipt_No,        
---RH.N_Receipt_Amount,        
---RH.N_Tax_Amount,        
--DATENAME(m,RH.Dt_Receipt_Date)+CAST(DATEPART(YYYY,RH.Dt_Receipt_Date) AS VARCHAR) AS ReceiptDate,        
--RH.S_Bank_Name,        
--RH.S_ChequeDD_No,        
--RH.Dt_ChequeDD_Date,        
--PM.S_PaymentMode_Name,        
--RH.S_Narration,        
--RH.I_Status,        
--RH.Dt_Crtd_On,        
--RH.Dt_Upd_On        
FROM         
T_Receipt_Header RH        
left join T_Status_Master SM   on SM.I_Status_Value=RH.I_Receipt_Type        
inner join T_Student_Detail SD   on RH.I_Student_Detail_ID=SD.I_Student_Detail_ID        
inner join T_Center_Hierarchy_Name_Details  TCHND on TCHND.I_Center_Id=RH.I_Centre_Id        
inner join T_PaymentMode_Master PM  on PM.I_PaymentMode_ID=RH.I_PaymentMode_ID      
inner join T_Enquiry_Regn_Detail as ERD on SD.I_Enquiry_Regn_ID=ERD.I_Enquiry_Regn_ID    
LEFT JOIN     
    (    
    select TM.S_TransactionMode,TID.ReceiptHeaderID,TM.I_ERP_TransactionNo from     
    T_ERP_Transaction_Master as TM     
    inner join T_ERP_Transaction_Invoice_Details as TID on TM.I_ERP_Transaction_Master_ID=TID.I_ERP_Transaction_Master_ID    
    where ReceiptHeaderID IS NOT NULL    
    )    
     as TID on TID.ReceiptHeaderID=RH.I_Receipt_Header_ID    
LEFT JOIN     
(select RH.I_Receipt_Header_ID  from  T_Receipt_Header RH        
inner JOIN T_Receipt_Component_Detail RCD ON RCD.I_Receipt_Detail_ID = RH.I_Receipt_Header_ID     
inner join T_Advance_Invoice_Child_Detail_Mapping as AICD on AICD.I_Receipt_Component_Detail_ID=RCD.I_Receipt_Comp_Detail_ID    
) as receipt on receipt.I_Receipt_Header_ID=RH.I_Receipt_Header_ID    
LEFT JOIN T_Invoice_Parent as TIP on RH.I_Invoice_Header_ID=TIP.I_Invoice_Header_ID    
CROSS JOIN T_Brand_Master BM    
WHERE        
S_Status_Type='ReceiptType'         
and RH.I_Receipt_Type<>2        
and SM.I_Brand_ID=@iBrandID        
and RH.I_Status=0        
AND RH.I_Centre_Id IN (SELECT CenterList.centerID       
FROM dbo.fnGetCentreIdByBrandId(@iBrandID) CenterList)        
and DATEDIFF(dd,@startDate,RH.Dt_Upd_On)>=0 and DATEDIFF(dd,@endDate,RH.Dt_Upd_On)<=0     
and BM.I_Brand_ID=@iBrandID     
        
UNION ALL        
        
SELECT     
BM.S_Brand_Name Brand,    
TERD.S_Enquiry_No "Enquiry Id",    
TERD.S_First_Name+' '+ISNULL(TERD.S_Middle_Name,'')+' '+TERD.S_Last_Name AS Student_Name,     
SM.S_Status_Desc "Receipt Type",    
RH.S_Receipt_No "Receipt No",    
DATENAME(m,RH.Dt_Receipt_Date)+CAST(DATEPART(YYYY,RH.Dt_Receipt_Date) AS VARCHAR) AS "Receipt Date",      
 RH.S_ChequeDD_No "Cheque/DD No",     
CASE WHEN TID.ReceiptHeaderID IS NULL THEN 'Offline('+PM.S_PaymentMode_Name+')'    
ELSE 'Online('+TID.S_TransactionMode+')' END "Payment Mode",    
CASE WHEN receipt.I_Receipt_Header_ID IS NULL THEN 'Current'    
    ELSE 'Advance' END "Payment Type",    
    
RH.S_Bank_Name "Bank Name",    
TID.I_ERP_TransactionNo "Transaction Ref no.",    
TIP.S_Invoice_No As "Invoice No.",    
RH.S_Narration Remarks    
    
    
    
    
    
--RH.I_Centre_Id,        
--TCHND.S_Center_Name,        
--TERD.I_Enquiry_Regn_ID,        
--NULL,        
--TERD.S_First_Name+' '+ISNULL(TERD.S_Middle_Name,'')+' '+TERD.S_Last_Name AS NAME,        
--SM.S_Status_Desc,        
--RH.S_Receipt_No,        
--RH.N_Receipt_Amount,        
--RH.N_Tax_Amount,        
--DATENAME(m,RH.Dt_Receipt_Date)+CAST(DATEPART(YYYY,RH.Dt_Receipt_Date) AS VARCHAR) AS ReceiptDate,        
--RH.S_Bank_Name,        
--RH.S_ChequeDD_No,        
--RH.Dt_ChequeDD_Date,        
--PM.S_PaymentMode_Name,        
--RH.S_Narration,        
--RH.I_Status,        
--RH.Dt_Crtd_On,        
--RH.Dt_Upd_On        
FROM         
T_Receipt_Header RH        
left join T_Status_Master SM   on SM.I_Status_Value=RH.I_Receipt_Type        
inner join dbo.T_Enquiry_Regn_Detail TERD   on RH.I_Enquiry_Regn_ID=TERD.I_Enquiry_Regn_ID        
inner join T_Center_Hierarchy_Name_Details  TCHND on TCHND.I_Center_Id=RH.I_Centre_Id        
inner join T_PaymentMode_Master PM  on PM.I_PaymentMode_ID=RH.I_PaymentMode_ID    
LEFT JOIN     
    (    
    select TM.S_TransactionMode,TID.ReceiptHeaderID,TM.I_ERP_TransactionNo from     
    T_ERP_Transaction_Master as TM     
    inner join T_ERP_Transaction_Invoice_Details as TID on TM.I_ERP_Transaction_Master_ID=TID.I_ERP_Transaction_Master_ID    
    where ReceiptHeaderID IS NOT NULL    
    )    
     as TID on TID.ReceiptHeaderID=RH.I_Receipt_Header_ID    
LEFT JOIN     
(select RH.I_Receipt_Header_ID  from  T_Receipt_Header RH        
inner JOIN T_Receipt_Component_Detail RCD ON RCD.I_Receipt_Detail_ID = RH.I_Receipt_Header_ID     
inner join T_Advance_Invoice_Child_Detail_Mapping as AICD on AICD.I_Receipt_Component_Detail_ID=RCD.I_Receipt_Comp_Detail_ID    
) as receipt on receipt.I_Receipt_Header_ID=RH.I_Receipt_Header_ID    
LEFT JOIN T_Invoice_Parent as TIP on RH.I_Invoice_Header_ID=TIP.I_Invoice_Header_ID    
CROSS JOIN T_Brand_Master BM    
        
WHERE        
S_Status_Type='ReceiptType'         
and RH.I_Receipt_Type<>2        
and SM.I_Brand_ID=@iBrandID        
AND RH.I_Centre_Id IN (SELECT CenterList.centerID       
FROM dbo.fnGetCentreIdByBrandId(@iBrandID) CenterList)        
and DATEDIFF(dd,@startDate,Dt_Receipt_Date)>=0 and DATEDIFF(dd,@endDate,Dt_Receipt_Date)<=0        
and BM.I_Brand_ID=@iBrandID         
        
UNION ALL        
        
SELECT      
BM.S_Brand_Name Brand,    
TERD.S_Enquiry_No "Enquiry Id",    
TERD.S_First_Name+' '+ISNULL(TERD.S_Middle_Name,'')+' '+TERD.S_Last_Name AS Student_Name,     
SM.S_Status_Desc "Receipt Type",    
RH.S_Receipt_No "Receipt No",    
DATENAME(m,RH.Dt_Receipt_Date)+CAST(DATEPART(YYYY,RH.Dt_Receipt_Date) AS VARCHAR) AS "Receipt Date",      
 RH.S_ChequeDD_No "Cheque/DD No",     
CASE WHEN TID.ReceiptHeaderID IS NULL THEN 'Offline('+PM.S_PaymentMode_Name+')'    
ELSE 'Online('+TID.S_TransactionMode+')' END "Payment Mode",    
CASE WHEN receipt.I_Receipt_Header_ID IS NULL THEN 'Current'    
    ELSE 'Advance' END "Payment Type",    
    
RH.S_Bank_Name "Bank Name",    
TID.I_ERP_TransactionNo "Transaction Ref no.",    
TIP.S_Invoice_No As "Invoice No.",    
RH.S_Narration Remarks    
    
    
    
    
--RH.I_Centre_Id,        
--TCHND.S_Center_Name,        
--TERD.I_Enquiry_Regn_ID,        
--NULL,        
--TERD.S_First_Name+' '+ISNULL(TERD.S_Middle_Name,'')+' '+TERD.S_Last_Name AS NAME,        
--SM.S_Status_Desc,        
--RH.S_Receipt_No,        
---RH.N_Receipt_Amount,        
---RH.N_Tax_Amount,        
--DATENAME(m,RH.Dt_Receipt_Date)+CAST(DATEPART(YYYY,RH.Dt_Receipt_Date) AS VARCHAR) AS ReceiptDate,        
--RH.S_Bank_Name,        
--RH.S_ChequeDD_No,        
--RH.Dt_ChequeDD_Date,        
--PM.S_PaymentMode_Name,        
--RH.S_Narration,        
--RH.I_Status,        
--RH.Dt_Crtd_On,        
--RH.Dt_Upd_On        
FROM         
T_Receipt_Header RH        
left join T_Status_Master SM   on SM.I_Status_Value=RH.I_Receipt_Type        
inner join dbo.T_Enquiry_Regn_Detail TERD ON TERD.I_Enquiry_Regn_ID=RH.I_Enquiry_Regn_ID        
inner join T_Center_Hierarchy_Name_Details  TCHND on TCHND.I_Center_Id=RH.I_Centre_Id        
inner join T_PaymentMode_Master PM  on PM.I_PaymentMode_ID=RH.I_PaymentMode_ID     
LEFT JOIN     
    (    
    select TM.S_TransactionMode,TID.ReceiptHeaderID,TM.I_ERP_TransactionNo from     
    T_ERP_Transaction_Master as TM     
    inner join T_ERP_Transaction_Invoice_Details as TID on TM.I_ERP_Transaction_Master_ID=TID.I_ERP_Transaction_Master_ID    
    where ReceiptHeaderID IS NOT NULL    
    )    
     as TID on TID.ReceiptHeaderID=RH.I_Receipt_Header_ID    
LEFT JOIN     
(select RH.I_Receipt_Header_ID  from  T_Receipt_Header RH        
inner JOIN T_Receipt_Component_Detail RCD ON RCD.I_Receipt_Detail_ID = RH.I_Receipt_Header_ID     
inner join T_Advance_Invoice_Child_Detail_Mapping as AICD on AICD.I_Receipt_Component_Detail_ID=RCD.I_Receipt_Comp_Detail_ID    
) as receipt on receipt.I_Receipt_Header_ID=RH.I_Receipt_Header_ID    
LEFT JOIN T_Invoice_Parent as TIP on RH.I_Invoice_Header_ID=TIP.I_Invoice_Header_ID    
CROSS JOIN T_Brand_Master BM    
    
WHERE        
S_Status_Type='ReceiptType'         
and RH.I_Receipt_Type<>2        
and SM.I_Brand_ID=@iBrandID        
and RH.I_Status=0        
AND RH.I_Centre_Id IN (SELECT CenterList.centerID       
FROM dbo.fnGetCentreIdByBrandId(@iBrandID) CenterList)        
and DATEDIFF(dd,@startDate,RH.Dt_Upd_On)>=0 and DATEDIFF(dd,@endDate,RH.Dt_Upd_On)<=0        
and BM.I_Brand_ID=@iBrandID         
        
Order by        
--RH.I_Status,        
--RH.Dt_Crtd_On,        
SD.S_First_Name+' '+ISNULL(SD.S_Middle_Name,'')+' '+SD.S_Last_Name,        
RH.S_Receipt_No        
        
END 