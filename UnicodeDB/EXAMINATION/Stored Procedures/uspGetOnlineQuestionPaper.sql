CREATE PROCEDURE [EXAMINATION].[uspGetOnlineQuestionPaper]
	@iExamComponentID INT,
	@iEvalStrategyID INT = NULL,
	@iUserID INT = NULL
AS

BEGIN
	SET NOCOUNT ON;	
	CREATE TABLE #tempTable
	(
		I_Pool_ID int
	)

	CREATE TABLE #TEMPBANK
	(	
		ID_Identity int identity(1,1),
		S_Question_Bank_ID varchar(500)
	)

	INSERT INTO #TEMPBANK
	select S_Question_Bank_ID from T_Test_Design 
	WHERE I_Exam_Component_ID = @iExamComponentID AND I_Eval_Strategy_ID = ISNULL(@iEvalStrategyID,I_Eval_Strategy_ID) AND I_Status_ID = 1

	DECLARE @iCount INT
	DECLARE @iRowCount INT
	DECLARE @sQuestionBankIDs VARCHAR(500)
	SELECT @iRowCount = count(ID_Identity) FROM #TEMPBANK
	SET @iCount = 1

	WHILE (@iCount <= @iRowCount)
	BEGIN	
		select @sQuestionBankIDs = S_Question_Bank_ID from #TEMPBANK where ID_Identity = @iCount

		INSERT INTO #tempTable
		SELECT I_Pool_ID FROM EXAMINATION.T_Bank_Pool_Mapping BPM,EXAMINATION.T_Test_Design TD
		WHERE TD.I_Exam_Component_ID = @iExamComponentID
		  AND I_Eval_Strategy_ID = ISNULL(@iEvalStrategyID,I_Eval_Strategy_ID)
		  AND BPM.I_Question_Bank_ID in (select * from dbo.fnString2Rows(@sQuestionBankIDs,','))
		  AND I_Status_ID = 1
		
		SET @iCount = @iCount + 1
	END	


	SELECT QP.I_Question_ID,QP.I_Pool_ID,QP.I_Answer_Type_ID,
		QP.S_Question,QP.S_Question_Options,QP.I_Question_Type,QP.I_Complexity_ID,
		QP.I_Document_ID,UD.S_Document_Name,UD.S_Document_Type,
		UD.S_Document_Path,UD.S_Document_URL
	FROM EXAMINATION.T_Question_Pool QP
	LEFT OUTER JOIN dbo.T_Upload_Document UD
	ON QP.I_Document_ID = UD.I_Document_ID
	AND I_Status = 1
	WHERE QP.I_Pool_ID IN
	(SELECT I_Pool_ID FROM #tempTable)

	SELECT QP.I_Question_ID, QC.I_Question_Choice_ID,QC.S_Answer_Desc,
		QC.B_Is_Answer,ISNULL(QC.N_Answer_Marks,0) AS N_Answer_Marks
	FROM EXAMINATION.T_Question_Choices QC
	INNER JOIN EXAMINATION.T_Question_Pool QP
	ON QP.I_Question_ID = QC.I_Question_ID
	WHERE QP.I_Pool_ID IN
	(SELECT I_Pool_ID FROM #tempTable)

	SELECT QP.I_Question_ID, SQ.I_SubQuestion_ID,SQ.I_SubQuestion_Type,
		SQ.S_SubQuestion_Desc,SQ.S_SubQuestion_Value,SQ.I_Document_ID,
			UD.S_Document_Name,UD.S_Document_Type,
			UD.S_Document_Path,UD.S_Document_URL
	FROM EXAMINATION.T_SubQuestion SQ
	INNER JOIN EXAMINATION.T_Question_Pool QP	
	ON QP.I_Question_ID = SQ.I_Question_ID
	LEFT OUTER JOIN dbo.T_Upload_Document UD
	ON SQ.I_Document_ID = UD.I_Document_ID
	WHERE QP.I_Pool_ID IN
	(SELECT I_Pool_ID FROM #tempTable)

	SELECT SQ.I_SubQuestion_ID , SQC.I_SubQuestion_Choice_ID,SQC.I_SubQuestion_Choice_Type,
		SQC.S_SubAnswer_Value,SQC.S_SubAnswer_Desc,
		SQC.B_Is_Answer,SQC.I_Document_ID,UD.S_Document_Name,UD.S_Document_Type,
			UD.S_Document_Path,UD.S_Document_URL
	FROM EXAMINATION.T_SubQuestion_Choice SQC
	INNER JOIN EXAMINATION.T_SubQuestion SQ
	ON SQC.I_SubQuestion_ID = SQ.I_SubQuestion_ID
	INNER JOIN EXAMINATION.T_Question_Pool QP
	ON SQ.I_Question_ID = QP.I_Question_ID
	LEFT OUTER JOIN dbo.T_Upload_Document UD
	ON SQC.I_Document_ID = UD.I_Document_ID
	WHERE QP.I_Pool_ID IN
	(SELECT I_Pool_ID FROM #tempTable)

	TRUNCATE TABLE #tempTable
	DROP TABLE #tempTable

	TRUNCATE TABLE #TEMPBANK
	DROP TABLE #TEMPBANK
END
