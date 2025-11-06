CREATE   PROCEDURE [dbo].[uspGetAllClassByBrand]  
(  
@iBrandID int = null  
)  
AS   
  
BEGIN TRY  
  
    SET NoCount ON ;  
 SET TRANSACTION ISOLATION LEVEL READ COMMITTED;  
  
SELECT   
S_Class_Name CourseName  
,I_Class_ID ID  
FROM T_Class  
where  I_Status = 1  
   
END TRY  
  
BEGIN CATCH  
 ROLLBACK TRANSACTION  
    DECLARE @ErrMsg NVARCHAR(max),@ErrSeverity INT  
    SELECT  @ErrMsg = ERROR_MESSAGE(),@ErrSeverity = ERROR_SEVERITY()  
    RAISERROR ( @ErrMsg, @ErrSeverity, 1 )  
  
END CATCH  
