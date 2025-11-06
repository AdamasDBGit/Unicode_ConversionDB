/**************************************************************************************************************
Created by  : Debarshi Basu
Date		: 05.05.2007
Description : This SP will retrieve the details of the exam design 
Parameters  : iExamComponentID
Returns     : Dataset
**************************************************************************************************************/

CREATE PROCEDURE [EXAMINATION].[uspGetExamDesign]
	(
		@iExamComponentID INT = NULL,
		@iExamID INT = NULL,
		@iEvalStrategyID INT = NULL
	)
AS

BEGIN
	SET NOCOUNT ON;	
	
	IF(@iEvalStrategyID = 0)
	BEGIN
		SET @iEvalStrategyID = NULL
	END
	
	IF (@iExamID IS NULL OR @iExamID = 0)
	BEGIN
		SELECT 
			TD.I_Eval_Strategy_ID, 
			TD.I_Exam_Component_ID, 
			TD.S_Question_Bank_ID,
			DP.I_Test_Design_Pattern_ID,
			DP.I_Test_Design_ID,
			DP.I_Pool_ID,
			DP.I_No_Of_Questions,
			DP.I_Complexity_ID,
			DP.N_Marks
		FROM EXAMINATION.T_Test_Design_Pattern DP WITH(NOLOCK)
			INNER JOIN EXAMINATION.T_Test_Design TD WITH(NOLOCK)
			ON TD.I_Test_Design_ID = DP.I_Test_Design_ID
		WHERE TD.I_Status_ID = 1
			AND TD.I_Exam_Component_ID = @iExamComponentID
			AND TD.I_Eval_Strategy_ID = ISNULL(@iEvalStrategyID,TD.I_Eval_Strategy_ID)
	END
	ELSE
	BEGIN
		DECLARE @iCourseID INT, @iTermID INT, @iModuleID INT
		
		SELECT	
			@iCourseID = I_Course_ID,
			@iTermID = I_Term_ID,
			@iModuleID = I_Module_ID
		FROM
			Examination.T_Examination_Detail
		WHERE
			I_Exam_ID = @iExamID
					
	IF (@iModuleID IS NULL OR @iModuleID = 0 )
	BEGIN
		SELECT @iEvalStrategyID = I_Term_Strategy_ID FROM dbo.T_Term_Eval_Strategy
			WHERE I_Course_ID = @iCourseID AND I_Term_ID = @iTermID AND I_Exam_Component_ID = @iExamComponentID			
		
	END
	ELSE
	BEGIN
		SELECT @iEvalStrategyID = I_Module_Strategy_ID FROM dbo.T_Module_Eval_Strategy 
			WHERE I_Course_ID = @iCourseID AND I_Term_ID = @iTermID AND I_Module_ID = @iModuleID AND I_Exam_Component_ID = @iExamComponentID			
	END	
		
		SELECT
			TD.I_Eval_Strategy_ID, 
			TD.I_Exam_Component_ID, 
			TD.S_Question_Bank_ID,
			DP.I_Test_Design_Pattern_ID,
			DP.I_Test_Design_ID,
			DP.I_Pool_ID,
			DP.I_No_Of_Questions,
			DP.I_Complexity_ID,
			DP.N_Marks
		FROM EXAMINATION.T_Test_Design_Pattern DP WITH(NOLOCK)
			INNER JOIN EXAMINATION.T_Test_Design TD WITH(NOLOCK)
			ON TD.I_Test_Design_ID = DP.I_Test_Design_ID
		WHERE TD.I_Status_ID = 1
			AND TD.I_Exam_Component_ID = @iExamComponentID
			AND TD.I_Eval_Strategy_ID = @iEvalStrategyID
			
	END
END
