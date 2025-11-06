-- =============================================
-- Description:	Gets the Module Weightage List
--exec [dbo].[uspGetModuleGroupModuleListForTerm] 1,1
-- =============================================
CREATE PROCEDURE [dbo].[uspGetModuleGroupModuleListForTerm] 
(
	@iTermID INT,
	@iModuleGroupId INT=NULL
)

AS
BEGIN
	
	SET NOCOUNT OFF

	SELECT * FROM (SELECT	[T_Module_Master].I_Module_ID,
			[T_Module_Master].S_Module_Code,
			[T_Module_Master].S_Module_Name,
			ISNULL([T_Module_Term_Map].I_Sequence,0) as I_Sequence,
			ISNULL([T_Module_Term_Map].C_Examinable,NULL) C_Examinable	,
			MGM.S_ModuleGroup_Name,
			ISNULL([T_Module_Term_Map].I_ModuleGroup_ID,0)	I_ModuleGroup_ID,
			[T_Module_Term_Map].S_Remarks,
			[T_Module_Term_Map].N_Weightage
	FROM dbo.T_Module_Master
	INNER JOIN dbo.[T_Module_Term_Map] WITH(NOLOCK)
	ON [dbo].[T_Module_Master].[I_Module_ID] = [dbo].[T_Module_Term_Map].[I_Module_ID] 
	LEFT JOIN [dbo].[T_ModuleGroup_Master] MGM ON MGM.I_ModuleGroup_ID= dbo.[T_Module_Term_Map].I_ModuleGroup_ID
	WHERE [T_Module_Master].I_Status <> 0 AND [T_Module_Term_Map].[I_Term_ID] = @iTermID
	AND  ISNULL(MGM.I_ModuleGroup_ID,0)=ISNULL(@iModuleGroupId,MGM.I_ModuleGroup_ID)
	AND [T_Module_Term_Map].I_Status = 1
	UNION ALL
	SELECT	[T_Module_Master].I_Module_ID,
			[T_Module_Master].S_Module_Code,
			[T_Module_Master].S_Module_Name,
			ISNULL([T_Module_Term_Map].I_Sequence,0) as I_Sequence,
			ISNULL([T_Module_Term_Map].C_Examinable,NULL) C_Examinable	,
			MGM.S_ModuleGroup_Name,
			ISNULL([T_Module_Term_Map].I_ModuleGroup_ID,0)	I_ModuleGroup_ID,
			[T_Module_Term_Map].S_Remarks,
			[T_Module_Term_Map].N_Weightage
	FROM dbo.T_Module_Master
	INNER JOIN dbo.[T_Module_Term_Map] WITH(NOLOCK)
	ON [dbo].[T_Module_Master].[I_Module_ID] = [dbo].[T_Module_Term_Map].[I_Module_ID] 
	LEFT JOIN [dbo].[T_ModuleGroup_Master] MGM ON MGM.I_ModuleGroup_ID= dbo.[T_Module_Term_Map].I_ModuleGroup_ID
	WHERE [T_Module_Master].I_Status <> 0 AND [T_Module_Term_Map].[I_Term_ID] = @iTermID
	AND  ISNULL(MGM.I_ModuleGroup_ID,0)=0
	AND [T_Module_Term_Map].I_Status = 1) DVTBL
	ORDER BY I_Sequence
	
END
