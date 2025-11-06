-- =============================================
-- Author:		Debarshi Basu
-- Create date: 24/03/2006
-- Description:	Modifies the Preferred Career Master Table
-- =============================================

CREATE PROCEDURE [dbo].[uspModifyPrefCareer] 
(
	@iPrefCareerID int,
	@sPrefCareerName varchar(50),    
	@sCreatedBy varchar(20),
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
		INSERT INTO dbo.T_Preferred_Career_Master(S_Pref_Career_Name, I_Status, S_Crtd_By, Dt_Crtd_On)
		VALUES(@sPrefCareerName, 1, @sCreatedBy, @dtCreatedOn)   
		SET @iResult = 1  -- Insertion successful 
	END
	ELSE IF @iFlag = 2
	BEGIN
		UPDATE dbo.T_Preferred_Career_Master
		SET S_Pref_Career_Name = @sPrefCareerName,
		S_Upd_By = @sCreatedBy,
		Dt_Upd_On = @dtCreatedOn
		where I_Pref_Career_ID = @iPrefCareerID
		SET @iResult = 1  -- Updation successful
	END
	-- Deletion of Master Data
	-- Check if the required value is used, if yes - deletion not allowed
	ELSE IF @iFlag = 3
	BEGIN
		IF NOT EXISTS(SELECT I_Pref_Career_ID FROM dbo.T_Enquiry_Regn_Detail WHERE I_Pref_Career_ID=@iPrefCareerID)
			BEGIN
				UPDATE dbo.T_Preferred_Career_Master
				SET I_Status = 0,
				S_Upd_By = @sCreatedBy,
				Dt_Upd_On = @dtCreatedOn
				where I_Pref_Career_ID = @iPrefCareerID
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
