/*
-- =================================================================
-- Author:Sanjay Mitra
-- Create date:16/14/2007 
-- Description: Select From  [T_Audit_Result]
-- =================================================================
*/
CREATE PROCEDURE [AUDIT].[uspGetNCRDetails] 
(
	@iAuditScheduleID INT,
	@iStatusID INT
)

AS
BEGIN


	SET NOCOUNT OFF;
	
	SELECT 
	 I_Audit_Result_ID 
	,I_Audit_Schedule_ID
	,I_Total_No_NC
	,I_Total_No_Repeated_NC
	,I_Total_No_New_NC
	,S_Audited_By
	,S_Report_Escalated_To
	,I_NCR_Status
	
	FROM [AUDIT].[T_Audit_Result]
	WHERE 
	I_Audit_Schedule_ID = @iAuditScheduleID AND I_NCR_Status = @iStatusID

END
