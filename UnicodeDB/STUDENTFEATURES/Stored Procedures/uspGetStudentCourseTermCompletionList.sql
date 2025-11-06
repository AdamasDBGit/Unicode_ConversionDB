CREATE PROCEDURE [STUDENTFEATURES].[uspGetStudentCourseTermCompletionList] 
(
	@iCourseID int, 
	@iTermID int=null,
	@dCurrentDate datetime,
	@iCenterID int,
	@MinAttendance int,
	@bStudentAttendanceNotRequired BIT = 0,
	@bFinancialCriteriaNotRequired BIT = 0
)

AS
BEGIN TRY 
	
	CREATE TABLE #TEMPTABLE
	(
		I_Student_Detail_ID INT,
		S_Batch_Code VARCHAR(50),
		S_Student_ID VARCHAR(500),		
		S_Title VARCHAR(10),
		S_First_Name VARCHAR(50),
		S_Middle_Name VARCHAR(50),
		S_Last_Name VARCHAR(50),
		S_Email_ID VARCHAR(200)
	)	

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
	AND TC.I_Term_ID = ISNULL(@iTermID,TC.I_Term_ID)
	AND TC.I_Status = 1


	IF @iTermID IS NULL
	BEGIN
		INSERT INTO #TEMPTABLE
		SELECT DISTINCT	SM.I_Student_Detail_ID,
				[tsbm].[S_Batch_Code],
				SM.S_Student_ID,
				SM.S_Title,
				SM.S_First_Name,
				SM.S_Middle_Name,
				SM.S_Last_Name,
				SM.S_Email_ID
		FROM dbo.T_Student_Detail SM
		INNER JOIN dbo.T_Student_Course_Detail SCD
		ON SM.I_Student_Detail_ID = SCD.I_Student_Detail_ID
		INNER JOIN [dbo].[T_Student_Batch_Master] AS TSBM
		ON [SCD].[I_Batch_ID] = [TSBM].[I_Batch_ID]
		INNER JOIN dbo.T_Student_Center_Detail SCEN
		ON SM.I_Student_Detail_ID = SCEN.I_Student_Detail_ID
		AND DATEDIFF(dd,ISNULL(SCD.Dt_Valid_From,@dCurrentDate),@dCurrentDate) >= 0
		AND	DATEDIFF(dd,ISNULL(SCD.Dt_Valid_To,@dCurrentDate),@dCurrentDate) <= 0
		LEFT OUTER JOIN [PSCERTIFICATE].[T_Student_PS_Certificate] AS TSPC
		ON [SCD].[I_Student_Detail_ID] = [TSPC].[I_Student_Detail_ID]
		AND [SCD].[I_Course_ID] = [TSPC].[I_Course_ID]
		WHERE SCD.I_Status = 1
		AND SM.I_Status = 1
		AND SCEN.I_Centre_Id = ISNULL(@iCenterID,SCEN.I_Centre_Id)
		AND SCD.I_Course_ID	= @iCourseID
		AND SCD.I_Is_Completed = 'TRUE'
		AND [TSPC].[I_Student_Detail_ID] IS NULL

		SELECT * FROM #TEMPTABLE 
		WHERE (@bStudentAttendanceNotRequired = 1 OR dbo.ufnGetStudentStatusAttendance(@iCenterID, I_Student_Detail_ID, @iCourseID, @iTermID,null,@MinAttendance,@TotalSession) = 'Cleared')		
		
	END
	ELSE
	BEGIN
		INSERT INTO #TEMPTABLE
		SELECT DISTINCT	SM.I_Student_Detail_ID,
				[TSBM2].[S_Batch_Code],
				SM.S_Student_ID,
				SM.S_Title,
				SM.S_First_Name,
				SM.S_Middle_Name,
				SM.S_Last_Name,
				SM.S_Email_ID
		FROM dbo.T_Student_Detail SM
		INNER JOIN dbo.T_Student_Term_Detail STD
		ON SM.I_Student_Detail_ID = STD.I_Student_Detail_ID
		INNER JOIN [dbo].[T_Student_Course_Detail] AS TSCD
		ON [STD].[I_Course_ID] = [TSCD].[I_Course_ID]
		INNER JOIN [dbo].[T_Student_Batch_Master] AS TSBM2
		ON [TSCD].[I_Course_ID] = [TSBM2].[I_Course_ID]
		INNER JOIN dbo.T_Student_Center_Detail SCEN
		ON SM.I_Student_Detail_ID = SCEN.I_Student_Detail_ID
		LEFT OUTER JOIN [PSCERTIFICATE].[T_Student_PS_Certificate] AS TSPC
		ON [TSCD].[I_Student_Detail_ID] = [TSPC].[I_Student_Detail_ID]
		AND [TSCD].[I_Course_ID] = [TSPC].[I_Course_ID]
		WHERE  SM.I_Status = 1
		AND SCEN.I_Centre_Id = ISNULL(@iCenterID,SCEN.I_Centre_Id)
		AND STD.I_Course_ID = @iCourseID
		AND STD.I_Term_ID = @iTermID
		AND TSCD.I_Is_Completed = 'TRUE'
		AND [TSPC].[I_Student_Detail_ID] IS NULL

		SELECT DISTINCT * FROM #TEMPTABLE
		WHERE (@bStudentAttendanceNotRequired = 1 OR dbo.ufnGetStudentStatusAttendance(@iCenterID, I_Student_Detail_ID, @iCourseID, @iTermID,null,@MinAttendance,@TotalSession) = 'Cleared')
		AND 
		(@bFinancialCriteriaNotRequired = 1 OR EXAMINATION.fnCheckFinancialCriteria(I_Student_Detail_ID,@iCenterID,@iCourseID, @iTermID,null,@TotalSessionCount,@TotalSession) = 'Y')
		ORDER BY [#TEMPTABLE].[S_Batch_Code]
	END	

END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
