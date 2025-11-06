CREATE PROCEDURE [dbo].[uspGetHierarchyMaster]
	
AS

BEGIN
	SET NOCOUNT ON;

	select I_Hierarchy_Master_ID, S_Hierarchy_Code, S_Hierarchy_Desc, 
	S_Hierarchy_Type, I_Status 
	from T_Hierarchy_Master 
	WHERE I_Status <> 0 
	
	
END
