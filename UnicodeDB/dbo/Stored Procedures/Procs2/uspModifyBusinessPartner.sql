CREATE PROCEDURE [dbo].[uspModifyBusinessPartner]
	@iUserID int,
	@sLoginID NVARCHAR(MAX),
	@sPassword NVARCHAR(MAX)=NULL,
	@sTitle NVARCHAR(MAX)=NULL,
	@sFirstName NVARCHAR(MAX),
	@sMiddleName NVARCHAR(MAX)=NULL,
	@sLastName NVARCHAR(MAX)=NULL,
	@sEmailID NVARCHAR(MAX)=NULL,
	@sUserType NVARCHAR(MAX),	
	@sCreatedBy NVARCHAR(MAX),
	@iflag int
AS
BEGIN TRY
	
	SET NOCOUNT ON;
	DECLARE @iTempUserID int;
	DECLARE @iSequence int
	SET @iTempUserID = NULL
	IF @iFlag = 1
	BEGIN

		SELECT @iSequence = MAX(I_User_ID) FROM dbo.T_User_Master
		SET @sLoginID = @sLoginID + CAST((@iSequence + 1) AS VARCHAR(20))

		INSERT INTO dbo.T_User_Master
		(
			S_Login_ID, 
			S_Password,
			S_Title,
			S_First_Name,
			S_Middle_Name,
			S_Last_Name,
			S_Email_ID,
			S_User_Type,
			I_Status,
			S_Crtd_By,
			Dt_Crtd_On 
		)
		VALUES
		(	
			@sLoginID,
			@sPassword,
			@sTitle,
			@sFirstName,
			@sMiddleName,
			@sLastName,
			@sEmailID,
			@sUserType,
			1,
			@sCreatedBy,
			GETDATE()
		)    
		
		SET @iTempUserID=SCOPE_IDENTITY()

	END
--	ELSE IF @iFlag = 2
--	Begin
--	--Not required for BP user
--	END
--	ELSE IF @iFlag = 3
--	Begin
--	--Not required for BP user
--	End
	
	SELECT @sLoginID AS LoginID, ISNULL(@iTempUserID, @iUserID) AS USERID

END TRY
BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH

