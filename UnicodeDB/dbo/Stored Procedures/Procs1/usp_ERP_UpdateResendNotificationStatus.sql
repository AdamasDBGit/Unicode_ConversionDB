CREATE PROCEDURE [dbo].[usp_ERP_UpdateResendNotificationStatus]
(
    @inNotificationLogsID int,
	@inSendStatus int,
	@stNotificationStatus NVARCHAR(max),
	@stErrorMessage NVARCHAR(max)=null

)
AS 
BEGIN TRY
    SET NOCOUNT ON;
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
   UPDATE T_ERP_Notification_Schedule_Logs 
   SET inSendStatus=@inSendStatus,
   stNotificationStatus=@stNotificationStatus,
   stErrorMessage = @stErrorMessage
   WHERE inNotificationLogsID=@inNotificationLogsID
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    DECLARE @ErrMsg NVARCHAR(max), @ErrSeverity INT;
    SELECT @ErrMsg = ERROR_MESSAGE(), @ErrSeverity = ERROR_SEVERITY();
    RAISERROR (@ErrMsg, @ErrSeverity, 1);
END CATCH;
