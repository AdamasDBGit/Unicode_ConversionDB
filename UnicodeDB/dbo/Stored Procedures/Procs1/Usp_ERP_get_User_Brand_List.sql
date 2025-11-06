----EXEC [Usp_ERP_get_User_Brand_List] 52     

CREATE  Proc [dbo].[Usp_ERP_get_User_Brand_List](                    
@User_ID int        
        
)                    
As                     
Begin         
        
--Declare @User_ID int=53        
                    
DECLARE @CurrentYear Varchar(4)                    
SELECT @CurrentYear= YEAR(GETDATE())   
--Select @CurrentYear  
------------Display Count--------------------        
        
Declare @centre as Table (CenterID int,brandID int,stdt date,enddt date,Is_currentSession int
,I_sessionID int)        
Insert Into @centre(CenterID,brandID,stdt,enddt,Is_currentSession,I_sessionID)        
select b.I_Centre_Id,b.I_Brand_ID,convert(date,d.Dt_Session_Start_Date)      
,convert(date,d.Dt_Session_End_Date)  ,d.I_Current_Session  ,d.I_School_Session_ID    
from T_ERP_User_Brand a        
Inner Join T_Brand_Center_Details b on a.I_Brand_ID=b.I_Brand_ID        
Inner Join T_Brand_Master c on c.I_Brand_ID=b.I_Brand_ID and c.I_Status=1        
Inner Join T_School_Academic_Session_Master d on d.I_Brand_ID=c.I_Brand_ID        
where I_User_ID=@User_ID   and d.  I_Current_Session=1    
 --Select * from @centre        
-------Pending Leads------------------        
         
                    
                    
                    
                    
 --Select * from T_School_Academic_Session_Master                    
Select UM.I_User_ID,UB.I_Brand_ID ,BM.S_Brand_Name,ASM.I_School_Session_ID ,                
SPCH.N_Value as BrandLogo,            
ASM.I_School_Session_ID            
,Bm.S_location as Location          
,ISNULL(UB.Is_Teaching_Staff,'false') as IsTeachingStaff          
,Isnull(enq.RecordCount,0) as TotalEnq        
,isnull(classtot.Totalclass,0) as Total_class        
,isnull(adm.admRecordCount,0) as TotalAdm        
from T_ERP_User_Brand UB                    
Inner Join T_ERP_User UM on UM.I_User_ID=UB.I_User_ID                    
Inner Join T_Brand_Master BM on BM.I_Brand_ID=UB.I_Brand_ID                    
Inner Join T_School_Academic_Session_Master ASM on ASM.I_Brand_ID=BM.I_Brand_ID  
Inner Join @centre cet ON cet. I_sessionID=ASM.I_School_Session_ID
Left Join T_ERP_Saas_Pattern_Header SPH on SPH.I_Brand_ID=BM.I_Brand_ID                
Left Join T_ERP_Saas_Pattern_Child_Header SPCH on SPCH.I_Pattern_HeaderID=SPH.I_Pattern_HeaderID                
Left Join @centre BCD on bcd.brandID=Bm.I_Brand_ID           
Left Join (        
SELECT                  
    I_Centre_Id ,        
 b.brandID        
         
    ,COUNT(I_Enquiry_Regn_ID) AS RecordCount                  
  --Into #Temp_Enq                  
FROM                  
    T_Enquiry_Regn_Detail a        
 Inner Join @centre b on a.I_Centre_Id=b.CenterID  
         
 where I_ERP_Entry=1                  
 and I_Enquiry_Status_Code =1                  
And                   
    convert(date,Dt_Crtd_On) >= stdt                  
    AND convert(date,Dt_Crtd_On) < enddt              
 --and I_Centre_Id=@Centerid            
GROUP BY                  
    I_Centre_Id          
 ,b.brandID        
        
) enq on enq.I_Centre_Id=bcd.CenterID and enq.brandID=bm.I_Brand_ID        
Left Join         
(        
select count(tc.I_Class_ID) as Totalclass,bm.I_Brand_ID as classBrand from T_Class TC         
Inner Join T_Brand_Master bm on tc.I_Brand_ID=bm.I_Brand_ID and tc.I_Status=1        
Group By bm.I_Brand_ID        
) classtot on classtot.classBrand=bm.I_Brand_ID        
        
Left Join (        
SELECT                  
    I_Centre_Id         
 ,b.brandID        
 ,                
    COUNT(I_Enquiry_Regn_ID) AS admRecordCount                  
  --Into #Temp_Enq                  
FROM                  
    T_Enquiry_Regn_Detail a        
 Inner Join @centre b on a.I_Centre_Id=b.CenterID   
         
 where I_ERP_Entry=1                  
 and I_Enquiry_Status_Code =3                  
--And                   
--    convert(date,Dt_Crtd_On) >= stdt                  
--    AND convert(date,Dt_Crtd_On) < enddt              
 --and I_Centre_Id=@Centerid            
GROUP BY                  
    I_Centre_Id ,b.brandID                 
        
) adm on adm.I_Centre_Id=bcd.CenterID and adm.brandID=bm.I_Brand_ID        
        
where UM.I_User_ID=@User_ID                    
And BM.I_Status=1 and UM.I_Status=1 and UB.Is_Active=1 and ASM.I_Status=1                 
And SPH.S_Property_Name='BRAND_LOGO'    
--and B.Is_currentSession =1  
--and Year(asm.Dt_Session_Start_Date)=@CurrentYear                 
and SPH.Is_Active=1 and SPCH.Is_Active=1              
End 