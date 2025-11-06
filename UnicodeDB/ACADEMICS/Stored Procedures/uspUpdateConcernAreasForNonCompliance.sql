CREATE PROCEDURE [ACADEMICS].[uspUpdateConcernAreasForNonCompliance] 
(
	@sConcernAreas VARCHAR(1000),
	@dtCurrentDate DATETIME
)
AS

BEGIN TRY
BEGIN TRAN T1

	SET NOCOUNT ON;
		
		UPDATE Academics.T_Concern_Areas
		SET I_Is_Notified = 1,
		S_Upd_By = 'SYSTEM_BATCH',
		Dt_Upd_On = @dtCurrentDate
		WHERE I_Concern_Areas_ID IN
		(
			SELECT * FROM [dbo].[fnString2Rows](@sConcernAreas, ',')
		)
		
		Declare @iActualRowCount Int
		Declare @iCount Int
		Declare @I_Process_ID_Max Int
		Declare @Comments Varchar(2000)
		Declare @ConcernAreasName Varchar(2000)
		Select @I_Process_ID_Max=ISNULL(Max(I_Process_ID),0)+1 From dbo.T_Batch_Log Where S_Batch_Process_Name='CONCERN_AREA_NC'
	
		SELECT IDENTITY(int, 1,1) AS ID_Num,*  INTO #ConcernAreas FROM [dbo].[fnString2Rows](@sConcernAreas, ',')
		Set @iCount=1
		SELECT @iActualRowCount = COUNT(*) FROM #ConcernAreas

		WHILE (@iCount <= @iActualRowCount)
		BEGIN
			SELECT @ConcernAreasName=CA.S_Description FROM Academics.T_Concern_Areas CA INNER JOIN #ConcernAreas TCA ON CA.I_Concern_Areas_ID=TCA.Val
			WHERE TCA.ID_Num=@iCount

			Set @Comments=@ConcernAreasName +' updated successfully'
			EXEC uspWriteBatchProcessLog @I_Process_ID_Max,'CONCERN_AREA_NC',@Comments,'Success'

			SET @iCount = @iCount + 1
		END

COMMIT TRAN T1
END TRY

BEGIN CATCH
--Error occurred:
	ROLLBACK  TRAN T1
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT @ErrMsg = ERROR_MESSAGE(),
	@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
