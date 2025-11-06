-- =============================================  
 --exec uspGetModuleGroupsWeightage NULL,370
-- =============================================  
  
CREATE PROCEDURE [dbo].[uspGetModuleGroupsWeightage]   
(
  @iBrandID INT = NULL,
  @iTermID INT = NULL
 )
AS  
BEGIN  
	  SELECT T.I_ModuleGroup_ID
		   ,T.S_ModuleGroup_Code
		   ,T.S_ModuleGroup_Name
		   ,SUM(ISNULL(T.N_Weightage,0)) AS N_Weightage
	  FROM (SELECT (CASE WHEN  MG.I_ModuleGroup_ID IS NULL THEN 1000 ELSE MG.I_ModuleGroup_ID END) AS I_ModuleGroup_ID
				,(CASE WHEN  MG.I_ModuleGroup_ID IS NULL THEN 'Others' ELSE MG.S_ModuleGroup_Code END) AS S_ModuleGroup_Code
				,(CASE WHEN  MG.I_ModuleGroup_ID IS NULL THEN 'Others' ELSE MG.S_ModuleGroup_Name END) AS S_ModuleGroup_Name 
				,ISNULL(MTM.N_Weightage,0) AS N_Weightage
		FROM T_Module_Term_Map MTM  
			LEFT JOIN T_ModuleGroup_Master MG ON MG.I_ModuleGroup_ID = MTM.I_ModuleGroup_ID AND MG.I_Status = 1 AND MG.I_Brand_ID = ISNULL(@iBrandID, MG.I_Brand_ID)
	 WHERE  MTM.I_Status = 1 
			AND MTM.I_Term_ID = ISNULL(@iTermID, MTM.I_Term_ID)
		) T
	 GROUP BY I_ModuleGroup_ID, S_ModuleGroup_Code,S_ModuleGroup_Name
	  
END
