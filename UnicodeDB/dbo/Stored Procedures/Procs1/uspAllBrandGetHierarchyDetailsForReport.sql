
--uspGetHierarchyDetails 1


CREATE PROCEDURE [dbo].[uspAllBrandGetHierarchyDetailsForReport]
@iBrandID INT	

AS

BEGIN
	SET NOCOUNT ON;

		SELECT	D.I_Hierarchy_Detail_ID,
			--L.I_Parent_ID as I_Parent_ID,
			D.S_Hierarchy_Name
			--D.I_Hierarchy_Master_ID,
			--HBD.I_Brand_ID,
			--F.S_Hierarchy_Code as Hierarchy_Master_Code,
			--F.S_Hierarchy_Desc as Hierarchy_Master_Desc,
			--F.S_Hierarchy_Type as Hierarchy_Master_Type,
			--D.I_Hierarchy_Level_Id,
			--D.I_Status,
			--E.I_Sequence,
			--L.S_Hierarchy_Chain 
	FROM T_Hierarchy_Details D 
	LEFT JOIN (SELECT * FROM T_Hierarchy_Mapping_Details
	WHERE I_Status<>0) AS L
	ON D.I_Hierarchy_Detail_ID = L.I_Hierarchy_Detail_ID
	INNER JOIN T_Hierarchy_Level_Master E
	ON D.I_Hierarchy_Master_ID = E.I_Hierarchy_Master_ID
	INNER JOIN T_Hierarchy_Master F
	ON D.I_Hierarchy_Master_ID=F.I_Hierarchy_Master_ID
	INNER JOIN T_Hierarchy_Brand_Details as HBD
	ON HBD.I_Hierarchy_Master_ID=F.I_Hierarchy_Master_ID
	WHERE D.I_Status<> 0  
	AND E.I_Status <> 0
	--AND GETDATE() >= ISNULL(L.Dt_Valid_From,GETDATE())
	--AND GETDATE() <= ISNULL(L.Dt_Valid_To,GETDATE())
	AND D.I_Hierarchy_Level_Id = E.I_Hierarchy_Level_Id
	AND HBD.I_Brand_ID=@iBrandID
	
END
