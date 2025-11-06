
CREATE PROCEDURE [dbo].[uspGetAllBatchByBrand_BKP_BeforeDynamic]
(
@iBrandID int = null
)
AS 

BEGIN TRY

    SET NoCount ON ;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

SELECT top 1000 [I_Batch_ID] BatchID
      
      ,S_Batch_Code BatchName
      
  FROM T_Student_Batch_Master
	
END TRY

BEGIN CATCH
	ROLLBACK TRANSACTION
    DECLARE @ErrMsg NVARCHAR(4000),@ErrSeverity INT
    SELECT  @ErrMsg = ERROR_MESSAGE(),@ErrSeverity = ERROR_SEVERITY()
    RAISERROR ( @ErrMsg, @ErrSeverity, 1 )

END CATCH
