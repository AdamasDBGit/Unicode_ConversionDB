/*
-- =================================================================
-- Author:Babin SAha
-- Create date:07/10/2007 
-- Description: (Schedule Change Request) Insert Into  [AUDIT].T_Schedule_Change_Request
-- =================================================================
*/
CREATE PROCEDURE [AUDIT].[uspCreateAuditScheduleChangeRequest]
(
		@iAuditScheduleID		INT				,
		@dtRequestedDate		DATETIME		,
		@sReasonOfChange		VARCHAR(2000)	,
		@sRemarks				VARCHAR(2000)	,
		@iRequestStatusID		INT				,
		@sCrtdBy				VARCHAR(20)		,
		@sUpdBy					VARCHAR(20)		,
		@dtCrtdOn				DATETIME		,
		@dtUpdOn				DATETIME		,
		@iAuditStatusID			INT             ,
		@sAuditDates		    VARCHAR(MAX)
)

AS
BEGIN TRY
	
DECLARE @iAuditScheduleID_Chk INT
DECLARE @iSchedule_Change_Request_ID INT

SET @iAuditScheduleID_Chk = 0
-- Insert record in  [AUDIT].T_Schedule_Change_Request Table
IF EXISTS(SELECT I_Audit_Schedule_ID FROM [AUDIT].T_Audit_Schedule WHERE I_Audit_Schedule_ID=@iAuditScheduleID)
BEGIN
	SET @iAuditScheduleID_Chk = (SELECT I_Audit_Schedule_ID FROM [AUDIT].T_Audit_Schedule WHERE I_Audit_Schedule_ID=@iAuditScheduleID)
END
IF @iAuditScheduleID_Chk <> 0
	BEGIN
	--BEGIN TRANSACTION SCRequest
	UPDATE  AUDIT.T_Audit_Schedule SET I_Status_ID=@iAuditStatusID WHERE I_Audit_Schedule_ID=@iAuditScheduleID
		
	--IF (@@ERROR =0)
	--BEGIN
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
			@dtRequestedDate		,
			@sReasonOfChange		,
			@sRemarks				,
			@iRequestStatusID		,
			@sCrtdBy				,
			@sUpdBy					,
			@dtCrtdOn				,
			@dtUpdOn				
			)
			--COMMIT TRANSACTION SCRequest
		--END
		--ELSE
		--ROLLBACK TRANSACTION SCRequest
		SELECT @iSchedule_Change_Request_ID = SCOPE_IDENTITY();
		
		INSERT INTO [AUDIT].T_Schedule_Change_Request_Details
	        ( 
	          I_Schedule_Change_Request_ID,
	          Dt_Audit_Date
	        )
	   SELECT @iSchedule_Change_Request_ID, CAST(FN.Val AS DATE) FROM dbo.fnString2Rows(@sAuditDates,',') FN
	
	END

END TRY

BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
