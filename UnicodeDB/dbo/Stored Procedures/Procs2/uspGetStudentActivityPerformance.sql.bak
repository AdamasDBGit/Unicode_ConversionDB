CREATE PROCEDURE [dbo].[uspGetStudentActivityPerformance] --1136,485
(	
	@iTermID INT,
	@iStudentDetailID INT
)
AS
BEGIN
	DECLARE @indexStudentActivity INT, @indexEvalCriteria INT,  @countStudentActivity INT, @countEvalCriteria INT
	DECLARE @activityID INT, @studentID INT, @studentActivityID INT
	
	--DECLARE @tblStudentActivity TABLE (ID INT IDENTITY(1,1), StudentID INT, ActivityID INT, StudentActivityID INT)
	CREATE TABLE #tblEvalCriteria  (ID INT IDENTITY(1,1), ActivityID INT, EvalCriteriaID INT)
	DECLARE @tblStudentActivity TABLE (ID INT IDENTITY(1,1), StudentID INT,  StudentName VARCHAR(150), ActivityID INT, ActivityName VARCHAR(50), StudentActivityID INT, 
	EvaluationID1 INT, EvaluationName1 VARCHAR(50), EvalGrade1 VARCHAR(50),
	EvaluationID2 INT, EvaluationName2 VARCHAR(50), EvalGrade2 VARCHAR(50),
	EvaluationID3 INT, EvaluationName3 VARCHAR(50), EvalGrade3 VARCHAR(50),
	EvaluationID4 INT, EvaluationName4 VARCHAR(50), EvalGrade4 VARCHAR(50),
	EvaluationID5 INT, EvaluationName5 VARCHAR(50), EvalGrade5 VARCHAR(50),
	EvaluationID6 INT, EvaluationName6 VARCHAR(50), EvalGrade6 VARCHAR(50))
	
	INSERT INTO @tblStudentActivity (StudentActivityID, StudentID, ActivityID)
	SELECT tsad.I_Student_Activity_ID, tsad.I_Student_Detail_ID, tsad.I_Activity_ID FROM dbo.T_Student_Activity_Details AS tsad
	WHERE I_Student_Detail_ID = @iStudentDetailID
	AND I_Status = 1
	
	SELECT @indexStudentActivity = 1, @countStudentActivity = COUNT('1') FROM @tblStudentActivity
	
	WHILE (@indexStudentActivity <= @countStudentActivity)
	BEGIN
		SELECT @activityID = ActivityID, @studentID = StudentID, @studentActivityID = StudentActivityID 
		FROM @tblStudentActivity AS tsa WHERE ID = @indexStudentActivity
		
		INSERT INTO #tblEvalCriteria ( ActivityID, EvalCriteriaID )
		SELECT I_Activity_ID , I_Evaluation_ID FROM dbo.T_ActivityEvalCriteria_Map AS taecm 
		WHERE I_Activity_ID = @activityID
		
		UPDATE @tblStudentActivity 
		SET EvaluationID1 = (SELECT EvalCriteriaID FROM #tblEvalCriteria t WHERE t.ActivityID = ActivityID AND t.ID = 1),
		EvaluationID2 = (SELECT TOP 1 EvalCriteriaID FROM #tblEvalCriteria t WHERE t.ActivityID = ActivityID AND t.ID = 2),
		EvaluationID3 = (SELECT TOP 1 EvalCriteriaID FROM #tblEvalCriteria t WHERE t.ActivityID = ActivityID AND t.ID = 3),
		EvaluationID4 = (SELECT TOP 1 EvalCriteriaID FROM #tblEvalCriteria t WHERE t.ActivityID = ActivityID AND t.ID = 4),
		EvaluationID5 = (SELECT TOP 1 EvalCriteriaID FROM #tblEvalCriteria t WHERE t.ActivityID = ActivityID AND t.ID = 5),
		EvaluationID6 = (SELECT TOP 1 EvalCriteriaID FROM #tblEvalCriteria t WHERE t.ActivityID = ActivityID AND t.ID = 6)
		WHERE ActivityID = @activityID
		
		UPDATE @tblStudentActivity 
		SET EvaluationName1 = (SELECT S_Evaluation_Name FROM dbo.T_Activity_Evaluation_Master WHERE I_Evaluation_ID = EvaluationID1),
		EvaluationName2 = (SELECT TOP 1 S_Evaluation_Name FROM dbo.T_Activity_Evaluation_Master WHERE I_Evaluation_ID = EvaluationID2),
		EvaluationName3 = (SELECT TOP 1 S_Evaluation_Name FROM dbo.T_Activity_Evaluation_Master WHERE I_Evaluation_ID = EvaluationID3),
		EvaluationName4 = (SELECT TOP 1 S_Evaluation_Name FROM dbo.T_Activity_Evaluation_Master WHERE I_Evaluation_ID = EvaluationID4),
		EvaluationName5 = (SELECT TOP 1 S_Evaluation_Name FROM dbo.T_Activity_Evaluation_Master WHERE I_Evaluation_ID = EvaluationID5),
		EvaluationName6 = (SELECT TOP 1 S_Evaluation_Name FROM dbo.T_Activity_Evaluation_Master WHERE I_Evaluation_ID = EvaluationID6)
		
		UPDATE @tblStudentActivity 
		SET EvalGrade1 = (SELECT TOP 1 S_Student_Grade FROM dbo.T_Student_Activity_Performance 
		WHERE I_Student_Activity_ID = StudentActivityID	AND I_Evaluation_ID = EvaluationID1 AND I_Term_ID = @iTermID)
		
		UPDATE @tblStudentActivity 
		SET EvalGrade2 = (SELECT TOP 1 S_Student_Grade FROM dbo.T_Student_Activity_Performance 
		WHERE I_Student_Activity_ID = StudentActivityID	AND I_Evaluation_ID = EvaluationID2 AND I_Term_ID = @iTermID)
		
		UPDATE @tblStudentActivity 
		SET EvalGrade3 = (SELECT TOP 1 S_Student_Grade FROM dbo.T_Student_Activity_Performance 
		WHERE I_Student_Activity_ID = StudentActivityID	AND I_Evaluation_ID = EvaluationID3 AND I_Term_ID = @iTermID)
		
		UPDATE @tblStudentActivity 
		SET EvalGrade4 = (SELECT TOP 1 S_Student_Grade FROM dbo.T_Student_Activity_Performance 
		WHERE I_Student_Activity_ID = StudentActivityID	AND I_Evaluation_ID = EvaluationID4 AND I_Term_ID = @iTermID)
		
		UPDATE @tblStudentActivity 
		SET EvalGrade5 = (SELECT TOP 1 S_Student_Grade FROM dbo.T_Student_Activity_Performance 
		WHERE I_Student_Activity_ID = StudentActivityID	AND I_Evaluation_ID = EvaluationID5 AND I_Term_ID = @iTermID)
		
		UPDATE @tblStudentActivity 
		SET EvalGrade6 = (SELECT TOP 1 S_Student_Grade FROM dbo.T_Student_Activity_Performance 
		WHERE I_Student_Activity_ID = StudentActivityID	AND I_Evaluation_ID = EvaluationID6 AND I_Term_ID = @iTermID)
		
		TRUNCATE TABLE #tblEvalCriteria
		
		SET @indexStudentActivity  = @indexStudentActivity + 1
	END
	
	SELECT ID ,
	        StudentID ,
	        tsd.S_First_Name + ' ' + ISNULL(tsd.S_Middle_Name,'') + ' ' + tsd.S_Last_Name AS StudentName ,
	        ActivityID ,
	        tam.S_Activity_Name AS ActivityName ,
	        StudentActivityID ,
	        EvaluationID1 ,
	        EvaluationName1 ,
	        EvalGrade1 ,
	        EvaluationID2 ,
	        EvaluationName2 ,
	        EvalGrade2 ,
	        EvaluationID3 ,
	        EvaluationName3 ,
	        EvalGrade3 ,
	        EvaluationID4 ,
	        EvaluationName4 ,
	        EvalGrade4 ,
	        EvaluationID5 ,
	        EvaluationName5 ,
	        EvalGrade5 ,
	        EvaluationID6 ,
	        EvaluationName6 ,
	        EvalGrade6 
	    FROM @tblStudentActivity TSA
		INNER JOIN dbo.T_Student_Detail AS tsd ON tsd.I_Student_Detail_ID = TSA.StudentID
		INNER JOIN dbo.T_Activity_Master AS tam ON TSA.ActivityID = TAM.I_Activity_ID
		ORDER BY tsd.S_First_Name
	
	DROP TABLE #tblEvalCriteria
END
