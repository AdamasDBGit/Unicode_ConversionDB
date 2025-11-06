/*
-- =================================================================
-- Author:Avirup Das
-- Create date:04/08/2007
-- Description:Get Kit Details From T_Kit_Master table
-- Parameter : 
-- =================================================================
*/

CREATE PROCEDURE [LOGISTICS].[uspSaveDocumentDetails]
(
     @iLogisticsID INT =NULL
	,@iDocumentID INT = NULL
	,@sUpdBy VARCHAR(20) = NULL
	,@dtUpdOn DATETIME = NULL
)

AS
BEGIN TRY
SET NOCOUNT OFF;
 	UPDATE [LOGISTICS].[T_Logistics_Master]
		SET 		
			I_Document_ID = @iDocumentID,		
			S_Upd_By	= @sUpdBy, 
			Dt_Upd_On	= @dtUpdOn
			WHERE I_Logistics_ID = COALESCE(@iLogisticsID, I_Logistics_ID)

END TRY

BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
