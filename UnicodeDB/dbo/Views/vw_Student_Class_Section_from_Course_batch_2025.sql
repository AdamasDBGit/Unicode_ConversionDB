CREATE view [dbo].[vw_Student_Class_Section_from_Course_batch_2025]      
as      
Select T.*,TS.S_Section_Name from (      
Select distinct CM.I_brand_ID, sbd.I_Student_ID,SD.S_Student_ID,SBM.I_Batch_ID,SBM.S_Batch_Name      
,CM.I_Course_ID,CM.S_Course_Name,TC.I_Class_ID,TC.S_Class_Name,TSG.I_School_Group_ID      
,TSG.S_School_Group_Code,TST.I_Stream_ID,TST.S_Stream,      
Case When SBM.S_Batch_Name Like '% A %' Then 1      
      When SBM.S_Batch_Name Like '% B %' Then 2      
   When SBM.S_Batch_Name Like '% C %' Then 3      
   When SBM.S_Batch_Name Like '% D %' Then 4      
   When SBM.S_Batch_Name Like '% E %' Then 5      
   When SBM.S_Batch_Name Like '% F %' Then 6      
   When SBM.S_Batch_Name Like '% G %' Then 7       
   When SBM.S_Batch_Name Like '% H %' Then 8      
   Else 1      
   End as SectionID      
      
from T_Student_Batch_Details SBD      
Inner Join T_Student_Batch_Master SBM ON SBM.I_Batch_ID=SBD.I_Batch_ID      
Inner Join T_Course_Master CM ON cm.I_Course_ID=SBM.I_Course_ID      
join dbo.T_Class as TC on TC.S_Class_Name =  replace(replace(replace(replace(replace(cm.S_Course_Name,' (2025)',''),'-COM',''),'-SCI',''),'-HUM',''),' IGCSE','')      
and TC.I_Brand_ID=107  
join dbo.T_School_Group as TSG ON  TSG.S_School_Group_Code = case when SBM.S_Batch_Name like '% DB %' then 'DB'      
   when SBM.S_Batch_Name like '% DS %' then 'DS'      
   when SBM.S_Batch_Name like '% IGCSE %' then 'IGCSE'      
   else 'DB' end    and TSG.I_Brand_Id=107   
left join dbo.T_Stream as TST ON case when SBM.S_Batch_Name like '%_COM_%(2025)' THEN 'Commerce'      
when SBM.S_Batch_Name like '%_SCI_%(2025)' THEN 'Science'      
when SBM.S_Batch_Name like '%_HUM_%(2025)' THEN 'Humanities'      
else NULL end = TST.S_Stream  and TST.I_brand_id=107    
      
Inner Join T_student_detail SD ON SD.I_Student_Detail_ID=SBD.I_Student_ID      
      
where cm.I_Brand_ID=107 and cm.S_Course_Name Like '%2025%'      
and SBD.I_Status=1       
) AS T       
Left Join T_Section TS ON TS.I_Section_ID=T.SectionID      