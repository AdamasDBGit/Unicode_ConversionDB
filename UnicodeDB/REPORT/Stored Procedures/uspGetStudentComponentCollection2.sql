CREATE PROCEDURE [REPORT].[uspGetStudentComponentCollection2]
(
@date1 DATE,
@date2 DATE,
@iBrandid INT


)
AS
BEGIN

SELECT 
Invoice_Collection.I_Student_Detail_ID,
Invoice_Collection.S_Student_ID,
Invoice_Collection.NAME,
Invoice_Collection.S_Component_Name,
Invoice_Collection.AmountPaid,
Invoice_Collection.TaxPaid,
Invoice_Collection.S_Tax_Desc,


Invoice_Collection.Dt_Receipt_Date,
Invoice_Collection.I_Installment_No ,
OnAccount_Collection.S_Status_Desc,
OnAccount_Collection.N_Receipt_Amount,
OnAccount_Collection.Dt_Receipt_Date
  

FROM
(
SELECT
--RH.I_Receipt_Type ,
SD.I_Student_Detail_ID,
SD.S_Student_ID,
LTRIM(SD.S_First_Name+' '+SD.S_Last_Name) AS NAME,
FCM.S_Component_Name,
ROUND(RCD.N_Amount_Paid,0.0) AS AmountPaid,
ROUND(RTD.N_Tax_Paid,0.0) AS TaxPaid,
TM.S_Tax_Desc,


RH.Dt_Receipt_Date,
ICD.I_Installment_No 

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

WHERE 
--SD.S_Student_ID like '12%' and
RH.I_Status=1
and FCM.I_Brand_ID=107
and RH.Dt_Receipt_Date between @date1 and @date2
and CONVERT(int,ROUND(RCD.N_Amount_Paid,0.0))>0

 
)AS Invoice_Collection

LEFT OUTER JOIN 
(
SELECT 
SD.I_Student_Detail_ID,
SD.S_Student_ID,SD.S_First_Name+' '+SD.S_Last_Name AS NAME,
SM.S_Status_Desc,
RH.N_Receipt_Amount,
RH.Dt_Receipt_Date,
RH.S_Narration 
FROM 
T_Receipt_Header RH
inner join T_Status_Master SM			on SM.I_Status_Value=RH.I_Receipt_Type
inner join T_Student_Detail SD			on RH.I_Student_Detail_ID=SD.I_Student_Detail_ID

WHERE
S_Status_Type='ReceiptType' 
and RH.I_Receipt_Type<>2
and I_Brand_ID=107
and RH.I_Status=1
and RH.Dt_Receipt_Date between @date1 and @date2
)
AS OnAccount_Collection

on Invoice_Collection.I_Student_Detail_ID = OnAccount_Collection.I_Student_Detail_ID
and CONVERT(date,Invoice_Collection.Dt_Receipt_Date)=CONVERT(date,OnAccount_Collection.Dt_Receipt_Date)

ORDER BY 
 
Invoice_Collection.S_Student_ID,
Invoice_Collection.Dt_Receipt_Date,
Invoice_Collection.I_Installment_No,
Invoice_Collection.S_Component_Name
 END
