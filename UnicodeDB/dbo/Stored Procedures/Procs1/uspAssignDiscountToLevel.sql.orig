CREATE PROCEDURE [dbo].[uspAssignDiscountToLevel]

	(
		@sSelectedCenters varchar(1000),
		@sSelectedDiscountID varchar(100),
		@sLoginID varchar(200)
	)


AS
BEGIN TRY
	
DECLARE @iGetCenterIndex int
DECLARE @iGetDiscountIndex int
DECLARE @iLength int
DECLARE @iDiscountListLength int
DECLARE @iCenterID int
DECLARE @iDiscountID int
DECLARE @sSelectedDiscountIDs varchar(100)

SET @iGetCenterIndex = CHARINDEX(',',LTRIM(RTRIM(@sSelectedCenters)),1)


IF @iGetCenterIndex > 1
BEGIN
	WHILE LEN(@sSelectedCenters) > 0
	BEGIN
		SET @iGetCenterIndex = CHARINDEX(',',@sSelectedCenters,1)
		SET @iLength = LEN(@sSelectedCenters)
		SET @iCenterID = CAST(LTRIM(RTRIM(LEFT(@sSelectedCenters,@iGetCenterIndex-1))) AS int)
		
		SET @sSelectedDiscountIDs = @sSelectedDiscountID
		SET @iGetDiscountIndex = CHARINDEX(',',LTRIM(RTRIM(@sSelectedDiscountIDs)),1)	
		WHILE LEN(@sSelectedDiscountIDs) > 0
		BEGIN
			SET @iGetDiscountIndex = CHARINDEX(',',@sSelectedDiscountIDs,1)
			SET @iDiscountListLength = LEN(@sSelectedDiscountIDs)
			SET @iDiscountID = CAST(LTRIM(RTRIM(LEFT(@sSelectedDiscountIDs,@iGetDiscountIndex-1))) AS int)
			
			
			IF NOT EXISTS (SELECT I_Discount_Scheme_ID,I_Centre_ID FROM T_DISCOUNT_CENTER_DETAIL WHERE I_Centre_ID =@iCenterID AND I_Discount_Scheme_ID= @iDiscountID AND I_Status = 1)
			INSERT INTO T_DISCOUNT_CENTER_DETAIL(I_Discount_Scheme_ID,I_Centre_ID,I_Status,S_Crtd_By,Dt_Crtd_On) VALUES
			(@iDiscountID,@iCenterID,1,@sLoginID,GETDATE())
			
			SELECT @sSelectedDiscountIDs = SUBSTRING(@sSelectedDiscountIDs,@iGetDiscountIndex + 1, @iDiscountListLength - @iGetDiscountIndex)
			SELECT @sSelectedDiscountIDs = LTRIM(RTRIM(@sSelectedDiscountIDs))
		END

		SELECT @sSelectedCenters = SUBSTRING(@sSelectedCenters,@iGetCenterIndex + 1, @iLength - @iGetCenterIndex)
		SELECT @sSelectedCenters = LTRIM(RTRIM(@sSelectedCenters))
	END
END

END TRY
BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
