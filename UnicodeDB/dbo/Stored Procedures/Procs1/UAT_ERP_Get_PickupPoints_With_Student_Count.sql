CREATE PROCEDURE [dbo].[UAT_ERP_Get_PickupPoints_With_Student_Count]
    @RouteID INT,
    @BrandID INT
AS
BEGIN
    SELECT 
        tm.I_PickupPoint_ID,
        tm.S_PickupPoint_Name,
        tm.pickup_latitude,
        tm.pickup_longitude,
        tm.pickup_index,
        tm.drop_index,
        COUNT(sth.I_Student_Detail_ID) AS totalStudentCount
    FROM 
        T_Transport_Master tm 
    LEFT JOIN 
        T_Route_Transport_Map rtm 
        ON tm.I_PickupPoint_ID = rtm.I_PickupPoint_ID AND rtm.I_Route_ID = @RouteID
    LEFT JOIN 
        T_Student_Transport_History sth 
        ON tm.I_PickupPoint_ID = sth.I_PickupPoint_ID AND sth.I_Route_ID = @RouteID
    WHERE 
        rtm.I_Route_ID = @RouteID 
        AND tm.I_Status = 1 
        AND rtm.I_Status = 1 
        AND tm.I_Brand_ID = @BrandID
    GROUP BY 
        tm.I_PickupPoint_ID,
        tm.S_PickupPoint_Name,
        tm.pickup_latitude,
        tm.pickup_longitude,
        tm.pickup_index,
        tm.drop_index
    ORDER BY 
        tm.pickup_index;
END;
