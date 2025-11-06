/*
-- =================================================================
-- Author:Ujjwal Sinha
-- Create date:14/05/2007 
-- Description:Update Plcacement registration record in T_Certificate_Query table 
-- =================================================================
*/
CREATE PROCEDURE [PSCERTIFICATE].[uspUpdateCertificateQuery]
(
		@iCertificateQueryID	INT		,
		--@iStudentDetailID	INT		,
		@sRepliedBy		VARCHAR(20)	,
		--@sQuery			VARCHAR(4000)	,
		@sReply			VARCHAR(4000)	,
		--@iStatus		INT,
		@sUpdBy			VARCHAR(20),
		@DtUpdOn		DATETIME
)
AS
BEGIN TRY
	
-- Update T_Certificate_Query table 
   UPDATE [PSCERTIFICATE].T_Certificate_Query
	SET
	--I_Student_Detail_ID	= @iStudentDetailID	,
	S_Replied_By		= @sRepliedBy,
	--S_Query			= @sQuery,
	S_Reply			= @sReply,
	--I_Status		= @iStatus,
	S_Upd_By		= @sUpdBy,
	Dt_Upd_On		= @DtUpdOn
     WHERE  I_Certificate_Query_ID = @iCertificateQueryID  
END TRY
BEGIN CATCH
	--Error occurred:

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
