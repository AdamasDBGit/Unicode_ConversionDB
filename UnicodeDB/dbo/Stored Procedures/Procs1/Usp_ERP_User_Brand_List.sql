--exec [Usp_ERP_User_Brand_List] 1
CREATE PROCEDURE [dbo].[Usp_ERP_User_Brand_List]
@UserID int 
as
SET NOCOUNT ON;  

SELECT 
t1.I_Brand_ID BrandID,
t2.I_Brand_ID SelectedBrandID,
t1.S_Brand_Name BrandName
from T_Brand_Master t1 right join [T_ERP_User_Brand] t2 on t1.I_Brand_ID = t2.I_Brand_ID
where t2.I_User_ID = @UserID
