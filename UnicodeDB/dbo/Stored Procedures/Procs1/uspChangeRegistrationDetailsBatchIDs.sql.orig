CREATE PROCEDURE [dbo].[uspChangeRegistrationDetailsBatchIDs] 
	@OldRegnIds VARCHAR(500),
	@NewBatchID INT,
	@Updt_By VARCHAR(500),
	@Updt_On DATETIME
 
AS
BEGIN TRY

IF @NewBatchID = 0
BEGIN
	UPDATE dbo.T_Student_Registration_Details SET I_Status = 0,Updt_By = @Updt_By,Updt_On = @Updt_On
	WHERE I_Registration_ID IN (SELECT val FROM dbo.fnString2Rows(@OldRegnIds,','))
END
ELSE
BEGIN
	UPDATE dbo.T_Student_Registration_Details SET I_Batch_ID = @NewBatchID,Updt_By = @Updt_By,Updt_On = @Updt_On
	WHERE I_Registration_ID IN (SELECT val FROM dbo.fnString2Rows(@OldRegnIds,','))
END
END TRY

BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
