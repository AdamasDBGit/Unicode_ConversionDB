--EXEC uspGetModuleGroupModuleList @iTermID = 370

CREATE PROCEDURE [dbo].[uspGetModuleGroupModuleList]
  @iTermID INT
AS
BEGIN
		SELECT (CASE WHEN MGM.I_ModuleGroup_ID IS NULL THEN 1000 ELSE MGM.I_ModuleGroup_ID END) AS I_ModuleGroup_ID 
			,(CASE WHEN MGM.S_ModuleGroup_Name IS NULL THEN 'Others' ELSE MGM.S_ModuleGroup_Name END) AS S_ModuleGroup_Name 
			,MM.I_Module_ID
			,MM.S_Module_Code
			,REPLACE(MM.S_Module_Name,'_',' ') AS S_Module_Name
			,MTM.I_Sequence
		FROM T_Module_Term_Map MTM 
			INNER JOIN T_Module_Master MM ON MM.I_Module_ID = MTM.I_Module_ID 
			LEFT JOIN T_ModuleGroup_Master MGM ON MGM.I_ModuleGroup_ID = MTM.I_ModuleGroup_ID 
        WHERE I_Term_ID = @iTermID 
			 AND MTM.I_Status = 1
		ORDER BY MM.S_Module_Name 
END
