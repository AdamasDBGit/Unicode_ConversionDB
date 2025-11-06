-- =============================================

-- =============================================
CREATE  PROCEDURE [dbo].[SPUpdateInternalStudentDetails_INT]
(
		@UserID				INT,
		@Title				NVARCHAR(MAX),
		@FirstName			NVARCHAR(MAX),
		@MiddleName			NVARCHAR(MAX)=NULL,
		@LastName			NVARCHAR(MAX),
		@Email				NVARCHAR(MAX),
		@MobileNumber		NVARCHAR(MAX)=NULL,
		@CurrentAddress1	NVARCHAR(MAX)=null,			
		@CurrentAddress2	NVARCHAR(MAX)=null,		
		@CurrentCountry		INT,
		@CurrentState		INT,
		@CurrentCity		INT,
		@CurrentZipcode		NVARCHAR(MAX),
		@PermanentAddress1	NVARCHAR(MAX)=null,
		@PermanentAddress2	NVARCHAR(MAX)=null,
		@PermanentCountry	INT,
		@PermanentState		INT,
		@PermanentCity		INT,
		@PermanentZipcode	NVARCHAR(MAX)=null,
		@RegistrationNumber NVARCHAR(MAX),
		@Result				NVARCHAR(MAX) OUTPUT
)
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION

			IF EXISTS (SELECT 1 FROM [T_Student_Detail] WHERE [S_Student_ID]=@RegistrationNumber)
			BEGIN
			PRINT('A')
				UPDATE [T_Student_Detail]
				SET
					[S_Title]			=@Title	,
					[S_First_Name]		=@FirstName	,
					[S_Middle_Name]		=ISNULL(@MiddleName,[S_Middle_Name]),
					[S_Last_Name]		=@LastName	,
					[S_Email_ID]		=@Email	,
					[S_Mobile_No]		=@MobileNumber	,
					[S_Curr_Address1]	=@CurrentAddress1	,
					[S_Curr_Address2]	=@CurrentAddress2	,
					[I_Curr_Country_ID]	=@CurrentCountry	,
					[I_Curr_State_ID]	=@CurrentState	,
					[I_Curr_City_ID]	=@CurrentCity	,
					[S_Curr_Pincode]	=@CurrentZipcode	,
					[S_Perm_Address1]	=@PermanentAddress1	,
					[S_Perm_Address2]	=@PermanentAddress2	,
					[I_Perm_Country_ID]	=@PermanentCountry	,
					[I_Perm_State_ID]	=@PermanentState	,
					[I_Perm_City_ID]	=@PermanentCity	,
					[S_Perm_Pincode]	=@PermanentZipcode	,
					[Dt_Upd_On]			=GETDATE(),
					[S_Upd_By]          =@UserID
				WHERE
				--[I_Student_Detail_ID]=@UserID
				[S_Student_ID]=@RegistrationNumber
				SELECT 
				[S_Title]			AS Title	,
				[S_First_Name]		AS FirstName,
				[S_Middle_Name]		AS MiddleName,
				[S_Last_Name]		AS LastName,
				[S_Email_ID]		AS EmailID,
				[S_Student_ID]		AS StudentID
				FROM 
				[T_Student_Detail]
				WHERE
				--[I_Student_Detail_ID]=@UserID
				[S_Student_ID]=@RegistrationNumber
				SET @Result='Updated'
			END
			ELSE
			BEGIN
			PRINT('B')
				SET @Result='UserNotExists'
			END
		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION;  
		SET @Result='NotUpdated'
		DECLARE 
			@ErrorMessage		VARCHAR(MAX),
			@ErrorSeverity		INT,
			@ErrorState			INT;
		SELECT 
			@ErrorMessage	=		ERROR_MESSAGE(),
			@ErrorSeverity	=		ERROR_SEVERITY(),
			@ErrorState		=		ERROR_STATE();
		RAISERROR 
		(
			@ErrorMessage,
			@ErrorSeverity,
			@ErrorState    
		);    
	END CATCH
END

