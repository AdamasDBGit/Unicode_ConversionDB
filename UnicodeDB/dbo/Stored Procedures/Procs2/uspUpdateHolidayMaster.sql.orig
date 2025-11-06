CREATE PROCEDURE [dbo].[uspUpdateHolidayMaster]  
( 
 @iHolidayId INT,  
 @iBrandId INT = NULL,   
 @iCenterId INT = NULL,     
 @dtHolidayDt DATETIME,  
 @sHolidayDesc VARCHAR(MAX)  
)  
AS   
  
BEGIN TRY  
  
    SET NoCount ON ;  
 SET TRANSACTION ISOLATION LEVEL READ COMMITTED;  
   
 UPDATE T_Holiday_Master  SET 
  I_Brand_ID=@iBrandId,
  I_Center_ID=@iCenterId,
  Dt_Holiday_Date=@dtHolidayDt,
  S_Holiday_Description=@sHolidayDesc
  WHERE I_Holiday_ID = @iHolidayId
       
   
END TRY  
  
BEGIN CATCH  
 ROLLBACK TRANSACTION  
    DECLARE @ErrMsg NVARCHAR(4000),@ErrSeverity INT  
    SELECT  @ErrMsg = ERROR_MESSAGE(),@ErrSeverity = ERROR_SEVERITY()  
    RAISERROR ( @ErrMsg, @ErrSeverity, 1 )  
  
END CATCH
