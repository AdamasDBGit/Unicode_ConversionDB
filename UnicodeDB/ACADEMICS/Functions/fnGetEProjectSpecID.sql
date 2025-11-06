-- =============================================
-- Author:		Abhisek Bhattacharya
-- Create date: '28/05/2007'
-- Description:	This Function return the E-Project Specification ID 
-- for a particular Course, Term , Module . 
-- Return: EProjectSpecID Integer
-- =============================================
CREATE FUNCTION [ACADEMICS].[fnGetEProjectSpecID]
(
	@iCourseID int,
	@iTermID int,
	@iModuleID int,
	@iCenterID int = null,
	@dStartDate datetime,
	@dCurrentDate datetime,
	@iEProjSpecAvailNoDays int
)
RETURNS  INT

AS 
-- Returns the Student Status whether elibigle or not for an E-Project.
BEGIN

DECLARE @iEProjectSpecID INT, @iTempEProjectSpecID INT
DECLARE @dCheckDate DATETIME--, @dEProjectEndDate DATETIME

	-- Set the Default as 0
	SET @iEProjectSpecID = 0

	-- Select the EProject Spec ID which is not yet allocated to any Group in the current Center
	SET @iEProjectSpecID = (SELECT TOP 1 I_E_Project_Spec_ID 
	FROM ACADEMICS.T_E_Project_Spec WITH(NOLOCK)
	WHERE I_Course_ID = @iCourseID
	AND I_Term_ID = @iTermID
	AND I_Module_ID = @iModuleID
	AND I_E_Project_Spec_ID NOT IN
	(
		SELECT I_E_Project_Spec_ID
		FROM ACADEMICS.T_E_Project_Group
		WHERE I_Course_ID = @iCourseID
		AND I_Term_ID = @iTermID
		AND I_Module_ID = @iModuleID
		AND I_Status <> 3
		AND I_Center_ID = @iCenterID
	)
	AND ISNULL(Dt_Valid_To, @dCurrentDate) >= @dCurrentDate 
	AND I_Status <> 0
	ORDER BY I_E_Project_Spec_ID)

	-- Return the information to the caller
	IF @iEProjectSpecID > 0
	BEGIN
		RETURN @iEProjectSpecID
	END
	
	-- SELECT @dCheckDate = DATEADD(MONTH,-2, @dStartDate)

	DECLARE EPROJECTSPEC_CURSOR CURSOR FOR
	SELECT DISTINCT A.I_E_Project_Spec_ID
	FROM ACADEMICS.T_E_Project_Group A
	INNER JOIN ACADEMICS.T_E_Project_Spec B
	ON A.I_E_Project_Spec_ID = B.I_E_Project_Spec_ID
	AND B.I_Status <> 0
	WHERE A.I_Course_ID = @iCourseID
	AND A.I_Term_ID = @iTermID
	AND A.I_Module_ID = @iModuleID
	AND A.I_Status <> 3
	AND ISNULL(B.Dt_Valid_To, @dCurrentDate) >= @dCurrentDate
	
	OPEN EPROJECTSPEC_CURSOR
	FETCH NEXT FROM EPROJECTSPEC_CURSOR INTO @iTempEProjectSpecID

	WHILE @@FETCH_STATUS = 0				
	BEGIN
		
		-- Check if the E-Project Spec is in use 
		-- for Group whose end date and New Project Start date difference 
		-- is less than Configurable Specified duration

		IF NOT EXISTS ( SELECT I_E_Project_Group_ID
		FROM ACADEMICS.T_E_Project_Group
		WHERE I_Course_ID = @iCourseID
		AND I_Term_ID = @iTermID
		AND I_Module_ID = @iModuleID 
		AND I_E_Project_Spec_ID = @iTempEProjectSpecID
		AND I_Status <> 3
		AND DATEDIFF(day, Dt_Project_End_Date, @dStartDate)<= @iEProjSpecAvailNoDays )
		BEGIN
			SET @iEProjectSpecID = @iTempEProjectSpecID 
			BREAK
		END

		FETCH NEXT FROM EPROJECTSPEC_CURSOR INTO @iTempEProjectSpecID
	END	

	CLOSE EPROJECTSPEC_CURSOR
	DEALLOCATE EPROJECTSPEC_CURSOR

	-- Return the information to the caller
	RETURN @iEProjectSpecID

END