-- =============================================
-- Author:		Santanu Maity
-- Create date: 05/07/2007
-- Description:	@iFlag = 1 -> INSERT NETWORK.T_Center_Renewal_Status
--				@iFlag = 2 -> INSERT NETWORK.T_Center_Renewal_Audit AND UPDATE NETWORK.T_Center_Renewal_Status
--				@iFlag = 3 -> INSERT NETWORK.T_Center_Renewal_Audit AND DELETE NETWORK.T_Center_Renewal_Status
-- =============================================
CREATE PROCEDURE [NETWORK].[uspUpdateResurrectionRequest] 
	-- Add the parameters for the stored procedure here
	@iCenterID int,
	@sReason varchar(200),
	@iStatus int,
	@sCreatedBy varchar(20),
	@dtCreatedOn datetime,
	@iFlag int
AS
BEGIN TRY
	BEGIN
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;
		-- Insert NETWORK.T_Center_Renewal_Status
		IF(@iFlag = 1)
		BEGIN
			INSERT INTO NETWORK.T_Resurrection_Request_Audit
			(
			I_Center_Resurrection_ID,
			I_Centre_Id,
			S_Reason,
			S_Remarks,
			I_Status,
			S_Crtd_By,
			S_Upd_By,
			Dt_Crtd_On,
			Dt_Upd_On	
			)
			SELECT *
			FROM NETWORK.T_Resurrection_Request
			WHERE I_Centre_Id = @iCenterID

			DELETE
			FROM NETWORK.T_Resurrection_Request
			WHERE I_Centre_Id = @iCenterID

			INSERT INTO NETWORK.T_Resurrection_Request
			(
			I_Centre_Id,
			S_Reason,
			I_Status,
			S_Crtd_By,
			Dt_Crtd_On	
			)
			VALUES
			(
			@iCenterID,
			@sReason,
			@iStatus,
			@sCreatedBy,
			@dtCreatedOn
			)
		END
--		Insert NETWORK.T_Center_Renewal_Audit AND Update NETWORK.T_Center_Renewal_Status
		ELSE IF (@iFlag = 2)
		BEGIN
			INSERT INTO NETWORK.T_Resurrection_Request_Audit
			(
			I_Center_Resurrection_ID,
			I_Centre_Id,
			S_Reason,
			S_Remarks,
			I_Status,
			S_Crtd_By,
			S_Upd_By,
			Dt_Crtd_On,
			Dt_Upd_On	
			)
			SELECT *
			FROM NETWORK.T_Resurrection_Request
			WHERE I_Centre_Id = @iCenterID

			UPDATE NETWORK.T_Resurrection_Request
			SET S_Reason = @sReason,
				I_Status = @iStatus,
				S_Upd_By = @sCreatedBy,
				Dt_Upd_On = @dtCreatedOn
				WHERE I_Centre_Id = @iCenterID
		END
		ELSE IF (@iFlag = 3)
		BEGIN
			INSERT INTO NETWORK.T_Resurrection_Request_Audit
			(
			I_Center_Resurrection_ID,
			I_Centre_Id,
			S_Reason,
			S_Remarks,
			I_Status,
			S_Crtd_By,
			S_Upd_By,
			Dt_Crtd_On,
			Dt_Upd_On	
			)
			SELECT *
			FROM NETWORK.T_Resurrection_Request
			WHERE I_Centre_Id = @iCenterID

			UPDATE NETWORK.T_Resurrection_Request
			SET S_Reason = @sReason,
				I_Status = 0,
				S_Upd_By = @sCreatedBy,
				Dt_Upd_On = @dtCreatedOn
				WHERE I_Centre_Id = @iCenterID
		END
	END
END TRY
BEGIN CATCH
	--Error occurred:  
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
