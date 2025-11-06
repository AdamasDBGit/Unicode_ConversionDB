CREATE PROCEDURE [dbo].[UAT_ERP_Get_Routes_With_Pickup_Count]
    @BrandID INT
AS
BEGIN
    SELECT 
        bm.I_Route_ID,
        bm.S_Route_No,
        bm.start_latitude,
        bm.start_longitude,
        COUNT(tm.I_PickupPoint_ID) AS PickupPointCount
    FROM 
        T_BusRoute_Master bm 
    LEFT JOIN 
        T_Route_Transport_Map rtm 
        ON bm.I_Route_ID = rtm.I_Route_ID
    LEFT JOIN 
        T_Transport_Master tm 
        ON tm.I_PickupPoint_ID = rtm.I_PickupPoint_ID
    WHERE 
        bm.I_Status = 1 
        AND (tm.I_Status = 1 OR tm.I_Status IS NULL) 
        AND (rtm.I_Status = 1 OR rtm.I_Status IS NULL)
        AND bm.I_Brand_ID = @BrandID
    GROUP BY 
        bm.I_Route_ID,
        bm.S_Route_No,
        bm.start_latitude,
        bm.start_longitude
    ORDER BY 
        bm.S_Route_No;
END;
