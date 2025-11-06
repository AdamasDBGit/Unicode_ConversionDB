CREATE PROCEDURE [dbo].[uspGetUserBrands](@LoginID NVARCHAR(max))
as
begin

select DISTINCT B.S_Login_ID,C.I_Brand_ID,D.S_Brand_Name from T_User_Hierarchy_Details A
inner join T_User_Master B on A.I_User_ID=B.I_User_ID
inner join T_Hierarchy_Brand_Details C on A.I_Hierarchy_Master_ID=C.I_Hierarchy_Master_ID
inner join T_Brand_Master D on C.I_Brand_ID=D.I_Brand_ID
where B.S_Login_ID=@LoginID and A.I_Status=1 and C.I_Status=1 and D.I_Status=1
order by B.S_Login_ID,C.I_Brand_ID

end


