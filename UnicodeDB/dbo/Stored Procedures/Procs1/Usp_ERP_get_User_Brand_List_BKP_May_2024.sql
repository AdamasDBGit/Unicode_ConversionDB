
CREATE  Proc [dbo].[Usp_ERP_get_User_Brand_List_BKP_May_2024](          
@User_ID int          
)          
As           
Begin          
          
DECLARE @CurrentYear Varchar(4)          
SELECT @CurrentYear= YEAR(GETDATE())           
          
          
          
          
 --Select * from T_School_Academic_Session_Master          
Select UM.I_User_ID,UB.I_Brand_ID ,BM.S_Brand_Name,ASM.I_School_Session_ID ,      
SPCH.N_Value as BrandLogo   ,  
ASM.I_School_Session_ID  
,Bm.S_location as Location
from T_ERP_User_Brand UB          
Inner Join T_ERP_User UM on UM.I_User_ID=UB.I_User_ID          
Inner Join T_Brand_Master BM on BM.I_Brand_ID=UB.I_Brand_ID          
Inner Join T_School_Academic_Session_Master ASM on ASM.I_Brand_ID=BM.I_Brand_ID       
Left Join T_ERP_Saas_Pattern_Header SPH on SPH.I_Brand_ID=BM.I_Brand_ID      
Left Join T_ERP_Saas_Pattern_Child_Header SPCH on SPCH.I_Pattern_HeaderID=SPH.I_Pattern_HeaderID      
      
where UM.I_User_ID=@User_ID          
And BM.I_Status=1 and UM.I_Status=1 and UB.Is_Active=1 and ASM.I_Status=1       
And SPH.S_Property_Name='BRAND_LOGO'      
and Year(asm.Dt_Session_Start_Date)=@CurrentYear       
and SPH.Is_Active=1 and SPCH.Is_Active=1    
End
