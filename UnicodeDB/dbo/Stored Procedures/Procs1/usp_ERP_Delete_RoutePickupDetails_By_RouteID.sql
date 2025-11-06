-- ==================================================================
--  Author : Surya Narayan Chakraborty
--  Creatd On : 02/11/2025
-- ==================================================================

-- exec [dbo].[usp_ERP_Delete_RoutePickupDetails_By_RouteID] 237;
CREATE PROCEDURE [dbo].[usp_ERP_Delete_RoutePickupDetails_By_RouteID]
    @RouteID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        IF NOT EXISTS (SELECT 1 FROM T_BusRoute_Master WHERE I_Route_ID = @RouteID)
        BEGIN
            RAISERROR('RouteID does not exist', 16, 1);
            RETURN;
        END

        -- Delete from T_BusRoute_Master
        DELETE FROM T_BusRoute_Master 
        WHERE I_Route_ID = @RouteID;

        -- Delete from T_Transport_Master
        DELETE FROM T_Transport_Master 
              WHERE I_PickupPoint_ID NOT IN (
                SELECT DISTINCT I_PickupPoint_ID 
                FROM T_Route_Transport_Map
                );
        
        -- Delete from T_Route_Transport_Map
        DELETE FROM T_Route_Transport_Map 
        WHERE I_Route_ID = @RouteID;
        
        COMMIT TRANSACTION;
        
        -- Return success message
        SELECT 'Route pickup details and mappings deleted successfully' AS Message;
        
    END TRY    
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
            
        -- Error handling
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        
        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH  
END;