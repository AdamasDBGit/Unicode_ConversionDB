CREATE PROCEDURE [dbo].[uspGetAllBatchByBrand]
(
@iBrandID int = null
)
AS 

BEGIN TRY

    SET NoCount ON ;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

SELECT SBM.I_Batch_ID BatchID,SBM.S_Batch_Code, SBM.S_Batch_Name
      FROM T_Student_Batch_Master as SBM
	  inner join
	  T_Center_Batch_Details as CBD on CBD.I_Batch_ID=SBM.I_Batch_ID
	  inner join
	  T_Brand_Center_Details as BCD on BCD.I_Centre_Id=CBD.I_Centre_Id
	  inner join
	  T_Brand_Master as BM on BM.I_Brand_ID=BCD.I_Brand_ID
	  where BM.I_Brand_ID=@iBrandID and SBM.I_Status <> 0 and SBM.b_IsApproved=1

	
END TRY

BEGIN CATCH
	ROLLBACK TRANSACTION
    DECLARE @ErrMsg NVARCHAR(4000),@ErrSeverity INT
    SELECT  @ErrMsg = ERROR_MESSAGE(),@ErrSeverity = ERROR_SEVERITY()
    RAISERROR ( @ErrMsg, @ErrSeverity, 1 )

END CATCH
