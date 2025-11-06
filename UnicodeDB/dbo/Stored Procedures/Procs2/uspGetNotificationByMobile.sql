--EXEC uspGetNotificationByMobile '16-0237','84914D57655E48228F615B0E4419C654','6','https://sms-staging.arivoo.in/'    
    
CREATE PROCEDURE [dbo].[uspGetNotificationByMobile]    
(    
    @sStudentID NVARCHAR(15),    
 @sToken NVARCHAR(200),    
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
        --NL.stRenderMessageBody AS Message,    
  COALESCE(  
        NL.stRenderMessageBody,  
        NL.stPushTemplateMessage,  
        NL.stEmailTemplateMessage,  
        NL.stSMSTemplateMessage  
                ) as Message,  
        NL.dtCreatedDate AS Date,    
        EC.I_Event_Category_ID AS CategoryID,    
        EC.S_Event_Category AS Category,    
  NL.inReadStatus AS ReadStatus,    
        CASE     
           WHEN NS.stPushAttachment IS NULL THEN NULL    
    WHEN NS.stPushAttachment NOT LIKE '%adamasworldschool%' THEN NULL    
    ELSE NS.stPushAttachment    
        END AS Images    
    FROM T_ERP_Notification_Schedule_Logs NL    
    JOIN T_ERP_Notification_Schedule NS ON NS.inNotificationScheduleId = NL.inNotificationScheduleId    
    JOIN T_Event_Category EC ON EC.I_Event_Category_ID = NS.inCategoryId    
 JOIN T_Parent_Master PM ON PM.I_Parent_Master_ID=NL.inParentMasterID    
    WHERE NL.stStudentId = @sStudentID     
  AND PM.S_Token = @sToken    
        AND (    
    (@iInterval = 1 AND NL.dtCreatedDate >= CAST(GETDATE() AS DATE))    
    OR (@iInterval <> 1 AND NL.dtCreatedDate >= DATEADD(DAY, -@Days, GETDATE()))    
)    
        AND NS.dtCreatedDate < GETDATE()    
        AND NL.inDeliveryChannelId = 3 --AND NL.inSendStatus = 1    
    ORDER BY NL.dtCreatedDate DESC;    
END TRY    
    
    
    
BEGIN CATCH    
    ROLLBACK TRANSACTION;    
    DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity INT;    
    SELECT @ErrMsg = ERROR_MESSAGE(), @ErrSeverity = ERROR_SEVERITY();    
    RAISERROR (@ErrMsg, @ErrSeverity, 1);    
END CATCH;