CREATE FUNCTION [dbo].[ufnPopulateCenterConfigDetailsBatch]
(
	@iCenterID int,
	@sConfigurationCode VARCHAR(500)
)
RETURNS @tempTable TABLE
(
	S_Config_Value VARCHAR(500)
)
AS
BEGIN
	DECLARE @dtDateTimeNow DATETIME
	DECLARE @iBrandID INT

	SET @dtDateTimeNow=GETDATE()
	SELECT @iBrandID=I_BRAND_ID FROM DBO.T_BRAND_CENTER_DETAILS WITH(NOLOCK) WHERE I_CENTRE_ID=@iCenterID

	IF EXISTS (SELECT 'TRUE' FROM DBO.T_CENTER_CONFIGURATION WITH(NOLOCK) WHERE I_CENTER_ID =@iCenterID AND I_STATUS = 1 AND I_BRAND_ID IS NULL AND [S_Config_Code]=@sConfigurationCode 
				AND @dtDateTimeNow >= ISNULL(Dt_Valid_From,@dtDateTimeNow) AND @dtDateTimeNow <= ISNULL(Dt_Valid_To,@dtDateTimeNow))
		BEGIN
			INSERT INTO @tempTable
			SELECT [S_Config_Value] FROM DBO.T_CENTER_CONFIGURATION WITH(NOLOCK) WHERE I_CENTER_ID=@iCenterID AND I_STATUS = 1 AND I_BRAND_ID IS NULL AND [S_Config_Code]=@sConfigurationCode 
			AND @dtDateTimeNow >= ISNULL(Dt_Valid_From,@dtDateTimeNow) AND @dtDateTimeNow <= ISNULL(Dt_Valid_To,@dtDateTimeNow)
		END
	ELSE IF EXISTS(SELECT 'TRUE' FROM DBO.T_CENTER_CONFIGURATION WITH(NOLOCK) WHERE I_CENTER_ID IS NULL AND I_STATUS = 1 AND I_BRAND_ID =@iBrandID AND [S_Config_Code]=@sConfigurationCode 
				AND @dtDateTimeNow >= ISNULL(Dt_Valid_From,@dtDateTimeNow) AND @dtDateTimeNow <= ISNULL(Dt_Valid_To,@dtDateTimeNow))
		BEGIN
			INSERT INTO @tempTable
			SELECT [S_Config_Value] FROM DBO.T_CENTER_CONFIGURATION WITH(NOLOCK) WHERE I_CENTER_ID IS NULL AND I_STATUS = 1 AND I_BRAND_ID =@iBrandID AND [S_Config_Code]=@sConfigurationCode 
			AND @dtDateTimeNow >= ISNULL(Dt_Valid_From,@dtDateTimeNow) AND @dtDateTimeNow <= ISNULL(Dt_Valid_To,@dtDateTimeNow)
		END
	ELSE IF EXISTS(SELECT 'TRUE' FROM DBO.T_CENTER_CONFIGURATION WITH(NOLOCK) WHERE I_CENTER_ID IS NULL AND I_STATUS = 1 AND I_BRAND_ID IS NULL AND [S_Config_Code]=@sConfigurationCode 
				AND @dtDateTimeNow >= ISNULL(Dt_Valid_From,@dtDateTimeNow) AND @dtDateTimeNow <= ISNULL(Dt_Valid_To,@dtDateTimeNow))
		BEGIN
			INSERT INTO @tempTable
			SELECT [S_Config_Value] FROM DBO.T_CENTER_CONFIGURATION WITH(NOLOCK) WHERE I_CENTER_ID IS NULL AND I_STATUS = 1 AND I_BRAND_ID IS NULL AND [S_Config_Code]=@sConfigurationCode 
			AND @dtDateTimeNow >= ISNULL(Dt_Valid_From,@dtDateTimeNow) AND @dtDateTimeNow <= ISNULL(Dt_Valid_To,@dtDateTimeNow)
		END
	ELSE
		BEGIN
			INSERT INTO @tempTable
			SELECT NULL
		END

	RETURN;
END