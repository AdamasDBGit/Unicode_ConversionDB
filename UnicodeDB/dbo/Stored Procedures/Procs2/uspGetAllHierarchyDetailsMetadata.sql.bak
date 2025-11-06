CREATE PROCEDURE [dbo].[uspGetAllHierarchyDetailsMetadata]
 
AS

BEGIN
	SET NOCOUNT OFF

	declare @strQuery varchar(5000)
	
	set @strQuery = 'Select *
					 from T_Hierarchy_details hd
					 inner join T_Hierarchy_Mapping_Details md
					 on hd.I_Hierarchy_Detail_ID = md.I_Hierarchy_Detail_ID
					 where md.I_Status = 1
					 and hd.I_Status = 1'
	exec(@strQuery)
	
END
