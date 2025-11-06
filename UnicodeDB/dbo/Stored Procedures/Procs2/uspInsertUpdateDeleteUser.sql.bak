CREATE PROCEDURE [dbo].[uspInsertUpdateDeleteUser] 
(
	@iMode				INT = 0,
	@iFacultyMasterID	INT = NULL,
	@sEmployeeCode		NVARCHAR(50) = NULL,
	@sEmployeeName		NVARCHAR(50) = NULL,
	@sEmployeeType		NVARCHAR(50) = NULL,
	@sMobileNo			NVARCHAR(50) = NULL,
	@dtDOB				DATETIME = NULL,
	@dtDOJ				DATETIME = NULL,
	@sGender			NVARCHAR(10) = NULL,
	@iReligionID		INT = NULL,
	@iMaritialID		INT = NULL,
	@sPhoto				NVARCHAR(MAX) = NULL,
	@sSignature			NVARCHAR(MAX) = NULL,
	@sPAN				NVARCHAR(50) = NULL,
	@sAadhar			NVARCHAR(50) = NULL,
	@sEMail				NVARCHAR(50)=NULL,
	@sPresentAddress	NVARCHAR(MAX) = NULL,
	@sPermanentAddress	NVARCHAR(MAX) = NULL,
	@iStatus			INT = 1,
	@iBrandID			INT = NULL,
	@iCreatedBy			INT = NULL,
	@ProvideUserAceess  INT=1,
	@UserID				INT = NULL,
	@UserName			NVARCHAR(200)=NULL,
	@Password			NVARCHAR(200) = NULL,
	@IsTeachingfaculty  BIT ='false',
	@UserCode		    NVARCHAR(10)
)
AS
begin transaction
BEGIN TRY 
DECLARE @FacultyID INT
DECLARE @LastUserID INT

	IF EXISTS(SELECT * FROM T_ERP_User WHERE S_Mobile = @sMobileNo AND I_User_ID !=@UserID AND I_Status=1)
		BEGIN
		SELECT 0 StatusFlag,'Duplicate mobile no ' Message
		END

	ELSE IF EXISTS(SELECT * FROM T_ERP_User AS EU
		INNER JOIN
		T_User_Profile AS UP ON EU.I_User_ID=UP.I_User_ID
		WHERE UP.S_PAN=@sPAN AND EU.I_User_ID !=@UserID AND EU.I_Status=1)
		BEGIN
		SELECT 0 StatusFlag,'Duplicate PAN' Message
		END

	ELSE IF EXISTS(
		SELECT * FROM T_ERP_User AS EU
		INNER JOIN
		T_User_Profile AS UP ON EU.I_User_ID=UP.I_User_ID
		WHERE UP.S_Aadhaar=@sAadhar AND UP.I_User_ID !=@UserID AND EU.I_Status=1
		)
		BEGIN
		SELECT 0 StatusFlag,'Duplicate Aadhar' Message
		END

	ELSE IF EXISTS(
		SELECT * FROM T_ERP_User AS EU
		INNER JOIN
		T_User_Profile AS UP ON EU.I_User_ID=UP.I_User_ID
		WHERE EU.[S_Email]=@sEMail AND EU.I_User_ID !=@UserID AND EU.I_Status=1
		)
		BEGIN
		SELECT 0 StatusFlag,'Duplicate Email' Message
		END

	ELSE IF EXISTS(
		SELECT * FROM T_ERP_User AS EU
		INNER JOIN
		T_User_Profile AS UP ON EU.I_User_ID=UP.I_User_ID 
		WHERE UP.S_EMP_Code=@sEmployeeCode AND EU.I_User_ID !=@UserID AND EU.I_Status=1
		)
		BEGIN
		SELECT 0 StatusFlag, 'Duplicate Employee Id' Message
		END

	ELSE IF EXISTS(
		SELECT * FROM T_ERP_User AS EU
		INNER JOIN
		T_User_Profile AS UP ON EU.I_User_ID=UP.I_User_ID 
		WHERE EU.S_Username=@UserName AND EU.I_User_ID !=@UserID AND EU.I_Status=1
		)
		BEGIN
		SELECT 0 StatusFlag, 'Duplicate User Name' Message
		END
	ELSE 
		BEGIN
		DECLARE @FullName VARCHAR(200);
				
			SET @FullName=@sEmployeeName
			DECLARE @FirstSpaceIndex INT, 
					@LastSpaceIndex INT,
					@FirstName VARCHAR(50),
					@MiddleName VARCHAR(50),
					@LastName VARCHAR(50);

			SET @FirstSpaceIndex = CHARINDEX(' ', @FullName);
			SET @LastSpaceIndex = LEN(@FullName) - CHARINDEX(' ', REVERSE(@FullName)) + 1;

		    -- Check IF there is a space in the full name
			IF @FirstSpaceIndex > 0
			BEGIN
				SET @FirstName = SUBSTRING(@FullName, 1, @FirstSpaceIndex - 1);
				SET @MiddleName = CASE WHEN @FirstSpaceIndex < @LastSpaceIndex - 1
									  THEN SUBSTRING(@FullName, @FirstSpaceIndex + 1, @LastSpaceIndex - @FirstSpaceIndex - 1)
									  ELSE NULL
								 END;
				SET @LastName = SUBSTRING(@FullName, @LastSpaceIndex, LEN(@FullName) - @LastSpaceIndex + 1);
			END
			ELSE
			BEGIN
				SET @FirstName = @FullName;
				SET @MiddleName = NULL;
				SET @LastName = NULL;
			END
						
			DECLARE  @iuserType INT=NULL
			IF @IsTeachingfaculty ='true'
			BEGIN
				SET @iuserType=2
			END


			IF (@iMode >= 1 AND @UserID > 0)
				BEGIN
					UPDATE T_User_Master SET I_Status = 0 WHERE I_User_ID = @UserID
					IF EXISTS(SELECT * FROM T_Faculty_Master WHERE I_User_ID=@UserID)
					BEGIN
						 UPDATE T_Faculty_Master SET I_Status = 0 WHERE I_User_ID = @UserID
					END
					SELECT 1 AS StatusFlag, 'User Deactivated successfully' AS Message
				END

			ELSE IF(@iMode <= 0 AND @UserID > 0 )
				BEGIN		
					IF EXISTS(SELECT * FROM T_ERP_User WHERE S_Mobile = @sMobileNo AND I_User_ID = @UserID)
					BEGIN
						--DECLARE @updateduserID INT 
						--SET @updateduserID = (SELECT I_User_ID  FROM T_ERP_User WHERE user=@sMobileNo)

						UPDATE T_ERP_User 
						SET 
							--S_Username = ISNULL(@UserName,S_Username),
							S_Password = ISNULL(@Password,S_Password), 
							S_Email = @sEMail,
							S_First_Name = @FirstName,
							S_Middle_Name = @MiddleName,
							S_Last_Name = @LastName,
							S_Mobile = @sMobileNo, 
							I_Created_By = @iCreatedBy,
							I_Status = @iStatus,
							--Is_Teaching_Staff=@IsTeachingfaculty, -- susmita : 2024-May-2024
							I_User_Type = @iuserType,
							stUserCode = @UserCode
						WHERE 
							S_Mobile = @sMobileNo  

						UPDATE T_ERP_User_Brand
						SET
							Is_Teaching_Staff = @IsTeachingfaculty 
						WHERE 
							I_Brand_ID = @iBrandID AND
							Is_Active = 1 AND 
							I_User_ID = @UserID


						UPDATE T_User_Profile 
						SET 
							[S_EMP_Code] = @sEmployeeCode,
							[S_EMP_Type] = @sEmployeeType,
							[Dt_DOJ] = @dtDOJ,
							[Dt_DOB] = @dtDOB,
							[S_Gender] = @sGender,
							[I_Religion_ID] = @iReligionID,
							[I_Maritial_ID] = @iMaritialID,
							[S_Photo] = @sPhoto,
							[S_Signature] = @sSignature,
							[S_PAN] = @sPAN,
							[S_Aadhaar] = @sAadhar,
							[S_Present_Address] = @sPresentAddress,
							[S_Permanent_Address]= @sPermanentAddress,
							[I_Status] = @iStatus,
							[I_Brand_ID] = NULL
						WHERE
							I_User_ID = @UserID

						IF @IsTeachingfaculty = 'false'
						BEGIN
							
							UPDATE T_ERP_User_Brand
							SET
								Is_Teaching_Staff = @IsTeachingfaculty 
							WHERE 
								I_Brand_ID = @iBrandID AND 
								Is_Active = 1 AND
								I_User_ID = @UserID
						END
						ELSE IF EXISTS(SELECT * FROM T_Faculty_Master WHERE I_User_ID=@UserID)
							BEGIN
								UPDATE T_Faculty_Master
								SET
									 [S_Faculty_Code]		= @sEmployeeCode
									,[S_Faculty_Name]		= @sEmployeeName
									,[S_Faculty_Type]		= @sEmployeeType
									,[Dt_DOJ]				= @dtDOJ
									,[I_CreatedBy]			= @iCreatedBy
									,[Dt_DOB]				= @dtDOB
									,[S_Gender]				= @sGender
									,[I_Religion_ID]		= @iReligionID
									,[I_Maritial_ID]		= @iMaritialID
									,[S_Mobile_No]			= @sMobileNo
									,[S_Photo]				= @sPhoto				
									,[S_Signature]			= @sSignature			
									,[S_PAN]				= @sPAN				
									,[S_Aadhaar]			= @sAadhar			
									,[S_Email]				= @sEMail				
									,[S_Present_Address]	= @sPresentAddress	
									,[S_Permanent_Address]	= @sPermanentAddress	
									,[Dt_CreatedAt]			= GETDATE()
									,[I_Status]				= @iStatus			
									,[I_Brand_ID]			= @iBrandID				
								WHERE
									I_User_ID = @UserID


							IF NOT EXISTS(SELECT * FROM T_ERP_User_Brand WHERE I_User_ID = @UserID AND I_Brand_ID = @iBrandID AND Is_Active = 'true')
							BEGIN
								INSERT INTO T_ERP_User_Brand
								(
									I_User_ID,
									I_Brand_ID,
									Is_Active,
									Dt_CreatedAt,
									I_CreatedBy,
									Is_Teaching_Staff
								)
								VALUES
								(
									@UserID,
									@iBrandID,
									1,
									GETDATE(),
									@iCreatedBy,
									@IsTeachingfaculty
								)
							END
						END
						ELSE IF NOT EXISTS(SELECT * FROM T_Faculty_Master WHERE I_User_ID = @UserID)
					    	BEGIN
							INSERT INTO [T_Faculty_Master]
								(
									 [S_Faculty_Code]
									,[S_Faculty_Name]
									,[S_Faculty_Type]
									,[Dt_DOJ]
									,[I_CreatedBy]
									,[Dt_DOB]
									,[S_Gender]
									,[I_Religion_ID]
									,[I_Maritial_ID]
									,[S_Photo]
									,[S_Mobile_No]
									,[S_Signature]
									,[S_PAN]
									,[S_Aadhaar]
									,[S_Email]
									,[S_Present_Address]
									,[S_Permanent_Address]
									,[Dt_CreatedAt]
									,[I_Status]
									,[I_Brand_ID]
									,I_User_ID
								)
								VALUES
								(
									 @sEmployeeCode
									,@sEmployeeName
									,@sEmployeeType
									,@dtDOJ
									,@iCreatedBy
									,@dtDOB
									,@sGender
									,@iReligionID
									,@iMaritialID
									,@sPhoto				
									,@sMobileNo
									,@sSignature			
									,@sPAN				
									,@sAadhar			
									,@sEMail				
									,@sPresentAddress	
									,@sPermanentAddress	
									,GETDATE()
									,@iStatus			
									,@iBrandID			
									,@UserID
								)
						END

						SELECT 1 StatusFlag,'User updated succesfully' Message
					END
					ELSE
					BEGIN
							SELECT 0 StatusFlag,'User Mobile no not matching' Message
					END
					END
			ELSE
			BEGIN		
					INSERT INTO T_ERP_User
					( 
						 S_Username, 
						 S_Password, 
						 S_Email,
						 S_First_Name,
						 S_Middle_Name,
						 S_Last_Name,
						 S_Mobile, 
						 Dt_CreatedAt, 
						 I_Created_By,
						 Dt_Last_Login, 
						 I_Status,
						 I_User_Type,
						 Is_Teaching_Staff,
						 stUserCode 
					)        
					VALUES
					( 
						 @UserName,  
						 @Password, 
						 @sEMail,
						 @FirstName,
						 @MiddleName,
						 @LastName,
						 @sMobileNo, 
						 GETDATE(), 
						 @iCreatedBy,
						 GETDATE(), 
						 1,
						 @iuserType,
						 @IsTeachingfaculty,
						 @UserCode
					)

					SET @LastUserID = SCOPE_IDENTITY()
					IF NOT EXISTS(SELECT * FROM T_ERP_User_Brand WHERE I_User_ID=@LastUserID AND I_Brand_ID=@iBrandID AND Is_Active='true')
					BEGIN
						INSERT INTO T_ERP_User_Brand
						(
							I_User_ID,
							I_Brand_ID,
							Is_Active,
							Dt_CreatedAt,
							I_CreatedBy,
							Is_Teaching_Staff
						)
						VALUES
						(
							@LastUserID,
							@iBrandID,
							1,
							GETDATE(),
							@iCreatedBy,
							@IsTeachingfaculty
						)

					END
					ELSE
					BEGIN
						UPDATE T_ERP_User_Brand
						SET 
							Is_Teaching_Staff = @IsTeachingfaculty 
						WHERE 
							I_Brand_ID=@iBrandID AND Is_Active=1 AND I_User_ID=@LastUserID
					END
						INSERT INTO T_User_Profile
							(
								 [S_EMP_Code]
								,[S_EMP_Type]
								,[Dt_DOJ]
								,[I_CreatedBy]
								,[Dt_DOB]
								,[S_Gender]
								,[I_Religion_ID]
								,[I_Maritial_ID]
								,[S_Photo]
								,[S_Signature]
								,[S_PAN]
								,[S_Aadhaar]
								,[S_Present_Address]
								,[S_Permanent_Address]
								,[Dt_CreatedAt]
								,[I_Status]
								,[I_Brand_ID],
								I_User_ID
							)
							VALUES
							(
								 @sEmployeeCode
								,@sEmployeeType
								,@dtDOJ
								,@iCreatedBy
								,@dtDOB
								,@sGender
								,@iReligionID
								,@iMaritialID
								,@sPhoto
								,@sSignature			
								,@sPAN				
								,@sAadhar			
								,@sPresentAddress	
								,@sPermanentAddress	
								,GETDATE()
								,@iStatus			
								,@iBrandID			
								,@LastUserID
							)
				IF (@IsTeachingfaculty = 'true')	
				BEGIN
					IF EXISTS(SELECT * FROM T_Faculty_Master WHERE I_User_ID=@LastUserID)
						BEGIN
							UPDATE T_Faculty_Master
							SET
								 [S_Faculty_Code]		= @sEmployeeCode
								,[S_Faculty_Name]		= @sEmployeeName
								,[S_Faculty_Type]		= @sEmployeeType
								,[Dt_DOJ]				= @dtDOJ
								,[I_CreatedBy]			= @iCreatedBy
								,[Dt_DOB]				= @dtDOB
								,[S_Gender]				= @sGender
								,[I_Religion_ID]		= @iReligionID
								,[I_Maritial_ID]		= @iMaritialID
								,[S_Mobile_No]			= @sMobileNo
								,[S_Photo]				= @sPhoto				
								,[S_Signature]			= @sSignature			
								,[S_PAN]				= @sPAN				
								,[S_Aadhaar]			= @sAadhar			
								,[S_Email]				= @sEMail				
								,[S_Present_Address]	= @sPresentAddress	
								,[S_Permanent_Address]	= @sPermanentAddress	
								,[Dt_CreatedAt]			= GETDATE()
								,[I_Status]				= @iStatus			
								,[I_Brand_ID]			= @iBrandID															  
							WHERE 
								I_User_ID = @UserID
						END
					ELSE
						BEGIN
							INSERT INTO [T_Faculty_Master]
							(
								 [S_Faculty_Code]
								,[S_Faculty_Name]
								,[S_Faculty_Type]
								,[Dt_DOJ]
								,[I_CreatedBy]
								,[Dt_DOB]
								,[S_Gender]
								,[I_Religion_ID]
								,[I_Maritial_ID]
								,[S_Photo]
								,[S_Mobile_No]
								,[S_Signature]
								,[S_PAN]
								,[S_Aadhaar]
								,[S_Email]
								,[S_Present_Address]
								,[S_Permanent_Address]
								,[Dt_CreatedAt]
								,[I_Status]
								,[I_Brand_ID]
								,I_User_ID
							)
							VALUES
							(
								 @sEmployeeCode
								,@sEmployeeName
								,@sEmployeeType
								,@dtDOJ
								,@iCreatedBy
								,@dtDOB
								,@sGender
								,@iReligionID
								,@iMaritialID
								,@sPhoto				
								,@sMobileNo
								,@sSignature			
								,@sPAN				
								,@sAadhar			
								,@sEMail				
								,@sPresentAddress	
								,@sPermanentAddress	
								,GETDATE()
								,@iStatus			
								,@iBrandID
								,@LastUserID
							)
							SET @FacultyID = SCOPE_IDENTITY()
						END
					END			

					SELECT 1 StatusFlag,'User added succesfully' Message
			END	
	END

END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity INT

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()
	SELECT 0 StatusFlag,@ErrMsg Message
END CATCH
COMMIT TRANSACTION