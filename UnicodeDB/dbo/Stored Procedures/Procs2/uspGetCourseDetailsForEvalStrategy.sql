CREATE PROCEDURE [dbo].[uspGetCourseDetailsForEvalStrategy] 
(
	-- Add the parameters for the stored procedure here
	@iCourseID int,
	@dtCurrentDate datetime = null
)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT OFF
	Set @dtCurrentDate = ISNULL(@dtCurrentDate,GETDATE())
    -- Course Basic Details
    -- Table[0]
	SELECT 
	CM.I_Course_ID,
	CM.I_CourseFamily_ID,
	CM.I_Brand_ID,
	CM.S_Course_Code,
	CM.S_Course_Name,
	CM.I_Grading_Pattern_ID,
	CM.S_Course_Desc,
	CM.I_Certificate_ID,
	CM.S_Crtd_By,
	CM.I_No_Of_Session,
	CM.S_Upd_By,
	CM.C_AptitudeTestReqd,
	CM.Dt_Crtd_On,
	CM.Dt_Upd_On,
	CM.I_Status,
	CM.I_Is_Editable,
	CR.S_Certificate_Name,
	CF.S_CourseFamily_Name
	FROM dbo.T_Course_Master CM
    LEFT OUTER JOIN dbo.T_Certificate_Master CR
	ON CM.I_Certificate_ID = CR.I_Certificate_ID
	LEFT OUTER JOIN dbo.T_CourseFamily_Master CF	
	ON CM.I_CourseFamily_ID = CF.I_courseFamily_ID
	WHERE CM.I_Course_ID = @iCourseID
	AND CM.I_Status=1
	
	
	-- Term List
	-- Table[1]
	SELECT	A.I_Term_Course_ID,
			A.I_Term_ID,
			B.S_Term_Code,
			B.S_Term_Name,
			A.I_Sequence,
			A.I_Status
	FROM dbo.T_Term_Course_Map A 
	INNER JOIN dbo.T_Term_Master B   
	ON A.I_Course_ID = @iCourseID
	AND A.I_Term_ID = B.I_Term_ID
	AND @dtCurrentDate >= ISNULL(A.Dt_Valid_From, @dtCurrentDate)
	AND @dtCurrentDate <= ISNULL(A.Dt_Valid_To, @dtCurrentDate)
	AND A.I_Status <> 0
	AND B.I_Status <> 0
	ORDER BY A.I_Sequence
	
	-- Module List
	-- Table[2]
	SELECT	A.I_Module_Term_ID,
			A.I_Module_ID,
			B.S_Module_Code,
			B.S_Module_Name,
			A.I_Term_ID,
			A.I_Sequence
	FROM dbo.T_Module_Term_Map A
	INNER JOIN dbo.T_Module_Master B
	ON A.I_Module_ID = B.I_Module_ID  
	INNER JOIN dbo.T_Term_Course_Map C
	ON A.I_Term_ID = C.I_Term_ID
	AND C.I_Course_ID = @iCourseID
	AND @dtCurrentDate >= ISNULL(A.Dt_Valid_From, @dtCurrentDate)
	AND @dtCurrentDate <= ISNULL(A.Dt_Valid_To, @dtCurrentDate)
	AND A.I_Status <> 0
	AND B.I_Status <> 0
	AND C.I_Status <> 0
	ORDER BY A.I_Sequence
	
	-- Session List
	-- Table[3]
	SELECT DISTINCT	A.I_Session_Module_ID, 
			A.I_Session_ID,
			B.S_Session_Code,
			B.S_Session_Name,
			A.I_Module_ID,
			A.I_Sequence,
			B.N_Session_Duration
	FROM dbo.T_Session_Module_Map A
	INNER JOIN dbo.T_Session_Master B
	ON A.I_Session_ID = B.I_Session_ID
	INNER JOIN dbo.T_Module_Term_Map C
	ON A.I_Module_ID = C.I_Module_ID
	INNER JOIN dbo.T_Term_Course_Map D   
	ON C.I_Term_ID = D.I_Term_ID
	AND D.I_Course_ID = @iCourseID
	AND @dtCurrentDate >= ISNULL(A.Dt_Valid_From, @dtCurrentDate)
	AND @dtCurrentDate <= ISNULL(A.Dt_Valid_To, @dtCurrentDate)
	AND A.I_Status <> 0
	AND B.I_Status <> 0
	AND C.I_Status <> 0
	AND D.I_Status <> 0
	ORDER BY A.I_Sequence
	
	-- Term Evaluation Strategy List
	-- Table[4]
	SELECT	DISTINCT A.I_Term_Strategy_ID,
			A.I_Term_ID,
			A.I_Exam_Component_ID,
			B.S_Component_Name,
			B.S_Component_Type,
			A.I_Exam_Type_Master_ID,
			A.I_TotMarks,
			A.N_Weightage,
			A.S_Remarks,
			A.I_IsPSDate,
			D.S_Exam_Type_Name,
			A.I_Exam_Duration
	FROM dbo.T_Term_Eval_Strategy A
	LEFT OUTER JOIN dbo.T_Exam_Component_Master B
	ON A.I_Exam_Component_ID = B.I_Exam_Component_ID
	AND B.I_Status = 1
	LEFT OUTER JOIN dbo.T_Exam_Type_Master D
	ON A.I_Exam_Type_Master_ID = D.I_Exam_Type_Master_ID
	INNER JOIN dbo.T_Term_Course_Map C
	ON A.I_Term_ID = C.I_Term_ID
	AND A.I_Course_ID = @iCourseID
	AND A.I_Status <> 0
	AND C.I_Status <> 0

	-- Module Evaluation Strategy List
	-- Table[5]
	SELECT	DISTINCT A.I_Module_Strategy_ID,
			A.I_Module_ID,
			A.I_Exam_Component_ID,
			B.S_Component_Name,
			B.S_Component_Type,
			B.I_Exam_Type_Master_ID,
			A.I_Term_ID,
			A.I_TotMarks,
			A.N_Weightage,
			A.S_Remarks,
			E.I_Exam_Type_Master_ID,
			E.S_Exam_Type_Name,
			A.I_Exam_Duration
	FROM dbo.T_Module_Eval_Strategy A
	INNER JOIN dbo.T_Exam_Component_Master B
	ON A.I_Exam_Component_ID = B.I_Exam_Component_ID
	INNER JOIN dbo.T_Exam_Type_Master E
	ON B.I_Exam_Type_Master_ID = E.I_Exam_Type_Master_ID
	INNER JOIN dbo.T_Module_Term_Map C
	ON A.I_Module_ID = C.I_Module_ID
	INNER JOIN dbo.T_Term_Course_Map D
	ON C.I_Term_ID = D.I_Term_ID
	AND A.I_Course_ID = @iCourseID
	AND A.I_Status <> 0
	AND B.I_Status <> 0
	AND C.I_Status <> 0
	AND D.I_Status <> 0
	
END
