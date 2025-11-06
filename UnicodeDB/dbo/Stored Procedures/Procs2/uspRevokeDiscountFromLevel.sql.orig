CREATE PROCEDURE [dbo].[uspRevokeDiscountFromLevel]
(
		@iSelectedDiscountID int,
		@sLoginID varchar(200)
	)

AS

BEGIN TRY
		
		UPDATE dbo.T_Discount_Center_Detail
		SET I_Status = 0,
		S_Upd_By = @sLoginID,
		Dt_Upd_On = GETDATE()
		WHERE I_Discount_Center_Detail_ID = @iSelectedDiscountID

END TRY
BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
