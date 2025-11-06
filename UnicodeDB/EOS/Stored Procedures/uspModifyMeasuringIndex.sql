-- ===========================================================
-- Author:		Swagatam Sarkar
-- Create date: 26/11/2007
-- Description:	Modifies the Measuring Index of KRA's
-- ===========================================================

CREATE PROCEDURE [EOS].[uspModifyMeasuringIndex] 
(
	@iKRAIndexID int = NULL,
	@sMeasuringIndex varchar(200),
	@sCreatedBy varchar(50),
	@dtCreatedOn datetime,
    @iFlag int
)
AS
BEGIN TRY

	SET NOCOUNT OFF;
	DECLARE @iResult INT
	
	set @iResult = 0 -- set to default zero 

    IF @iFlag = 1
	BEGIN
		INSERT INTO EOS.T_KRA_Index_Master(S_KRA_Index_Desc, I_Status, S_Crtd_By, Dt_Crtd_On)
		VALUES(@sMeasuringIndex, 1, @sCreatedBy, @dtCreatedOn)   
		SET @iResult = 1  -- Insertion successful 
	END
	ELSE IF @iFlag = 2
	BEGIN
		UPDATE EOS.T_KRA_Index_Master
		SET S_KRA_Index_Desc = @sMeasuringIndex,
		S_Upd_By = @sCreatedBy,
		Dt_Upd_On = @dtCreatedOn
		where  I_KRA_Index_ID = @iKRAIndexID
		SET @iResult = 1  -- Updation successful
	END
	-- Deletion of Master Data
	-- Check if the required value is used, if yes - deletion not allowed
	ELSE IF @iFlag = 3
	BEGIN
		IF NOT EXISTS(SELECT I_KRA_Index_ID FROM EOS.T_Role_KRA_Map WHERE I_KRA_Index_ID = @iKRAIndexID)
			BEGIN
				UPDATE EOS.T_KRA_Index_Master
				SET I_Status = 0,
				S_Upd_By = @sCreatedBy,
				Dt_Upd_On = @dtCreatedOn
				where I_KRA_Index_ID = @iKRAIndexID
				SET @iResult = 1  -- Deletion successful
			END
		ELSE
			BEGIN
				SET @iResult = 2  -- Deletion not allowed due to Foreign Key Constraint
			END
	END
	SELECT @iResult Result
END TRY

BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
