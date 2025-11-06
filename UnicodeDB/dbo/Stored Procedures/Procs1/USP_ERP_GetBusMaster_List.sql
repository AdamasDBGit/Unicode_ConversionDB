CREATE PROCEDURE [dbo].[USP_ERP_GetBusMaster_List]
(
    @iBrandID   INT,
    @Search     NVARCHAR(max) = NULL,  -- optional search text
    @Limit      INT = NULL,            -- pagination
    @Offset     INT = NULL             -- pagination
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Temp table to hold result
    CREATE TABLE #BusList
    (
        I_Bus_ID INT,
        S_Bus_Number NVARCHAR(max),
        I_Total_Seat INT,
        S_Tracking_Device_ID NVARCHAR(max),
        I_Flag TINYINT,
        Dt_CreatedAt DATETIME,
        Dt_UpdatedAt DATETIME
    );

    INSERT INTO #BusList
    SELECT 
        I_Bus_ID,
        S_Bus_Number,
        I_Total_Seat,
        S_Tracking_Device_ID,
        I_Flag,
        Dt_CreatedAt,
        Dt_UpdatedAt
    FROM T_ERP_BusMaster
    WHERE I_Brand_ID = @iBrandID
      AND I_Flag IN (0,1)   -- exclude deleted
      AND (
            @Search IS NULL 
            OR S_Bus_Number LIKE '%' + @Search + '%'
            OR S_Tracking_Device_ID LIKE '%' + @Search + '%'
          );

    -- Final output with paging
    SELECT 
        I_Bus_ID,
        S_Bus_Number AS BusNumber,
        I_Total_Seat AS TotalSeat,
        S_Tracking_Device_ID AS TrackingDevice,
        I_Flag,
        Dt_CreatedAt,
        Dt_UpdatedAt
    FROM #BusList
    ORDER BY I_Bus_ID DESC
    OFFSET ISNULL(@Offset,0) ROWS
    FETCH NEXT ISNULL(@Limit,10) ROWS ONLY;

    -- Return total count for pagination
    SELECT COUNT(1) AS TotalCount FROM #BusList;
END;
