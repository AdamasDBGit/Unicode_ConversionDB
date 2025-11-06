-- =============================================
-- Author:		Abhisek Bhattacharya
-- Create date: 06/02/2007
-- Description:	Loads all the Activity Role Mapping
-- =============================================
CREATE PROCEDURE [dbo].[uspGetActivityRoleMapping]
  
AS
BEGIN
	SET NOCOUNT OFF

    SELECT A.I_WAR_Workflow_Activity_Role_Mapping_ID, A.I_WFD_Role_ID, A.S_WFD_Activity_Level,
	B.I_WAM_Workflow_Activity_ID, B.S_WAM_Workflow_Code, B.S_WAM_Workflow_Desc,
	B.S_WAM_Activity_Code, B.S_WAM_Activity_Desc, C.S_TRM_Role_Code
	FROM dbo.T_Workflow_Activity_Role_Mapping A, dbo.T_Workflow_Activity_Master B, dbo.T_Role_Master C
	WHERE A.I_WAR_Workflow_Activity_ID = B.I_WAM_Workflow_Activity_ID
	AND A.I_WFD_Role_ID = C.I_TRM_Role_ID
END
