CREATE PROCEDURE [dbo].[USP_ERP_DeleteDriverEscortMaster]  
(
    @I_Driver_Escort_ID INT       -- Driver/Escort to delete
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Soft delete if you want (set a flag instead of hard delete)
        -- UPDATE T_ERP_DriverEscortMaster
        -- SET I_Flag = 2,
        --     updated_at = GETDATE()
        -- WHERE I_Driver_Escort_ID = @I_Driver_Escort_ID
        --   AND I_Flag <> 2;

        -- Or hard delete
        DELETE FROM T_ERP_DriverEscortMaster
        WHERE I_Driver_Escort_ID = @I_Driver_Escort_ID;

        COMMIT TRANSACTION;

        -- Return success
        SELECT
            1 AS StatusFlag,
            'Driver/Escort deleted successfully' AS Message,
            @I_Driver_Escort_ID AS DriverEscortID;

    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;

        SELECT
            0 AS StatusFlag,
            ERROR_MESSAGE() AS Message,
            @I_Driver_Escort_ID AS DriverEscortID;
    END CATCH
END;