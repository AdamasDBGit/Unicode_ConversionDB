CREATE PROCEDURE [dbo].[USP_ERP_DeleteBusMaster]
(
    @iBusID    INT,   -- Bus to delete
    @iBrandID  INT,   -- Brand check (safety)
    @iUserID   INT    -- User performing action
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE T_ERP_BusMaster
        SET 
            I_Flag = 2,               -- Soft delete
            Dt_UpdatedAt = GETDATE()
        WHERE I_Bus_ID = @iBusID
          AND I_Brand_ID = @iBrandID
          AND I_Flag <> 2;            -- Only if not already deleted

        COMMIT TRANSACTION;

        SELECT 
            1 AS Status,
            'Bus deleted successfully' AS Message,
            @iBusID AS BusID;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;

        SELECT 
            0 AS Status,
            ERROR_MESSAGE() AS Message,
            @iBusID AS BusID;
    END CATCH
END;
