--EXEC uspGetNotificationByMobile '16-0237','84914D57655E48228F615B0E4419C654','6','https://sms-staging.arivoo.in/'

CREATE PROCEDURE [dbo].[uspUpdateNotificatinReadStatus]
(
    @inNotificationID int
)
AS 
BEGIN TRY
    SET NOCOUNT ON;
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

    UPDATE T_ERP_Notification_Schedule_Logs set inReadStatus =1 where inNotificationLogsID=@inNotificationID
	select 1 StatusFlag,'Status updated' Message
END TRY



BEGIN CATCH
    ROLLBACK TRANSACTION;
    DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity INT;
    SELECT @ErrMsg = ERROR_MESSAGE(), @ErrSeverity = ERROR_SEVERITY();
    RAISERROR (@ErrMsg, @ErrSeverity, 1);
END CATCH;