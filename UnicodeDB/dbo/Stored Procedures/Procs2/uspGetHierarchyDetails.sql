--uspGetHierarchyDetails 1


CREATE PROCEDURE [dbo].[uspGetHierarchyDetails]
	@iHierarchyMasterID INT

AS

BEGIN
	SET NOCOUNT ON;

		SELECT	D.I_Hierarchy_Detail_ID,
			L.I_Parent_ID as I_Parent_ID,
			D.S_Hierarchy_Name,
			D.I_Hierarchy_Master_ID,
			D.I_Hierarchy_Level_Id,
			D.I_Status,
			E.I_Sequence,
			L.S_Hierarchy_Chain 
	FROM T_Hierarchy_Details D 
	LEFT JOIN (SELECT * FROM T_Hierarchy_Mapping_Details
	WHERE I_Status<>0) AS L
	ON D.I_Hierarchy_Detail_ID = L.I_Hierarchy_Detail_ID
	INNER JOIN T_Hierarchy_Level_Master E
	ON D.I_Hierarchy_Master_ID = E.I_Hierarchy_Master_ID
	WHERE D.I_Hierarchy_Master_ID = @iHierarchyMasterID
	AND D.I_Status<> 0  
	AND E.I_Status <> 0
	--AND GETDATE() >= ISNULL(L.Dt_Valid_From,GETDATE())
	--AND GETDATE() <= ISNULL(L.Dt_Valid_To,GETDATE())
	AND D.I_Hierarchy_Level_Id = E.I_Hierarchy_Level_Id
	
END
