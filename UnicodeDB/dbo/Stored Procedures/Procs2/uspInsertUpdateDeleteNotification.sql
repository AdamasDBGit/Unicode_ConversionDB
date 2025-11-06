CREATE PROCEDURE [dbo].[uspInsertUpdateDeleteNotification]    
(    
    @inNotificationTemplateID INT = NULL,    
    @stTemplateTitle NVARCHAR(200),    
    @stEmailSubject NVARCHAR(200) = NULL,    
    @stSMSTemplateMessage NVARCHAR(MAX) = NULL,    
    @stPushTemplateMessage NVARCHAR(MAX) = NULL,    
    @stEmailTemplateMessage NVARCHAR(MAX) = NULL,    
    @inNotificationTypeID INT,    
    @inNotificationCategoryID INT,    
    @stDeliveryChannelID NVARCHAR(100),    
    @inCreatedBy INT,    
    @Status INT,    
    @stPushTitle NVARCHAR(100) = NULL,    

    -- 🔹 Newly added fields
    @inNotificationType INT = NULL,    
    @inEvent INT = NULL    
)    
AS    
BEGIN    
    BEGIN TRY      
        BEGIN TRANSACTION      

        -- 🔹 Common Validation: Check duplicate event
        IF EXISTS (
            SELECT 1 
            FROM T_NotificationTemplate 
            WHERE inEvent = @inEvent 
              AND I_Deleted = 0
              AND (@inNotificationTemplateID IS NULL OR inNotificationTemplateID <> @inNotificationTemplateID) -- exclude self on update
        )
        BEGIN
            SELECT 0 AS statusFlag, 'Another notification is already tagged with this Event. Only one template can be linked to a given Event.' AS Message    
            ROLLBACK TRANSACTION    
            RETURN    
        END

        -- INSERT OPERATION    
        IF @inNotificationTemplateID IS NULL OR @inNotificationTemplateID = 0    
        BEGIN    
            INSERT INTO T_NotificationTemplate    
            (    
                stTemplateTitle,    
                stSMSTemplateMessage,    
                stPushTemplateMessage,    
                stEmailTemplateMessage,    
                stEmailSubject,    
                inNotificationTypeID,    
                inNotificationCategoryID,    
                stDeliveryChannelID,    
                dtCreatedDate,    
                inCreatedBy,    
                I_Status,    
                I_Deleted,    
                I_IsApproved,       
                stPushTitle,    
                inNotificationType,    
                inEvent    
            )    
            VALUES    
            (    
                @stTemplateTitle,    
                @stSMSTemplateMessage,    
                @stPushTemplateMessage,    
                @stEmailTemplateMessage,    
                @stEmailSubject,    
                @inNotificationTypeID,    
                @inNotificationCategoryID,    
                @stDeliveryChannelID,    
                GETDATE(),    
                @inCreatedBy,    
                @Status,    
                0,    
                1,    
                @stPushTitle,    
                @inNotificationType,    
                @inEvent    
            )    
    
            SELECT 1 AS statusFlag, 'Notification created successfully' AS Message    
        END    
        -- UPDATE OPERATION    
        ELSE     
        BEGIN    
            IF EXISTS (SELECT 1 FROM T_NotificationTemplate WHERE inNotificationTemplateID = @inNotificationTemplateID AND I_Deleted = 0)    
            BEGIN    
                UPDATE T_NotificationTemplate    
                SET     
                    stTemplateTitle = @stTemplateTitle,    
                    stSMSTemplateMessage = @stSMSTemplateMessage,    
                    stPushTemplateMessage = @stPushTemplateMessage,    
                    stEmailTemplateMessage = @stEmailTemplateMessage,    
                    stEmailSubject = @stEmailSubject,    
                    inNotificationTypeID = @inNotificationTypeID,    
                    inNotificationCategoryID = @inNotificationCategoryID,    
                    stDeliveryChannelID = @stDeliveryChannelID,    
                    inCreatedBy = @inCreatedBy,    
                    I_Status = @Status,    
                    stPushTitle = @stPushTitle,    
                    inNotificationType = @inNotificationType,    
                    inEvent = @inEvent    
                WHERE inNotificationTemplateID = @inNotificationTemplateID    
    
                SELECT 1 AS statusFlag, 'Notification updated successfully' AS Message    
            END    
            ELSE     
            BEGIN    
                SELECT 0 AS statusFlag, 'Notification template not found or deleted' AS Message    
                ROLLBACK TRANSACTION    
                RETURN    
            END    
        END    
    
        COMMIT TRANSACTION      
    END TRY     
    BEGIN CATCH     
        IF @@TRANCOUNT > 0      
            ROLLBACK TRANSACTION      
            
        SELECT 0 AS statusFlag, 'Something went wrong!', ERROR_MESSAGE() AS errorMessage    
    END CATCH      
END
