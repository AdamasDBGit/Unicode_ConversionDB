CREATE PROCEDURE [dbo].[uspGetNotificationTemplateByID]  
    @inNotificationTemplateID INT  
AS  
BEGIN  
    SET NOCOUNT ON;  
  
    SELECT   
        inNotificationTemplateID AS NotificationTemplateID,  
        stTemplateTitle AS Title,  
        stSMSTemplateMessage AS SMSMessageBody,  
        stPushTemplateMessage AS PushMessageBody,  
        stPushTitle AS PushMessageTitle,  
        stEmailTemplateMessage AS EmailMessageBody,  
        stEmailSubject AS EmailMessageSubject,  
        inNotificationTypeID AS NotificationType,  
        inNotificationCategoryID AS NotificationCategory,  
        stDeliveryChannelID AS stDeliveryChannel,  
        inCreatedBy AS CreatedBy,  
        I_Status AS Status,  
        I_Deleted AS Deleted,  
        I_IsApproved AS IsApproved,  
  
        -- newly added fields  
        inNotificationType AS inNotificationType,  -- Execution Type  
        inEvent AS inEvent                         -- Event  
    FROM   
        T_NotificationTemplate  
    WHERE   
        inNotificationTemplateID = @inNotificationTemplateID  
        AND I_Deleted = 0;  
END  
  
  