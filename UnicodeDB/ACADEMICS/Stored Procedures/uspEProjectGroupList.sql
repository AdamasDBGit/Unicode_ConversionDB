/*******************************************************
Description : Get E-Project Group Details
Author	:     Abhisek Bhattacharya
Date	:	  05/21/2007
*********************************************************/

CREATE PROCEDURE [ACADEMICS].[uspEProjectGroupList] 
(
	@iCourseID int= null,
	@iTermID int= null,
	@iModuleID int= null,
	@iCenterID int= null,
	@iStudentDetailID int = null,
	@dFromDate datetime = null,
	@dToDate datetime = null,
	@dCurrentDate datetime=null,
	@sCenterIDList varchar(500) = null,
	@iFlag int
)

AS

BEGIN TRY 

DECLARE @iGetIndex int
DECLARE @sCenterID varchar(20)
DECLARE @iLength int

DECLARE @TemEProjectGroup TABLE
(
	I_E_Project_Group_ID int,
	S_Group_Desc varchar(200), 
	Dt_Project_Start_Date datetime,
	Dt_Project_End_Date datetime, 
	Dt_Cancellation_Date datetime, 
	Dt_New_End_Date datetime, 
	S_Reason varchar(500), 
	S_Cancellation_Reason varchar(2000),
	I_Status int, 
	I_E_Project_Spec_ID int,
	S_Description varchar(500), 
	I_File_ID int,
	S_Document_Name varchar(1000),
	S_Document_Type varchar(50),
	S_Document_Path varchar(5000),
	S_Document_URL varchar(5000),
	I_Centre_Id int,
	S_Center_Code varchar(20),
	S_Center_Name varchar(100),
	I_Course_ID int,
	S_Course_Code varchar(50),
	S_Course_Name varchar(250),
	I_Term_ID int,
	S_Term_Code varchar(50),
	S_Term_Name varchar(250),
	I_Module_ID int,
	S_Module_Code varchar(50),
	S_Module_Name varchar(250)
)

-- All GroupList details
IF(@iFlag = 1)
BEGIN

	SELECT  EPG.I_E_Project_Group_ID,
			EPG.S_Group_Desc, 
			EPG.Dt_Project_Start_Date,
			EPG.Dt_Project_End_Date, 
			EPG.Dt_Cancellation_Date, 
			EPE.Dt_New_End_Date, 
			EPE.S_Reason, 
			EPG.S_Cancellation_Reason,
			EPG.I_Status, 
			EPG.I_E_Project_Spec_ID,
			EPS.S_Description, 
			EPS.I_File_ID,
			UD.S_Document_Name,
			UD.S_Document_Type,
			UD.S_Document_Path,
			UD.S_Document_URL,
			CNM.I_Centre_Id,
			CNM.S_Center_Code,
			CNM.S_Center_Name,
			CM.I_Course_ID,
			CM.S_Course_Code,
			CM.S_Course_Name,
			TM.I_Term_ID,
			TM.S_Term_Code,
			TM.S_Term_Name,
			MM.I_Module_ID,
			MM.S_Module_Code,
			MM.S_Module_Name
			FROM ACADEMICS.T_E_Project_Group EPG 
			INNER JOIN ACADEMICS.T_E_Project_Spec EPS
			ON EPG.I_E_Project_Spec_ID = EPS.I_E_Project_Spec_ID
			INNER JOIN dbo.T_Centre_Master CNM
			ON EPG.I_Center_ID = CNM.I_Centre_ID
			AND CNM.I_Status = 1
			INNER JOIN dbo.T_Course_Master CM
			ON EPG.I_Course_ID = CM.I_Course_ID
			AND CM.I_Status = 1
			INNER JOIN dbo.T_Term_Master TM
			ON EPG.I_Term_ID = TM.I_Term_ID
			AND TM.I_Status = 1
			INNER JOIN dbo.T_Module_Master MM
			ON EPG.I_Module_ID = MM.I_Module_ID
			AND MM.I_Status =1
			INNER JOIN dbo.T_Upload_Document UD
			ON EPS.I_File_ID = UD.I_Document_ID
			AND UD.I_Status = 1
			LEFT OUTER JOIN ACADEMICS.T_E_Project_Extension EPE 
			ON EPE.I_E_Project_Group_ID=EPG.I_E_Project_Group_ID
			AND EPE.I_Status =1
			WHERE EPG.I_Course_ID=@iCourseID
			AND EPG.I_Term_ID=@iTermID
			AND EPG.I_Module_ID=@iModuleID
			AND EPG.I_Center_ID=@iCenterID
			AND ISNULL(@dFromDate, EPG.Dt_Project_Start_Date) <= EPG.Dt_Project_Start_Date
			AND ISNULL(@dToDate, EPG.Dt_Project_Start_Date) >= EPG.Dt_Project_Start_Date 
			AND EPG.I_Status <> 3
			AND EPS.I_Status = 1
			ORDER BY EPG.Dt_Project_Start_Date DESC
END

-- GroupList details for students requesting for E-Project Extension
IF(@iFlag = 2)
BEGIN

	SELECT  EPG.I_E_Project_Group_ID,
			EPG.S_Group_Desc, 
			EPG.Dt_Project_Start_Date,
			EPG.Dt_Project_End_Date, 
			EPG.Dt_Cancellation_Date, 
			EPE.Dt_New_End_Date, 
			EPE.S_Reason, 
			EPG.S_Cancellation_Reason,
			EPG.I_Status, 
			EPG.I_E_Project_Spec_ID, 
			EPS.S_Description, 
			EPS.I_File_ID,
			UD.S_Document_Name,
			UD.S_Document_Type,
			UD.S_Document_Path,
			UD.S_Document_URL,
			CNM.I_Centre_Id,
			CNM.S_Center_Code,
			CNM.S_Center_Name,
			CM.I_Course_ID,
			CM.S_Course_Code,
			CM.S_Course_Name,
			TM.I_Term_ID,
			TM.S_Term_Code,
			TM.S_Term_Name,
			MM.I_Module_ID,
			MM.S_Module_Code,
			MM.S_Module_Name
			FROM ACADEMICS.T_E_Project_Group EPG 
			INNER JOIN ACADEMICS.T_E_Project_Spec EPS
			ON EPS.I_E_Project_Spec_ID=EPG.I_E_Project_Spec_ID
			INNER JOIN ACADEMICS.T_E_Project_Extension EPE 
			ON EPE.I_E_Project_Group_ID=EPG.I_E_Project_Group_ID
			AND EPE.I_Status = 1
			INNER JOIN dbo.T_Centre_Master CNM
			ON EPG.I_Center_ID = CNM.I_Centre_ID
			AND CNM.I_Status = 1
			INNER JOIN dbo.T_Course_Master CM
			ON EPG.I_Course_ID = CM.I_Course_ID
			AND CM.I_Status = 1
			INNER JOIN dbo.T_Term_Master TM
			ON EPG.I_Term_ID = TM.I_Term_ID
			AND TM.I_Status = 1
			INNER JOIN dbo.T_Module_Master MM
			ON EPG.I_Module_ID = MM.I_Module_ID
			AND MM.I_Status =1
			INNER JOIN dbo.T_Upload_Document UD
			ON EPS.I_File_ID = UD.I_Document_ID
			AND UD.I_Status = 1
			WHERE EPG.I_Course_ID=@iCourseID
			AND EPG.I_Term_ID=@iTermID
			AND EPG.I_Module_ID=@iModuleID
			AND EPG.I_Center_ID=@iCenterID
			AND EPG.I_Status <> 3
			ORDER BY EPG.Dt_Project_Start_Date DESC
END 

-- GroupList details for the specified Student
IF(@iFlag = 3)
BEGIN

	SELECT  EPG.I_E_Project_Group_ID,
			EPG.S_Group_Desc, 
			EPG.Dt_Project_Start_Date,
			EPG.Dt_Project_End_Date, 
			EPG.Dt_Cancellation_Date, 
			EPG.S_Cancellation_Reason,
			EPG.I_Status,
			EPG.I_E_Project_Spec_ID, 
			EPS.S_Description, 
			EPS.I_File_ID,
			UD.S_Document_Name,
			UD.S_Document_Type,
			UD.S_Document_Path,
			UD.S_Document_URL,
			EPE.Dt_New_End_Date, 
			EPE.S_Reason,
			CNM.I_Centre_Id,
			CNM.S_Center_Code,
			CNM.S_Center_Name,
			CM.I_Course_ID,
			CM.S_Course_Code,
			CM.S_Course_Name,
			TM.I_Term_ID,
			TM.S_Term_Code,
			TM.S_Term_Name,
			MM.I_Module_ID,
			MM.S_Module_Code,
			MM.S_Module_Name
			FROM ACADEMICS.T_E_Project_Group EPG
			INNER JOIN  ACADEMICS.T_Center_E_Project_Manual CEM  WITH(NOLOCK)
			ON CEM.I_E_Project_Group_ID = EPG.I_E_Project_Group_ID
			AND CEM.I_Student_Detail_ID = @iStudentDetailID
			AND CEM.I_Status <> 3
			INNER JOIN ACADEMICS.T_E_Project_Spec EPS
			ON EPS.I_E_Project_Spec_ID=EPG.I_E_Project_Spec_ID
			INNER JOIN dbo.T_Upload_Document UD
			ON EPS.I_File_ID = UD.I_Document_ID
			AND UD.I_Status = 1
			INNER JOIN dbo.T_Centre_Master CNM
			ON EPG.I_Center_ID = CNM.I_Centre_ID
			AND CNM.I_Status = 1
			INNER JOIN dbo.T_Course_Master CM
			ON EPG.I_Course_ID = CM.I_Course_ID
			AND CM.I_Status = 1
			INNER JOIN dbo.T_Term_Master TM
			ON EPG.I_Term_ID = TM.I_Term_ID
			AND TM.I_Status = 1
			INNER JOIN dbo.T_Module_Master MM
			ON EPG.I_Module_ID = MM.I_Module_ID
			AND MM.I_Status =1
			LEFT OUTER JOIN ACADEMICS.T_E_Project_Extension EPE WITH(NOLOCK)
			ON EPE.I_E_Project_Group_ID=EPG.I_E_Project_Group_ID
			AND EPE.I_Status =1
			WHERE EPG.I_Course_ID=ISNULL(@iCourseID,EPG.I_Course_ID)
			AND EPG.I_Term_ID=ISNULL(@iTermID,EPG.I_Term_ID)
			AND EPG.I_Module_ID=ISNULL(@iModuleID, EPG.I_Module_ID)
			AND EPG.I_Center_ID=ISNULL(@iCenterID,EPG.I_Center_ID)
			AND EPG.I_Status <> 3
			AND EPG.Dt_Project_End_Date > ISNULL(@dCurrentDate,GETDATE()) ---Only those eprojects for which end date>current date
			AND EPS.Dt_Valid_To>ISNULL(@dCurrentDate,GETDATE())--Only those specifications for which dt_valid_to >current date
END 

-- GroupList details for those having EProject Uploaded.
IF(@iFlag = 4)
BEGIN

	SELECT  EPG.I_E_Project_Group_ID,
			EPG.S_Group_Desc, 
			EPG.Dt_Project_Start_Date,
			EPG.Dt_Project_End_Date, 
			EPG.Dt_Cancellation_Date, 
			EPE.Dt_New_End_Date, 
			EPE.S_Reason, 
			EPG.S_Cancellation_Reason,
			EPG.I_Status, 
			EPG.I_E_Project_Spec_ID, 
			EPS.S_Description, 
			EPS.I_File_ID,
			UD.S_Document_Name,
			UD.S_Document_Type,
			UD.S_Document_Path,
			UD.S_Document_URL,
			CNM.I_Centre_Id,
			CNM.S_Center_Code,
			CNM.S_Center_Name,
			CM.I_Course_ID,
			CM.S_Course_Code,
			CM.S_Course_Name,
			TM.I_Term_ID,
			TM.S_Term_Code,
			TM.S_Term_Name,
			MM.I_Module_ID,
			MM.S_Module_Code,
			MM.S_Module_Name
			FROM ACADEMICS.T_E_Project_Group EPG 
			INNER JOIN ACADEMICS.T_E_Project_Spec EPS
			ON EPS.I_E_Project_Spec_ID=EPG.I_E_Project_Spec_ID
			INNER JOIN dbo.T_Centre_Master CNM
			ON EPG.I_Center_ID = CNM.I_Centre_ID
			AND CNM.I_Status = 1
			INNER JOIN dbo.T_Course_Master CM
			ON EPG.I_Course_ID = CM.I_Course_ID
			AND CM.I_Status = 1
			INNER JOIN dbo.T_Term_Master TM
			ON EPG.I_Term_ID = TM.I_Term_ID
			AND TM.I_Status = 1
			INNER JOIN dbo.T_Module_Master MM
			ON EPG.I_Module_ID = MM.I_Module_ID
			AND MM.I_Status =1
			INNER JOIN dbo.T_Upload_Document UD
			ON EPS.I_File_ID = UD.I_Document_ID
			AND UD.I_Status = 1
			LEFT OUTER JOIN ACADEMICS.T_E_Project_Extension EPE 
			ON EPE.I_E_Project_Group_ID=EPG.I_E_Project_Group_ID
			AND EPE.I_Status =1
			WHERE EPG.I_Course_ID=@iCourseID
			AND EPG.I_Term_ID=@iTermID
			AND EPG.I_Module_ID=@iModuleID
			AND EPG.I_Center_ID=@iCenterID
			AND EPG.I_Status IN (6,2)
			ORDER BY EPG.Dt_Project_Start_Date DESC
END
-- All GroupList details for Centers
IF(@iFlag = 5)
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
			
			INSERT INTO @TemEProjectGroup
			(
				I_E_Project_Group_ID,
				S_Group_Desc, 
				Dt_Project_Start_Date,
				Dt_Project_End_Date, 
				Dt_Cancellation_Date, 
				Dt_New_End_Date, 
				S_Reason, 
				S_Cancellation_Reason,
				I_Status, 
				I_E_Project_Spec_ID,
				S_Description, 
				I_File_ID,
				S_Document_Name,
				S_Document_Type,
				S_Document_Path,
				S_Document_URL,
				I_Centre_Id,
				S_Center_Code,
				S_Center_Name,
				I_Course_ID,
				S_Course_Code,
				S_Course_Name,
				I_Term_ID,
				S_Term_Code,
				S_Term_Name,
				I_Module_ID,
				S_Module_Code,
				S_Module_Name
			)
			SELECT  EPG.I_E_Project_Group_ID,
			EPG.S_Group_Desc, 
			EPG.Dt_Project_Start_Date,
			EPG.Dt_Project_End_Date, 
			EPG.Dt_Cancellation_Date, 
			EPE.Dt_New_End_Date, 
			EPE.S_Reason, 
			EPG.S_Cancellation_Reason,
			EPG.I_Status, 
			EPG.I_E_Project_Spec_ID,
			EPS.S_Description, 
			EPS.I_File_ID,
			UD.S_Document_Name,
			UD.S_Document_Type,
			UD.S_Document_Path,
			UD.S_Document_URL,
			CNM.I_Centre_Id,
			CNM.S_Center_Code,
			CNM.S_Center_Name,
			CM.I_Course_ID,
			CM.S_Course_Code,
			CM.S_Course_Name,
			TM.I_Term_ID,
			TM.S_Term_Code,
			TM.S_Term_Name,
			MM.I_Module_ID,
			MM.S_Module_Code,
			MM.S_Module_Name
			FROM ACADEMICS.T_E_Project_Group EPG 
			INNER JOIN ACADEMICS.T_E_Project_Spec EPS
			ON EPG.I_E_Project_Spec_ID = EPS.I_E_Project_Spec_ID
			INNER JOIN dbo.T_Centre_Master CNM
			ON EPG.I_Center_ID = CNM.I_Centre_ID
			AND CNM.I_Status = 1
			INNER JOIN dbo.T_Course_Master CM
			ON EPG.I_Course_ID = CM.I_Course_ID
			AND CM.I_Status = 1
			INNER JOIN dbo.T_Term_Master TM
			ON EPG.I_Term_ID = TM.I_Term_ID
			AND TM.I_Status = 1
			INNER JOIN dbo.T_Module_Master MM
			ON EPG.I_Module_ID = MM.I_Module_ID
			AND MM.I_Status =1
			INNER JOIN dbo.T_Upload_Document UD
			ON EPS.I_File_ID = UD.I_Document_ID
			AND UD.I_Status = 1
			LEFT OUTER JOIN ACADEMICS.T_E_Project_Extension EPE 
			ON EPE.I_E_Project_Group_ID=EPG.I_E_Project_Group_ID
			AND EPE.I_Status =1
			WHERE EPG.I_Center_ID=@iCenterID
			AND ISNULL(@dFromDate, EPG.Dt_Project_Start_Date) <= EPG.Dt_Project_Start_Date
			AND ISNULL(@dToDate, EPG.Dt_Project_Start_Date) >= EPG.Dt_Project_Start_Date 
			AND EPG.I_Status <> 3
			AND EPS.I_Status = 1
			ORDER BY EPG.Dt_Project_Start_Date DESC
			
			SELECT @sCenterIDList = SUBSTRING(@sCenterIDList,@iGetIndex + 1, @iLength - @iGetIndex)
			SELECT @sCenterIDList = LTRIM(RTRIM(@sCenterIDList))	
		END
	END
	SELECT * FROM @TemEProjectGroup
END

END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
