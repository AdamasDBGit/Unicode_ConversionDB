/*****************************************************************************************************************
Created by: Swagatam Sarkar
Date: 08/06/2007
Description: Updates the Receipt Flag for adjusted receipts
Parameters: 
Returns:	
******************************************************************************************************************/

CREATE PROCEDURE [dbo].[uspUpdateOfflineReceiptFlag]
(
	@sReceiptID VARCHAR(50)
) 

AS
SET NOCOUNT OFF
BEGIN TRY 

	UPDATE T_Center_Receipt
	SET	I_Flag_IsAdjusted = 1
	WHERE I_Center_Receipt_ID = @sReceiptID		

END TRY

BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
