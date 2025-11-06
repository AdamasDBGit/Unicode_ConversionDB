CREATE PROCEDURE [dbo].[uspGetSetCenterStatus] 
	@iCenterID INT,
	@iFlag int

AS
BEGIN
	IF (@iFlag = 0)
	BEGIN
		SELECT I_Status from dbo.T_Centre_Master
		where I_Centre_Id = @iCenterID
	END
	ELSE
	BEGIN
		update dbo.T_Centre_Master
		set I_Status = @iFlag
		where I_Centre_Id = @iCenterID

		SELECT @iFlag AS I_Status
	END
END
