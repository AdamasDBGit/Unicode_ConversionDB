CREATE PROCEDURE [dbo].[uspModifyEmployer]
	@iUserID int,
	@sLoginID varchar(200),
	@sPassword varchar(200)=NULL,
	@sTitle varchar(20)=NULL,
	@sFirstName varchar(100),
	@sMiddleName varchar(100)=NULL,
	@sLastName varchar(100)=NULL,
	@sEmailID varchar(200)=NULL,
	@sUserType varchar(20),	
	@iReferenceID int = null,
	@iHierarchyMasterID int=NULL,
	@iHierarchyDetailID int=NULL,
	@sCreatedBy varchar(20),
	@iflag int
AS
BEGIN TRY
	
	SET NOCOUNT ON;

	DECLARE @iTempUserID int;
	DECLARE @iSequence int
	DECLARE @iEmployerHierarchyDetailID int
	DECLARE @iEmployerMasterID int
	
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
			I_Reference_ID,
			S_Forget_Pwd_Qtn,
			S_Forget_Pwd_Answer,
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
			@iReferenceID,
			NULL,
			NULL,
			@sCreatedBy,
			GETDATE()
		)    
		
		SET @iTempUserID = SCOPE_IDENTITY()
		
		SELECT @iEmployerHierarchyDetailID = A.I_Hierarchy_Detail_ID,
		@iEmployerMasterID = A.I_Hierarchy_Master_ID
		FROM dbo.T_User_Hierarchy_Details A
		INNER JOIN dbo.T_User_Master B
		ON A.I_User_ID = B.I_User_ID
		INNER JOIN dbo.T_User_Master C
		ON A.I_User_ID = C.I_User_ID
		WHERE C.S_Login_ID = @sCreatedBy
		AND A.I_Hierarchy_Master_ID = @iHierarchyMasterID
			
		INSERT INTO dbo.T_User_Hierarchy_Details
		( 
			I_User_ID, 
			I_Hierarchy_Master_ID, 
			I_Hierarchy_Detail_ID, 
			Dt_Valid_From, 
			I_Status
		)
		VALUES
		(
			@iTempUserID, 
			@iEmployerMasterID, 
			@iEmployerHierarchyDetailID, 
			GETDATE(), 
			1
		)

	END
	ELSE IF @iFlag = 2
	BEGIN
		UPDATE dbo.T_User_Master
		SET S_Login_ID = @sLoginID,
		S_Title = @sTitle,
		S_First_Name = @sFirstName,
		S_Middle_Name = @sMiddleName,
		S_Last_Name=@sLastName,
		S_Email_ID=@sEmailID,
		S_User_Type=@sUserType,
		S_Upd_By=@sCreatedBy,
		Dt_Upd_On=GETDATE()
		WHERE I_User_ID = @iUserID
	END
	ELSE IF @iFlag = 3
	BEGIN
		UPDATE dbo.T_User_Master
		SET I_Status = 0,
		S_Upd_By = @sCreatedBy,
		Dt_Upd_On = getdate()
		WHERE I_User_ID = @iUserID

		UPDATE dbo.T_User_Hierarchy_Details
		SET Dt_Valid_To=getdate(),
		I_Status = 0
		WHERE I_User_ID = @iUserID 
		AND I_Status <> 0
		
		UPDATE dbo.T_User_Role_Details
		SET I_Status = 0
		WHERE I_User_ID = @iUserID
		AND I_Status <> 0
	END
	
	SELECT @sLoginID AS LoginID, ISNULL(@iTempUserID, @iUserID) AS USERID

END TRY
BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
