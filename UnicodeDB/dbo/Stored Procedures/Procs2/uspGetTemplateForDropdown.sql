CREATE PROCEDURE [dbo].[uspGetTemplateForDropdown]  
(  
    @inNotificationTypeID INT,  
 @inNotificationCategoryID INT  
)  
AS  
BEGIN  
    SELECT  
        inNotificationTemplateID,  
        stTemplateTitle,  
  stEmailSubject,  
  stEmailTemplateMessage,  
  stSMSTemplateMessage,  
  stPushTemplateMessage,  
  stPushTitle  
    FROM   
        T_NotificationTemplate  
    WHERE   
        inNotificationTypeID = @inNotificationTypeID AND  
  inNotificationCategoryID = @inNotificationCategoryID AND  
  I_IsApproved = 1   
END