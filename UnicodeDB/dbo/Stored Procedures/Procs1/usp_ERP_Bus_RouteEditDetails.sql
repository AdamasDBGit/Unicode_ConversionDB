CREATE PROCEDURE [dbo].[usp_ERP_Bus_RouteEditDetails]      
@RouteID INT = NULL      
AS      
BEGIN      
SET NOCOUNT ON;      
BEGIN TRY      
           SELECT DISTINCT a.I_Route_ID, a.S_Route_No, a.start_latitude, a.start_longitude, a.S_Location, 
                     c.I_PickupPoint_ID, c.S_PickupPoint_Name,c.pickup_latitude, c.pickup_longitude,    
                     c.PickPoint_Landmark, c.pickup_index, c.drop_index,     
                     c.S_PickupPoint_Location, c.Pickup_Full_Address, c.I_Brand_ID      
              FROM T_BusRoute_Master a      
        INNER JOIN T_Route_Transport_Map b on a.I_Route_ID = b.I_Route_ID      
        INNER JOIN T_Transport_Master c on c.I_PickupPoint_ID = b.I_PickupPoint_ID      
        --inner join T_Student_Transport_History d on d.I_PickupPoint_ID = c.I_PickupPoint_ID      
        WHERE a.I_Route_ID = @RouteID      
        ORDER BY a.I_Route_ID;      
      
    END TRY      
BEGIN CATCH      
     END CATCH      
END