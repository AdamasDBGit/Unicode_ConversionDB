--uspGetHierarchyTreeDetails 9


CREATE PROCEDURE [dbo].[uspGetHierarchyTreeDetails]
	@iHierarchyMasterID INT

AS

BEGIN
	SET NOCOUNT ON;

	SELECT	A.I_Hierarchy_Mapping_ID,
			A.I_Hierarchy_Detail_ID,
			A.I_Parent_ID,
			A.S_Hierarchy_Chain,
			A.S_Hierarchy_Level_Chain,
			B.S_Hierarchy_Name
	FROM dbo.T_Hierarchy_Mapping_Details A WITH(NOLOCK), T_Hierarchy_Details B WITH(NOLOCK)
	WHERE A.I_Status <> 0
	AND A.I_Hierarchy_Detail_ID = B.I_Hierarchy_Detail_ID
	AND B.I_Hierarchy_Master_ID = @iHierarchyMasterID
	AND B.I_Status <> 0
	
END
