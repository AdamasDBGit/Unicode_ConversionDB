CREATE PROCEDURE [REPORT].[uspGetStudentComponentCollection]
(
@date1 DATE,
@date2 DATE,
@iBrandid INT


)
AS
BEGIN

SELECT
BM.S_Brand_Name,
--SBM.S_Batch_Name,
SD.I_Student_Detail_ID,
SD.S_Student_ID,
SD.S_First_Name+' '+SD.S_Last_Name AS "NAME",
FCM.S_Component_Name AS "COMPONENT NAME",
ROUND(RCD.N_Amount_Paid,0.0) AS "AmountPaid",
ROUND(RTD.N_Tax_Paid,0.0) AS "TaxPaid",
TM.S_Tax_Desc AS "TAX_DESC",
RH.Dt_Receipt_Date AS "RECEIPT_DATE",
ICD.I_Installment_No AS "INSTALLMENT_NO",
RH.S_Bank_Name,
RH.S_Branch_Name,
RH.S_ChequeDD_No,
PM.S_PaymentMode_Name,
RH.Dt_ChequeDD_Date

 

FROM

T_Invoice_Parent IP 
inner join T_Invoice_Child_Header ICH		on IP.I_Invoice_Header_ID = ICH.I_Invoice_Header_ID 
inner join T_Invoice_Child_Detail ICD		on ICD.I_Invoice_Child_Header_ID=ICH.I_Invoice_Child_Header_ID
inner join T_Student_Detail SD				on SD.I_Student_Detail_ID = IP.I_Student_Detail_ID
inner join T_Fee_Component_Master FCM		on ICD.I_Fee_Component_ID=FCM.I_Fee_Component_ID
inner join T_Receipt_Component_Detail RCD   on RCD.I_Invoice_Detail_ID=ICD.I_Invoice_Detail_ID 
inner join T_Receipt_Header RH				on RH.I_Receipt_Header_ID=RCD.I_Receipt_Detail_ID
left join T_Receipt_Tax_Detail RTD			on RCD.I_Receipt_Comp_Detail_ID=RTD.I_Receipt_Comp_Detail_ID
left join T_Tax_Master TM					on RTD.I_Tax_ID=TM.I_Tax_ID
inner join T_PaymentMode_Master PM			on PM.I_PaymentMode_ID = RH.I_PaymentMode_ID
--inner join T_Student_Batch_Details SBD		on SD.I_Student_Detail_ID=SBD.I_Student_ID
--inner join T_Student_Batch_Master SBM		on SBM.I_Batch_ID=SBD.I_Batch_ID
inner join T_Brand_Master BM				on BM.I_Brand_ID=FCM.I_Brand_ID
WHERE 
--SD.S_Student_ID like '12%' and
RH.I_Status=1
and FCM.I_Brand_ID=@iBrandid
and RH.Dt_Receipt_Date between @date1 and @date2
and CONVERT(int,ROUND(RCD.N_Amount_Paid,0.0))>0

UNION
 

SELECT 
BM.S_Brand_Name,
--SBM.S_Batch_Name,
SD.I_Student_Detail_ID,
SD.S_Student_ID,
SD.S_First_Name+' '+SD.S_Last_Name AS NAME,
SM.S_Status_Desc AS "COMPONENT NAME",
ROUND(RH.N_Receipt_Amount,0.0) AS "AmountPaid",
ROUND(RH.N_Tax_Amount,0.0) AS "TaxPaid",
'' AS "TAX_DESC",

RH.Dt_Receipt_Date AS "RECEIPT_DATE",
'' AS "INSTALLMENT_NO" ,
RH.S_Bank_Name,
RH.S_Branch_Name,
RH.S_ChequeDD_No,
PM.S_PaymentMode_Name,
RH.Dt_ChequeDD_Date


FROM 
T_Receipt_Header RH
inner join T_Status_Master SM			on SM.I_Status_Value=RH.I_Receipt_Type
inner join T_Student_Detail SD			on RH.I_Student_Detail_ID=SD.I_Student_Detail_ID
inner join T_PaymentMode_Master PM		on PM.I_PaymentMode_ID=RH.I_PaymentMode_ID
--inner join T_Student_Batch_Details SBD  on SBD.I_Batch_ID = SD.I_Student_Detail_ID
--inner join T_Student_Batch_Master SBM   on SBM.I_Batch_ID=SBD.I_Batch_ID
inner join T_Brand_Master BM			on BM.I_Brand_ID=SM.I_Brand_ID
WHERE
S_Status_Type='ReceiptType' and 
RH.I_Receipt_Type<>2
and 
SM.I_Brand_ID=@iBrandid
and RH.I_Status=1
and CONVERT(date,RH.Dt_Receipt_Date) between @date1 and @date2

END
