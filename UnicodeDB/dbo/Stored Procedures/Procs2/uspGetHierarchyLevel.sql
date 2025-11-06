CREATE PROCEDURE [dbo].[uspGetHierarchyLevel] 

AS
BEGIN

	SELECT  HLM.I_Hierarchy_Level_Id,
			HLM.S_Hierarchy_Level_Code, 
			HLM.S_Hierarchy_Level_Name,
			HLM.I_Hierarchy_Master_ID, 
			HLM.I_Is_Last_Node,
			HLM.I_Sequence,
			HLM.I_Status, 
			HLM.S_Crtd_By,  
			HLM.S_Upd_By, 
			HLM.Dt_Crtd_On, 
			HLM.Dt_Upd_On,
			HM.S_Hierarchy_Code,
			HM.S_Hierarchy_Desc,
			HM.S_Hierarchy_Type
	FROM dbo.T_Hierarchy_Level_Master HLM
	INNER JOIN dbo.T_Hierarchy_Master HM
	ON HLM.I_Hierarchy_Master_ID = HM.I_Hierarchy_Master_ID
	WHERE HLM.I_Status <> 0
	AND HM.I_Status <> 0

END
