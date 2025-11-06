-- =============================================
-- Author:		Santanu Maity
-- Create date: 05/07/2007
-- Description:	@iFlag = 1 -> NETWORK.T_Termination_Request
--				@iFlag = 2 -> INSERT NETWORK.T_Termination_Request_Audit AND UPDATE NETWORK.T_Termination_Request
--				@iFlag = 3 -> INSERT NETWORK.T_Termination_Request_Audit AND DELETE NETWORK.T_Termination_Request
-- =============================================
CREATE PROCEDURE [NETWORK].[uspUpdateTerminationRequest] 
	-- Add the parameters for the stored procedure here
	@iCenterID int,
	@sReason varchar(200),
	@iStatus int,
	@iDocumentID int,
	@sCreatedBy varchar(20),
	@dtCreatedOn datetime,
	@iFlag int
AS
BEGIN TRY
	BEGIN
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;
		-- Insert NETWORK.T_Termination_Request
		IF(@iFlag = 1)
		BEGIN
			INSERT INTO NETWORK.T_Termination_Request_Audit
			(
			I_Center_Termination_ID,
			I_Centre_Id,
			I_Document_ID,
			S_Reason,
			I_Status,
			S_Crtd_By,
			S_Upd_By,
			Dt_Crtd_On,
			Dt_Upd_On
			)
			SELECT *
			FROM NETWORK.T_Termination_Request
			WHERE I_Centre_Id = @iCenterID

			DELETE FROM NETWORK.T_Termination_Request
			WHERE I_Centre_Id = @iCenterID
			
			INSERT INTO NETWORK.T_Termination_Request
			(
			I_Centre_Id,
			I_Document_ID,
			S_Reason,
			I_Status,
			S_Crtd_By,
			Dt_Crtd_On	
			)
			VALUES
			(
			@iCenterID,
			@iDocumentID,
			@sReason,
			@iStatus,
			@sCreatedBy,
			@dtCreatedOn
			)
		END
--		Insert NETWORK.T_Termination_Request_Audit AND Update NETWORK.T_Termination_Request
		ELSE IF (@iFlag = 2)
		BEGIN
			INSERT INTO NETWORK.T_Termination_Request_Audit
			(
			I_Center_Termination_ID,
			I_Centre_Id,
			I_Document_ID,
			S_Reason,
			I_Status,
			S_Crtd_By,
			S_Upd_By,
			Dt_Crtd_On,
			Dt_Upd_On
			)
			SELECT *
			FROM NETWORK.T_Termination_Request
			WHERE I_Centre_Id = @iCenterID

			UPDATE NETWORK.T_Termination_Request
			SET I_Status = @iStatus,
				I_Document_ID = @iDocumentID,
				S_Reason = @sReason,
				S_Upd_By = @sCreatedBy,
				Dt_Upd_On = @dtCreatedOn
				WHERE I_Centre_Id = @iCenterID
		END
		ELSE IF (@iFlag = 3)
		BEGIN
			INSERT INTO NETWORK.T_Termination_Request_Audit
			(
			I_Center_Termination_ID,
			I_Centre_Id,
			I_Document_ID,
			S_Reason,
			I_Status,
			S_Crtd_By,
			S_Upd_By,
			Dt_Crtd_On,
			Dt_Upd_On
			)
			SELECT *
			FROM NETWORK.T_Termination_Request
			WHERE I_Centre_Id = @iCenterID

			UPDATE NETWORK.T_Termination_Request
			SET I_Status = 0,
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
