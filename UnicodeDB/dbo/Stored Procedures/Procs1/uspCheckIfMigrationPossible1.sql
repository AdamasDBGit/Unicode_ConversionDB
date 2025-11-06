CREATE PROC [dbo].[uspCheckIfMigrationPossible1]
(
	@iPreCourseID INT = NULL,
	@iMigrationCourseID INT = NULL,
	@iStudentID INT = NULL
)
AS 
BEGIN

SET NOCOUNT ON
SET XACT_ABORT ON

BEGIN TRY

DECLARE @iCurrentTerm INT
DECLARE @iPreviousTermCount INT
DECLARE @iMigrationTermCount INT
DECLARE @iStepTerm INT
DECLARE @iStepModule INT
DECLARE @iCentreID INT

	--Get the Student Centre ID
	SELECT DISTINCT @iCentreID = I_Centre_ID FROM T_Student_Center_Detail WHERE I_Student_Detail_ID = @iStudentID
	--Max Term attended by the Student
	SELECT @iCurrentTerm = ISNULL(MAX(I_Term_ID),0) FROM dbo.T_Student_Attendance_Details
	WHERE Dt_Attendance_Date IN 
	(
		SELECT MAX(Dt_Attendance_Date) FROM dbo.T_Student_Attendance_Details
		WHERE I_Student_Detail_ID = @iStudentID AND I_Course_ID = @iPreCourseID 
	)
	AND I_Student_Detail_ID = @iStudentID AND I_Course_ID = @iPreCourseID
print 'A'
print @iCurrentTerm

CREATE TABLE #tmpTerm
(
	ID [INT] IDENTITY(1,1) NOT NULL,
	iTermID INT NULL,
	iSequence INT NULL
)

CREATE TABLE #tmpTermMatch
(
	ID [INT] IDENTITY(1,1) NOT NULL,
	iTermID INT NULL,
	I_Exam_Type_Master_ID INT NULL,
	I_TotMarks INT NULL,
	N_Weightage INT NULL
)

CREATE TABLE #tmpModuleMatch
(
	ID [INT] IDENTITY(1,1) NOT NULL,
	iModuleID INT NULL,
	I_Exam_Component_ID INT NULL,
	I_TotMarks INT NULL,
	N_Weightage INT NULL
)

	IF @iCurrentTerm > 0
	BEGIN

		SELECT @iPreviousTermCount = I_Sequence FROM dbo.T_Term_Course_Map 
		WHERE I_Course_ID = @iPreCourseID AND I_Term_ID = @iCurrentTerm AND I_Status <> 0

print @iPreviousTermCount

		INSERT INTO #tmpTerm
		SELECT DISTINCT I_Term_ID,I_Sequence FROM dbo.T_Term_Course_Map 
		WHERE I_Course_ID = @iPreCourseID and I_Sequence <= @iPreviousTermCount AND I_Status <> 0

		SELECT @iMigrationTermCount = COUNT(DISTINCT I_Term_ID) 
		FROM dbo.T_Term_Course_Map TCM
		INNER JOIN #tmpTerm tt
		ON TCM.I_Term_ID = tt.iTermID
		AND TCM.I_Sequence = tt.iSequence
		WHERE I_Course_ID = @iMigrationCourseID 
		AND I_Status <> 0 

print @iMigrationTermCount

		IF @iPreviousTermCount = @iMigrationTermCount
		BEGIN			

			INSERT INTO #tmpTermMatch
			SELECT I_Term_ID,I_Exam_Type_Master_ID,I_TotMarks,N_Weightage 
			FROM dbo.T_Term_Eval_Strategy WHERE I_Course_ID=@iPreCourseID
			AND I_Term_ID IN (SELECT DISTINCT iTermID FROM #tmpTerm) AND I_Status <> 0
			EXCEPT
			SELECT I_Term_ID,I_Exam_Type_Master_ID,I_TotMarks,N_Weightage 
			FROM dbo.T_Term_Eval_Strategy WHERE I_Course_ID=@iMigrationCourseID
			AND I_Term_ID IN (SELECT DISTINCT iTermID FROM #tmpTerm) AND I_Status <> 0

			SELECT @iStepTerm=ISNULL(COUNT(1),0) FROM #tmpTermMatch
			IF @iStepTerm = 0
			BEGIN
				INSERT INTO #tmpModuleMatch
				SELECT I_Module_ID,I_Exam_Component_ID,I_TotMarks,N_Weightage
				FROM T_Module_Eval_Strategy WHERE I_Course_ID = @iPreCourseID
				AND I_Term_ID IN (SELECT DISTINCT iTermID FROM #tmpTerm) AND I_Status <> 0
				EXCEPT
				SELECT I_Module_ID,I_Exam_Component_ID,I_TotMarks,N_Weightage
				FROM T_Module_Eval_Strategy WHERE I_Course_ID = @iMigrationCourseID
				AND I_Term_ID IN (SELECT DISTINCT iTermID FROM #tmpTerm) AND I_Status <> 0

				SELECT @iStepModule=ISNULL(COUNT(1),0) FROM #tmpModuleMatch
				
				IF @iStepModule = 0
				BEGIN

					IF EXISTS(SELECT 'True' FROM
					T_Course_Center_Detail CCD
					INNER JOIN T_Course_Center_Delivery_FeePlan CDF
					ON CCD.I_Course_Center_ID = CDF.I_Course_Center_ID
					INNER JOIN T_COURSE_DELIVERY_MAP CDM
					ON CDF.I_Course_Delivery_ID = CDM.I_Course_Delivery_ID
					INNER JOIN T_COURSE_MASTER CM
					ON CDM.I_COURSE_ID = CM.I_COURSE_ID
					INNER JOIN T_DELIVERY_PATTERN_MASTER DPM
					ON CDM.I_DELIVERY_PATTERN_ID=DPM.I_DELIVERY_PATTERN_ID
					WHERE CCD.I_Course_ID =@iMigrationCourseID
					AND CCD.I_Centre_ID = @iCentreID
					AND CCD.I_Status<>0
					AND CDF.I_Status<>0
					AND CDM.I_Status<>0 )
					BEGIN
						SELECT 1
					END
					ELSE
					BEGIN
						SELECT 0
					END
				END
				ELSE
				BEGIN
					SELECT 0
				END
			END
			ELSE
			BEGIN
				SELECT 0
			END
		END
		ELSE
		BEGIN
			SELECT 0
		END		

	END
	ELSE
	BEGIN
			IF EXISTS(SELECT 'True' FROM
			T_Course_Center_Detail CCD
			INNER JOIN T_Course_Center_Delivery_FeePlan CDF
			ON CCD.I_Course_Center_ID = CDF.I_Course_Center_ID
			INNER JOIN T_COURSE_DELIVERY_MAP CDM
			ON CDF.I_Course_Delivery_ID = CDM.I_Course_Delivery_ID
			INNER JOIN T_COURSE_MASTER CM
			ON CDM.I_COURSE_ID = CM.I_COURSE_ID
			INNER JOIN T_DELIVERY_PATTERN_MASTER DPM
			ON CDM.I_DELIVERY_PATTERN_ID=DPM.I_DELIVERY_PATTERN_ID
			WHERE CCD.I_Course_ID =@iMigrationCourseID
			AND CCD.I_Centre_ID = @iCentreID
			AND CCD.I_Status<>0
			AND CDF.I_Status<>0
			AND CDM.I_Status<>0 )
			BEGIN
				SELECT 1	--As Student id yet to attend any class can migrate to other course
			END
			ELSE
			BEGIN
				SELECT 0
			END
			
	END

	DROP TABLE #tmpTerm
	DROP TABLE #tmpTermMatch
	DROP TABLE #tmpModuleMatch

END TRY

BEGIN CATCH
	PRINT ERROR_MESSAGE()
END CATCH

END
