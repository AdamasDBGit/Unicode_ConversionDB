/*
-- =================================================================
-- Author:Babin SAha
-- Create date:07/09/2007 
-- Description: Update Audit Schedule Into  [AUDIT].T_Audit_Schedule Table 
--				And Insert old data into  the [AUDIT].T_Audit_Schedule_History
-- =================================================================
*/
CREATE PROCEDURE [AUDIT].[uspUpdateAuditSchedule]
(
		@iAuditScheduleID	INT			,
		@iCenterID			INT			,
		@dtAuditedOn 		DATETIME	,
		@iUserID			INT			,
		@iAuditTypeID		INT			,
		@iStatusID			INT			,
		@sCrtdBy			VARCHAR(20)	,
		@sUpdBy 			VARCHAR(20)	,
		@dtCretedOn 		DATETIME	,
		@dtUpdatedOn 		DATETIME

)


AS
BEGIN TRY
DECLARE @iAuditScheduleID_EXIST BIT
SET @iAuditScheduleID_EXIST = 0
IF(@iAuditScheduleID IS NOT NULL)
BEGIN
		IF EXISTS (SELECT I_Audit_Schedule_ID FROM T_Audit_Schedule WHERE I_Audit_Schedule_ID = @iAuditScheduleID)
		BEGIN
			SET @iAuditScheduleID_EXIST =1
		END
END
DECLARE @iAuditScheduleHistoryID INT
SET @iAuditScheduleHistoryID = 0 
BEGIN TRANSACTION TrnsAuditSchedule_Backup
		IF @iAuditScheduleID_EXIST =1
		BEGIN		
						
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
					WHERE I_Audit_Schedule_ID = @iAuditScheduleID

				--Get Current Entry AuditScheduleHistoryID
				SET @iAuditScheduleHistoryID = SCOPE_IDENTITY();

				IF (@iAuditScheduleHistoryID > 0 AND @@ERROR =0)
				BEGIN
						--Update T_Audit_Schedule
						UPDATE [AUDIT].T_Audit_Schedule
						SET 	
								I_Center_ID		=	@iCenterID		,
								Dt_Audit_On		=	@dtAuditedOn	,
								I_User_ID		=	@iUserID		,
								I_Audit_Type_ID	=	@iAuditTypeID	,
								I_Status_ID		=	@iStatusID		,
								S_Crtd_By		=	@sCrtdBy		, 
								S_Upd_By		=	@sUpdBy			, 
								Dt_Crtd_On		=	@dtCretedOn		, 
								Dt_Upd_On		=	@dtUpdatedOn			 
								
						WHERE I_Audit_Schedule_ID = @iAuditScheduleID
					COMMIT TRANSACTION TrnsAuditSchedule_Backup
				END
				ELSE
					ROLLBACK TRANSACTION TrnsAuditSchedule_Backup

		END 
		ELSE
			COMMIT TRANSACTION TrnsAuditSchedule_Backup
END TRY

BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
