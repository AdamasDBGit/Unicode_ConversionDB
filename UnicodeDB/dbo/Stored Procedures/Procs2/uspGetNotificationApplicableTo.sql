--exec uspGetNotificationApplicableTo 2    
CREATE   PROCEDURE [dbo].[uspGetNotificationApplicableTo]        
(        
@NotificationApplicableForID int        
)        
        
AS         
        
BEGIN TRY        
        
    SET NoCount ON ;        
 SET TRANSACTION ISOLATION LEVEL READ COMMITTED;        
        
     
SELECT         
I_NotificationApplicableTo_ID NotificationApplicableToID     
,I_NotificationApplicable_ID NotificationApplicableForID  
,S_NotificationApplicableTo_Name NotificationApplicableToName        
FROM T_ERP_NotificationApplicableTo where Is_Active=1 and I_status = 0 and I_NotificationApplicable_ID = ISNULL(@NotificationApplicableForID,I_NotificationApplicable_ID)        
         
END TRY        
        
BEGIN CATCH        
 ROLLBACK TRANSACTION        
    DECLARE @ErrMsg NVARCHAR(4000),@ErrSeverity INT        
    SELECT  @ErrMsg = ERROR_MESSAGE(),@ErrSeverity = ERROR_SEVERITY()        
    RAISERROR ( @ErrMsg, @ErrSeverity, 1 )        
        
END CATCH        