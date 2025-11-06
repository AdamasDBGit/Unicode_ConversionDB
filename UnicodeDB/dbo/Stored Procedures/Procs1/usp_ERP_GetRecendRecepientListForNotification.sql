--EXEC [usp_ERP_GetRecendRecepientListForNotification] '32105'

CREATE PROCEDURE [dbo].[usp_ERP_GetRecendRecepientListForNotification]
(
    @logids NVARCHAR(MAX)
)
AS 
BEGIN TRY
    SET NOCOUNT ON;
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SELECT 
	T1.inNotificationLogsID,
	T1.inDeliveryChannelId,
	T1.stPushTitle,
	T1.stTemplateTitle,
	T1.stEmailTemplateMessage,
	T1.stEmailSubject,
	T1.stPushTemplateMessage,
	T1.stRenderMessageBody,
	T2.stEmailAttachment,
	T2.stPushAttachment,
	T2.inNotificationScheduleID,
	T3.S_Guardian_Email guardianEmail,
	CASE WHEN T3.I_IsTokenActive=0
	THEN Null
	WHEN T3.I_IsTokenActive=1
	THEN
	T3.S_Firebase_Token
	END AS stFireBaseToken
	FROM T_ERP_Notification_Schedule_Logs T1 
	INNER JOIN T_ERP_Notification_Schedule T2 ON T2.inNotificationScheduleID=T1.inNotificationScheduleID
	INNER JOIN T_Parent_Master T3 ON T3.I_Parent_Master_ID=T1.inParentMasterID
	WHERE T1.inNotificationLogsID 
    IN (SELECT Value FROM dbo.ERP_SplitString(@logids, ',')) --AND T1.inSendStatus in (2,3)      
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity INT;
    SELECT @ErrMsg = ERROR_MESSAGE(), @ErrSeverity = ERROR_SEVERITY();
    RAISERROR (@ErrMsg, @ErrSeverity, 1);
END CATCH;