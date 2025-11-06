CREATE PROCEDURE [MBP].[uspGetHierarchyDetails]
(
	@iHierarchyDetailID int
)
AS

BEGIN

	SET NOCOUNT ON;
	
	SELECT HMD.I_Hierarchy_Detail_ID, HD.S_Hierarchy_Name 
	FROM dbo.T_Hierarchy_Mapping_Details HMD
	INNER JOIN dbo.T_Hierarchy_Details HD 
	ON HMD.I_Hierarchy_Detail_ID = HD.I_Hierarchy_Detail_ID
	WHERE HMD.I_Parent_ID = @iHierarchyDetailID AND HMD.I_Status = 1

END
