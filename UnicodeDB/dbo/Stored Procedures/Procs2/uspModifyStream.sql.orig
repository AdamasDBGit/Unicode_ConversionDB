-- =============================================
-- Author:		Debarshi Basu
-- Create date: 26/03/2006
-- Description:	Modifies the Stream Master table
-- =============================================
CREATE PROCEDURE [dbo].[uspModifyStream] 
(
	@iStreamID int,
	@sStreamName varchar(50),    
	@sCreatedBy varchar(20),
	@dtCreatedOn datetime,
    @iFlag int
)
AS
BEGIN TRY
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @iResult INT
	
	set @iResult = 0 -- set to default zero 
    IF @iFlag = 1
	BEGIN
		INSERT INTO dbo.T_Stream_Master(S_Stream_Name, I_Status, S_Crtd_By, Dt_Crtd_On)
		VALUES(@sStreamName, 1, @sCreatedBy, @dtCreatedOn)   
		SET @iResult = 1  -- Insertion successful 
	END
	ELSE IF @iFlag = 2
	BEGIN
		UPDATE dbo.T_Stream_Master
		SET S_Stream_Name = @sStreamName,
		S_Upd_By = @sCreatedBy,
		Dt_Upd_On = @dtCreatedOn
		where I_Stream_ID = @iStreamID
		SET @iResult = 1  -- Updation successful
	END
	-- Deletion of Master Data
	-- Check if the required value is used, if yes - deletion not allowed
	ELSE IF @iFlag = 3
	BEGIN
		IF NOT EXISTS(SELECT I_Stream_ID FROM dbo.T_Enquiry_Regn_Detail WHERE I_Stream_ID=@iStreamID)
			BEGIN
				UPDATE dbo.T_Stream_Master
				SET I_Status = 0,
				S_Upd_By = @sCreatedBy,
				Dt_Upd_On = @dtCreatedOn
				where I_Stream_ID = @iStreamID
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
