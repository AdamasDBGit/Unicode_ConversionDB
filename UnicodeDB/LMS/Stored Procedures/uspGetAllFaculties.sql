CREATE PROCEDURE [LMS].[uspGetAllFaculties](@BrandID int)
AS
begin

	select DISTINCT A.I_Employee_ID,A.S_First_Name,ISNULL(A.S_Middle_Name,'') as S_Middle_Name,A.S_Last_Name 
	from T_Employee_Dtls A
	inner join EOS.T_Employee_Role_Map B on A.I_Employee_ID=B.I_Employee_ID and B.I_Role_ID=18
	inner join T_Center_Hierarchy_Name_Details C on A.I_Centre_Id=C.I_Center_ID
	where
	B.I_Status_ID=1 and A.I_Status=3 and C.I_Brand_ID=@BrandID
	order by A.I_Employee_ID DESC

end
