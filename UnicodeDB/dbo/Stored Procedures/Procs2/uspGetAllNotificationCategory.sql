CREATE   PROCEDURE [dbo].[uspGetAllNotificationCategory]  
(  
 @NotificationCategoryID INT NULL  
)  
AS   
  
BEGIN TRY  
  
    SET NoCount ON ;  
 SET TRANSACTION ISOLATION LEVEL READ COMMITTED;  
  
  SELECT   
   I_NotificationCategory_ID NotificationCategory_ID  
   ,S_NotificationCategory_Name NotificationCategory_Name  
  FROM   
   T_NotificationCategory   
  WHERE   
   I_status = 1   
   
END TRY  
  
BEGIN CATCH  
 ROLLBACK TRANSACTION  
    DECLARE @ErrMsg Nnvarchar(max),@ErrSeverity INT  
    SELECT  @ErrMsg = ERROR_MESSAGE(),@ErrSeverity = ERROR_SEVERITY()  
    RAISERROR ( @ErrMsg, @ErrSeverity, 1 )  
  
END CATCH  