-- =============================================
-- Author:		Debarshi Basu
-- Create date: 26/03/2006
-- Description:	Updates the Infrastructure details status for a center
-- =============================================
CREATE PROCEDURE [NETWORK].[uspUpdateInfrastructureRequest]
	@iCenterID INT,
	@iCenterStatus INT,
	@sReason VARCHAR(1000),
	@iStatus INT,
	@sCreatedBy VARCHAR(20),
	@dtCreatedOn DATETIME	
AS
BEGIN
	SET NOCOUNT OFF;
	
	IF EXISTS (SELECT * FROM NETWORK.T_Center_InfrastructureRequest
				WHERE I_Centre_Id = @iCenterID AND I_Status <> 0)
		BEGIN
			UPDATE NETWORK.T_Center_InfrastructureRequest
				SET I_Status = @iStatus,
					S_Reason = @sReason,
					S_Upd_By = @sCreatedBy,
					Dt_Upd_On = @dtCreatedOn
				WHERE I_Centre_Id = @iCenterID
					AND I_Status <> 0
		END
	ELSE
		BEGIN
			INSERT INTO NETWORK.T_Center_InfrastructureRequest
			(I_Centre_Id,I_Status,S_Reason,S_Crtd_By,Dt_Crtd_On)
			VALUES
			(@iCenterID,@iStatus,@sReason,@sCreatedBy,@dtCreatedOn)
		END

--	INSERT VALUES INTO CENTER MASTER AUDIT
	INSERT INTO NETWORK.T_Center_Master_Audit		
			SELECT * FROM dbo.T_Centre_Master
				WHERE I_Centre_Id = @iCenterID

	UPDATE dbo.T_Centre_Master
		SET I_Status = @iCenterStatus
		WHERE I_Centre_Id = @iCenterID
			AND I_Status <> 0
	
END
