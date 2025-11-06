-- =================================================================================  
-- Author : Surya Narayan Chakraborty.  
-- Created On : 03/11/2025  
-- =================================================================================  
  
--EXEC [dbo].[usp_ERP_Get_Pickup_Details] 1;  
CREATE PROCEDURE [dbo].[usp_ERP_Get_Pickup_Details]  
@RouteID INT = NULL  
AS  
BEGIN  
SET NOCOUNT ON;  
BEGIN TRY        
              SELECT  
                     c.I_PickupPoint_ID,  
                     c.S_PickupPoint_Name  
              FROM T_BusRoute_Master AS a  
          INNER JOIN T_Route_Transport_Map AS b ON a.I_Route_ID = b.I_Route_ID  
          INNER JOIN T_Transport_Master AS c ON c.I_PickupPoint_ID = b.I_PickupPoint_ID  
          WHERE a.I_Status = 1
          AND b.I_Status = 1
          AND c.I_Status = 1
          --a.I_Route_ID = @RouteID  
          ORDER BY a.I_Route_ID,   
                   c.I_PickupPoint_ID  
  
    END TRY        
BEGIN CATCH        
     END CATCH        
END  
  