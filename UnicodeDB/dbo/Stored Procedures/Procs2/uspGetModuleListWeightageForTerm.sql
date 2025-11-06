-- =============================================
-- Author:		Sibsankar Bag
-- Create date: 29/11/2018
-- Description:	Gets the Module Weightage List
--exec [dbo].[uspGetModuleListWeightageForTerm] 370
-- =============================================
CREATE PROCEDURE [dbo].[uspGetModuleListWeightageForTerm] 
(
	@iTermID INT
)

AS
BEGIN
	
	SET NOCOUNT OFF


	SELECT	MM.I_Module_ID,
			MM.S_Module_Code,
			MM.S_Module_Name,
			ISNULL(MTM.I_Sequence,0) AS I_Sequence,
			ISNULL(MTM.C_Examinable,NULL) C_Examinable	,
			ISNULL(MGM.S_ModuleGroup_Name,'Others') AS S_ModuleGroup_Name,
			ISNULL(MTM.I_ModuleGroup_ID,1000)	AS I_ModuleGroup_ID,
			MTM.S_Remarks,
			ISNULL(MTM.N_Weightage,0) AS N_Weightage
	FROM dbo.T_Module_Master MM  WITH(NOLOCK) 
		INNER JOIN dbo.[T_Module_Term_Map] MTM WITH(NOLOCK) ON MM.[I_Module_ID] = MTM.[I_Module_ID]	 
		LEFT JOIN [dbo].[T_ModuleGroup_Master] MGM  WITH(NOLOCK)  ON MGM.I_ModuleGroup_ID = MTM.I_ModuleGroup_ID
	WHERE MM.I_Status <> 0 
		  AND MTM.[I_Term_ID] = @iTermID
	      AND MTM.I_Status = 1	
	
	
END
