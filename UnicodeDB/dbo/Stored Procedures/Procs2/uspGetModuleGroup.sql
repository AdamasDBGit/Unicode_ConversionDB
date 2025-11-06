CREATE PROCEDURE [dbo].[uspGetModuleGroup]     
AS    
BEGIN    
    
 SELECT I_ModuleGroup_ID
	,S_ModuleGroup_Code
	,S_ModuleGroup_Name
	,I_Brand_Id
	,I_Sequence,I_Status
 FROM T_ModuleGroup_Master    
 ORDER BY S_ModuleGroup_Code    
    
END
