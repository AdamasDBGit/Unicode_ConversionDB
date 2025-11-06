/*
-- =================================================================
-- Author:Chandan Dey
-- Create date:31/07/2007
-- Description:Get Logistics Item List From T_Logistics_Master table
-- Parameter : 
-- =================================================================
*/
CREATE PROCEDURE [LOGISTICS].[uspCheckKitCodeForSaveKitMaster]
(
	@sKitCode VARCHAR(20),
	@flag Bit  = 0 OUTPUT
)
AS
BEGIN TRY
SET NOCOUNT OFF;
DECLARE @sKitCodeFlag INT
SET @sKitCodeFlag =0

SELECT @sKitCodeFlag =COUNT(*) FROM LOGISTICS.T_Kit_Master WHERE S_Kit_Code  = @sKitCode

IF @sKitCodeFlag = 0
BEGIN
	SET  @flag =1
END
ELSE
BEGIN
	SET  @flag =0
END


END TRY

BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
