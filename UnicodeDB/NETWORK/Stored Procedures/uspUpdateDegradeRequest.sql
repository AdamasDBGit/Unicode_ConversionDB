-- =============================================
-- Author:		Debarshi Basu
-- Create date: 15/07/2007
-- Description:	Updates the Degrade request for the center
-- =============================================
CREATE PROCEDURE [NETWORK].[uspUpdateDegradeRequest] 
	-- Add the parameters for the stored procedure here
	@iCenterID INT,
	@sRemarks Varchar(1000),
	@iRequestedCategory INT,
	@iStatus INT,
	@iFlag INT,
	@sCrtdBy VARCHAR(20),
	@dtCrtdOn Datetime
AS
BEGIN TRY
	BEGIN
		SET NOCOUNT ON;
		IF(@iFlag = 1)
		BEGIN
			INSERT INTO NETWORK.T_Upgrade_Request_Audit
			SELECT I_Center_Upgrade_Request_ID,I_Centre_Id,S_Reason,
				S_Remarks,I_Is_Upgrade,S_Crtd_By,S_Upd_By,Dt_Crtd_On,Dt_Upd_On,
				I_Requested_Category,I_Status
			FROM NETWORK.T_Upgrade_Request
			WHERE I_Centre_Id = @iCenterID

			DELETE FROM NETWORK.T_Upgrade_Request
			WHERE I_Centre_Id = @iCenterID

			INSERT INTO NETWORK.T_Upgrade_Request
			(I_Centre_Id,S_Remarks,I_Is_Upgrade,S_Crtd_By,Dt_Crtd_On,
			 I_Requested_Category,I_Status)
			VALUES
			(@iCenterID,@sRemarks,0,@sCrtdBy,@dtCrtdOn,
				@iRequestedCategory,@iStatus)	
		END
		ELSE IF (@iFlag = 2)
		BEGIN
			INSERT INTO NETWORK.T_Upgrade_Request_Audit
			SELECT I_Center_Upgrade_Request_ID,I_Centre_Id,S_Reason,
				S_Remarks,I_Is_Upgrade,S_Crtd_By,S_Upd_By,Dt_Crtd_On,Dt_Upd_On,
				I_Requested_Category,I_Status
			FROM NETWORK.T_Upgrade_Request
			WHERE I_Centre_Id = @iCenterID

			UPDATE NETWORK.T_Upgrade_Request
			SET S_Remarks = @sRemarks,
				S_Upd_By = @sCrtdBy,
				Dt_Upd_On = @dtCrtdOn,
				I_Requested_Category = @iRequestedCategory,
				I_Status = @iStatus
			WHERE I_Centre_Id = @iCenterID
		END
		ELSE IF (@iFlag = 3)
		BEGIN
			INSERT INTO NETWORK.T_Upgrade_Request_Audit
			SELECT I_Center_Upgrade_Request_ID,I_Centre_Id,S_Reason,
				S_Remarks,I_Is_Upgrade,S_Crtd_By,S_Upd_By,Dt_Crtd_On,Dt_Upd_On,
				I_Requested_Category,I_Status
			FROM NETWORK.T_Upgrade_Request
			WHERE I_Centre_Id = @iCenterID

			DELETE FROM NETWORK.T_Upgrade_Request
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
