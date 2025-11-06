CREATE   PROCEDURE USP_ERP_GetBusMaster_Details_v2
(
    @BusID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        I_Bus_ID,
        I_Brand_ID,
        S_Bus_Number,
        I_Total_Seat,
        S_Tracking_Device_ID,
        Dt_CreatedAt,
        Dt_UpdatedAt,
        I_Flag
    FROM 
        T_ERP_BusMaster   -- change to your actual table name if different
    WHERE 
        I_Bus_ID = @BusID;
END