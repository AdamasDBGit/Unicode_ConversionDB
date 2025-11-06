CREATE PROCEDURE [dbo].[usp_ERP_UpdateAdhocPaymentScheduleNotification]
(
    @AdhocPaymentScheduleHeaderID INT,
    @inNotificationScheduleID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE T_ERP_AdhocPaymentScheduleHeader
        SET inNotificationScheduleID = @inNotificationScheduleID
        WHERE inAdhocPaymentScheduleHeaderID = @AdhocPaymentScheduleHeaderID;

        COMMIT TRANSACTION;

        -- ? Return Success Response
        SELECT 
            1 AS StatusFlag, 
            'Notification Schedule ID updated successfully.' AS Message,
            @AdhocPaymentScheduleHeaderID AS Id;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;

        DECLARE @ErrorMessage Nnvarchar(max) = ERROR_MESSAGE();

        -- ? Return Error Response
        SELECT 
            0 AS StatusFlag, 
            @ErrorMessage AS Message,
            NULL AS Id;
    END CATCH;
END;
