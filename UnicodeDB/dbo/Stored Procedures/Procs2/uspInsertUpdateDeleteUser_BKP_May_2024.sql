

/*******************************************************
Description : Save E-Project Manual
Author	:     Arindam Roy
Date	:	  05/22/2007
*********************************************************/

CREATE PROCEDURE [dbo].[uspInsertUpdateDeleteUser_BKP_May_2024] 
(
	@iMode int = 0,
	@iFacultyMasterID int = null,
	@sEmployeeCode nvarchar(50) = null,
	@sEmployeeName	 nvarchar(50) = null,
	@sEmployeeType	 nvarchar(50) = null,
	@sMobileNo	 nvarchar(50) = null,
	@dtDOB datetime = null,
	@dtDOJ datetime = null,
	@sGender nvarchar(10) = null,
	@iReligionID int = null,
	@iMaritialID int = null,
	@sPhoto				nvarchar(MAX) = null,
	@sSignature			nvarchar(MAX) = null,
	@sPAN				nvarchar(50) = null,
	@sAadhar			nvarchar(50) = null,
	@sEMail				nvarchar(50)=null,
	@sPresentAddress	nvarchar(MAX) = null,
	@sPermanentAddress	nvarchar(MAX) = null,
	@iStatus			int = 1,
	@iBrandID			int = null,
	@iCreatedBy int = null,
	@ProvideUserAceess int=1,
	@UserID int = null,
	@UserName nvarchar(200)=null,
	@Password nvarchar(200) = null,
	@IsTeachingfaculty bit ='false'
	--@UtRecipient UT_Recipient readonly
)
AS
begin transaction
BEGIN TRY 
DECLARE @FacultyID int
DECLARE @LastUserID int

	IF EXISTS(select * from T_ERP_User where S_Mobile = @sMobileNo and I_User_ID !=@UserID)
		BEGIN
		SELECT 0 StatusFlag,'Duplicate mobile no ' Message
		END

	ELSE IF EXISTS(select * from T_ERP_User as EU
		inner join
		T_User_Profile as UP on EU.I_User_ID=UP.I_User_ID
		where UP.S_PAN=@sPAN and EU.I_User_ID !=@UserID)
		BEGIN
		SELECT 0 StatusFlag,'Duplicate PAN' Message
		END

	ELSE IF EXISTS(
		select * from T_ERP_User as EU
		inner join
		T_User_Profile as UP on EU.I_User_ID=UP.I_User_ID
		where UP.S_Aadhaar=@sAadhar and UP.I_User_ID !=@UserID
		)
		BEGIN
		SELECT 0 StatusFlag,'Duplicate Aadhar' Message
		END

	ELSE IF EXISTS(
		select * from T_ERP_User as EU
		inner join
		T_User_Profile as UP on EU.I_User_ID=UP.I_User_ID
		where EU.[S_Email]=@sEMail and EU.I_User_ID !=@UserID
		)
		BEGIN
		SELECT 0 StatusFlag,'Duplicate Email' Message
		END

	ELSE IF EXISTS(
		select * from T_ERP_User as EU
		inner join
		T_User_Profile as UP on EU.I_User_ID=UP.I_User_ID 
		where UP.S_EMP_Code=@sEmployeeCode and EU.I_User_ID !=@UserID
		)
		BEGIN
		SELECT 0 StatusFlag, 'Duplicate Employee Code' Message
		END



ELSE 

	BEGIN


	DECLARE @FullName VARCHAR(200);
						set @FullName=@sEmployeeName

						DECLARE @FirstSpaceIndex INT, 
						@LastSpaceIndex INT,
						@FirstName VARCHAR(50),
						@MiddleName VARCHAR(50),
						@LastName VARCHAR(50);

				SET @FirstSpaceIndex = CHARINDEX(' ', @FullName);
				SET @LastSpaceIndex = LEN(@FullName) - CHARINDEX(' ', REVERSE(@FullName)) + 1;

				-- Check if there is a space in the full name
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

				--SELECT @FirstName AS FirstName, @MiddleName AS MiddleName, @LastName AS LastName;

					DECLARE  @iuserType INT=NULL
					IF @IsTeachingfaculty ='true'
					BEGIN
						SET @iuserType=2
					END


			IF (@iMode >= 1 AND @UserID > 0)
				BEGIN
					UPDATE T_User_Master set I_Status = 0 WHERE I_User_ID = @UserID
					IF EXISTS(SELECT * from T_Faculty_Master where I_User_ID=@UserID)
					BEGIN
						 UPDATE T_Faculty_Master set I_Status = 0 WHERE I_User_ID = @UserID
					END
					SELECT 1 AS StatusFlag, 'User Deactivated successfully' AS Message
				END

			ELSE IF(@iMode <= 0 AND @UserID > 0 )
			
		


					BEGIN
		
					IF EXISTS(select * from T_ERP_User where S_Mobile = @sMobileNo and I_User_ID=@UserID)
					BEGIN

						

						DECLARE @updateduserID int 



						set @updateduserID = (select I_User_ID  from T_ERP_User where user=@sMobileNo )

						

						UPDATE T_ERP_User 
						SET 
						--S_Username = ISNULL(@UserName,S_Username),
						--S_Password = ISNULL(@Password,S_Password), 
						S_Email=@sEMail,
						S_First_Name=@FirstName,
						S_Middle_Name=@MiddleName,
						S_Last_Name=@LastName,
						S_Mobile=@sMobileNo, 
						I_Created_By=@iCreatedBy,
						I_Status=@iStatus,
						Is_Teaching_Staff=@IsTeachingfaculty,
						I_User_Type=@iuserType
						where S_Mobile=@sMobileNo  

						Update T_User_Profile 
						SET 
						[S_EMP_Code] = @sEmployeeCode,
						[S_EMP_Type] = @sEmployeeType,
						[Dt_DOJ] = Dt_DOJ,
						[Dt_DOB] =Dt_DOB,
						[S_Gender] = @sGender,
						[I_Religion_ID] = @iReligionID,
						[I_Maritial_ID] = I_Maritial_ID,
						[S_Photo] = @sPhoto,
						[S_Signature] = @sSignature,
						[S_PAN] = @sPAN,
						[S_Aadhaar] = @sAadhar,
						[S_Present_Address] = @sPresentAddress,
						[S_Permanent_Address]= @sPermanentAddress,
						[I_Status]=@iStatus,
						[I_Brand_ID]=@iBrandID
						where I_User_ID=@UserID

						IF @IsTeachingfaculty = 'false'
						BEGIN
							update T_Faculty_Master  set I_Status=0 where I_User_ID=@UserID
						END
						ELSE IF EXISTS(select * from T_Faculty_Master where I_User_ID=@UserID)
						BEGIN

							UPDATE T_Faculty_Master
							SET
							 [S_Faculty_Code]				=@sEmployeeCode
							,[S_Faculty_Name]				=@sEmployeeName
							,[S_Faculty_Type]				=@sEmployeeType
							,[Dt_DOJ]						=@dtDOJ
							,[I_CreatedBy]					=@iCreatedBy
							,[Dt_DOB]						=@dtDOB
							,[S_Gender]						=@sGender
							,[I_Religion_ID]				=@iReligionID
							,[I_Maritial_ID]				=@iMaritialID
							,[S_Mobile_No]					=@sMobileNo
							,[S_Photo]						=@sPhoto				
							,[S_Signature]					=@sSignature			
							,[S_PAN]						=@sPAN				
							,[S_Aadhaar]					=@sAadhar			
							,[S_Email]						=@sEMail				
							,[S_Present_Address]			=@sPresentAddress	
							,[S_Permanent_Address]			=@sPermanentAddress	
							,[Dt_CreatedAt]					=GETDATE()--
							,[I_Status]						=@iStatus			
							,[I_Brand_ID]					=@iBrandID	
			
							where I_User_ID = @UserID


							if not exists(select * from T_ERP_User_Brand where I_User_ID=@UserID and I_Brand_ID=@iBrandID and Is_Active='true')
							BEGIN

								insert into T_ERP_User_Brand
								(
								I_User_ID,
								I_Brand_ID,
								Is_Active,
								Dt_CreatedAt,
								I_CreatedBy
								)
								values
								(
								@UserID,
								@iBrandID,
								1,
								GETDATE(),
								@iCreatedBy
								)

							END


						END
						ELSE IF not exists(select * from T_Faculty_Master where I_User_ID=@UserID)
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
								 @sEmployeeCode--
								,@sEmployeeName--
								,@sEmployeeType--
								,@dtDOJ--
								,@iCreatedBy--
								,@dtDOB--
								,@sGender--
								,@iReligionID--
								,@iMaritialID--
								,@sPhoto				--
								,@sMobileNo
								,@sSignature			--
								,@sPAN				--
								,@sAadhar			--
								,@sEMail				--
								,@sPresentAddress	--
								,@sPermanentAddress	--
								,GETDATE()--
								,@iStatus			--
								,@iBrandID			--
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
							  Is_Teaching_Staff
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
							  @IsTeachingfaculty
							)

							set @LastUserID = SCOPE_IDENTITY()


							if not exists(select * from T_ERP_User_Brand where I_User_ID=@LastUserID and I_Brand_ID=@iBrandID and Is_Active='true')
							BEGIN

								insert into T_ERP_User_Brand
								(
								I_User_ID,
								I_Brand_ID,
								Is_Active,
								Dt_CreatedAt,
								I_CreatedBy
								)
								values
								(
								@LastUserID,
								@iBrandID,
								1,
								GETDATE(),
								@iCreatedBy
								)

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
							 @sEmployeeCode--
							,@sEmployeeType--
							,@dtDOJ--
							,@iCreatedBy--
							,@dtDOB--
							,@sGender--
							,@iReligionID--
							,@iMaritialID--
							,@sPhoto
							,@sSignature			--
							,@sPAN				--
							,@sAadhar			--
							,@sPresentAddress	--
							,@sPermanentAddress	--
							,GETDATE()--
							,@iStatus			--
							,@iBrandID			--
							,@LastUserID
							)



				IF (@IsTeachingfaculty = 'true')		
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
							 @sEmployeeCode--
							,@sEmployeeName--
							,@sEmployeeType--
							,@dtDOJ--
							,@iCreatedBy--
							,@dtDOB--
							,@sGender--
							,@iReligionID--
							,@iMaritialID--
							,@sPhoto				--
							,@sMobileNo
							,@sSignature			--
							,@sPAN				--
							,@sAadhar			--
							,@sEMail				--
							,@sPresentAddress	--
							,@sPermanentAddress	--
							,GETDATE()--
							,@iStatus			--
							,@iBrandID
							,@LastUserID--
							)
							set @FacultyID = SCOPE_IDENTITY()
					END
					

					SELECT 1 StatusFlag,'User added succesfully' Message
			END

			

	END

END TRY
BEGIN CATCH
	rollback transaction
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()
select 0 StatusFlag,@ErrMsg Message
	--RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
commit transaction
