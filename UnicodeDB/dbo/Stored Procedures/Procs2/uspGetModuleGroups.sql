
CREATE PROCEDURE [dbo].[uspGetModuleGroups]   
(
  @iBrandID INT = NULL,
  @iModuleGroupID INT = NULL
)
AS  
BEGIN  
  
  SELECT MG.[I_ModuleGroup_ID]
      ,MG.[S_ModuleGroup_Code]
      ,MG.[S_ModuleGroup_Name]
	  ,ISNULL(MG.[I_Sequence],0) I_Sequence
      ,MG.[I_Brand_ID]
      ,MG.[S_Crtd_By]
      ,MG.[Dt_Crtd_On]
      ,MG.[S_Upd_By]
      ,MG.[Dt_Upd_On]
      ,MG.[I_Status]
  FROM [dbo].[T_ModuleGroup_Master] MG, dbo.T_Brand_Master B  
	 WHERE MG.I_Status <> 0  
	 AND MG.I_Brand_ID = B.I_Brand_ID 
	 AND MG.I_ModuleGroup_ID=ISNULL(@iModuleGroupID, MG.I_ModuleGroup_ID)
	 AND MG.I_Brand_ID=ISNULL(@iBrandID, MG.I_Brand_ID)
 ORDER BY MG.S_ModuleGroup_Name  
END
