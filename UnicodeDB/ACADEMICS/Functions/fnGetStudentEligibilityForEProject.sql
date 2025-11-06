-- =============================================
-- Author:		Abhisek Bhattacharya
-- Create date: '23/05/2007'
-- Description:	This Function return the Status 
-- of student eligible for E-Project 
-- Return: Status Character
-- =============================================
CREATE FUNCTION [ACADEMICS].[fnGetStudentEligibilityForEProject]
(
	@iStudentDetailID int,
	@iCourseID int,
	@iTermID int,
	@iModuleID int,
	@dCurrenDate datetime
)
RETURNS  CHAR(1)

AS 
-- Returns the Student Status whether elibigle or not for an E-Project.
BEGIN

DECLARE @cStatus CHAR(1)
DECLARE @iPrevModuleID INT, @iPrevTermID INT 
DECLARE @iModuleSequence INT, @iTermSequence INT 
DECLARE @iIsCompleted INT, @iEProjectComplete INT

	-- Set the Default as N
	SET @cStatus = 'N'

	-- Get the Module Sequence for the selected Module, Term
	SELECT @iModuleSequence = I_Sequence
	FROM dbo.T_Module_Term_Map
	WHERE I_Term_ID = @iTermID
	AND I_Module_ID = @iModuleID
	AND I_Status = 1
	AND @dCurrenDate >= ISNULL(Dt_Valid_From,@dCurrenDate)
	AND @dCurrenDate <= ISNULL(Dt_Valid_To,@dCurrenDate)
	
	-- Get the Term Sequence for the selected Term, Course
	SELECT @iTermSequence = I_Sequence
	FROM dbo.T_Term_Course_Map
	WHERE I_Term_ID = @iTermID
	AND I_Course_ID = @iCourseID
	AND I_Status = 1
	AND @dCurrenDate >= ISNULL(Dt_Valid_From,@dCurrenDate)
	AND @dCurrenDate <= ISNULL(Dt_Valid_To,@dCurrenDate)
	
	-- If the Module is not the first module of the Term
	IF @iModuleSequence > 1
	BEGIN
		SET @iModuleSequence = @iModuleSequence - 1
		
		-- Select the (Previous)Module having sequence 1 less than that of the selected module
		SELECT @iPrevModuleID = I_Module_ID
		FROM dbo.T_Module_Term_Map
		WHERE I_Term_ID = @iTermID
		AND I_Status = 1
		AND @dCurrenDate >= ISNULL(Dt_Valid_From,@dCurrenDate)
		AND @dCurrenDate <= ISNULL(Dt_Valid_To,@dCurrenDate)
		AND I_Sequence = @iModuleSequence

		-- Check whether the previous Module is completed by the Student
		SELECT @iIsCompleted = CAST(I_Is_Completed AS INT)
		FROM dbo.T_Student_Module_Detail
		WHERE I_Student_Detail_ID = @iStudentDetailID
		AND I_Course_ID = @iCourseID
		AND I_Term_ID = @iTermID
		AND I_Module_ID = @iPrevModuleID
	
		-- If completed, set the Flag as Y
		IF @iIsCompleted = 1
		BEGIN
			SET @cStatus = 'Y'
		END
	END
	ELSE
	BEGIN
		IF @iTermSequence > 1
		BEGIN
			SET @iTermSequence = @iTermSequence - 1
		
			-- Select the (Previous)Module having sequence 1 less than that of the selected module
			SELECT @iPrevTermID = I_Term_ID
			FROM dbo.T_Term_Course_Map
			WHERE I_Course_ID = @iCourseID
			AND I_Status = 1
			AND @dCurrenDate >= ISNULL(Dt_Valid_From,@dCurrenDate)
			AND @dCurrenDate <= ISNULL(Dt_Valid_To,@dCurrenDate)
			AND I_Sequence = @iTermSequence

			-- Check whether the previous Module is completed by the Student
			SELECT @iIsCompleted = CAST(I_Is_Completed AS INT)
			FROM dbo.T_Student_Term_Detail
			WHERE I_Student_Detail_ID = @iStudentDetailID
			AND I_Course_ID = @iCourseID
			AND I_Term_ID = @iPrevTermID

			-- If completed, set the Flag as Y
			IF @iIsCompleted = 1
			BEGIN
				SET @cStatus = 'Y'
			END
		END
		ELSE
		BEGIN	
			SET @cStatus = 'Y'				
		END	
	END
	-- If Student has already got Manual Number assigned for the Module
	IF NOT EXISTS (SELECT I_Center_E_Proj_ID FROM Academics.T_Center_E_Project_Manual
						   WHERE I_Course_ID = @iCourseID
						   AND I_Term_ID = @iTermID
						   AND I_Module_ID = @iModuleID
						   AND I_Student_Detail_ID = @iStudentDetailID)
						   --AND I_Status = 2)
	BEGIN
		SET @cStatus = 'Y'
	END
	ELSE
	BEGIN
		SET @cStatus = 'N'
	END
	-- If the student is currently dropped out
	IF NOT EXISTS (SELECT I_Dropout_ID FROM ACADEMICS.T_Dropout_Details
						   WHERE I_Student_Detail_ID = @iStudentDetailID
						   AND I_Dropout_Status = 1)
	BEGIN
		SET @cStatus = 'Y'
	END
	ELSE
	BEGIN
		SET @cStatus = 'N'
	END
	-- If the student is currently on leave or break
	IF NOT EXISTS (SELECT I_Student_Leave_ID FROM dbo.T_Student_Leave_Request
						   WHERE I_Student_Detail_ID = @iStudentDetailID
						   AND @dCurrenDate >= Dt_From_Date
						   AND @dCurrenDate< = ISNULL(Dt_To_Date,@dCurrenDate)
						   AND I_Status = 1)
	BEGIN
		SET @cStatus = 'Y'
	END
	ELSE
	BEGIN
		SET @cStatus = 'N'
	END
	

    -- Return the information to the caller
    RETURN @cStatus
END;