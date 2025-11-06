-- =============================================
-- Author:		Soumya Sikder
-- Create date: 17/01/2007
-- Description:	Modifies the Course Family Master Table
-- =============================================
CREATE PROCEDURE [dbo].[uspModifyDiscountSchemeMaster] 
(
	@iDiscountSchemeID int = null,
	@sDiscountSchemeName varchar(50) = null,
    @sDiscountSchemeBy varchar(20),
	@dDiscountSchemeOn datetime,
    @iFlag int
)
AS
BEGIN TRY
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT OFF

    IF @iFlag = 1
	BEGIN
		INSERT INTO dbo.T_Discount_Scheme_Master
		(S_Discount_Scheme_Name,
		 Dt_Valid_From, 
		 I_Status, 
		 S_Crtd_By, 
		 Dt_Crtd_On)
		VALUES
		( @sDiscountSchemeName,
		  @dDiscountSchemeOn, 
          1, 
		  @sDiscountSchemeBy, 
		  @dDiscountSchemeOn)    
	END
	ELSE IF @iFlag = 2
	BEGIN
		UPDATE dbo.T_Discount_Scheme_Master
		SET S_Discount_Scheme_Name = @sDiscountSchemeName,
		S_Crtd_By = @sDiscountSchemeBy,
		Dt_Crtd_On = @dDiscountSchemeOn
		where I_Discount_Scheme_ID = @iDiscountSchemeID
	END
	ELSE IF @iFlag = 3
	BEGIN
		UPDATE dbo.T_Discount_Scheme_Master
		SET I_Status = 0,
		Dt_Valid_To = @dDiscountSchemeOn,
		S_Upd_By = @sDiscountSchemeBy,
		Dt_Upd_On = @dDiscountSchemeOn
		where I_Discount_Scheme_ID = @iDiscountSchemeID
	END

END TRY
BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
