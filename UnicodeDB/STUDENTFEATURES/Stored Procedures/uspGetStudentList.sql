CREATE PROCEDURE [STUDENTFEATURES].[uspGetStudentList]
(
	@iCourseID int, 
	@iTermID int=null,
	@dCurrentDate datetime
)

AS
BEGIN TRY 
	
	IF @iTermID IS NULL
	BEGIN
	
		SELECT	SM.I_Student_Detail_ID,
				SM.S_Student_ID,
				SM.S_Title,
				SM.S_First_Name,
				SM.S_Middle_Name,
				SM.S_Last_Name,
				SM.S_Email_ID
		FROM dbo.T_Student_Detail SM
		INNER JOIN dbo.T_Student_Course_Detail SCD
		ON SM.I_Student_Detail_ID = SCD.I_Student_Detail_ID
		AND @dCurrentDate >= ISNULL(SCD.Dt_Valid_From, @dCurrentDate)
		AND @dCurrentDate <= ISNULL(SCD.Dt_Valid_To, @dCurrentDate)
		AND SCD.I_Status = 1
		AND SM.I_Status = 1
		AND SCD.I_Course_ID	= @iCourseID
		AND SCD.I_Is_Completed = 'TRUE'
		AND SM.I_Student_Detail_ID NOT IN
		(	SELECT I_Student_Detail_ID
			FROM dbo.T_Student_Term_Detail 
			WHERE I_Course_ID = @iCourseID
			AND I_Is_Completed <> 'TRUE' )
	END
	ELSE
	BEGIN
	
		SELECT	SM.I_Student_Detail_ID,
				SM.S_Student_ID,
				SM.S_Title,
				SM.S_First_Name,
				SM.S_Middle_Name,
				SM.S_Last_Name,
				SM.S_Email_ID
		FROM dbo.T_Student_Detail SM
		INNER JOIN dbo.T_Student_Term_Detail STD
		ON SM.I_Student_Detail_ID = STD.I_Student_Detail_ID
		AND STD.I_Course_ID = @iCourseID
		AND STD.I_Term_ID = @iTermID
		AND STD.I_Is_Completed <> 'TRUE'
		AND SM.I_Status = 1

	END	

END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
