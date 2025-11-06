/*****************************************************************************************************************
Created by: Debman Mukherjee
Date: 08/05/2007
Description:Gets the list of nominated faculties for a particular center and training id
Parameters: TrainingId
******************************************************************************************************************/
CREATE PROCEDURE [ACADEMICS].[uspGetFacultyNominationList]
(
	@iTrainingId int,
	@sCenterIDList varchar(5000) = null,
	@CurrentDate datetime,
	@iFlag int
)
AS
SET NOCOUNT OFF
BEGIN TRY 
	
	DECLARE @iCenterID int
	DECLARE @iGetIndex int
	DECLARE @sCenterID varchar(20)
	DECLARE @iLength int

	DECLARE @TemFacultyNomination TABLE
	(
		I_Faculty_Nomination_ID int,
		I_Centre_Id int,
		I_Employee_ID int,
		C_Attended char(1),
		C_Approved char(1),
		N_Marks_Obtd numeric(8,2),
		C_Feedback_Provided char(1),
		C_Feedback_Received char(1),
		S_Emp_ID varchar(20),
		S_Title varchar(10),
		S_First_Name varchar(50),
		S_Middle_Name varchar(50),
		S_Last_Name varchar(50),
		S_Center_Name varchar(100),
		S_Center_Code varchar(20),
		I_User_ID int,
		S_Email_ID varchar(200)
	)
	
	IF @iFlag = 1
	BEGIN
		-- Select list of all nominated faculties
		SELECT
			F.I_Faculty_Nomination_ID,
			F.I_Centre_Id,
			F.I_Employee_ID,
			F.C_Attended,
			F.C_Approved,
			F.N_Marks_Obtd,
			F.C_Feedback_Provided,
			F.C_Feedback_Received,
			E.S_Emp_ID,
			E.S_Title,
			E.S_First_Name,
			E.S_Middle_Name,
			E.S_Last_Name,
			CM.S_Center_Name,
			CM.S_Center_Code,
			UM.I_User_ID,
			UM.S_Email_ID
		FROM
			ACADEMICS.T_Faculty_Nomination F WITH (NOLOCK)
		INNER JOIN dbo.T_Employee_Dtls E
		ON F.I_Employee_ID = E.I_Employee_ID
		INNER JOIN dbo.T_Centre_Master CM
		ON F.I_Centre_Id = CM.I_Centre_Id
		INNER JOIN dbo.T_User_Master UM
		ON F.I_Employee_ID = UM.I_Reference_ID
		AND UM.S_User_Type = 'CE'
		WHERE F.I_Training_ID = @iTrainingId
		AND UM.I_Status = 1
		AND CM.I_Status = 1
		AND E.I_Status IN (3,6)
		AND @CurrentDate >= ISNULL(CM.Dt_Valid_From,@CurrentDate)
		AND @CurrentDate <= ISNULL(CM.Dt_Valid_To,@CurrentDate)
	
	END
	ELSE IF @iFlag = 2
	BEGIN
		-- Select list of finally approved faculty
		SELECT
			F.I_Faculty_Nomination_ID,
			F.I_Centre_Id,
			F.I_Employee_ID,
			F.C_Attended,
			F.C_Approved,
			F.N_Marks_Obtd,
			F.C_Feedback_Provided,
			F.C_Feedback_Received,
			E.S_Emp_ID,
			E.S_Title,
			E.S_First_Name,
			E.S_Middle_Name,
			E.S_Last_Name,
			CM.S_Center_Name,
			CM.S_Center_Code,
			UM.I_User_ID,
			UM.S_Email_ID
		FROM
			ACADEMICS.T_Faculty_Nomination F WITH (NOLOCK)
		INNER JOIN dbo.T_Employee_Dtls E
		ON F.I_Employee_ID = E.I_Employee_ID
		INNER JOIN dbo.T_Centre_Master CM
		ON F.I_Centre_Id = CM.I_Centre_Id
		INNER JOIN dbo.T_User_Master UM
		ON F.I_Employee_ID = UM.I_Reference_ID
		AND UM.S_User_Type = 'CE'
		WHERE F.I_Training_ID = @iTrainingId
		AND F.C_Approved = 'Y'
		AND UM.I_Status = 1
		AND CM.I_Status = 1
		AND E.I_Status IN (3,6)
		AND @CurrentDate >= ISNULL(CM.Dt_Valid_From,@CurrentDate)
		AND @CurrentDate <= ISNULL(CM.Dt_Valid_To,@CurrentDate)
	END
	
	ELSE IF @iFlag = 3
	BEGIN
		-- Select list of faculty whose feedback is not given
		SELECT
			F.I_Faculty_Nomination_ID,
			F.I_Centre_Id,
			F.I_Employee_ID,
			F.C_Attended,
			F.C_Approved,
			F.N_Marks_Obtd,
			F.C_Feedback_Provided,
			F.C_Feedback_Received,
			E.S_Emp_ID,
			E.S_Title,
			E.S_First_Name,
			E.S_Middle_Name,
			E.S_Last_Name,
			CM.S_Center_Name,
			CM.S_Center_Code,
			UM.I_User_ID,
			UM.S_Email_ID
		FROM
			ACADEMICS.T_Faculty_Nomination F WITH (NOLOCK)
		INNER JOIN dbo.T_Employee_Dtls E
		ON F.I_Employee_ID = E.I_Employee_ID
		INNER JOIN dbo.T_Centre_Master CM
		ON F.I_Centre_Id = CM.I_Centre_Id
		INNER JOIN dbo.T_User_Master UM
		ON F.I_Employee_ID = UM.I_Reference_ID
		AND UM.S_User_Type = 'CE'
		WHERE F.I_Training_ID = @iTrainingId
		AND F.C_Attended = 'Y'
		AND ISNULL(F.C_Feedback_Received, 'N') <> 'Y'
		AND UM.I_Status = 1
		AND CM.I_Status = 1
		AND E.I_Status IN (3,6)
		AND @CurrentDate >= ISNULL(CM.Dt_Valid_From,@CurrentDate)
		AND @CurrentDate <= ISNULL(CM.Dt_Valid_To,@CurrentDate)

	END
	
	ELSE IF @iFlag = 4
	BEGIN
		-- Select list of all nominated faculties beloging to particular Centers
		SET @iGetIndex = CHARINDEX(',',LTRIM(RTRIM(@sCenterIDList)),1)
		
		IF @iGetIndex > 1
		BEGIN
			WHILE LEN(@sCenterIDList) > 0
			BEGIN
				SET @iGetIndex = CHARINDEX(',',@sCenterIDList,1)
				SET @iLength = LEN(@sCenterIDList)
				SET @iCenterID = CAST(LTRIM(RTRIM(LEFT(@sCenterIDList,@iGetIndex-1))) AS int)
				
				INSERT INTO @TemFacultyNomination
				(
					I_Faculty_Nomination_ID,
					I_Centre_Id,
					I_Employee_ID,
					C_Attended,
					C_Approved,
					N_Marks_Obtd,
					C_Feedback_Provided,
					C_Feedback_Received,
					S_Emp_ID,
					S_Title,
					S_First_Name,
					S_Middle_Name,
					S_Last_Name,
					S_Center_Name,
					S_Center_Code,
					I_User_ID,
					S_Email_ID
				)
				SELECT
					F.I_Faculty_Nomination_ID,
					F.I_Centre_Id,
					F.I_Employee_ID,
					F.C_Attended,
					F.C_Approved,
					F.N_Marks_Obtd,
					F.C_Feedback_Provided,
					F.C_Feedback_Received,
					E.S_Emp_ID,
					E.S_Title,
					E.S_First_Name,
					E.S_Middle_Name,
					E.S_Last_Name,
					CM.S_Center_Name,
					CM.S_Center_Code,
					UM.I_User_ID,
					UM.S_Email_ID
				FROM
					ACADEMICS.T_Faculty_Nomination F WITH (NOLOCK)
				INNER JOIN dbo.T_Employee_Dtls E
				ON F.I_Employee_ID = E.I_Employee_ID
				INNER JOIN dbo.T_Centre_Master CM
				ON F.I_Centre_Id = CM.I_Centre_Id
				INNER JOIN dbo.T_User_Master UM
				ON F.I_Employee_ID = UM.I_Reference_ID
				AND UM.S_User_Type = 'CE'
				WHERE F.I_Training_ID = @iTrainingId
				AND F.I_Centre_Id = @iCenterID
				AND UM.I_Status = 1
				AND CM.I_Status = 1
				AND E.I_Status IN (3,6)
				AND @CurrentDate >= ISNULL(CM.Dt_Valid_From,@CurrentDate)
				AND @CurrentDate <= ISNULL(CM.Dt_Valid_To,@CurrentDate)

				SELECT @sCenterIDList = SUBSTRING(@sCenterIDList,@iGetIndex + 1, @iLength - @iGetIndex)
				SELECT @sCenterIDList = LTRIM(RTRIM(@sCenterIDList))

			END
		END
		SELECT * FROM @TemFacultyNomination
	END
		
END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
