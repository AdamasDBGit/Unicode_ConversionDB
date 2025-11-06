




CREATE View [dbo].[vw_Student_Fine_Waieve_OFF]
as
Select DISTINCT IVP.I_Invoice_Header_ID,IVP.I_Student_Detail_ID,sd.S_Student_ID
,ivp.S_Invoice_No,fw.I_Invoice_Child_Header_ID,fw.Dt_Installment_Date,fw.Is_Fine_waiveroff,fw.S_Invoice_Number
,fw.Fine_waieve_off_Amt,fw.dt_Finewaiveroff,fw.s_finewaieveoff_remarks
from T_Invoice_Parent ivp
Inner join (
select ICH.I_Invoice_Header_ID, ICH.I_Invoice_Child_Header_ID,Dt_Installment_Date,S_Invoice_Number
,Is_Fine_waiveroff,s_finewaieveoff_remarks
,CONVERT(VARCHAR(10), dt_Finewaiveroff, 120) + ' ' + 
    LEFT(CONVERT(VARCHAR(8), dt_Finewaiveroff, 108), 5) as dt_Finewaiveroff
--,Convert(Date,dt_Finewaiveroff) as dt_Finewaiveroff
,ISNULL(MAX(Fine_waiveroff_Amt),0) as Fine_waieve_off_Amt 
from T_Invoice_Child_Detail ICD
Inner Join T_Invoice_Child_Header ICH ON ICH.I_Invoice_Child_Header_ID=ICD.I_Invoice_Child_Header_ID
where ISNULL(Is_Fine_waiveroff,0)=1
Group by 
ICH.I_Invoice_Header_ID,
ICH.I_Invoice_Child_Header_ID,Dt_Installment_Date,S_Invoice_Number,Is_Fine_waiveroff,dt_Finewaiveroff
,s_finewaieveoff_remarks
) as fw on fw.I_Invoice_Header_ID=ivp.I_Invoice_Header_ID
Inner Join T_Student_Detail SD ON sd.I_Student_Detail_ID=ivp.I_Student_Detail_ID
