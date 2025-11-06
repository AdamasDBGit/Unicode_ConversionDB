CREATE PROCEDURE [dbo].[uspGetSubjectType] 
 @iBrandID int = null
AS
BEGIN TRY   
 SET NOCOUNT OFF;  
BEGIN
Select S_Subject_Type SubjectType,
I_Subject_Type_ID SubjectTypeID
from T_Subject_Type
END
END TRY  
BEGIN CATCH  
 --Error occurred:    
  
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int  
 SELECT @ErrMsg = ERROR_MESSAGE(),  
   @ErrSeverity = ERROR_SEVERITY()  
  
 RAISERROR(@ErrMsg, @ErrSeverity, 1)  
END CATCH
