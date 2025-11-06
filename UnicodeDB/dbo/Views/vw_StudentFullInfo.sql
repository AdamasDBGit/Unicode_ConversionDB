CREATE View  vw_StudentFullInfo
as
select distinct top 1000 Bm.i_brand_ID,BM.S_Brand_Name,BM.S_Brand_Code, asm.I_School_Session_ID,asm.S_Label,ERD.I_Enquiry_Regn_ID ,ERD.S_Enquiry_No,sd.I_Student_Detail_ID
,sd.S_Student_ID 
,Concat(SD.S_First_Name ,' ',SD.S_Middle_Name,' ',sd.S_Last_Name) as StudentName
,sg.I_School_Group_ID
,sg.S_School_Group_Name,tc.I_Class_ID,tc.S_Class_Name,ts.I_Section_ID,TS.S_Section_Name,strr.I_Stream_ID,STRR.S_Stream
,sd.S_Age,sd.Dt_Birth_Date,sd.S_Email_ID,sd.S_Mobile_No
,Max(Case When PM.I_Relation_ID=1 Then Concat(PM.S_First_Name,' ',PM.S_Middile_Name,' ',PM.S_Last_Name) End) As FatherName,           
Max(Case When PM.I_Relation_ID=1 Then PM.I_Parent_Master_ID End) As Father_Parent_Master_ID           
          
,Max(Case When PM.I_Relation_ID=1 Then PM.S_Mobile_No End) As FatherContactNumber           
,Max(Case When PM.I_Relation_ID=2 Then Concat(PM.S_First_Name,' ',PM.S_Middile_Name,' ',PM.S_Last_Name) End) As Mothername           
,Max(Case When PM.I_Relation_ID=2 Then PM.I_Parent_Master_ID End) As Mother_Parent_Master_ID,           
          
 Max(Case When PM.I_Relation_ID=2 Then PM.S_Mobile_No End) As MotherContactNumber   
,Erd.I_Curr_Country_ID
,currCM.S_Country_Name ,currsm.I_State_ID as CurrentStateID,currsm.S_State_Name as CurrentStatename,currct.I_City_ID as CurrCityID
,currct.S_City_Name as Currentcityname,
 prmsm.I_State_ID as PermStateID,PrmSm.S_State_Name as Perm_Statename,permct.I_City_ID as PermCityID,permct.S_City_Name as Perm_CityName
 ,TIP.I_Invoice_Header_ID,TIP.S_Invoice_No ,TIP.N_Invoice_Amount as Invoice_Amount,Rh.N_Receipt_Amount as RegistrationFee,adh.I_Status_Value as ProspectusID
 --,adhf.I_Status_Value as FineID,Rh.N_Receipt_Amount as FineAmount
 ,fs.I_Fee_Structure_ID,fs.S_Fee_Structure_Name
from T_Enquiry_Regn_Detail ERD 
Inner Join T_Brand_Center_Details BCD on Bcd.I_Centre_Id=Erd.I_Centre_Id and BCD.I_Status=1
Inner Join T_Brand_Master BM on BM.I_Brand_ID=BCD.I_Brand_ID and BM.I_Status=1
Inner Join T_School_Academic_Session_Master ASM ON asm.I_Brand_ID=BM.I_Brand_ID and asm.I_Status=1
and year(asm.Dt_Session_Start_Date)=Year(getdate())
Left Join T_Student_Detail SD on SD.I_Enquiry_Regn_ID=ERD.I_Enquiry_Regn_ID and SD.I_Status=1
Left Join T_Student_Class_Section SCS on scs.I_Brand_ID=bm.I_Brand_ID 
and scs.I_Student_Detail_ID=sd.I_Student_Detail_ID and scs.I_Status=1 
and scs.I_School_Session_ID=asm.I_School_Session_ID
Left Join T_School_Group_Class SGC ON sgc.I_School_Group_Class_ID=scs.I_School_Group_Class_ID 
and sgc.I_Status=1
Inner Join T_School_Group SG ON sg.I_School_Group_ID=sgc.I_School_Group_ID and SG.I_Status=1
and sg.I_Brand_Id=Bm.I_Brand_ID
Inner Join T_Class TC on tc.I_Class_ID =sgc.I_Class_ID and tc.I_Status=1 and tc.I_Brand_ID=bm.I_Brand_ID
Left Join T_Country_Master currCM on currcm.I_Country_ID=erd.I_Curr_Country_ID and currcm.I_Status=1
Left Join T_State_Master currSM on currSM.I_State_ID=Erd.I_Curr_State_ID and currsm.I_Status=1
Left Join T_State_Master PrmSm on prmsm.I_State_ID=ERD.I_Perm_State_ID and prmsm.I_Status=1
Left Join T_City_Master currct on currct.I_City_ID=ERD.I_Curr_City_ID and currct.I_Status=1
Left Join T_City_Master permct on permct.I_City_ID=ERD.I_Perm_City_ID and currct.I_Status=1
Left Join T_Section TS ON ts.I_Section_ID=Scs.I_Section_ID 
Left Join T_Stream STRR On STRR.I_Stream_ID=scs.I_Stream_ID and strr.I_brand_id=bm.I_Brand_ID and strr.I_Status=1
Left Join T_Invoice_Parent TIP ON TIP.I_Student_Detail_ID =SD.I_Student_Detail_ID and TIP.I_Status=1
and TIP.I_Centre_Id=ERD.I_Centre_Id
Left Join T_ERP_Stud_Fee_Struct_Comp_Mapping SCM on scm.R_I_Enquiry_Regn_ID=erd.I_Enquiry_Regn_ID
and scm.I_Brand_ID=bm.I_Brand_ID
Left Join T_ERP_Fee_Structure FS On fs.I_Fee_Structure_ID=scm.R_I_Fee_Structure_ID and fs.Is_Active=1
Left Join T_Receipt_Header RH on Rh.I_Enquiry_Regn_ID=ERd.I_Enquiry_Regn_ID and rh.I_Centre_Id=ERd.I_Centre_Id

Left Join T_Status_Master as Adh on adh.I_Status_Value=rh.I_Receipt_Type and adh.Status_Type=1 and adh.I_Brand_ID=Bm.I_Brand_ID
--Left Join T_Status_Master as Adhf on Adhf.I_Status_Value=rh.I_Receipt_Type and adh.Status_Type=2 and adhf.I_Brand_ID=bm.I_Brand_ID
--and adh.Is_active=1 and rh.I_Receipt_Type<>2  and rh.I_Receipt_Type is not null
   Left Join T_Student_Parent_Maps SPM on SPM.I_Student_Detail_ID=sd.I_Student_Detail_ID          
   Inner Join T_Parent_Master PM on PM.I_Parent_Master_ID=SPM.I_Parent_Master_ID          

 where
 --sd.S_Student_ID='24-0047' and

 adh.Is_active=1 and rh.I_Receipt_Type<>2  and rh.I_Receipt_Type is not null
 --and adhf.Is_active=1
 Group by 
 Bm.i_brand_ID,BM.S_Brand_Name,BM.S_Brand_Code, asm.I_School_Session_ID,asm.S_Label,ERD.I_Enquiry_Regn_ID ,ERD.S_Enquiry_No,sd.I_Student_Detail_ID
,sd.S_Student_ID 
,Concat(SD.S_First_Name ,' ',SD.S_Middle_Name,' ',sd.S_Last_Name) 
,sg.I_School_Group_ID
,sg.S_School_Group_Name,tc.I_Class_ID,tc.S_Class_Name,ts.I_Section_ID,TS.S_Section_Name,strr.I_Stream_ID,STRR.S_Stream
,sd.S_Age,sd.Dt_Birth_Date,sd.S_Email_ID,sd.S_Mobile_No

,Erd.I_Curr_Country_ID
,currCM.S_Country_Name ,currsm.I_State_ID ,currsm.S_State_Name ,currct.I_City_ID 
,currct.S_City_Name ,
 prmsm.I_State_ID ,PrmSm.S_State_Name ,permct.I_City_ID ,permct.S_City_Name 
 ,TIP.I_Invoice_Header_ID,TIP.S_Invoice_No ,TIP.N_Invoice_Amount ,Rh.N_Receipt_Amount ,adh.I_Status_Value 
 --,adhf.I_Status_Value as FineID,Rh.N_Receipt_Amount as FineAmount
 ,fs.I_Fee_Structure_ID,fs.S_Fee_Structure_Name
Order by BM.I_Brand_ID ASC,ERD.I_Enquiry_Regn_ID

--select * from vw_StudentFullInfo
--select * from T_Receipt_Header