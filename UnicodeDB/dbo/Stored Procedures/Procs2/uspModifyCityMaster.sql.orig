CREATE PROCEDURE [dbo].[uspModifyCityMaster] 
	-- Add the parameters for the stored procedure here
	@iCityID INT,
	@sCityCode VARCHAR(10),
	@sCityName VARCHAR(50),
	@iCountryID INT,
	@iStateID INT,
	@sCityBy VARCHAR(20),
	@dCityOn DATETIME,
	@iFlag INT
AS
BEGIN TRY
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

	IF(@iFlag=1)
		BEGIN
			INSERT INTO dbo.T_City_Master (
											S_City_Code,
											S_City_Name,
											I_Country_ID,
											I_State_ID,
											I_Status,
											S_Crtd_By,
											Dt_Crtd_On
											) 
			VALUES (
											@sCityCode,
											@sCityName,
											@iCountryID,
											@iStateID,
											1,
											@sCityBy,
											@dCityOn
					)
		END

	IF(@iFlag=2)
		BEGIN
			UPDATE dbo.T_City_Master SET
			S_City_Name=@sCityName,
			S_Upd_By=@sCityBy,
			Dt_Upd_On=@dCityOn
			WHERE 
			I_City_ID=@iCityID
		END

	IF(@iFlag=3)
		BEGIN
			UPDATE dbo.T_City_Master SET
			I_Status=0,
			S_Upd_By=@sCityBy,
			Dt_Upd_On=@dCityOn	
			WHERE 
			I_City_ID=@iCityID
		END

END TRY
BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
