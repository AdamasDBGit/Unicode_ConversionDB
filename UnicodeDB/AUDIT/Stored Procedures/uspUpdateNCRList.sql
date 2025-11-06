/*
-- =================================================================
-- Author:Babin SAha
-- Create date:07/16/2007 
-- Description: UPDATE  [T_Audit_Result_NCR] For Stats Change
-- =================================================================
*/
CREATE PROCEDURE [AUDIT].[uspUpdateNCRList] 
(
		@iNCRID						INT
		,@iStatusID					INT				
		,@btisAcknowledged			BIT	= NULL			
		,@dtacknowledgedon			DATETIME	= NULL			
		,@sacknowledgementremarks	VARCHAR(20)	= NULL 
		,@dtTargetDate				DATETIME	=NULL	
)

AS
BEGIN


	SET NOCOUNT OFF;
	
	UPDATE [AUDIT].[T_Audit_Result_NCR]
	SET
	I_Status_ID = @iStatusID
	,I_Is_Acknowledged = COALESCE(@btisAcknowledged ,I_Is_Acknowledged)
	,Dt_Acknowledged_On = COALESCE(@dtacknowledgedon , Dt_Acknowledged_On)
	,S_Acknowledgement_Remarks = COALESCE(@sacknowledgementremarks,S_Acknowledgement_Remarks)
	,Dt_Target_Close =  COALESCE(@dtTargetDate ,Dt_Target_Close)
	WHERE I_Audit_Report_NCR_ID = @iNCRID AND [I_Status_ID] != 6

END
