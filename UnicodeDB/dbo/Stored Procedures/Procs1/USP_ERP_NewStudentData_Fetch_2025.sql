  
--EXEC USP_ERP_NewStudentData_Fetch_2025 107  
CREATE Proc USP_ERP_NewStudentData_Fetch_2025(            
@BrandID int            
)            
as             
begin            
Insert Into T_ERP_Student_DataMapped(            
  I_Brand_ID             
    ,I_Student_Detail_ID             
    ,student_erp_id             
    ,S_Course_Name             
    ,S_Batch_Name             
    ,StudentName             
    ,S_Mobile_No            
    ,S_Class_Name             
    ,S_Section_Name             
    ,S_Stream             
    ,S_School_Group_Code             
    ,Section_Name_GPS             
    ,S_PickupPoint_Name             
    ,N_Fees             
    ,S_Route_No             
    ,FatherName             
    ,Father_Parent_Master_ID             
    ,FatherContactNumber             
    ,Father_Is_Primary             
    ,F_Is_BusTravel             
    ,Mothername             
    ,Mother_Parent_Master_ID             
    ,MotherContactNumber             
    ,Mother_Is_Primary             
    ,M_Is_BusTravel             
 ,Dt_Modify_Dt            
            
)            
Select   Distinct         
scs.I_Brand_ID,            
St.I_Student_Detail_ID,            
       ST.S_Student_ID as student_erp_id,            
    NULL as S_Course_Name,            
    null as S_Batch_Name,            
       Concat(ST.S_First_Name, ' ', ST.S_Middle_Name, ' ', ST.S_Last_Name) as StudentName,            
       ST.S_Mobile_No            
    --,SUBSTRING(Cm.S_Course_Name, 1, CHARINDEX(' (2025)', Cm.S_Course_Name)) as ActualClassname            
    ,TC.S_Class_Name,            
    TS.S_Section_Name,            
    Strm.S_Stream,            
    sg.S_School_Group_Code,            
    case When TC.S_Class_Name IN('Class XII','Class XI')            
    Then Concat((SUBSTRING( Strm.S_Stream, 1, 3 )),' ',TS.S_Section_Name)            
    Else            
    Concat(TS.S_Section_Name,' ',SG.S_School_Group_Code)             
    End as Section_Name_GPS,            
    TM.S_PickupPoint_Name,            
       TM.N_Fees,            
       TBM.S_Route_No,            
Max(Case When PM.I_Relation_ID=1 Then Concat(PM.S_First_Name,' ',PM.S_Middile_Name,' ',PM.S_Last_Name) End) As FatherName,             
Max(Case When PM.I_Relation_ID=1 Then PM.I_Parent_Master_ID End) As Father_Parent_Master_ID             
            
,Max(Case When PM.I_Relation_ID=1 Then PM.S_Mobile_No End) As FatherContactNumber             
,Max(Case When PM.I_Relation_ID=1 Then PM.I_IsPrimary End) As Father_Is_Primary             
,Max(Case When PM.I_Relation_ID=1 Then PM.I_IsBusTravel End) As F_Is_BusTravel            
,Max(Case When PM.I_Relation_ID=2 Then Concat(PM.S_First_Name,' ',PM.S_Middile_Name,' ',PM.S_Last_Name) End) As Mothername             
,Max(Case When PM.I_Relation_ID=2 Then PM.I_Parent_Master_ID End) As Mother_Parent_Master_ID,             
            
 Max(Case When PM.I_Relation_ID=2 Then PM.S_Mobile_No End) As MotherContactNumber             
,Max(Case When PM.I_Relation_ID=2 Then PM.I_IsPrimary End) As Mother_Is_Primary             
,Max(Case When PM.I_Relation_ID=2 Then PM.I_IsBusTravel End) As M_Is_BusTravel            
,Null            
            
--Into #FetchData            
from T_Student_Class_Section scs        
  Inner Join T_Student_Detail ST ON ST.I_Student_Detail_ID=scs.I_Student_Detail_ID     
  and scs.I_Status=1  
Inner Join T_School_Group_Class SGC on SGC.I_School_Group_Class_ID=SCS.I_School_Group_Class_ID    
 Inner Join T_Class TC on TC.I_Class_ID=SGC.I_Class_ID   and TC.I_Brand_ID=@BrandID         
 Inner Join T_School_Group SG on SG.I_School_Group_ID=SGC.I_School_Group_ID    and SG.I_Brand_Id=@BrandID         
 Left Join T_Section TS on TS.I_Section_ID=ISNULL(SCS.I_Section_ID,1)            
 Left Join T_Stream Strm on Strm.I_Stream_ID=scs.I_Stream_ID   
  Left Join            
    (            
        SELECT *,            
               ROW_NUMBER() OVER (PARTITION BY I_Student_Detail_ID ORDER BY Dt_Crtd_On DESC) AS rn            
        FROM T_Student_Transport_History            
    ) t1            
        on t1.I_Student_Detail_ID = ST.I_Student_Detail_ID            
           and t1.rn = 1            
    Left Join T_BusRoute_Master TBM             
        on TBM.I_Route_ID = t1.I_Route_ID and TBM.I_Status=1            
    Left Join T_Transport_Master TM            
        on TM.I_PickupPoint_ID = t1.I_PickupPoint_ID and TM.I_Status=1            
           and TM.I_Brand_ID = scs.I_Brand_ID            
   Left Join T_Student_Parent_Maps SPM on SPM.I_Student_Detail_ID=ST.I_Student_Detail_ID            
   Left Join T_Parent_Master PM on PM.I_Parent_Master_ID=SPM.I_Parent_Master_ID            
            
 Where scs.I_Brand_ID=@BrandID             
 and scs.I_School_Session_ID=7    
 --and ST.S_Student_ID like '25-%'  
          
  and Not Exists(            
  select 1 from T_ERP_Student_DataMapped stm              
  where stm.I_Student_Detail_ID=St.I_Student_Detail_ID            
       
            
  )      
 -- ANd (TM.S_PickupPoint_Name is Not null and TBM.S_Route_No is not null)    
    Group By             
    St.I_Student_Detail_ID,            
       ST.S_Student_ID,            
    --Cm.S_Course_Name,            
    --SBM.S_Batch_Name,            
       Concat(ST.S_First_Name, ' ', ST.S_Middle_Name, ' ', ST.S_Last_Name) ,            
       ST.S_Mobile_No,            
    TC.S_Class_Name,            
    TS.S_Section_Name,            
    Strm.S_Stream,            
    SG.S_School_Group_Code,            
    TM.S_PickupPoint_Name,            
       TM.N_Fees,            
       TBM.S_Route_No,            
    scs.I_brand_id            
          order by ST.S_Student_ID  
    End