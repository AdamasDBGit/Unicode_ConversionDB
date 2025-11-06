CREATE PROC [dbo].[uspInsertSAPBatchLog]
(
@iCenterID INT = NULL,
@SComments VARCHAR(100) = NULL
)
AS 
BEGIN TRY
	
    INSERT INTO dbo.T_SAP_Batch_Log(I_Brand_ID,I_Centre_ID,S_Comments,Dt_Run_Date)
    VALUES (NULL,@iCenterID,@SComments + ' OF FT SAP BATCH PROCESS',GETDATE())
    
END TRY

BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)

END CATCH
