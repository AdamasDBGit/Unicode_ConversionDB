-- =============================================
-- Author:		Abhisek Bhattacharya
-- Create date: 05/02/2007
-- Description:	Loads all the Workflow Activity mapping
-- =============================================
CREATE PROCEDURE [dbo].[uspGetWorkflowActivityMapping] 
AS
BEGIN
	SET NOCOUNT OFF

    SELECT I_WAM_Workflow_Activity_ID, S_WAM_Workflow_Code, S_WAM_Workflow_Desc,
	S_WAM_Activity_Code, S_WAM_Activity_Desc, S_WAM_Workflow_Type, I_WAM_Need_Response
	FROM dbo.T_Workflow_Activity_Master
END
