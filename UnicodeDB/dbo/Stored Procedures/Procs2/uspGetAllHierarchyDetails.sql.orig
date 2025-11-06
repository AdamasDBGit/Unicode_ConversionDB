CREATE PROCEDURE [dbo].[uspGetAllHierarchyDetails]
			@sHierarchyChain varchar(5000)
 
AS

BEGIN
	SET NOCOUNT OFF

	declare @strQuery varchar(5000)
	
	set @strQuery = 'Select *
					 from T_Hierarchy_details hd
					 inner join T_Hierarchy_Mapping_Details md
					 on hd.I_Hierarchy_Detail_ID = md.I_Hierarchy_Detail_ID
					 where S_Hierarchy_Chain like ''' + @sHierarchyChain +'%' + '''
					 and md.I_Status = 1
					 and hd.I_Status = 1'
--					 and getdate() >= isnull(Dt_Valid_From, getdate())
--					 and getdate() <= isnull(Dt_Valid_To, getdate()) '
	
	exec(@strQuery)
	
END
