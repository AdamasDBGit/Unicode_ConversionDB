/****************************************************************************************/

CREATE PROCEDURE [EXAMINATION].[uspGetEligibilityList] 
	@iExamID int, 
	@MinAttendance int = NULL,
	@iAllowedNumberOfNonPaymentDays int = NULL,
	@iAllowedNumberOfNonAttendedDays int = NULL,
	@iPassPercent int = NULL,
	@dCurrenDate datetime,
	@iMaximumResitAllowed INT = NULL,
	@bCourseEnrollmentNotRequired BIT = 0,
	@bFinancialDropoutNotRequired BIT = 0,
	@bFAcademicDropoutNotRequired BIT = 0,
	@bDropoutLeaveStatusNotRequired BIT = 0,
	@bAllModulePassNotRequired BIT = 0,
	@bPreviousTermCompletionNotRequired BIT = 0,
	@bNoOfAttemptsNotRequired BIT = 0,
	@bStudentAttendanceNotRequired BIT = 0,
	@bFinancialCriteriaNotRequired BIT = 0
AS
BEGIN
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
	
	SELECT I_Student_Detail_ID,S_Student_ID,S_Title,S_Age,
	S_First_Name,S_Middle_Name,S_Last_Name ,S_Email_ID
	FROM dbo.T_Student_Detail
	WHERE T_Student_Detail.I_Status = 1
	AND I_Student_Detail_ID IN (SELECT I_Student_Detail_ID FROM dbo.T_Student_Center_Detail WHERE I_Centre_Id = @iCenterID AND I_Status = 1)
	AND I_Student_Detail_ID IN (SELECT I_Student_Detail_ID FROM dbo.T_Student_Term_Detail WHERE I_Course_ID = @iCourseID AND I_Term_ID = @iTermID AND I_Is_Completed = 0)
	--AND (@bCourseEnrollmentNotRequired = 1 OR EXAMINATION.fnCheckStudentCourseEnrollment(I_Student_Detail_ID,@iCourseID,@iTermID,@iModuleID) = 'Y')	
	AND (@bFinancialDropoutNotRequired = 1 OR ACADEMICS.ufnGetStudentFinancialDropoutStatus(I_Student_Detail_ID,@iCenterID,@iAllowedNumberOfNonPaymentDays,@dCurrenDate) = 'N')
	AND (@bFAcademicDropoutNotRequired = 1 OR ACADEMICS.ufnGetStudentAcademicDropoutStatus(I_Student_Detail_ID,@iCenterID,@iAllowedNumberOfNonAttendedDays,@dCurrenDate) = 'N')
	AND (@bDropoutLeaveStatusNotRequired = 1 OR ACADEMICS.ufnGetStudentDropoutLeaveStatus(I_Student_Detail_ID,@iCenterID,@dtExamDate) = 'N')
	--AND (@bAllModulePassNotRequired = 1 OR EXAMINATION.ufnGetAllModulesPassStatus(I_Student_Detail_ID, @iCourseID, @iTermID,@iPassPercent,@iTotalExamCount) = 'Y')
	--AND (@bPreviousTermCompletionNotRequired = 1 OR EXAMINATION.ufnGetPreviousTermCompletionStatus(I_Student_Detail_ID, @iCourseID, @iTermID) = 'Y')
	AND (@bNoOfAttemptsNotRequired = 1 OR EXAMINATION.fnGetNoOfAttempts(I_Student_Detail_ID, @iComponentID, @iCourseID, @iTermID, @iModuleID) < @iMaximumResitAllowed)
	AND (@bStudentAttendanceNotRequired = 1 OR dbo.ufnGetStudentStatusAttendance(@iCenterID, I_Student_Detail_ID, @iCourseID, @iTermID,@iModuleID,@MinAttendance,@TotalSession) = 'Cleared')
	AND (@bFinancialCriteriaNotRequired = 1 OR EXAMINATION.fnCheckFinancialCriteria(I_Student_Detail_ID,@iCenterID,@iCourseID, @iTermID,@iModuleID,@TotalSessionCount,@TotalSession) = 'Y')
END
