-- =============================================
-- Author:		Debarshi Basu
-- Create date: 26/03/2006
-- Description:	Modifies the FollowUp Closure master table
-- =============================================
CREATE PROCEDURE [dbo].[uspModifyFollowupClosureMaster]
	@iFollowupClosureID int,
	@sFollowupClosureDesc varchar(50),
	@sCreatedBy varchar(20),
	@dtCreatedOn datetime,
	@iFlag int			
AS
BEGIN TRY
	SET NOCOUNT OFF;
	DECLARE @iResult INT
	
	set @iResult = 0 -- set to default zero 

	if(@iFlag=1)
		BEGIN
			INSERT INTO dbo.T_Followup_Closure_Master
				   (
						S_Followup_Closure_Desc,
						I_Status, 
						S_Crtd_By, 
						Dt_Crtd_On
				   )
			VALUES(
					@sFollowupClosureDesc, 
					1, 
					@sCreatedBy, 
					@dtCreatedOn
				)
			SET @iResult = 1  -- Insertion successful
		END	
			
		ELSE IF(@iFlag=2)
		BEGIN
				UPDATE dbo.T_Followup_Closure_Master
				SET S_Followup_Closure_Desc = @sFollowupClosureDesc,
				S_Upd_By = @sCreatedBy,
				Dt_Upd_On = @dtCreatedOn
				where I_Followup_Closure_ID = @iFollowupClosureID
				SET @iResult = 1  -- Updation successful	
		END
	-- Deletion of Master Data
	-- Check if the required value is used, if yes - deletion not allowed
	ELSE IF(@iFlag = 3)
		BEGIN
			IF NOT EXISTS(SELECT I_Followup_Closure_ID FROM dbo.T_Enquiry_Regn_Followup WHERE I_Followup_Closure_ID=@iFollowupClosureID)
				BEGIN
					UPDATE dbo.T_Followup_Closure_Master
					SET I_Status = 0,
					S_Upd_By = @sCreatedBy,
					Dt_Upd_On = @dtCreatedOn
					where I_Followup_Closure_ID = @iFollowupClosureID
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
