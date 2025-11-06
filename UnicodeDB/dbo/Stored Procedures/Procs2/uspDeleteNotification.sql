CREATE   PROCEDURE [dbo].[uspDeleteNotification]  
(  
  @NotificationTemplateId INT  
)  
AS  
BEGIN  
 BEGIN TRY    
   BEGIN TRANSACTION         
        
       UPDATE T_NotificationTemplate  
        SET I_Deleted = 1  
       WHERE   
     inNotificationTemplateID = @NotificationTemplateId  
  
      SELECT 1 as statusFlag,'Notification deleted successfully' as Message  
     
  COMMIT TRANSACTION    
 END TRY   
BEGIN CATCH   
IF @@TRANCOUNT > 0    
 ROLLBACK TRANSACTION    
  SELECT 0 as statusFlag,'Something went wrong!' as Message,ERROR_MESSAGE() as errorMessage  
 END CATCH    
END  