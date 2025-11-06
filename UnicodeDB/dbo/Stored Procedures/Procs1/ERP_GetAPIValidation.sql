-- =============================================
-- Author:		<Arijit Manna>
-- Create date: <2024-04-10>
-- Description:	<Get API Validation>
-- exec ERP_GetAPIValidation 'WBAzqAgsKwUNoT5dbJJu','APIValidation'
-- =============================================
CREATE PROCEDURE [dbo].[ERP_GetAPIValidation]
	(
	@Token nvarchar(MAX),
	@Type nvarchar(50)
	)
AS
BEGIN
	
	SET NOCOUNT ON;
DECLARE @brandID int
-- get the brandid from the token
set @brandID = (select t1.I_Brand_ID from T_Faculty_Master t1 inner join T_ERP_User t2 on t1.I_User_ID=t2.I_User_ID
 where t2.S_Token=@Token)

   select 
   t1.S_Property_Name PropertyName
  ,t1.S_Property_Type PropertyType
  ,t2.N_Value Value
  ,t1.I_Brand_ID BrandID
  ,SPCH.N_Value as BrandLogo
  ,TBM.S_Brand_Name BrandName
from [T_ERP_Saas_Pattern_Header] t1
INNER JOIN [T_ERP_Saas_Pattern_Child_Header] t2
on t1.I_Pattern_HeaderID =t2.I_Pattern_HeaderID
Left Join T_ERP_Saas_Pattern_Header SPH on SPH.I_Brand_ID=t1.I_Brand_ID
Left Join T_ERP_Saas_Pattern_Child_Header SPCH on SPCH.I_Pattern_HeaderID=SPH.I_Pattern_HeaderID  
left join T_Brand_Master TBM ON TBM.I_Brand_ID=t1.I_Brand_ID
where t1.I_Brand_ID = @BrandID and t1.S_Property_Type = @Type and SPH.S_Property_Name='BRAND_LOGO'  
END
