CREATE   PROCEDURE [dbo].[uspGetNotificationType]    
(    
@NotificationTypeID int    
)    
    
AS     
    
BEGIN TRY    
    
    SET NoCount ON ;    
 SET TRANSACTION ISOLATION LEVEL READ COMMITTED;    
    
SELECT     
I_NotificationType_ID NotificationTypeID    
,S_NotificationType_Name NotificationTypeName    
FROM T_ERP_NotificationType where I_status = 0 and Is_Active=1 and I_NotificationType_ID = ISNULL(@NotificationTypeID,I_NotificationType_ID)    
     
END TRY    
    
BEGIN CATCH    
 ROLLBACK TRANSACTION    
    DECLARE @ErrMsg NVARCHAR(max),@ErrSeverity INT    
    SELECT  @ErrMsg = ERROR_MESSAGE(),@ErrSeverity = ERROR_SEVERITY()    
    RAISERROR ( @ErrMsg, @ErrSeverity, 1 )    
    
END CATCH    
  
