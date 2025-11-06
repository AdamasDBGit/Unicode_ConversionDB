CREATE PROCEDURE [dbo].[USP_ERP_GetDriverEscortMaster_List]
AS
BEGIN
    SELECT *
    FROM T_ERP_DriverEscortMaster
    ORDER BY I_Driver_Escort_ID DESC;
END;