CREATE   PROCEDURE [dbo].[uspGetNotificationPriority]    
(    
@NotificationPriorityID int    
)    
    
AS     
    
BEGIN TRY    
    
    SET NoCount ON ;    
 SET TRANSACTION ISOLATION LEVEL READ COMMITTED;    
    
SELECT     
I_NotificationPriority_ID NotificationPriority_ID    
,S_NotificationPriority_Name NotificationPriority_Name    
FROM T_ERP_NotificationPriority where Is_Active=1 and I_Status=0 and I_NotificationPriority_ID = ISNULL(@NotificationPriorityID,I_NotificationPriority_ID)    
     
END TRY    
    
BEGIN CATCH    
 ROLLBACK TRANSACTION    
    DECLARE @ErrMsg NVARCHAR(max),@ErrSeverity INT    
    SELECT  @ErrMsg = ERROR_MESSAGE(),@ErrSeverity = ERROR_SEVERITY()    
    RAISERROR ( @ErrMsg, @ErrSeverity, 1 )    
    
END CATCH    
  
