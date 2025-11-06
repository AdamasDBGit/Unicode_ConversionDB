CREATE PROCEDURE [ACADEMICS].[uspModifyTrainingCalendar] 
(
	@xCenterIDList xml = null,
	@iTrainingID int = null,
	@sTrainingName varchar(200)= null,
	@dTrainingDate datetime = null,	
	@dTrainingEndDate datetime = null,
	@sTrainingDescription varchar(2000) = null,
	@sTrainingVenue varchar(1000)= null,
	@sSkillList xml = null,
	@sTrainingDocketDocID varchar(50)= null,
	@iTrainerID int = null,
	@sTrainerTitle varchar(20) = null,
	@sTrainerFirstName varchar(100) = null,
	@sTrainerMiddleName varchar(100) = null,
	@sTrainerLastName varchar(100) = null,
	@sTrainerEmail varchar(200) = null,
	@sTrainerPassword nvarchar(200) = null,
	@iTrainerRole int = null,
	@iStatus int,
	@sUser varchar(20),
	@dDate datetime,
	@iFlag int
)
AS

BEGIN TRY 

	DECLARE @AdjPosition SMALLINT, @AdjCount SMALLINT 
	DECLARE @sCenterListXML XML, @sCenterXML XML
	DECLARE @sTrainingXML XML, @sSkillXML XML
	DECLARE @iSkillID int, @iCenterID int
	DECLARE @iUserID int
	DECLARE @sLoginID varchar(200)
	
	SET @sLoginID  = ''
	
	-- Inserting New Records in the table
	IF @iFlag = 1
	BEGIN
	
		-- Creating the Trainer if @sTrainerID is 0
		IF @iTrainerID IS NULL OR @iTrainerID = 0
		BEGIN
			BEGIN TRAN T11
			
			SELECT @iUserID = MAX(I_User_ID)
			FROM dbo.T_User_Master
			
			SET @iUserID  = @iUserID + 1
			
			SET @sLoginID = @sTrainerFirstName + CAST(@iUserID AS VARCHAR(5))
			
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
				@sTrainerPassword,
				@sTrainerTitle,
				@sTrainerFirstName,
				ISNULL(@sTrainerMiddleName, null),
				@sTrainerLastName,
				@sTrainerEmail,
				'TE',
				1,
				@sUser,
				@dDate
			)
			
			SET @iTrainerID = SCOPE_IDENTITY()
			
			INSERT INTO dbo.T_User_Role_Details
			(
				I_Role_ID,
				I_User_ID,
				I_Status,
				S_Crtd_By,
				Dt_Crtd_On
			)
			VALUES
			(
				@iTrainerRole,
				@iTrainerID,
				1,
				@sUser,
				@dDate
			)
			
			COMMIT TRAN T11
		END
		ELSE
		BEGIN
			SELECT @sLoginID = S_Login_ID
			FROM dbo.T_User_Master
			WHERE I_User_ID = @iTrainerID
		END	
		
		BEGIN TRAN T1
		
		INSERT INTO ACADEMICS.T_Training_Calendar
		(
			S_Training_Name,
			Dt_Training_Date,
			Dt_Training_End_Date,
			S_Description,
			S_Venue,
			I_Document_ID,
			I_User_ID,
			I_Status,
			S_Crtd_By,
			Dt_Crtd_On
		 )
		VALUES
		 (
			@sTrainingName,
			@dTrainingDate,
			@dTrainingEndDate,
			@sTrainingDescription,
			@sTrainingVenue,
			@sTrainingDocketDocID,
			@iTrainerID,
			@iStatus,
			@sUser,
			@dDate
		  )

		SET @iTrainingID = SCOPE_IDENTITY()

		COMMIT TRAN T1
		
		SET @AdjPosition = 1
		SET @sTrainingXML = @sSkillList.query('/Training[position()=sql:variable("@AdjPosition")]')
		
		SET @AdjCount = @sSkillList.value('count((Training/Skill))','int')
		WHILE(@AdjPosition<=@AdjCount)	
		BEGIN
			SET @sSkillXML = @sSkillList.query('/Training/Skill[position()=sql:variable("@AdjPosition")]')
			SELECT	@iSkillID = T.a.value('@I_Skill_ID','int')
			FROM @sSkillXML.nodes('/Skill') T(a)

			INSERT INTO ACADEMICS.T_Training_Skill
			(
				I_Skill_ID, 
				I_Training_ID, 
				S_Crtd_By, 
				Dt_Crtd_On	
			)
			VALUES
			(
				@iSkillID,
				@iTrainingID,
				@sUser,
				@dDate
			)

		SET @AdjPosition=@AdjPosition+1
		END	

		SET @AdjPosition = 1
		SET @sCenterListXML = @xCenterIDList.query('/Training[position()=sql:variable("@AdjPosition")]')
		
		SET @AdjCount = @xCenterIDList.value('count((Training/Center))','int')
		WHILE(@AdjPosition<=@AdjCount)	
		BEGIN
			SET @sCenterXML = @xCenterIDList.query('/Training/Center[position()=sql:variable("@AdjPosition")]')
			SELECT	@iCenterID = T.a.value('@I_Center_ID','int')
			FROM @sCenterXML.nodes('/Center') T(a)

			INSERT INTO ACADEMICS.T_Training_Center_Mapping
			(
				I_Center_Id, 
				I_Training_ID, 
				I_Status
			)
			VALUES
			(
				@iCenterID,
				@iTrainingID,
				1
			)

		SET @AdjPosition=@AdjPosition+1
		END

	END

	-- Updating Records in the Table
	IF @iFlag = 2
	BEGIN
		
		-- Creating the Trainer if @sTrainerID is 0
		IF @iTrainerID IS NULL OR @iTrainerID = 0
		BEGIN
			BEGIN TRAN T12
			
			SELECT @iUserID = MAX(I_User_ID)
			FROM dbo.T_User_Master
			
			SELECT @iUserID  = @iUserID + 1
			
			SET @sLoginID = @sTrainerFirstName + CAST(@iUserID AS VARCHAR(5))
			
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
				@sTrainerPassword,
				@sTrainerTitle,
				@sTrainerFirstName,
				ISNULL(@sTrainerMiddleName, null),
				@sTrainerLastName,
				@sTrainerEmail,
				'TE',
				1,
				@sUser,
				@dDate
			)
			
			SET @iTrainerID = SCOPE_IDENTITY()
			
			INSERT INTO dbo.T_User_Role_Details
			(
				I_Role_ID,
				I_User_ID,
				I_Status,
				S_Crtd_By,
				Dt_Crtd_On
			)
			VALUES
			(
				@iTrainerRole,
				@iTrainerID,
				1,
				@sUser,
				@dDate
			)
			
			COMMIT TRAN T12
		END
		BEGIN
			SELECT @sLoginID = S_Login_ID
			FROM dbo.T_User_Master
			WHERE I_User_ID = @iTrainerID
		END
		
		UPDATE ACADEMICS.T_Training_Calendar
		SET
			I_User_ID = @iTrainerID,
			S_Training_Name = ISNULL(@sTrainingName,S_Training_Name),
			Dt_Training_Date = ISNULL(@dTrainingDate,Dt_Training_Date),
			Dt_Training_End_Date = ISNULL(@dTrainingEndDate,Dt_Training_End_Date),
			S_Description = ISNULL(@sTrainingDescription,S_Description),
			S_Venue = ISNULL(@sTrainingVenue,S_Venue),
			I_Document_ID = ISNULL(@sTrainingDocketDocID,I_Document_ID),
			I_Status = @iStatus,
			S_Upd_By = @sUser,
			Dt_Upd_On = @dDate
		WHERE I_Training_ID = @iTrainingID

		DELETE FROM ACADEMICS.T_Training_Skill
		WHERE I_Training_ID = @iTrainingID
		
		SET @AdjPosition = 1
		SET @sTrainingXML = @sSkillList.query('/Training[position()=sql:variable("@AdjPosition")]')
		
		SET @AdjCount = @sSkillList.value('count((Training/Skill))','int')
		WHILE(@AdjPosition<=@AdjCount)	
		BEGIN
			SET @sSkillXML = @sSkillList.query('/Training/Skill[position()=sql:variable("@AdjPosition")]')
			SELECT	@iSkillID = T.a.value('@I_Skill_ID','int')
			FROM @sSkillXML.nodes('/Skill') T(a)

			INSERT INTO ACADEMICS.T_Training_Skill
			(
				I_Skill_ID, 
				I_Training_ID, 
				S_Crtd_By, 
				Dt_Crtd_On	
			)
			VALUES
			(
				@iSkillID,
				@iTrainingID,
				@sUser,
				@dDate
			)

		SET @AdjPosition=@AdjPosition+1
		END	

	END

	-- Delete operation in table
	IF @iFlag = 3
	BEGIN
	
		UPDATE ACADEMICS.T_Training_Calendar
		SET
			I_Status = @iStatus,
			S_Upd_By = @sUser,
			Dt_Upd_On = @dDate
		WHERE I_Training_ID = @iTrainingID

		DELETE FROM ACADEMICS.T_Training_Skill
		WHERE I_Training_ID = @iTrainingID
		
		UPDATE ACADEMICS.T_Training_Center_Mapping
		SET
			I_Status = 0
		WHERE I_Training_ID = @iTrainingID
		
	END
	
	SELECT @iTrainingID TrainingID, @sLoginID LoginID

END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
