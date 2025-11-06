/*
-- =================================================================
-- Author:Babin SAha
-- Create date:07/09/2007 
-- Description:Insert Schedule Request Into  [AUDIT].T_Schedule_Change_Request 
-- =================================================================
*/
CREATE PROCEDURE [AUDIT].[uspCreateAuditRescheduleRequest]
(
		@iAuditScheduleID	INT				,
		@dtRequestedDate 	DATETIME		,
		@sReasonOfChange	VARCHAR(2000)	,
		@sRemarks			VARCHAR(2000)	,
		@iStatusID			INT				,
		@sCrtdBy			VARCHAR(20)		,
		@sUpdBy 			VARCHAR(20)		,
		@dtCretedOn 		DATETIME		,
		@dtUpdatedOn 		DATETIME

)

AS
BEGIN TRY
	

-- Insert record in  [AUDIT].T_Schedule_Change_Request

INSERT INTO [AUDIT].T_Schedule_Change_Request
		(	
		I_Audit_Schedule_ID		,
		Dt_Requested_Date		,
		S_Reason_Of_Change		,
		S_Remarks				,
		I_Status_ID				,
		S_Crtd_By				, 
		S_Upd_By				, 
		Dt_Crtd_On				, 
		Dt_Upd_On		 
		)
	VALUES 
		(
		@iAuditScheduleID		,
		@dtRequestedDate 		,
		@sReasonOfChange		,
		@sRemarks				,
		@iStatusID				,
		@sCrtdBy				,
		@sUpdBy 				,
		@dtCretedOn 			,
		@dtUpdatedOn 		

		)

END TRY

BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
