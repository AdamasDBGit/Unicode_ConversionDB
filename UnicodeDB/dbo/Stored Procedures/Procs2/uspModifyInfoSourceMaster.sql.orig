-- =============================================
-- Author:		Debarshi Basu
-- Create date: 23/03/2006
-- Description:	Manages the master data table of Information Sourse
-- =============================================

CREATE PROCEDURE [dbo].[uspModifyInfoSourceMaster]
	@iInfoSourceID int,
	@sInfoSourceName varchar(100),
	@sInfoSourceBy varchar(20),
	@dtInfoSourceOn datetime,
	@iFlag int			
AS
BEGIN TRY
	SET NOCOUNT OFF;
	DECLARE @iResult INT
	
	set @iResult = 0 -- set to default zero 

	if(@iFlag=1)
		BEGIN
			INSERT INTO dbo.T_Information_Source_Master
			(
					S_Info_Source_Name,
					I_Status, 
					S_Crtd_By, 
					Dt_Crtd_On	
			)
			VALUES(
					@sInfoSourceName, 
					1, 
					@sInfoSourceBy, 
					@dtInfoSourceOn
				)				
			SET @iResult = 1  -- Insertion successful
		END	
			
		ELSE IF(@iFlag=2)
		BEGIN
				UPDATE dbo.T_Information_Source_Master
				SET S_Info_Source_Name = @sInfoSourceName,
				S_Upd_By = @sInfoSourceBy,
				Dt_Upd_On = @dtInfoSourceOn
				where I_Info_Source_ID = @iInfoSourceID					
				SET @iResult = 1  -- Updation successful
		END
	-- Deletion of Master Data
	-- Check if the required value is used, if yes - deletion not allowed
	ELSE IF(@iFlag = 3)
		BEGIN
			IF NOT EXISTS(SELECT I_Info_Source_ID FROM dbo.T_Enquiry_Regn_Detail WHERE I_Info_Source_ID=@iInfoSourceID)
				BEGIN
					UPDATE dbo.T_Information_Source_Master
					SET I_Status = 0,
					S_Upd_By = @sInfoSourceBy,
					Dt_Upd_On = @dtInfoSourceOn
					where I_Info_Source_ID = @iInfoSourceID
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
