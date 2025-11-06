
--EXEC REPORT.uspStudentMarksGraphicalTermCaption @iBatchID = 783,@iTermID =13
--EXEC REPORT.uspStudentMarksGraphicalTermCaption @iBatchID = 783, @iTermID =12,@bUptoTerm = 1
--EXEC REPORT.uspStudentMarksGraphicalTermCaption @iBatchID = 783, @iTermID =11,@bUptoTerm = 1
--EXEC REPORT.uspStudentMarksGraphicalTermCaption @iBatchID = 1057, @iTermID =370,@bUptoTerm = 1
--EXEC REPORT.uspStudentMarksGraphicalTermCaption @iBatchID = 1057, @iTermID =371,@bUptoTerm = 1

CREATE PROCEDURE [REPORT].[uspStudentMarksGraphicalTermCaption] 
	@iBatchID INT
	,@iTermID INT = NULL
	,@bUptoTerm BIT = NULL
AS
BEGIN	

    DECLARE @sTermName VARCHAR(20)
	DECLARE @iMaxSequence INT
	DECLARE @iSequence INT 

	SELECT @iMaxSequence = MAX(I_Sequence) 
			FROM T_Term_Course_Map TM WITH (NOLOCK) 
			INNER JOIN T_Student_Batch_Master SBM WITH (NOLOCK) ON TM.I_Course_ID = SBM.I_Course_ID AND SBM.I_Batch_ID = @iBatchID
			AND TM.I_Status = 1

	SELECT @iSequence = I_Sequence 
			FROM T_Term_Course_Map TM WITH (NOLOCK) 
			INNER JOIN T_Student_Batch_Master SBM WITH (NOLOCK) ON TM.I_Course_ID = SBM.I_Course_ID AND SBM.I_Batch_ID = @iBatchID
			WHERE I_Term_ID = @iTermID
			AND TM.I_Status = 1

	IF @iTermID IS NULL OR @iMaxSequence = ISNULL(@iSequence,@iMaxSequence)
		SET @sTermName = (SELECT ISNULL(T.S_Display_Name,T.S_Term_Name)
			FROM T_Term_Course_Map TM WITH (NOLOCK)
				INNER JOIN T_Student_Batch_Master SBM WITH (NOLOCK) ON TM.I_Course_ID = SBM.I_Course_ID AND SBM.I_Batch_ID = @iBatchID
				INNER JOIN  T_Term_Master T ON T.I_Term_Id = TM.I_Term_Id AND I_Sequence = @iMaxSequence)--'ANNUAL TERM'
	ELSE
		SET @sTermName = (SELECT ISNULL(T.S_Display_Name,T.S_Term_Name)
			FROM T_Term_Course_Map TM WITH (NOLOCK)
				INNER JOIN T_Student_Batch_Master SBM WITH (NOLOCK) ON TM.I_Course_ID = SBM.I_Course_ID AND SBM.I_Batch_ID = @iBatchID
				INNER JOIN  T_Term_Master T ON T.I_Term_Id = TM.I_Term_Id AND I_Sequence = @iSequence)--(CASE @iSequence  WHEN  1 THEN 'FIRST TERM' WHEN 2 THEN 'SECOND TERM' END)

	IF @iTermID IS NULL
		SELECT 'UPTO ' + @sTermName AS S_Term_Caption
	ELSE IF @iTermID IS NOT NULL AND @bUptoTerm = 1
		SELECT 'UPTO '+  @sTermName AS S_Term_Caption 
	ELSE
		SELECT @sTermName  AS S_Term_Caption 
END
