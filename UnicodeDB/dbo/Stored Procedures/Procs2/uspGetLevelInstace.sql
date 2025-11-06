CREATE PROCEDURE [dbo].[uspGetLevelInstace]

AS

BEGIN
SET NOCOUNT ON;

SELECT  D.I_Hierarchy_Detail_ID,
		D.I_Hierarchy_Level_Id,
		D.I_Hierarchy_Master_ID,
		D.S_Hierarchy_Name,
		M.I_Parent_ID,
		D.I_Status,
		D.Dt_Crtd_On,
		D.Dt_Upd_On,
		D.S_Crtd_By,
		D.S_Upd_By,
		L.S_Hierarchy_Level_Code,
		L.I_Is_Last_Node,
		L.I_Sequence,
		H.S_Hierarchy_Type,
		H.S_Hierarchy_Code
FROM T_Hierarchy_Details D
INNER JOIN T_Hierarchy_Level_Master L
ON D.I_Hierarchy_Level_Id = L.I_Hierarchy_Level_Id
INNER JOIN dbo.T_Hierarchy_Master H
ON H.I_Hierarchy_Master_ID = D.I_Hierarchy_Master_ID
LEFT OUTER JOIN dbo.T_Hierarchy_Mapping_Details M
ON D.I_Hierarchy_Detail_ID = M.I_Hierarchy_Detail_ID
AND M.I_Status <> 0
WHERE D.I_Status <> 0
AND L.I_Status <> 0
AND H.I_Status <> 0

END
