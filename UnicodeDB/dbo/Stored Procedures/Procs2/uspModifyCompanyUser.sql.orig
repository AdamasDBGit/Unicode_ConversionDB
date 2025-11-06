CREATE PROCEDURE [dbo].[uspModifyCompanyUser]
	@iUserID int,
	@sLoginID varchar(200),
	@sPassword varchar(200)=NULL,
	@sTitle varchar(20)=NULL,
	@sFirstName varchar(100),
	@sMiddleName varchar(100)=NULL,
	@sLastName varchar(100)=NULL,
	@sEmailID varchar(200)=NULL,
	@sUserType varchar(20),
	@sForgotPasswordQuestion varchar(200)=NULL,
	@sForgotPasswordAnswer varchar(200)=NULL,	
	@iReferenceID int = null,
	@iHierarchyMasterID int=NULL,
	@iHierarchyDetailID int=NULL,
	@iOldHierarchyDetailID int=NULL,
	@sCreatedBy varchar(20),
	@DOB DATETIME,
	@iflag INT,
	@bIsLDAPUser BIT = FALSE
AS
BEGIN TRY
	
	SET NOCOUNT ON;
	DECLARE @iTempUserID int;
	DECLARE @sSequence varchar(10)
	DECLARE @iSequence int
	DECLARE @iStudentHierarchyDetailID int
	DECLARE @iStudentMasterID int
	DECLARE @iEmployerHierarchyDetailID int
	DECLARE @iEmployerMasterID int
	
	SET @iTempUserID = NULL
	
	IF @iFlag = 1
	BEGIN
	--for non company
		IF @sUserType <> 'AE'
		BEGIN
			SELECT @iSequence = MAX(I_User_ID) FROM dbo.T_User_Master
			-- SET @sLoginID = @sLoginID + CAST((@iSequence + 1) AS VARCHAR(20))	-- Not Required any more
		END
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
			Dt_Crtd_On,
			B_LDAP_User,
			Dt_Date_Of_Birth 
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
			GETDATE(),
			@bIsLDAPUser,
			@DOB
		)    
		
		SET @iTempUserID = SCOPE_IDENTITY()
		
		IF @sUserType = 'ST'
		BEGIN
			-- assign salse org , there won't be any Role Hierarchy for student
			SELECT @iStudentHierarchyDetailID = A.I_Hierarchy_Detail_ID,
			@iStudentMasterID = A.I_Hierarchy_Master_ID
			FROM dbo.T_Center_Hierarchy_Details A
			INNER JOIN dbo.T_Student_Center_Detail B
			ON A.I_Center_Id = B.I_Centre_Id
			WHERE B.I_Student_Detail_ID = @iReferenceID
			AND A.I_Status = 1
			AND B.I_Status = 1
			AND GETDATE() >= ISNULL(B.Dt_Valid_From,GETDATE())
			AND GETDATE() <= ISNULL(B.Dt_Valid_To,GETDATE())
			
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
				@iStudentMasterID, 
				@iStudentHierarchyDetailID, 
				GETDATE(), 
				1
			)
		END
		ELSE IF @sUserType = 'EM'
		BEGIN
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
		Dt_Upd_On=GETDATE(),
		B_LDAP_User = @bIsLDAPUser,
		Dt_Date_Of_Birth=@DOB
		WHERE I_User_ID = @iUserID

		IF @sUserType <> 'ST' AND @sUserType <> 'EM' AND @sUserType<> 'EMP' AND @sUserType<> 'TE'-- not for student and employer
		BEGIN		
			UPDATE dbo.T_User_Hierarchy_Details
			SET Dt_Valid_To = GETDATE(),
			I_Status = 0
			where I_User_ID = @iUserID 
			AND I_Hierarchy_Master_ID = @iHierarchyMasterID
			--AND I_Hierarchy_Detail_ID = @iOldHierarchyDetailID
			AND I_Status<>0
		
		END
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
