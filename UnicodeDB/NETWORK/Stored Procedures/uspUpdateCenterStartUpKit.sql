-- =============================================
-- Author:		Debarshi Basu
-- Create date: 26/03/2006
-- Description:	Inserts/Updates/Deletes list for StartUpKit of a center
-- =============================================
CREATE PROCEDURE [NETWORK].[uspUpdateCenterStartUpKit]
	@iCenterID INT,
	@iStartUpKitID INT,
	@sActNo Varchar(50),
	@sActSpec VARCHAR(200),
	@sCreatedBy Varchar(20),
	@dtCreatedOn datetime,
	@iFlag INT	
AS
BEGIN
	SET NOCOUNT OFF;
	
	IF (@iFlag = 1)
	BEGIN	
		INSERT INTO NETWORK.T_Startup_Kit_Detail
		(I_Startup_Kit_ID,I_Centre_Id,S_Act_Spec,S_Act_No,S_Crtd_By,
		Dt_Crtd_On,I_Status)
		VALUES
		(@iStartUpKitID,@iCenterID,@sActSpec,@sActNo,@sCreatedBy,
			@dtCreatedOn,1)
	END
	ELSE IF (@iFlag = 2)
	BEGIN	
		UPDATE NETWORK.T_Startup_Kit_Detail
			SET S_Act_Spec = @sActSpec,
				S_Act_No = @sActNo,
				S_Upd_By = @sCreatedBy,
				Dt_Upd_On = @dtCreatedOn
			WHERE I_Centre_Id = @iCenterID
				AND I_Startup_Kit_ID = @iStartUpKitID
				AND I_Status <> 0
	END 
	ELSE
	BEGIN
		UPDATE NETWORK.T_Startup_Kit_Detail
			SET I_Status = 0,
				S_Upd_By = @sCreatedBy,
				Dt_Upd_On = @dtCreatedOn
			WHERE I_Centre_Id = @iCenterID
				AND I_Startup_Kit_ID = @iStartUpKitID
				AND I_Status <> 0
	END
	
END
