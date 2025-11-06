CREATE PROCEDURE [dbo].[USP_ERP_GetBusMaster_List_v2]
(
    @iBrandID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        I_Bus_ID,
        S_Bus_Number     AS BusNumber,
        I_Total_Seat     AS TotalSeat,
        S_Tracking_Device_ID AS TrackingDevice,
        I_Flag,
        Dt_CreatedAt,
        Dt_UpdatedAt
    FROM T_ERP_BusMaster
    WHERE I_Brand_ID = @iBrandID
      AND I_Flag IN (0, 1)       -- Include only active/not deleted
    ORDER BY I_Bus_ID DESC;       -- Optional: Keep same sorting as before
END