CREATE PROCEDURE [dbo].[uspUpdateBatchProcessesDataBrandWise]  
(  
	@S_Batch_Process_Name varchar(100)=null,
	@S_Last_Run_Status varchar(50) =null  
)  
AS  

BEGIN TRY  
	BEGIN TRANSACTION TrnBatch
	SET NOCOUNT ON;  
		  
		UPDATE dbo.T_Batch_Master  
		SET  
		Dt_Last_Run_Date = GETDATE(),  
		S_Last_Run_Status = @S_Last_Run_Status
		WHERE S_Batch_Process_Name=@S_Batch_Process_Name
	  
	COMMIT TRANSACTION TrnBatch
END TRY  

BEGIN CATCH  
	ROLLBACK TRANSACTION TrnBatch
END CATCH
