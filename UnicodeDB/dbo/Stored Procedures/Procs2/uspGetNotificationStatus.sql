CREATE PROCEDURE [dbo].[uspGetNotificationStatus]  
(  
@NotificationStatusID int  
)  
  
AS   
  
BEGIN TRY  
  
    SET NoCount ON ;  
 SET TRANSACTION ISOLATION LEVEL READ COMMITTED;  
  
SELECT   
I_NotificationStatus_ID NotificationStatusID  
,S_NotificationStatus_Name NotificationStatusName  
FROM T_ERP_NotificationStatus where I_status = 0 and Is_Active=1 and I_NotificationStatus_ID = ISNULL(@NotificationStatusID,I_NotificationStatus_ID)  
   
END TRY  
  
BEGIN CATCH  
 ROLLBACK TRANSACTION  
    DECLARE @ErrMsg NVARCHAR(max),@ErrSeverity INT  
    SELECT  @ErrMsg = ERROR_MESSAGE(),@ErrSeverity = ERROR_SEVERITY()  
    RAISERROR ( @ErrMsg, @ErrSeverity, 1 )  
  
END CATCH  


