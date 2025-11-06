/*****************************************************************************************************************
Created by: Debarshi Basu
Date: 22/07/07
Description: Checks if fund transfer is allowed for a center
Parameters: 
Returns:	
Modified By: 
******************************************************************************************************************/

CREATE PROCEDURE [dbo].[uspCheckFundTranfer]
(
	@iCenterID INT
)

AS

BEGIN TRY

	SELECT * FROM dbo.T_Center_Fund_Transfer
	WHERE B_Stop_Center_Fund_Transfer = 1
		AND I_Center_ID = @iCenterID
		AND I_Status = 1
		AND GETDATE() >= ISNULL(Dt_Period_Start, GETDATE())
		AND GETDATE() <= ISNULL(Dt_Period_End, GETDATE())
		
END TRY
BEGIN CATCH

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)

END CATCH
