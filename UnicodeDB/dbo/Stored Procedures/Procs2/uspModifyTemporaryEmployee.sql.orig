CREATE PROCEDURE [dbo].[uspModifyTemporaryEmployee]
	@iUserID int,
	@sLoginID varchar(20) = NULL,
	@sPassword varchar(200)=NULL,
	@sTitle varchar(20)=NULL,
	@sFirstName varchar(100) = NULL,
	@sMiddleName varchar(100)=NULL,
	@sLastName varchar(100)=NULL,
	@sEmailID varchar(200)=NULL,
	@sUserType varchar(20),
	@sForgotPasswordQuestion varchar(200)=NULL,
	@sForgotPasswordAnswer varchar(200)=NULL,	
	@iReferenceID int = NULL,
	@iHierarchyMasterID int=NULL,
	@iHierarchyDetailSOID int=NULL,
	@iHierarchyDetailTDID int=NULL,
	@iOldHierarchyDetailID int=NULL,
	@sCreatedBy varchar(20),
	@iflag int
AS
BEGIN TRY
	
	SET NOCOUNT ON;
	DECLARE @iTempUserID int;
	DECLARE @sSequence varchar(10)
	DECLARE @iSequence int
	DECLARE @iEmpHierarchyDetailID int
	DECLARE @iEmpMasterID int
	DECLARE @iHierarchyMasterTDID INT
	
	SET @iTempUserID = NULL
	SELECT @iHierarchyMasterTDID = I_Hierarchy_Master_ID 
	FROM dbo.T_Hierarchy_Master WHERE S_Hierarchy_Type = 'RH'
	
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
			I_Reference_ID,
			S_User_Type,
			I_Status,
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
			@iReferenceID,
			@sUserType,
			1,
			@sForgotPasswordQuestion,
			@sForgotPasswordAnswer,
			@sCreatedBy,
			GETDATE()
		)    
		
		SET @iTempUserID = SCOPE_IDENTITY()
		
		SELECT @iEmpHierarchyDetailID = A.I_Hierarchy_Detail_ID,
		@iEmpMasterID = A.I_Hierarchy_Master_ID
		FROM dbo.T_Center_Hierarchy_Details A
		INNER JOIN dbo.T_Employee_Dtls B
		ON A.I_Center_Id = B.I_Centre_Id
		WHERE B.I_Employee_ID = @iReferenceID
		AND A.I_Status = 1
		AND B.I_Status <> 4
		AND B.I_Status <> 5
		
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
			@iEmpMasterID, 
			@iEmpHierarchyDetailID, 
			GETDATE(), 
			1
		)
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
			@iHierarchyMasterTDID, 
			@iHierarchyDetailTDID, 
			GETDATE(), 
			1
		)		
	END
	ELSE IF @iFlag = 2
	BEGIN
		UPDATE dbo.T_User_Master
		SET S_Login_ID = ISNULL(@sLoginID,S_Login_ID),
		S_Title = ISNULL(@sTitle,S_Title),
		S_First_Name = ISNULL(@sFirstName,S_First_Name),
		S_Middle_Name = ISNULL(@sMiddleName,S_Middle_Name),
		S_Last_Name = ISNULL(@sLastName,S_Last_Name),
		S_Email_ID = ISNULL(@sEmailID,S_Email_ID),
		S_User_Type = @sUserType,
		S_Upd_By= @sCreatedBy,
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
		--AND I_Hierarchy_Master_ID = @iHierarchyMasterID
		--AND I_Hierarchy_Detail_ID = @iOldHierarchyDetailID
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
