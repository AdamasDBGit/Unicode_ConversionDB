CREATE PROCEDURE [dbo].[USP_ERP_DeleteGuardMaster]
(
    @I_Guard_ID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Hard delete
        DELETE FROM T_ERP_GuardMaster
        WHERE I_Guard_ID = @I_Guard_ID;

        COMMIT TRANSACTION;

        SELECT
            1 AS StatusFlag,
            'Guard deleted successfully' AS Message,
            @I_Guard_ID AS I_Guard_ID;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;

        SELECT
            0 AS StatusFlag,
            ERROR_MESSAGE() AS Message,
            @I_Guard_ID AS I_Guard_ID;
    END CATCH
END;