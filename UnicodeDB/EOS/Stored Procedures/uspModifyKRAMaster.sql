-- ===========================================================
-- Author:		Swagatam Sarkar
-- Create date: 27/11/2007
-- Description:	Modifies the KRA Master
-- ===========================================================

CREATE PROCEDURE [EOS].[uspModifyKRAMaster] 
(
	@iKRAID int = null,
	@iKRAIndexID int = NULL,
	@sKRADesc varchar(200),
	@iKRAType int = NULL,
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
		INSERT INTO EOS.T_KRA_Master(I_KRA_Index_ID, S_KRA_Desc, I_KRA_Type, I_Status, S_Crtd_By, Dt_Crtd_On)
		VALUES(@iKRAIndexID, @sKRADesc, @iKRAType, 1, @sCreatedBy, @dtCreatedOn)   
		SET @iResult = 1  -- Insertion successful 
	END
	ELSE IF @iFlag = 2
	BEGIN
		UPDATE EOS.T_KRA_Master
		SET I_KRA_Index_ID = @iKRAIndexID,
		S_KRA_Desc = @sKRADesc,
		I_KRA_Type = @iKRAType,
		S_Upd_By = @sCreatedBy,
		Dt_Upd_On = @dtCreatedOn
		where  I_KRA_ID = @iKRAID
		SET @iResult = 1  -- Updation successful
	END
	-- Deletion of Master Data
	ELSE IF @iFlag = 3
	BEGIN
		IF EXISTS(SELECT I_KRA_ID FROM EOS.T_KRA_Master WHERE I_KRA_ID = @iKRAID)
			BEGIN
				UPDATE EOS.T_KRA_Master
				SET I_Status = 0,
				S_Upd_By = @sCreatedBy,
				Dt_Upd_On = @dtCreatedOn
				where I_KRA_ID = @iKRAID
				SET @iResult = 1  -- Deletion successful
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
