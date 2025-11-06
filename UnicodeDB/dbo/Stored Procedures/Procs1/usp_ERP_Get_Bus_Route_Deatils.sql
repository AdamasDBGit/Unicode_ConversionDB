-- ===================================================================  
-- Author : Surya Narayan Chakraborty.  
-- Created On : 29/10/2025  
-- ===================================================================  
  
--exec [dbo].[usp_ERP_Get_Bus_Route_Deatils] 107;      
CREATE PROCEDURE [dbo].[usp_ERP_Get_Bus_Route_Deatils]      
@iBrandID INT = NULL      
AS      
BEGIN      
SET NOCOUNT ON;      
BEGIN TRY      
    -- Get distinct route details with pickup point count
    SELECT DISTINCT 
        a.I_Route_ID,     
        a.S_Route_No,     
        a.S_Location,     
        a.start_latitude,     
        a.start_longitude,
        COUNT(b.I_PickupPoint_ID) AS Total_PickupPoints    
    FROM T_BusRoute_Master a      
    LEFT JOIN T_Route_Transport_Map b on a.I_Route_ID = b.I_Route_ID      
    WHERE EXISTS (
        SELECT 1 FROM T_Transport_Master tm 
        WHERE tm.I_PickupPoint_ID = b.I_PickupPoint_ID 
        AND tm.I_Brand_ID = @iBrandID
    )
    GROUP BY 
        a.I_Route_ID,     
        a.S_Route_No,     
        a.S_Location,     
        a.start_latitude,     
        a.start_longitude
    ORDER BY a.I_Route_ID;      
END TRY      
BEGIN CATCH      
    -- Error handling here    
END CATCH    
END;

