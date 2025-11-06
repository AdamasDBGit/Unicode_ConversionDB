/*
-- =================================================================
-- Author:Ujjwal Sinha
-- Create date:14/05/2007 
-- Description:Insert Certificate Query record in T_Certificate_Query table 
-- =================================================================
*/
CREATE PROCEDURE [PSCERTIFICATE].[uspAddCertificateQuery]
(
		@iStudentDetailID	INT		,
		@sRepliedBy		VARCHAR(20) =null	,
		@sQuery			VARCHAR(4000)	,
		@iPSFlag		INT,
		@sReply			VARCHAR(4000)=null	,
		@sCrtdBy 		VARCHAR(20)	,
		@dtCrtdOn 		DATETIME
)
AS
BEGIN TRY
	

-- Insert record in  T_Certificate_Query Table

INSERT INTO [PSCERTIFICATE].T_Certificate_Query
		(
		I_Student_Detail_ID	,
		S_Replied_By		,
		S_Query			,
		B_PS_Flag		,
		S_Reply			,
		I_Status		,
		S_Crtd_By		, 
		Dt_Crtd_On 
		)
	VALUES (
		@iStudentDetailID	,
		@sRepliedBy		,
		@sQuery			,
		@iPSFlag		,
		@sReply			,
		1				,
		@sCrtdBy 		,
		@dtCrtdOn
		)

END TRY

BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
