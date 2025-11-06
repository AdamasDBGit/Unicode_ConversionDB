CREATE   PROCEDURE [dbo].[uspApproveNotificationTemplate]  
(  
 @NotificationTemplateId INT,  
 @Approved INT  
)  
AS  
BEGIN  
 BEGIN TRY    
  BEGIN TRANSACTION    
  
   UPDATE T_NotificationTemplate set I_IsApproved = @Approved  
   WHERE inNotificationTemplateID = @NotificationTemplateId  
  
   SELECT 1 as statusFlag,'Template approved successfully' as Message  
  
   COMMIT TRANSACTION    
 END TRY   
 BEGIN CATCH   
  IF @@TRANCOUNT > 0    
  ROLLBACK TRANSACTION    
   SELECT 0 AS statusFlag,'Something went wrong!' AS Message,ERROR_MESSAGE() as errorMessage  
 END CATCH    
END  