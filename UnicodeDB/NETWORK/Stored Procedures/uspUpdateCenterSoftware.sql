-- =============================================
-- Author:		Debarshi Basu
-- Create date: 26/03/2006
-- Description:	Inserts/Updates/Deletes list for Software of a center
-- =============================================
CREATE PROCEDURE [NETWORK].[uspUpdateCenterSoftware]
	@iCenterID INT,
	@iSoftwareID INT,
	@sActVersion Varchar(50),
	@sActLicense VARCHAR(200),
	@sCreatedBy Varchar(20),
	@dtCreatedOn datetime,
	@iFlag INT	
AS
BEGIN
	SET NOCOUNT OFF;
	
	IF (@iFlag = 1)
	BEGIN	
		INSERT INTO NETWORK.T_Software_Detail
		(I_Software_ID,I_Centre_Id,S_Act_Version,S_Act_License_No,S_Crtd_By,
		Dt_Crtd_On,I_Status)
		VALUES
		(@iSoftwareID,@iCenterID,@sActVersion,@sActLicense,@sCreatedBy,
			@dtCreatedOn,1)
	END
	ELSE IF (@iFlag = 2)
	BEGIN	
		UPDATE NETWORK.T_Software_Detail
			SET S_Act_Version = @sActVersion,
				S_Act_License_No = @sActLicense,
				S_Upd_By = @sCreatedBy,
				Dt_Upd_On = @dtCreatedOn
			WHERE I_Centre_Id = @iCenterID
				AND I_Software_ID = @iSoftwareID
				AND I_Status <> 0
	END 
	ELSE
	BEGIN
		UPDATE NETWORK.T_Software_Detail
			SET I_Status = 0,
				S_Upd_By = @sCreatedBy,
				Dt_Upd_On = @dtCreatedOn
			WHERE I_Centre_Id = @iCenterID
				AND I_Software_ID = @iSoftwareID
				AND I_Status <> 0
	END
	
END
