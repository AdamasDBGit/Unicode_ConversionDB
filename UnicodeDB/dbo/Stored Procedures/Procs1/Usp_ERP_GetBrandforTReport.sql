CREATE Proc [dbo].[Usp_ERP_GetBrandforTReport]
As
begin
Select BM.I_Brand_ID as BrandID,S_Brand_Code as BrandCode
,S_Brand_Name as Brand_Name
from T_Brand_Master BM
where I_Status=1
End