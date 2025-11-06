CREATE PROCEDURE [dbo].[UAT_ERP_GetRouteDetails]
    @I_Route_ID INT,
    @I_Brand_ID INT
AS
BEGIN
    SELECT 
        bm.I_Route_ID AS RouteId,
        bm.S_Route_No AS RouteName,
        bm.S_Location AS StartLocation,
        bm.start_latitude AS StartLatitude,
        bm.start_longitude AS StartLongitude,
        tm.I_PickupPoint_ID AS PickupId,
        tm.S_PickupPoint_Name AS PickupName,
        tm.PickPoint_Landmark AS Landmark,
        tm.Pickup_Full_Address AS FullAddress,
        tm.pickup_latitude AS Latitude,
        tm.pickup_longitude AS Longitude,
        tm.pickup_index AS PickupOrder,
        tm.drop_index AS DropOrder,
        tm.N_Fees AS PickupFee
    FROM 
        T_BusRoute_Master bm
    LEFT JOIN 
        T_Route_Transport_Map rtm ON bm.I_Route_ID = rtm.I_Route_ID
    LEFT JOIN 
        T_Transport_Master tm ON tm.I_PickupPoint_ID = rtm.I_PickupPoint_ID
    WHERE 
        bm.I_Brand_ID = @I_Brand_ID 
        AND bm.I_Status = 1 
        AND bm.I_Route_ID = @I_Route_ID
		AND (tm.I_Status = 1 OR tm.I_Status IS NULL)
        AND (rtm.I_Status = 1 OR rtm.I_Status IS NULL)
    GROUP BY 
        bm.I_Route_ID,
        bm.S_Route_No,
        bm.S_Location,
        bm.start_latitude,
        bm.start_longitude,
		tm.pickup_index,
        tm.I_PickupPoint_ID,
        tm.S_PickupPoint_Name,
        tm.PickPoint_Landmark,
        tm.Pickup_Full_Address,
        tm.pickup_latitude,
        tm.pickup_longitude,        
        tm.drop_index,
        tm.N_Fees;
END
