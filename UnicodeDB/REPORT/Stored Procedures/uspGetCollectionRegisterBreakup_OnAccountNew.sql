CREATE PROCEDURE [REPORT].[uspGetCollectionRegisterBreakup_OnAccountNew]
(
@sHierarchyList VARCHAR(MAX),
@iBrandID INT,
@startDate DATE,
@endDate DATE
)

AS
BEGIN

SELECT 
RH.I_Centre_Id,
TCHND.S_Center_Name,
SD.I_Student_Detail_ID,
SD.S_Student_ID,
SD.S_First_Name+' '+ISNULL(SD.S_Middle_Name,'')+' '+SD.S_Last_Name AS NAME,
SM.S_Status_Desc,
RH.S_Receipt_No,
RH.N_Receipt_Amount,
RH.N_Tax_Amount,
DATENAME(m,RH.Dt_Receipt_Date)+CAST(DATEPART(YYYY,RH.Dt_Receipt_Date) AS VARCHAR) AS ReceiptDate,
RH.S_Bank_Name,
RH.S_ChequeDD_No,
RH.Dt_ChequeDD_Date,
PM.S_PaymentMode_Name,
RH.S_Narration,
RH.I_Status,
RH.Dt_Crtd_On,
RH.Dt_Upd_On
FROM 
T_Receipt_Header RH
left join T_Status_Master SM			on SM.I_Status_Value=RH.I_Receipt_Type
inner join T_Student_Detail SD			on RH.I_Student_Detail_ID=SD.I_Student_Detail_ID
inner join T_Center_Hierarchy_Name_Details  TCHND	on TCHND.I_Center_Id=RH.I_Centre_Id
inner join T_PaymentMode_Master PM		on PM.I_PaymentMode_ID=RH.I_PaymentMode_ID

WHERE
S_Status_Type='ReceiptType' 
and RH.I_Receipt_Type<>2
and SM.I_Brand_ID=@iBrandID
AND RH.I_Centre_Id IN (SELECT CenterList.centerID FROM dbo.fnGetCentersForReports(@sHierarchyList, CAST(@iBrandID AS INT)) CenterList)
and DATEDIFF(dd,@startDate,Dt_Receipt_Date)>=0 and DATEDIFF(dd,@endDate,Dt_Receipt_Date)<=0


UNION ALL

SELECT 
RH.I_Centre_Id,
TCHND.S_Center_Name,
SD.I_Student_Detail_ID,
SD.S_Student_ID,
SD.S_First_Name+' '+ISNULL(SD.S_Middle_Name,'')+' '+SD.S_Last_Name AS NAME,
SM.S_Status_Desc,
RH.S_Receipt_No,
-RH.N_Receipt_Amount,
-RH.N_Tax_Amount,
DATENAME(m,RH.Dt_Receipt_Date)+CAST(DATEPART(YYYY,RH.Dt_Receipt_Date) AS VARCHAR) AS ReceiptDate,
RH.S_Bank_Name,
RH.S_ChequeDD_No,
RH.Dt_ChequeDD_Date,
PM.S_PaymentMode_Name,
RH.S_Narration,
RH.I_Status,
RH.Dt_Crtd_On,
RH.Dt_Upd_On
FROM 
T_Receipt_Header RH
left join T_Status_Master SM			on SM.I_Status_Value=RH.I_Receipt_Type
inner join T_Student_Detail SD			on RH.I_Student_Detail_ID=SD.I_Student_Detail_ID
inner join T_Center_Hierarchy_Name_Details  TCHND	on TCHND.I_Center_Id=RH.I_Centre_Id
inner join T_PaymentMode_Master PM		on PM.I_PaymentMode_ID=RH.I_PaymentMode_ID
WHERE
S_Status_Type='ReceiptType' 
and RH.I_Receipt_Type<>2
and SM.I_Brand_ID=@iBrandID
and RH.I_Status=0
AND RH.I_Centre_Id IN (SELECT CenterList.centerID FROM dbo.fnGetCentersForReports(@sHierarchyList, CAST(@iBrandID AS INT)) CenterList)
and DATEDIFF(dd,@startDate,RH.Dt_Upd_On)>=0 and DATEDIFF(dd,@endDate,RH.Dt_Upd_On)<=0

UNION ALL

SELECT 
RH.I_Centre_Id,
TCHND.S_Center_Name,
TERD.I_Enquiry_Regn_ID,
NULL,
TERD.S_First_Name+' '+ISNULL(TERD.S_Middle_Name,'')+' '+TERD.S_Last_Name AS NAME,
SM.S_Status_Desc,
RH.S_Receipt_No,
RH.N_Receipt_Amount,
RH.N_Tax_Amount,
DATENAME(m,RH.Dt_Receipt_Date)+CAST(DATEPART(YYYY,RH.Dt_Receipt_Date) AS VARCHAR) AS ReceiptDate,
RH.S_Bank_Name,
RH.S_ChequeDD_No,
RH.Dt_ChequeDD_Date,
PM.S_PaymentMode_Name,
RH.S_Narration,
RH.I_Status,
RH.Dt_Crtd_On,
RH.Dt_Upd_On
FROM 
T_Receipt_Header RH
left join T_Status_Master SM			on SM.I_Status_Value=RH.I_Receipt_Type
inner join dbo.T_Enquiry_Regn_Detail TERD			on RH.I_Enquiry_Regn_ID=TERD.I_Enquiry_Regn_ID
inner join T_Center_Hierarchy_Name_Details  TCHND	on TCHND.I_Center_Id=RH.I_Centre_Id
inner join T_PaymentMode_Master PM		on PM.I_PaymentMode_ID=RH.I_PaymentMode_ID

WHERE
S_Status_Type='ReceiptType' 
and RH.I_Receipt_Type<>2
and SM.I_Brand_ID=@iBrandID
AND RH.I_Centre_Id IN (SELECT CenterList.centerID FROM dbo.fnGetCentersForReports(@sHierarchyList, CAST(@iBrandID AS INT)) CenterList)
and DATEDIFF(dd,@startDate,Dt_Receipt_Date)>=0 and DATEDIFF(dd,@endDate,Dt_Receipt_Date)<=0


UNION ALL

SELECT 
RH.I_Centre_Id,
TCHND.S_Center_Name,
TERD.I_Enquiry_Regn_ID,
NULL,
TERD.S_First_Name+' '+ISNULL(TERD.S_Middle_Name,'')+' '+TERD.S_Last_Name AS NAME,
SM.S_Status_Desc,
RH.S_Receipt_No,
-RH.N_Receipt_Amount,
-RH.N_Tax_Amount,
DATENAME(m,RH.Dt_Receipt_Date)+CAST(DATEPART(YYYY,RH.Dt_Receipt_Date) AS VARCHAR) AS ReceiptDate,
RH.S_Bank_Name,
RH.S_ChequeDD_No,
RH.Dt_ChequeDD_Date,
PM.S_PaymentMode_Name,
RH.S_Narration,
RH.I_Status,
RH.Dt_Crtd_On,
RH.Dt_Upd_On
FROM 
T_Receipt_Header RH
left join T_Status_Master SM			on SM.I_Status_Value=RH.I_Receipt_Type
inner join dbo.T_Enquiry_Regn_Detail TERD ON TERD.I_Enquiry_Regn_ID=RH.I_Enquiry_Regn_ID
inner join T_Center_Hierarchy_Name_Details  TCHND	on TCHND.I_Center_Id=RH.I_Centre_Id
inner join T_PaymentMode_Master PM		on PM.I_PaymentMode_ID=RH.I_PaymentMode_ID
WHERE
S_Status_Type='ReceiptType' 
and RH.I_Receipt_Type<>2
and SM.I_Brand_ID=@iBrandID
and RH.I_Status=0
AND RH.I_Centre_Id IN (SELECT CenterList.centerID FROM dbo.fnGetCentersForReports(@sHierarchyList, CAST(@iBrandID AS INT)) CenterList)
and DATEDIFF(dd,@startDate,RH.Dt_Upd_On)>=0 and DATEDIFF(dd,@endDate,RH.Dt_Upd_On)<=0


Order by
--RH.I_Status,
--RH.Dt_Crtd_On,
SD.S_First_Name+' '+ISNULL(SD.S_Middle_Name,'')+' '+SD.S_Last_Name,
RH.S_Receipt_No

END
