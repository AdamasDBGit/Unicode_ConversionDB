-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspModifySessionTypeMaster]
(
	-- Add the parameters for the stored procedure here
	@iSessionID int,  -- Session Type Id
	@sSessionType varchar(50),
	@sSessionBy varchar(20),
	@dSessionOn datetime,
	@iFlag int
)
AS
BEGIN TRY
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT OFF;
	DECLARE @sErrorCode varchar(20)

    -- Insert statements for procedure here
	IF(@iFlag=1)
	BEGIN
		INSERT INTO T_Session_Type_Master
		(
			S_Session_Type_Name,
			I_Status,
			S_Crtd_By,
			Dt_Crtd_On
		)	
		VALUES 
		(
			@sSessionType,
			1,
			@sSessionBy,
			@dSessionOn
		)
	END	

	IF(@iFlag=2)
	BEGIN
		UPDATE T_Session_Type_Master 
		SET	S_Session_Type_Name = @sSessionType,
			S_Upd_By = @sSessionBy,
			Dt_Upd_On = @dSessionOn
		WHERE I_Session_Type_ID = @iSessionID
		
	END	
	-- Check if deletion is allowed
	IF(@iFlag=3)
	BEGIN
		IF EXISTS(SELECT I_Session_ID FROM dbo.T_Session_Master
				  WHERE I_Session_Type_ID = @iSessionID
				  AND I_Status = 1)
		BEGIN
			SET @sErrorCode = 'CM_100019'
		END
		ELSE
		BEGIN	
			UPDATE T_Session_Type_Master 
			SET I_Status = 0,
				S_Upd_By = @sSessionBy,
				Dt_Upd_On = @dSessionOn
			WHERE I_Session_Type_ID = @iSessionID
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
