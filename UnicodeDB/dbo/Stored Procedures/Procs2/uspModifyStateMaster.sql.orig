CREATE PROCEDURE [dbo].[uspModifyStateMaster] 
	-- Add the parameters for the stored procedure here
	@iStateID INT,
	@sStateCode VARCHAR(10),
	@sStateName VARCHAR(50),
	@iCountryID INT,
	@sStateBy VARCHAR(20),
	@dStateOn DATETIME,
	@iFlag INT
AS
BEGIN TRY
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF(@iFlag=1)
		BEGIN
			INSERT INTO dbo.T_State_Master (
											S_State_Code,
											S_State_Name,
											I_Country_ID,
											I_Status,
											S_Crtd_By,
											Dt_Crtd_On
											) 
			VALUES (
											@sStateCode,
											@sStateName,
											@iCountryID,
											1,
											@sStateBy,
											@dStateOn
					)
		END

	IF(@iFlag=2)
		BEGIN
			UPDATE dbo.T_State_Master SET
			S_State_Name=@sStateName,
			S_Upd_By=@sStateBy,
			Dt_Upd_On=@dStateOn
			WHERE 
			I_State_ID=@iStateID
		END

	IF(@iFlag=3)
		BEGIN
			UPDATE dbo.T_State_Master SET
			I_Status=0,
			S_Upd_By=@sStateBy,
			Dt_Upd_On=@dStateOn
			WHERE 
			I_State_ID=@iStateID
		END
END TRY
BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
