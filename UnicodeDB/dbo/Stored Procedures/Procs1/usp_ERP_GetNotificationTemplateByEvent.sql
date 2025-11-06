  
  
CREATE PROCEDURE [dbo].[usp_ERP_GetNotificationTemplateByEvent]  
(  
    @inEventId INT  
)  
AS  
BEGIN  
    SET NOCOUNT ON;  
  
    BEGIN TRY  
        IF EXISTS (  
            SELECT 1   
            FROM T_NotificationTemplate   
            WHERE inEvent = @inEventId   
              AND I_Deleted = 0   
              AND I_IsApproved = 1  
        )  
        BEGIN  
            SELECT   
                inNotificationTemplateID AS TemplateId,  
                stTemplateTitle,  
                inNotificationTypeID AS TypeId,  
                inNotificationCategoryID AS CategoryId,  
                stDeliveryChannelID AS DeliveryChannelId,  
                inNotificationType,  
                inEvent,  
                stPushTitle,  
                stEmailSubject,  
                stSMSTemplateMessage,  
                stPushTemplateMessage,  
                stEmailTemplateMessage  ,
                inNotificationType inNotificationDefinedTypeId,
                inEvent inEventTypeId
            FROM T_NotificationTemplate  
            WHERE inEvent = @inEventId   
              AND I_Deleted = 0   
              AND I_IsApproved = 1;  
        END  
        ELSE  
        BEGIN  
            SELECT 0 AS statusFlag, 'No active notification template found for this Event' AS Message;  
        END  
    END TRY  
    BEGIN CATCH  
        SELECT 0 AS statusFlag, ERROR_MESSAGE() AS errorMessage;  
    END CATCH  
END  