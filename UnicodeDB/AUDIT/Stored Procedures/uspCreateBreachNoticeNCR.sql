/*
-- =================================================================
-- Author:Sanjay Mitra
-- Create date:07/20/2007 
-- Description: CREATE BREACH NOTICE (INSERT INTO c)
-- =================================================================
*/
CREATE PROCEDURE [AUDIT].[uspCreateBreachNoticeNCR] 
(
		 @iNCRID					INT
		,@iBreachNoticeID			INT 	
		,@sCreatedBy				VARCHAR(20) = NULL	
		,@sUpdatedBy				VARCHAR(20)  = NULL	
		,@dtCreatedOn				DATETIME = NULL 	
		,@dtUpdatedOn				DATETIME = NULL 	
)

AS
BEGIN TRY


	SET NOCOUNT OFF;
	
	IF NOT EXISTS (SELECT [TARN].[I_Audit_Report_NCR_ID] FROM [AUDIT].[T_Audit_Result_NCR] AS TARN 
	WHERE TARN.[I_Audit_Report_NCR_ID] = @iNCRID AND [TARN].[I_Status_ID] = 6)
	BEGIN
		INSERT INTO [AUDIT].[T_Breach_Notice_NCR]
		(
			 I_Audit_Report_NCR_ID
			,I_Breach_Notice_ID
			,S_Crtd_By
			,S_Updt_By
			,Dt_Crtd_By
			,Dt_Upd_On
		)

		VALUES
		(
			 @iNCRID
			,@iBreachNoticeID	
			,@sCreatedBy
			,@sUpdatedBy
			,@dtCreatedOn
			,@dtUpdatedOn
		)
	END
	
END TRY

BEGIN CATCH
--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
