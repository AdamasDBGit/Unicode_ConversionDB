CREATE PROCEDURE [dbo].[UAT_ERP_REMOVE_ROUTE]
    @I_Brand_ID INT,
    @I_Route_ID INT,
    @StatusFlag INT OUTPUT,
    @Message Nnvarchar(max) OUTPUT,
    @ErrorMessage Nnvarchar(max) OUTPUT
AS
BEGIN
    -- Start a transaction
    BEGIN TRANSACTION;
 
    BEGIN TRY
        -- Update T_BusRoute_Master
        UPDATE T_BusRoute_Master
        SET I_Status = 0
        WHERE I_Route_ID = @I_Route_ID AND I_Brand_ID = @I_Brand_ID;
 
        -- Check if the update affected any rows
        IF @@ROWCOUNT = 0
        BEGIN
            -- Set error message if no rows were updated
            SELECT @ErrorMessage = 'No rows updated in T_BusRoute_Master.';
            ROLLBACK TRANSACTION;
            SET @StatusFlag = 0;
            SET @Message = NULL;
            RETURN;
        END
 
        -- Update T_Route_Transport_Map
        UPDATE T_Route_Transport_Map
        SET I_Status = 0
        WHERE I_Route_ID = @I_Route_ID;
 
        -- Check if the update affected any rows
        IF @@ROWCOUNT = 0
        BEGIN
            -- Set error message if no rows were updated
            SELECT @ErrorMessage = 'No rows updated in T_Route_Transport_Map.';
            ROLLBACK TRANSACTION;
            SET @StatusFlag = 0;
            SET @Message = NULL;
            RETURN;
        END
 
        -- Update T_Transport_Master using PickupPoint_IDs from T_Route_Transport_Map
        UPDATE T_Transport_Master
        SET I_Status = 0
        WHERE I_PickupPoint_ID IN (
            SELECT I_PickupPoint_ID
            FROM T_Route_Transport_Map
            WHERE I_Route_ID = @I_Route_ID
        )
        AND I_Brand_ID = @I_Brand_ID;
 
        -- Check if the update affected any rows
        IF @@ROWCOUNT = 0
        BEGIN
            -- Set error message if no rows were updated
            SELECT @ErrorMessage = 'No rows updated in T_Transport_Master.';
            ROLLBACK TRANSACTION;
            SET @StatusFlag = 0;
            SET @Message = NULL;
            RETURN;
        END
 
        -- Commit the transaction
        COMMIT TRANSACTION;
 
        -- Set output parameters for success
        SET @StatusFlag = 1;
        SET @Message = 'Route deleted successfully';
        SET @ErrorMessage = NULL;
    END TRY
    BEGIN CATCH
        -- Rollback the transaction on error
        ROLLBACK TRANSACTION;
 
        -- Set output parameters for failure
        SET @StatusFlag = 0;
        SET @Message = NULL;
        SET @ErrorMessage = ERROR_MESSAGE();
    END CATCH;
END;
