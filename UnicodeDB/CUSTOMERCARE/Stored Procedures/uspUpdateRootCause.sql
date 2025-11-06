/*
-- =================================================================
-- Author:Ujjwal Sinha
-- Create date:14/05/2007 
-- Description:Update Plcacement registration record in T_Root_Cause_Master table 
-- =================================================================
*/
CREATE PROCEDURE [CUSTOMERCARE].[uspUpdateRootCause]
(
 		@iRootCauseID		INT		,
		@iStatusID		INT		,
		@iComplaintCategoryID	INT		,
		@sRootCauseCode		VARCHAR(20)	,
		@sRootCauseDesc		VARCHAR(2000)	,
		@sUpdBy			VARCHAR(20)	,
		@DtUpdOn		DATETIME,
		@iBrandID		INT = null	
)
AS
BEGIN TRY
	
-- Update T_Root_Cause_Master table 
   UPDATE [CUSTOMERCARE].T_Root_Cause_Master
	SET
	I_Status_ID		= @iStatusID		,
	I_Brand_ID		= @iBrandID			,
	I_Complaint_Category_ID	= @iComplaintCategoryID	,
	S_Root_Cause_Code	= @sRootCauseCode	,
	S_Root_Cause_Desc	= @sRootCauseDesc	,
	S_Upd_By		= @sUpdBy		,
	Dt_Upd_On		= @DtUpdOn
     WHERE  I_Root_Cause_ID = @iRootCauseID  
END TRY
BEGIN CATCH
	--Error occurred:

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
