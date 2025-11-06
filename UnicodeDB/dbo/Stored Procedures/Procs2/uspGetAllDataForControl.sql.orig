CREATE PROCEDURE [dbo].[uspGetAllDataForControl]
	-- Add the parameters for the stored procedure here
			@sHierarchyList	varchar(5000),
			@iHierarchyMasterID int
 
AS
BEGIN
	SET NOCOUNT ON;
	
	declare  @s varchar(5000)

set @s = 'select *
		from T_Hierarchy_details hd
	    inner join T_Hierarchy_Mapping_Details md
	    on hd.I_Hierarchy_Detail_ID = md.I_Hierarchy_Detail_ID
		WHERE md.I_Hierarchy_Detail_ID in (' + @sHierarchyList + ') 
		 and hd.I_Status = 1
		and md.I_Status = 1'
		
exec(@s)

select DISTINCT I_Hierarchy_Level_Id, S_Hierarchy_Level_Name 
			from T_Hierarchy_Level_Master
			WHERE I_Hierarchy_Master_ID = @iHierarchyMasterID
			and I_Status = 1
	
END
