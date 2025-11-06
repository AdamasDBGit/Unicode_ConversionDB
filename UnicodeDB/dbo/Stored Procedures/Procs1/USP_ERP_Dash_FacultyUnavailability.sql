CREATE Proc [dbo].[USP_ERP_Dash_FacultyUnavailability](  
@BrandID int  
)  
As Begin  
select Count(SCR.I_Routine_Structure_Detail_ID) As UnavailableCount ,  
WDM.S_Day_Name  
,FM.S_Faculty_Name  
from T_ERP_Student_Class_Routine  SCR   
Inner Join T_ERP_Routine_Structure_Detail RSD   
Inner Join T_Week_Day_Master WDM on WDM.I_Day_ID=RSD.I_Day_ID  
on RSD.I_Routine_Structure_Detail_ID=SCR.I_Routine_Structure_Detail_ID   
Inner Join T_ERP_Teacher_Unavailability_Header TUH   
on TUH.I_Faculty_Master_ID=SCR.I_Faculty_Master_ID  
Inner Join T_Faculty_Master FM on FM.I_Faculty_Master_ID=TUH.I_Faculty_Master_ID  
where   
--SCR.I_Faculty_Master_ID=10 and   
WDM.S_Day_Name=DATENAME(WEEKDAY, GETDATE())  
and convert(date,TUH.Dt_From)<=convert(date,GETDATE())   
and convert(date,TUH.Dt_To) >=convert(date,GETDATE())  
and TUH.Dt_Approved is not Null and FM.I_Brand_ID=@BrandID  
Group by WDM.S_Day_Name  
,FM.S_Faculty_Name  
End
