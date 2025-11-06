/*
-- =================================================================
-- Author:Babin SAha
-- Create date:07/09/2007 
-- Description:Update Schedule Request Into  [AUDIT].T_Schedule_Change_Request 
-- =================================================================
*/
CREATE PROCEDURE [AUDIT].[uspUpdateAuditRescheduleRequest]
(
		@iScheduleChangeRequestID	INT	,
		--@iFlag INT						,	-- @iFlag=2 Reject | @iFlag=1 Approve
		@iStatusAudit INT				,	--  Schedule = 1,ReScheduleRequested = 2,Visited = 3,Evaluated = 4
		@iStatusChangeRequest	INT		,	--Requested = 1,Approved = 2,Reject = 3 
											--*Note If @iFlag=2 Then it Must
		@Remarks VARCHAR(2000)		,
		@RequestUpdated VARCHAR(20)		,
		@RequestUpdateOn DATETIME		,
		@AuditScheduleUpdated VARCHAR(20),
		@AuditScheduleUpdateOn DATETIME
)

AS
BEGIN TRY
-- APPROVE Reschedule Request
IF @iStatusChangeRequest =2 
BEGIN
DECLARE @iAuditScheduleID_EXIST INT
,@dtRequestedDate DATETIME
SET @iAuditScheduleID_EXIST = 0
		IF EXISTS (SELECT I_Audit_Schedule_ID FROM [AUDIT].[T_schedule_change_request] WHERE I_Schedule_Change_Request_ID = @iScheduleChangeRequestID)
		BEGIN
			SELECT @iAuditScheduleID_EXIST=I_Audit_Schedule_ID FROM [AUDIT].[T_schedule_change_request] WHERE I_Schedule_Change_Request_ID = @iScheduleChangeRequestID
		END
DECLARE @iAuditScheduleHistoryID INT
SET @iAuditScheduleHistoryID = 0 
		IF @iAuditScheduleID_EXIST <> 0
		BEGIN	
			BEGIN TRANSACTION Tran_Adt_History
					-- Make a backup of Audit Schedule  in T_Audit_Schedule_History Table
					INSERT INTO [AUDIT].T_Audit_Schedule_History
							(	
							I_Audit_Schedule_ID	,
							I_Center_ID			,
							Dt_Audit_On			,
							I_User_ID			,
							I_Audit_Type_ID		,
							I_Status_ID			,
							S_Crtd_By			, 
							S_Upd_By			, 
							Dt_Crtd_On			, 
							Dt_Upd_On		 
							)
						
					SELECT I_Audit_Schedule_ID	,
							I_Center_ID			,
							Dt_Audit_On			,
							I_User_ID			,
							I_Audit_Type_ID		,
							I_Status_ID			,
							S_Crtd_By			, 
							S_Upd_By			, 
							Dt_Crtd_On			, 
							Dt_Upd_On	
					FROM [AUDIT].T_Audit_Schedule
					WHERE I_Audit_Schedule_ID = @iAuditScheduleID_EXIST
					
					--Get Current Entry AuditScheduleHistoryID
					SET @iAuditScheduleHistoryID = SCOPE_IDENTITY();
					IF (@iAuditScheduleHistoryID>0)
						BEGIN
							IF EXISTS(SELECT Dt_Requested_Date FROM [AUDIT].[T_schedule_change_request] WHERE I_Schedule_Change_Request_ID=@iScheduleChangeRequestID)
							BEGIN
								--Updates status to APPROVE in T_schedule_change_request
								UPDATE [AUDIT].[T_schedule_change_request]
								SET I_Status_ID = @iStatusChangeRequest ,S_Upd_By = @RequestUpdated ,Dt_Upd_On = @RequestUpdateOn,S_Remarks=@Remarks
								WHERE I_Schedule_Change_Request_ID = @iScheduleChangeRequestID
								
								--Get Changed Audit Date
								SELECT @dtRequestedDate=Dt_Requested_Date FROM [AUDIT].[T_schedule_change_request] WHERE I_Schedule_Change_Request_ID=@iScheduleChangeRequestID
								
								--Update T_Audit_Schedule
								UPDATE [AUDIT].T_Audit_Schedule
								SET  Dt_Audit_On  =	@dtRequestedDate ,I_Status_ID = @iStatusAudit	
								,S_Upd_By = @AuditScheduleUpdated ,Dt_Upd_On=@AuditScheduleUpdateOn
								WHERE I_Audit_Schedule_ID = @iAuditScheduleID_EXIST
								
								DELETE FROM AUDIT.T_Audit_Schedule_Details WHERE
								I_Audit_Schedule_ID = @iAuditScheduleID_EXIST
								
								INSERT INTO AUDIT.T_Audit_Schedule_Details
	                            ( 
	                              I_Audit_Schedule_ID ,
	                              Dt_Audit_Date
	                             )
	                            SELECT SCR.I_Audit_Schedule_ID,SCRD.Dt_Audit_Date FROM AUDIT.T_Schedule_Change_Request SCR
								INNER JOIN [AUDIT].T_Schedule_Change_Request_Details SCRD
								ON SCR.I_Schedule_Change_Request_ID = SCRD.I_Schedule_Change_Request_ID
								WHERE SCR.I_Schedule_Change_Request_ID=@iScheduleChangeRequestID
								
								COMMIT TRANSACTION Tran_Adt_History
							END
							ELSE
								BEGIN
									ROLLBACK TRANSACTION Tran_Adt_History
								END
						END
					ELSE
						BEGIN
							ROLLBACK TRANSACTION Tran_Adt_History
						END
					
		END 

END

IF @iStatusChangeRequest =3
BEGIN
	--Updates status to REJECT in T_schedule_change_request
	UPDATE [AUDIT].[T_schedule_change_request]
	SET I_Status_ID = 3,S_Remarks= @Remarks 
	WHERE I_Schedule_Change_Request_ID = @iScheduleChangeRequestID

	DECLARE @iAuditScheduleID_CHK INT
	SET @iAuditScheduleID_CHK =  (SELECT I_Audit_Schedule_ID FROM [AUDIT].[T_schedule_change_request] 
							 WHERE I_Schedule_Change_Request_ID = @iScheduleChangeRequestID)
	


	UPDATE AUDIT.T_Audit_Schedule
	SET I_Status_ID = 1 
	WHERE I_Audit_Schedule_ID = @iAuditScheduleID_CHK

END
END TRY

BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
