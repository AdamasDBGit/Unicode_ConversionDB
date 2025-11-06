  
  
CREATE   PROCEDURE [dbo].[uspGetNotificationDelivery]    
(    
@NotificationDeliveryID int    
)    
    
AS     
    
BEGIN TRY    
    
    SET NoCount ON ;    
 SET TRANSACTION ISOLATION LEVEL READ COMMITTED;    
    
SELECT     
I_NotificationDelivery_ID NotificationDelivery_ID    
,S_NotificationDelivery_Name NotificationDelivery_Name    
FROM T_ERP_NotificationDelivery where Is_Active=1 and I_Status=0 and I_NotificationDelivery_ID = ISNULL(@NotificationDeliveryID,I_NotificationDelivery_ID)    
     
END TRY    
    
BEGIN CATCH    
 ROLLBACK TRANSACTION    
    DECLARE @ErrMsg Nnvarchar(max),@ErrSeverity INT    
    SELECT  @ErrMsg = ERROR_MESSAGE(),@ErrSeverity = ERROR_SEVERITY()    
    RAISERROR ( @ErrMsg, @ErrSeverity, 1 )    
    
END CATCH    
  