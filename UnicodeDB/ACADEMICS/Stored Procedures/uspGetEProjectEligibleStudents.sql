/*******************************************************
Description : Get Students eligible for e-projects
Author	:     Soumya Sikder
Date	:	  05/21/2007
*********************************************************/

CREATE PROCEDURE [ACADEMICS].[uspGetEProjectEligibleStudents] 
(
	@iCourseID int,
	@iTermID int,
	@iModuleID int,
	@iCenterID int,
	@dDate datetime
)
AS

BEGIN TRY 

	CREATE TABLE #tempStudent
	(
		I_Student_Detail_ID INT,
		S_Student_ID VARCHAR(500),
		S_Title VARCHAR(10),
		S_First_Name VARCHAR(50),
		S_Middle_Name VARCHAR(50),
		S_Last_Name	VARCHAR(50),
		I_E_Proj_Manual_Number INT
	)
	-- DECLARE statements goes here
	DECLARE @iStudentID INT
	--DECLARE @cEligibility CHAR(1)

	-- Declaring the CURSOR and getting all students
	DECLARE STUDENTS_CURSOR CURSOR FOR
	SELECT A.I_Student_Detail_ID 
	FROM dbo.T_Student_Course_Detail A WITH(NOLOCK)
	INNER JOIN dbo.T_Student_Center_Detail B
	ON A.I_Student_Detail_ID = B.I_Student_Detail_ID
	WHERE A.I_Course_ID = @iCourseID
	AND B.I_Centre_Id = @iCenterID
	AND @dDate >= ISNULL(A.Dt_Valid_From, @dDate)
	AND @dDate <= ISNULL(A.Dt_Valid_To, @dDate)
	AND @dDate >= ISNULL(B.Dt_Valid_From, @dDate)
	AND @dDate <= ISNULL(B.Dt_Valid_To, @dDate)
	AND A.I_Status <> 0
	AND A.I_Is_Completed <> 1
	AND B.I_Status <> 0

	-- Call the Function to set Student Status wether eligible
	OPEN STUDENTS_CURSOR
	FETCH NEXT FROM STUDENTS_CURSOR INTO @iStudentID	
	
	WHILE @@FETCH_STATUS = 0				
	BEGIN

		-- Get Student Details only if the Student is Eligible
		IF [ACADEMICS].fnGetStudentEligibilityForEProject(@iStudentID, @iCourseID, @iTermID, @iModuleID, @dDate) = 'Y'
		BEGIN
		
		INSERT INTO #tempStudent
		SELECT DISTINCT SD.I_Student_Detail_ID,
			   SD.S_Student_ID,
			   SD.S_Title,
			   SD.S_First_Name,
			   SD.S_Middle_Name,
			   SD.S_Last_Name,
			   CEM.I_E_Proj_Manual_Number
		FROM dbo.T_Student_Detail  SD 
		LEFT OUTER JOIN ACADEMICS.T_Center_E_Project_Manual CEM WITH(NOLOCK)
		ON CEM.I_Student_Detail_ID = SD.I_Student_Detail_ID
		AND CEM.I_Course_ID = @iCourseID
		AND CEM.I_Term_ID = @iTermID
		AND CEM.I_Module_ID = @iModuleID
		AND CEM.I_Center_ID = @iCenterID
		AND CEM.I_Status NOT IN (2,3)
		WHERE SD.I_Student_Detail_ID = @iStudentID
		AND SD.I_Status = 1

		END

		FETCH NEXT FROM STUDENTS_CURSOR INTO @iStudentID
	END

	-- Get all the eligible Student Details
	SELECT * FROM #tempStudent

	DROP TABLE #tempStudent

	CLOSE STUDENTS_CURSOR
	DEALLOCATE STUDENTS_CURSOR
 
END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
