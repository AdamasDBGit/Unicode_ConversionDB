CREATE Proc [dbo].[Usp_ERP_Get_CreatedBy_Userfor_Report]
(
@brandID int =null
)
as begin
Select distinct EU.I_User_ID,S_Username,EUB.I_Brand_ID from T_ERP_User EU
Inner Join T_ERP_User_Brand EUB ON EUB.I_User_ID=EU.I_User_ID
and EUB.Is_Active=1
where I_Status=1 and EUB.I_Brand_ID=@brandID
UNION 
Select 0 as I_User_ID ,'ALL' as S_Username,@brandID as I_Brand_ID
End