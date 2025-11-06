/*
-- =================================================================
-- Author:Ujjwal Sinha
-- Create date:14/05/2007 
-- Description:Insert Plcacement registration record in T_Root_Cause_Master table 
-- =================================================================
*/
CREATE PROCEDURE [CUSTOMERCARE].[uspSaveRootCause]
(
		@iComplaintCategoryID	INT		,
		@sRootCauseCode		VARCHAR(20)	,
		@sRootCauseDesc		VARCHAR(2000)	,
		@sCrtdBy 		VARCHAR(20)	,
		@dtCrtdOn 		DATETIME,
		@IBrandID 		INT = NULL
)
AS
BEGIN TRY
	

-- Insert record in  T_Root_Cause_Master Table

INSERT INTO [CUSTOMERCARE].T_Root_Cause_Master
		(
		I_Brand_ID	,
		I_Status_ID		,
		I_Complaint_Category_ID	,
		S_Root_Cause_Code	,
		S_Root_Cause_Desc	,
		S_Crtd_By		, 
		Dt_Crtd_On 
		)
	VALUES (
		@IBrandID,
		1			,
		@iComplaintCategoryID	,
		@sRootCauseCode		,
		@sRootCauseDesc		,
		@sCrtdBy 		,
		@dtCrtdOn
		)

SET @sRootCauseCode = @sRootCauseCode+'-'+ CAST(SCOPE_IDENTITY()AS VARCHAR(10))

UPDATE [CUSTOMERCARE].T_Root_Cause_Master SET S_Root_Cause_Code =@sRootCauseCode
WHERE I_Root_Cause_ID = SCOPE_IDENTITY()

SELECT SCOPE_IDENTITY()

END TRY

BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
