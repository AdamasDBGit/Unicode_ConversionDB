CREATE PROCEDURE [dbo].[uspRemoveFeePlan] 
(
	@iFeePlanId int,
	@dEffectiveEndDate datetime,
	@sUpdatedBy varchar(20)
)

AS
BEGIN TRY

		BEGIN TRANSACTION
		UPDATE T_Course_Fee_Plan
		SET Dt_Valid_To = @dEffectiveEndDate,
		S_Upd_By = @sUpdatedBy,
		Dt_Upd_On = GETDATE()
		WHERE I_Course_Fee_Plan_ID = @iFeePlanId
		AND I_Status = 1
		
		UPDATE dbo.T_Course_Center_Delivery_FeePlan
		SET Dt_Valid_To = @dEffectiveEndDate
		WHERE I_Course_Fee_Plan_ID = @iFeePlanId
		AND I_Status = 1
		COMMIT TRANSACTION
END TRY
BEGIN CATCH
	--Error occurred:  
	ROLLBACK TRANSACTION
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
