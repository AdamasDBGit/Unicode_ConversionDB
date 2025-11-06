/*
-- =================================================================
-- Author:Sanjay Mitra
-- Create date:07/19/2007 
-- Description: CREATE BREACH NOTICE (INSERT INTO c)
-- =================================================================
*/
CREATE PROCEDURE [AUDIT].[uspCreateBreachNotice] 
(
		 @iCenterID					INT
		,@dtIssuedON				DATETIME				
		,@sRemarks					VARCHAR(2000)
		,@iDocumentID				INT
		,@sCreatedBy				VARCHAR(20) = NULL	
		,@sUpdatedBy				VARCHAR(20)  = NULL	
		,@dtCreatedOn				DATETIME = NULL 	
		,@dtUpdatedOn				DATETIME = NULL 	
		
		,@iBreachNoticeID			INT OUTPUT	
)

AS
BEGIN TRY


	SET NOCOUNT OFF;
	
	INSERT INTO [AUDIT].[T_Breach_Notice]
	(
		 I_Center_ID
		,Dt_Letter_Issue_On
		,S_Remarks
		,I_Document_ID
		,S_Crtd_By
		,S_Updt_By
		,Dt_Crtd_By
		,Dt_Upd_On
	)

	VALUES
	(
		 @iCenterID 
		,@dtIssuedON 
		,@sRemarks 	
		,@iDocumentID	
		,@sCreatedBy
		,@sUpdatedBy
		,@dtCreatedOn
		,@dtUpdatedOn

	)
	SET @iBreachNoticeID = SCOPE_IDENTITY()
END TRY

BEGIN CATCH
--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
