CREATE PROCEDURE [LMS].[uspGetCentres](@BrandID int)
as
begin

select A.I_Centre_Id,A.S_Center_Code,A.S_Center_Name,C.S_Center_Address1,C.S_Telephone_No,C.S_Email_ID 
from T_Centre_Master A
inner join T_Center_Hierarchy_Name_Details B on A.I_Centre_Id=B.I_Center_ID
inner join NETWORK.T_Center_Address C on A.I_Centre_Id=C.I_Centre_Id
where B.I_Brand_ID=@BrandID and A.I_Status=1

end
