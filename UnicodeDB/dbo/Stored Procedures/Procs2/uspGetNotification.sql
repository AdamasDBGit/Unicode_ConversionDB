CREATE PROCEDURE [dbo].[uspGetNotification]    
(    
    @NotificationTemplateId INT = NULL    
)    
AS    
BEGIN    
    SET NOCOUNT ON;  
  
    SELECT    
        NT.inNotificationTemplateID,    
        NT.stTemplateTitle,    
        NT.stSMSTemplateMessage,    
        NT.stPushTemplateMessage,    
        NT.stEmailTemplateMessage,    
        NT.I_Status AS Status,    
        NT.I_Deleted AS Deleted,    
        NT.I_IsApproved AS IsApproved,    
        -- Get delivery channel names  
        STUFF((  
            SELECT ', ' + ND2.S_NotificationDelivery_Name  
            FROM dbo.SplitString(NT2.stDeliveryChannelID, ',') AS DC  
            INNER JOIN T_ERP_NotificationDelivery ND2   
                ON ND2.I_NotificationDelivery_ID = CAST(DC.Value AS INT)  
            WHERE NT2.inNotificationTemplateID = NT.inNotificationTemplateID  
            FOR XML PATH(''), TYPE).value('.', 'Nnvarchar(max)'), 1, 2, '') AS DeliveryChannelName,  
          
        NTT.S_NotificationType_Name AS NotificationTypeName,    
        EC.S_Event_Category AS NotificationCategory    
    FROM T_NotificationTemplate NT    
    JOIN T_ERP_NotificationType NTT ON NTT.I_NotificationType_ID = NT.inNotificationTypeID    
    JOIN T_Event_Category EC ON EC.I_Event_Category_ID = NT.inNotificationCategoryID    
    -- Needed for correlated subquery inside STUFF()  
    OUTER APPLY (SELECT NT2.stDeliveryChannelID, NT2.inNotificationTemplateID FROM T_NotificationTemplate NT2 WHERE NT2.inNotificationTemplateID = NT.inNotificationTemplateID) AS NT2  
    WHERE (@NotificationTemplateId IS NULL OR NT.inNotificationTemplateID = @NotificationTemplateId)    
          AND NT.I_Deleted = 0;  
END;  