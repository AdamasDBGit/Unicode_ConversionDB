--exec [dbo].[uspGetComponentMaster] null,2,'515AB40DC8654D7EB63D306F606DEF88'
CREATE PROCEDURE [dbo].[uspGetComponentMaster]
(
 @iBrandID int =null,
 @iType int = null,
 @sToken nvarchar(max) = null
)
AS
BEGIN
if(@iBrandID =0)
BEGIN
set @iBrandID = (select top 1 I_Brand_ID from T_Parent_Master where S_Token = @sToken)
END
select 
t2.S_Component_Code AS ComponentCode
,t2.S_Component_Name AS ComponentName
,t1.I_Brand_ID AS BrandID
,TBM.S_Brand_Name BrandName
,t1.I_Status AS StausCode
,CASE when t1.I_Status = 0 then 'InActive'
	  when t1.I_Status = 1 then 'Active'
	  when t1.I_Status = 2 then 'Under Maintainance'
	  when t1.I_Status = 3 then 'Coming Soon'
	  else '' end AS StatusDescription
from T_App_Brand_Component_Map t1 
inner join T_App_Component_Master t2 on t1.I_App_Component_Master_ID = t2.I_App_Component_Master_ID
inner join T_Brand_Master TBM ON TBM.I_Brand_ID = t1.I_Brand_ID
where t1.I_Brand_ID = @iBrandID and t2.I_Status = 1 and t2.I_Type=@iType
order by t2.I_Sequence
END
