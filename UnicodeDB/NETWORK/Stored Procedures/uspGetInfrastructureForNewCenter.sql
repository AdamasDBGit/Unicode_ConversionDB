CREATE PROCEDURE [NETWORK].[uspGetInfrastructureForNewCenter]
(
@iCenterID INT
)
AS
BEGIN
	SELECT * FROM NETWORK.T_Center_InfrastructureRequest CIR WITH (NOLOCK)
	WHERE CIR.I_Centre_Id = @iCenterID
END
