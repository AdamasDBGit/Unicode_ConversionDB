-- =============================================
-- Author:		Soumya Sikder
-- Create date: 12/03/2007
-- Description:	Modifies the Skill Master Table
-- =============================================
CREATE PROCEDURE [dbo].[uspModifySkillMaster] 
(
	@iSkillID int,
	@iBrandID int,
	@sSkillNo varchar(20),	
    @sSkillDesc varchar(100),
	@sSkillType varchar(50),
	@sSkillBy varchar(20),
	@dSkillOn datetime,
    @iFlag int
)
AS
BEGIN TRY
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT OFF;
	DECLARE @sErrorCode varchar(20)
	
    IF @iFlag = 1
	BEGIN
		INSERT INTO dbo.T_EOS_Skill_Master
		(
			I_Brand_ID,
			S_Skill_No, 
			S_Skill_Desc,
			S_Skill_Type, 
			I_Status, 
			S_Crtd_By, 
			Dt_Crtd_On
		)
		VALUES
		(
			@iBrandID,
			@sSkillNo, 
			@sSkillDesc,
			@sSkillType, 
			1, 
			@sSkillBy, 
			@dSkillOn
		)    
	END
	ELSE IF @iFlag = 2
	BEGIN
		UPDATE dbo.T_EOS_Skill_Master
		SET S_Skill_No = @sSkillNo,
		S_Skill_Desc = @sSkillDesc,
		S_Skill_Type = @sSkillType,
		S_Upd_By = @sSkillBy,
		Dt_Upd_On = @dSkillOn
		where I_Skill_ID = @iSkillID
	END
	-- Check for deletion of Master Data
	ELSE IF @iFlag = 3
	BEGIN
		IF EXISTS(SELECT I_Module_ID FROM dbo.T_Module_Master
					WHERE I_Skill_ID = @iSkillID
					AND I_Status = 1)
			BEGIN
				SET @sErrorCode = 'CM_100021'
			END
		ELSE
		BEGIN
			UPDATE dbo.T_EOS_Skill_Master
			SET I_Status = 0,
			S_Upd_By = @sSkillBy,
			Dt_Upd_On = @dSkillOn
			where I_Skill_ID = @iSkillID
		END
	END
	SELECT @sErrorCode AS ERROR
END TRY
BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
