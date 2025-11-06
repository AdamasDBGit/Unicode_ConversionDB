CREATE   PROCEDURE [dbo].[uspGetClassWiseBatch]  
(  
@iClassID int = null  
)  
AS   
  
BEGIN TRY  
  
    SET NoCount ON ;  
 SET TRANSACTION ISOLATION LEVEL READ COMMITTED;  
  
select TSBM.I_Batch_ID BatchID  
,TSBM.S_Batch_Name BatchName  
from T_Student_Batch_Master TSBM   
INNER JOIN T_Class TC ON TC.I_Class_ID = TSBM.I_Class_ID  
where TC.I_Class_ID = @iClassID  
  
   
END TRY  
  
BEGIN CATCH  
 ROLLBACK TRANSACTION  
    DECLARE @ErrMsg NVARCHAR(4000),@ErrSeverity INT  
    SELECT  @ErrMsg = ERROR_MESSAGE(),@ErrSeverity = ERROR_SEVERITY()  
    RAISERROR ( @ErrMsg, @ErrSeverity, 1 )  
  
END CATCH  