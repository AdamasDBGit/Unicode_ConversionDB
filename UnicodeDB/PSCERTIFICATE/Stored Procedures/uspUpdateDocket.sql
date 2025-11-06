/*
-- =================================================================
-- Author:Chandan Dey
-- Create date:06/09/2007 
-- Description:Update Docket No in T_Certificate_Despatch_Info Table
-- =================================================================
*/
CREATE PROCEDURE [PSCERTIFICATE].[uspUpdateDocket]
(
		@iDispatchID	INT,
		@sDocketNum		VARCHAR(20),
		@sUpdBy			VARCHAR(20),
		@DtUpdOn		DATETIME
)
AS
BEGIN TRY
	
-- Update T_Certificate_Despatch_Info table 
   UPDATE [PSCERTIFICATE].T_Certificate_Despatch_Info
	SET
		S_Docket_No		= @sDocketNum,
		S_Upd_By		= @sUpdBy,
		Dt_Upd_On		= @DtUpdOn
   WHERE I_Despatch_ID  = @iDispatchID
END TRY
BEGIN CATCH
	--Error occurred:

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
