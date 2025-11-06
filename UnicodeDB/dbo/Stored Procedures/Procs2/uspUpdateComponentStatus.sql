
CREATE PROCEDURE dbo.uspUpdateComponentStatus
    @Updates dbo.ComponentStatusUpdateType READONLY
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE T_App_Brand_Component_Map
    SET I_Status = U.I_Status
    FROM T_App_Brand_Component_Map BCM
    INNER JOIN @Updates U
        ON BCM.I_App_Component_Master_ID = U.I_App_Component_Master_ID
        AND BCM.I_Brand_ID = U.I_Brand_ID;
END
