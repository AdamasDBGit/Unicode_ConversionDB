CREATE   PROCEDURE [dbo].[uspGetNotificationBrand]    
(    
@NotificationBrandID int    
)    
    
AS     
    
BEGIN TRY    
    
    SET NoCount ON ;    
 SET TRANSACTION ISOLATION LEVEL READ COMMITTED;    
    
SELECT     
I_Brand_ID NotificationBrandID    
,S_Brand_Name NotificationBrandName    
FROM T_Brand_Master where I_status = 1 and I_Brand_ID = ISNULL(@NotificationBrandID,I_Brand_ID)    
     
END TRY    
    
BEGIN CATCH    
 ROLLBACK TRANSACTION    
    DECLARE @ErrMsg NVARCHAR(4000),@ErrSeverity INT    
    SELECT  @ErrMsg = ERROR_MESSAGE(),@ErrSeverity = ERROR_SEVERITY()    
    RAISERROR ( @ErrMsg, @ErrSeverity, 1 )    
    
END CATCH    
  