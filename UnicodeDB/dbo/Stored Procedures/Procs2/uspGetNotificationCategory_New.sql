CREATE   PROCEDURE [dbo].[uspGetNotificationCategory_New]    
(    
 @NotificationCategory_ID int = NULL  
)    
    
AS     
    
BEGIN TRY    
SET NoCount ON ;    
 SET TRANSACTION ISOLATION LEVEL READ COMMITTED;    
    
SELECT     
I_Event_Category_ID NotificationCategory_ID    
,S_Event_Category NotificationCategory_Name    
FROM T_Event_Category where I_Status=1   
     
END TRY    
    
BEGIN CATCH    
 ROLLBACK TRANSACTION    
    DECLARE @ErrMsg NVARCHAR(4000),@ErrSeverity INT    
    SELECT  @ErrMsg = ERROR_MESSAGE(),@ErrSeverity = ERROR_SEVERITY()    
    RAISERROR ( @ErrMsg, @ErrSeverity, 1 )    
    
END CATCH    