CREATE PROCEDURE [dbo].[uspModifyBrandMaster] 
(
	@iBrandID int,
	@vBrandCode varchar(20),
    @vBrandName varchar(100),
	@vBrandBy varchar(20),
	@dBrandOn datetime,
    @iFlag int
)

AS
BEGIN TRY
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	-- Declare Statement
	DECLARE @iMaxBrandID INT

	SELECT @iMaxBrandID = MAX(I_Brand_ID) FROM T_Brand_Master
	SET @iMaxBrandID = ISNULL(@iMaxBrandID,0) + 1

    IF @iFlag = 1
	BEGIN 
		INSERT INTO dbo.T_Brand_Master(I_Brand_ID, S_Brand_Code, S_Brand_Name, I_Status, S_Crtd_By, Dt_Crtd_On)
		VALUES(@iMaxBrandID, @vBrandCode, @vBrandName, 1, @vBrandBy, @dBrandOn)    
	END
	ELSE IF @iFlag = 2
	BEGIN
		UPDATE dbo.T_Brand_Master
		SET S_Brand_Code = @vBrandCode,
		S_Brand_Name = @vBrandName,
		S_Upd_By = @vBrandBy,
		Dt_Upd_On = @dBrandOn
		where I_Brand_ID = @iBrandID
	END
	ELSE IF @iFlag = 3
	BEGIN
		UPDATE dbo.T_Brand_Master
		SET I_Status = 0,
		S_Upd_By = @vBrandBy,
		Dt_Upd_On = @dBrandOn
		where I_Brand_ID = @iBrandID
	END

END TRY
BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
