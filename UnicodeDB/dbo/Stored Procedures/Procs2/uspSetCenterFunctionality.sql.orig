CREATE PROCEDURE [dbo].[uspSetCenterFunctionality] 
	@iCenterID INT,
	@sStatusCode Varchar(50),
	@iFlag INT
AS
BEGIN

	IF @iFlag = 0
	BEGIN
		DELETE FROM dbo.T_Center_Functionality_Status WHERE I_Center_ID = @iCenterID
	END
	ELSE
	BEGIN
		INSERT INTO dbo.T_Center_Functionality_Status
		(I_Center_ID,S_Status_Code)
		VALUES 
		(@iCenterID, @sStatusCode)
	END
END
