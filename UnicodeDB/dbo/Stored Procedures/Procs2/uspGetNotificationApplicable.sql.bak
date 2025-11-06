CREATE   PROCEDURE [dbo].[uspGetNotificationApplicable]    
(    
@NotificationApplicableID int    
)    
    
AS     
    
BEGIN TRY    
    
    SET NoCount ON ;    
 SET TRANSACTION ISOLATION LEVEL READ COMMITTED;    
    
SELECT     
I_NotificationApplicable_ID NotificationApplicableID    
,S_NotificationApplicable_Name NotificationApplicableName    
FROM T_ERP_NotificationApplicable where Is_Active=1 and I_status = 0 and I_NotificationApplicable_ID = ISNULL(@NotificationApplicableID,I_NotificationApplicable_ID)    
     
END TRY    
    
BEGIN CATCH    
 ROLLBACK TRANSACTION    
    DECLARE @ErrMsg NVARCHAR(4000),@ErrSeverity INT    
    SELECT  @ErrMsg = ERROR_MESSAGE(),@ErrSeverity = ERROR_SEVERITY()    
    RAISERROR ( @ErrMsg, @ErrSeverity, 1 )    
    
END CATCH    
  