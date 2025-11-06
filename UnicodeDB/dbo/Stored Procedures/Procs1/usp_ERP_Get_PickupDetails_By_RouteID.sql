-- ========================================================================
-- Author : Surya Narayan Chakraborty.
-- Created On : 01/11/2025
-- ========================================================================

-- EXEC [dbo].[usp_ERP_Get_PickupDetails_By_RouteID] 15;  
CREATE PROCEDURE [dbo].[usp_ERP_Get_PickupDetails_By_RouteID]  
    @RouteID INT  
AS  
BEGIN  
    SET NOCOUNT ON;  
      
    BEGIN TRY   
        SELECT DISTINCT  
            a.I_Route_ID,   
            a.S_Route_No,  
            c.I_PickupPoint_ID,   
            c.S_PickupPoint_Name,   
            c.pickup_latitude,   
            c.pickup_longitude,      
            c.pickup_index,     
            c.drop_index,     
            c.Pickup_Full_Address,     
            c.I_Brand_ID,  
            ISNULL(StudentCounts.Total_Students, 0) AS Total_Student_per_PickupPoint  
        FROM T_BusRoute_Master a    
        INNER JOIN T_Route_Transport_Map b ON a.I_Route_ID = b.I_Route_ID    
        INNER JOIN T_Transport_Master c ON c.I_PickupPoint_ID = b.I_PickupPoint_ID   
        LEFT JOIN (  
            SELECT   
                d.I_PickupPoint_ID,  
                COUNT(DISTINCT d.I_Student_Detail_ID) AS Total_Students  
            FROM T_Student_Transport_History d  
            INNER JOIN T_Route_Transport_Map rtm ON d.I_PickupPoint_ID = rtm.I_PickupPoint_ID  
            WHERE rtm.I_Route_ID = @RouteID  
            GROUP BY d.I_PickupPoint_ID  
        ) AS StudentCounts ON c.I_PickupPoint_ID = StudentCounts.I_PickupPoint_ID  
        WHERE a.I_Route_ID = @RouteID  
        ORDER BY c.pickup_index, c.I_PickupPoint_ID;  
    END TRY      
    BEGIN CATCH      
        -- Error handling here  
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();  
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();  
        DECLARE @ErrorState INT = ERROR_STATE();  
          
        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);  
    END CATCH    
  
END;  