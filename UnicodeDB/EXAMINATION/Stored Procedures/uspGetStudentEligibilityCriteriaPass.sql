/**************************************************************************************************************
Created by  : Debarshi Basu
Date		: 12.02.2008
Description : This SP will delete an existing question pool
Parameters  : 
Returns     : 
**************************************************************************************************************/

CREATE PROCEDURE [EXAMINATION].[uspGetStudentEligibilityCriteriaPass]
	(
		@iStudentID INT,
		@iExamID INT,
		@dCurrenDate datetime,
		@MinAttendance int = NULL,
		@iAllowedNumberOfNonPaymentDays int = NULL,
		@iAllowedNumberOfNonAttendedDays int = NULL,
		@iPassPercent int = NULL,		
		@iMaximumResitAllowed INT = NULL
	) 
AS

BEGIN TRY
	
	DECLARE	@iCenterID INT
	DECLARE @iCourseID INT 
	DECLARE @iTermID INT 
	DECLARE @iModuleID INT
	DECLARE @iComponentID INT
	DECLARE @dtExamDate DATETIME
	
	SELECT	@iCenterID = I_Centre_Id,
			@iCourseID = I_Course_ID,
			@iTermID = I_Term_ID,
			@iModuleID = I_Module_ID,
			@iComponentID = I_Exam_Component_ID,
			@dtExamDate = Dt_Exam_Date
	FROM EXAMINATION.T_Examination_Detail
	WHERE I_Exam_ID = @iExamID

	DECLARE @TotalSession INT

	SELECT @TotalSession = COUNT(SM.I_Session_Module_ID)
	FROM dbo.T_Term_Course_Map TC
		INNER JOIN dbo.T_Module_Term_Map MT
		ON TC.I_Term_ID = MT.I_Term_ID
			AND MT.I_Status = 1
		INNER JOIN dbo.T_Session_Module_Map SM
		ON ISNULL(MT.I_Module_ID,0) = ISNULL(SM.I_Module_ID,0)
			AND SM.I_Status = 1
	WHERE TC.I_Course_ID = @iCourseID
	AND TC.I_Term_ID = @iTermID
	AND SM.I_Module_ID = ISNULL(@iModuleID,SM.I_Module_ID)
	AND TC.I_Status = 1

	DECLARE @iTotalExamCount INT
	SELECT @iTotalExamCount = COUNT(*)
	FROM dbo.T_Module_Eval_Strategy MES WITH(NOLOCK)
	WHERE MES.I_Term_ID = @iTermID
	AND MES.I_Course_ID = @iCourseID
	AND MES.I_Status = 1

	DECLARE @TotalSessionCount INT
	SELECT @TotalSessionCount = COUNT(SM.I_Session_Module_ID)
	FROM dbo.T_Term_Course_Map TC
		INNER JOIN dbo.T_Module_Term_Map MT
		ON TC.I_Term_ID = MT.I_Term_ID
			AND MT.I_Status = 1
		INNER JOIN dbo.T_Session_Module_Map SM
		ON ISNULL(MT.I_Module_ID,0) = ISNULL(SM.I_Module_ID,0)
			AND SM.I_Status = 1
	WHERE TC.I_Course_ID = ISNULL(@iCourseID,TC.I_Course_ID)	
	AND TC.I_Status = 1

	CREATE TABLE #TempTable
	(
		I_Criteria_ID INT	
	)
	
	IF (ACADEMICS.ufnGetStudentFinancialDropoutStatus(@iStudentID,@iCenterID,@iAllowedNumberOfNonPaymentDays,@dCurrenDate) = 'N')
	BEGIN
		INSERT INTO #TempTable SELECT 1
	END
	IF (ACADEMICS.ufnGetStudentAcademicDropoutStatus(@iStudentID,@iCenterID,@iAllowedNumberOfNonAttendedDays,@dCurrenDate) = 'N')
	BEGIN
		INSERT INTO #TempTable SELECT 2
	END
	IF (ACADEMICS.ufnGetStudentDropoutLeaveStatus(@iStudentID,@iCenterID,@dtExamDate) = 'N')
	BEGIN
		INSERT INTO #TempTable SELECT 3
	END
	IF (EXAMINATION.ufnGetAllModulesPassStatus(@iStudentID, @iCourseID, @iTermID,@iPassPercent,@iTotalExamCount) = 'Y')
	BEGIN
		INSERT INTO #TempTable SELECT 4
	END
	IF (EXAMINATION.ufnGetPreviousTermCompletionStatus(@iStudentID, @iCourseID, @iTermID) = 'Y')
	BEGIN
		INSERT INTO #TempTable SELECT 5
	END
	IF (EXAMINATION.fnGetNoOfAttempts(@iStudentID, @iComponentID, @iCourseID, @iTermID, @iModuleID) < @iMaximumResitAllowed)
	BEGIN
		INSERT INTO #TempTable SELECT 6
	END
	IF (dbo.ufnGetStudentStatusAttendance(@iCenterID, @iStudentID, @iCourseID, @iTermID,@iModuleID,@MinAttendance,@TotalSession) = 'Cleared')
	BEGIN
		INSERT INTO #TempTable SELECT 7
	END
	IF (EXAMINATION.fnCheckFinancialCriteria(@iStudentID,@iCenterID,@iCourseID, @iTermID,@iModuleID,@TotalSessionCount,@TotalSession) = 'Y')
	BEGIN
		INSERT INTO #TempTable SELECT 8
	END

	SELECT * FROM #TempTable
END TRY	
	
BEGIN CATCH

DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
SELECT	@ErrMsg = ERROR_MESSAGE(),
		@ErrSeverity = ERROR_SEVERITY()

RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
