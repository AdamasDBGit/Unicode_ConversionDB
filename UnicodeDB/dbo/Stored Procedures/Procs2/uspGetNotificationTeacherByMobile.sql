CREATE PROCEDURE [dbo].[uspGetNotificationTeacherByMobile]
(
    @sToken NVARCHAR(MAX),
    @iInterval INT,
    @baseURL NVARCHAR(200)
)
AS 
BEGIN TRY
    SET NOCOUNT ON;
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

    DECLARE @Days INT;
    SET @Days = CASE @iInterval
                    WHEN 1 THEN 1 -- days
                    WHEN 2 THEN 2
                    WHEN 3 THEN 7
                    WHEN 4 THEN 15
                    WHEN 5 THEN 30
                    WHEN 6 THEN 90
                    WHEN 7 THEN 180
                    WHEN 8 THEN 365
                END;

  
  SELECT 
        NL.inNotificationLogsId AS ID,
        NL.stTemplateTitle AS Title,
        NL.stRenderMessageBody AS Message,
        NL.dtCreatedDate AS Date,
        EC.I_Event_Category_ID AS CategoryID,
        EC.S_Event_Category AS Category,
		NL.inReadStatus AS ReadStatus,
        CASE 
            WHEN NS.stPushAttachment IS NULL THEN NULL
            ELSE CONCAT(@baseURL, REPLACE(NS.stPushAttachment, '\', '/'))
        END AS Images
    FROM T_ERP_Notification_Schedule_Logs NL
    JOIN T_ERP_Notification_Schedule NS ON NS.inNotificationScheduleId = NL.inNotificationScheduleId
    JOIN T_Event_Category EC ON EC.I_Event_Category_ID = NS.inCategoryId	
	JOIN T_ERP_USER U ON U.I_User_ID = TRY_CONVERT(INT, NL.stTeacherId)
    WHERE U.S_Token = @sToken 
       -- AND NL.dtCreatedDate >= DATEADD(DAY, -@Days, GETDATE()) 
       --  AND NS.dtCreatedDate < GETDATE()
       AND NL.inDeliveryChannelId = 3 AND NL.inSendStatus = 1
    ORDER BY NL.dtCreatedDate DESC;

END TRY

BEGIN CATCH
    ROLLBACK TRANSACTION;
    DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity INT;
    SELECT @ErrMsg = ERROR_MESSAGE(), @ErrSeverity = ERROR_SEVERITY();
    RAISERROR (@ErrMsg, @ErrSeverity, 1);
END CATCH;