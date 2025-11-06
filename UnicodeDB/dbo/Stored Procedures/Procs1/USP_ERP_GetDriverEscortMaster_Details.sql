CREATE PROCEDURE [dbo].[USP_ERP_GetDriverEscortMaster_Details]
    @I_Driver_Escort_ID INT
AS
BEGIN
    SELECT *
    FROM T_ERP_DriverEscortMaster
    WHERE I_Driver_Escort_ID = @I_Driver_Escort_ID;
END;