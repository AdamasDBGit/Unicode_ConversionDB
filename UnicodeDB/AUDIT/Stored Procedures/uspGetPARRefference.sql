/*
-- =================================================================
-- Author:Babin Saha
-- Create date:07/23/2007 
-- Description: Select From  [T_Audit_Result_NCR] used in GetNCRList Method in AuditBuilder
-- =================================================================
*/
CREATE PROCEDURE [AUDIT].[uspGetPARRefference] 

AS
BEGIN


	SET NOCOUNT OFF;
	
	SELECT
	ISNULL(S_Assessment,'') AS 'S_Assessment'
	,ISNULL(I_AuditScore,'0') AS 'I_AuditScore'
	,ISNULL(S_Percentage,'') AS 'S_Percentage'

	FROM [AUDIT].[T_Audit_Report_Par_Refference]


END
