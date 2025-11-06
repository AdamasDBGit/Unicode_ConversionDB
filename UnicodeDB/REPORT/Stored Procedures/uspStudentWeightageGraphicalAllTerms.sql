
--EXEC REPORT.uspStudentWeightageGraphicalAllTerms @iBatchId = 783, @iStudentId = 4695
--EXEC REPORT.uspStudentWeightageGraphicalAllTerms @iBatchId = 783, @iStudentId = 4695, @iTermId = 13
--EXEC REPORT.uspStudentWeightageGraphicalAllTerms @iBatchId = 1057, @iStudentId = 4400, @iTermId = 370
--EXEC REPORT.uspStudentWeightageGraphicalAllTerms @iBatchId = 8419, @iStudentId = 4659

CREATE PROCEDURE [REPORT].[uspStudentWeightageGraphicalAllTerms] 
	@iBatchID INT
	,@iStudentID INT
	,@iTermID INT = NULL
AS
BEGIN	

  DECLARE @Terms AS TABLE (I_Term_ID INT
							,I_Sequence INT)

  DECLARE @iCourseID INT
	SET @iCourseID = (SELECT I_Course_ID 
						FROM T_Student_Batch_Master AS tsbm WITH (NOLOCK) 
						WHERE I_Batch_ID = @iBatchID)

	IF @iTermID IS NULL --Pick all terms
		INSERT INTO @Terms(I_Term_ID
							,I_Sequence)
		SELECT
			TCM.I_Term_ID
			,TCM.I_Sequence
		FROM T_Term_Course_Map TCM WITH (NOLOCK)
		WHERE TCM.I_Course_ID = @iCourseID
			AND TCM.I_Status = 1
	ELSE --Terms Upto
	   INSERT INTO @Terms(I_Term_ID
						,I_Sequence)
		SELECT
			TCM.I_Term_ID
			,TCM.I_Sequence
		FROM T_Term_Course_Map TCM WITH (NOLOCK)
		WHERE TCM.I_Course_ID = @iCourseID
			AND TCM.I_Status = 1  
			AND TCM.I_Sequence <= (SELECT I_Sequence --Pick Terms Upto TermId Passed
									FROM T_Term_Course_Map ITCM WITH (NOLOCK) 
									WHERE I_Course_ID = @iCourseID
										AND I_Term_ID = @iTermID 
										AND ITCM.I_Status = 1)
   
   CREATE TABLE #Modules(I_ModuleGroup_ID INT
						,I_Module_ID INT
						,I_Term_ID INT 
						,N_Weightage INT
						,I_Sequence INT)

 --Pick ModuleGroup wise weightage
  INSERT INTO #Modules(I_ModuleGroup_ID
						,I_Module_ID
						,I_Term_ID
						,N_Weightage
						,I_Sequence)
	SELECT
		MTM.I_ModuleGroup_ID
		,MTM.I_Module_ID
		,MTM.I_Term_ID
		,MTM.N_Weightage
		,MTM.I_Sequence
	FROM T_Module_Term_Map MTM WITH (NOLOCK)
		INNER JOIN @Terms T ON T.I_Term_ID = MTM.I_Term_ID
	WHERE MTM.I_Status = 1
		--AND MTM.N_Weightage > 0
		AND MTM.I_Module_ID IN (SELECT I_Module_ID 
								FROM T_Module_Eval_Strategy MES WITH (NOLOCK) 
								INNER JOIN @Terms T ON T.I_Term_ID = MES.I_Term_ID
								WHERE MES.I_Status = 1)
							

   DECLARE @Student AS TABLE(I_Student_ID INT
							,I_Course_ID INT 
							,I_Term_ID INT
							,S_Term_Name VARCHAR(250)
							,I_Exam_Component_ID INT
							,S_Exam_Component_Name VARCHAR(200)
							,I_Batch_Exam_ID INT
							,I_Sequence INT
							,I_Exam_Component_Sequence INT)

   INSERT INTO @Student(I_Student_ID
						,I_Course_ID
						,I_Term_ID
						,S_Term_Name
						,I_Exam_Component_ID
						,S_Exam_Component_Name
						,I_Batch_Exam_ID
						,I_Sequence
						,I_Exam_Component_Sequence)
	SELECT DISTINCT
		TSBD.I_Student_ID
		,TSBM.I_Course_ID
		,TM.I_Term_ID
		,ISNULL(TM.S_Display_Name,TM.S_Term_Name) + ' (' + CONVERT(VARCHAR(5),WT.N_Weightage) + ')'
		,ECM.I_Exam_Component_ID
		,ECM.S_Component_Name
		,BEM.I_Batch_Exam_ID
		,tcm.I_Sequence
		,ECM.I_Sequence_No
	FROM EXAMINATION.T_Batch_Exam_Map BEM WITH (NOLOCK)
		INNER JOIN T_Term_Master TM WITH (NOLOCK) ON TM.I_Term_ID = BEM.I_Term_ID
		INNER JOIN @Terms TMS ON TMS.I_Term_ID = TM.I_Term_ID
		INNER JOIN T_Exam_Component_Master ECM WITH (NOLOCK) ON ECM.I_Exam_Component_ID = BEM.I_Exam_Component_ID
		INNER JOIN dbo.T_Student_Batch_Details TSBD WITH (NOLOCK) ON TSBD.I_Batch_ID = BEM.I_Batch_ID
		INNER JOIN dbo.T_Student_Batch_Master AS tsbm WITH (NOLOCK) ON TSBM.I_Batch_ID = TSBD.I_Batch_ID
		--INNER JOIN T_Course_Master cm WITH (NOLOCK) ON cm.I_Course_ID = tsbm.I_Course_ID
		INNER JOIN #Modules MTM WITH (NOLOCK) ON MTM.I_Module_ID = BEM.I_Module_ID AND MTM.I_Term_ID = BEM.I_Term_ID
		INNER JOIN (SELECT I_Term_ID
							,SUM(N_Weightage) AS N_Weightage 
					FROM #Modules 
					GROUP BY I_Term_ID) WT ON WT.I_Term_ID = TM.I_Term_ID
		INNER JOIN T_Term_Course_Map tcm WITH (NOLOCK) ON tcm.I_Course_ID = tsbm.I_Course_ID 
				AND tcm.I_Term_ID = TM.I_Term_ID
		
	WHERE BEM.I_Batch_ID = @iBatchID
		AND TSBD.I_Student_ID = @iStudentID
		AND TSBD.I_Status IN (1, 2 ) 
		AND TM.I_Status = 1 
		AND tcm.I_Status = 1
		--AND MTM.N_Weightage > 0
		AND BEM.I_Status != 0
		AND ISNULL(ECM.B_Exclude_In_Report,0) = 0	

	--Script 3
	DECLARE @bSecTop BIT = 0
	DECLARE @bAllSecTop BIT = 0

	DECLARE @Order AS TABLE(I_Order INT)

	INSERT INTO @Order(I_Order)
	VALUES(1),(2),(3),(4),(5)


	DECLARE @ReturnTable AS TABLE (I_Student_Detail_ID INT
						--,I_Batch_Exam_ID INT
						,I_Term_ID INT
						,I_Exam_Component_ID INT
						,I_Marks NUMERIC(8,2)
						,I_Marks_Per NUMERIC(8,2)
						,I_Order INT
						,B_Sec_Top INT
						,B_All_Sec_Top INT
						,I_Perm_Level INT) --1Up,2Down,3Same

	INSERT INTO @ReturnTable(I_Student_Detail_ID
							--,I_Batch_Exam_ID
							,I_Term_ID
							,I_Exam_Component_ID
							,I_Marks
							,I_Order
							,B_Sec_Top
							,B_All_Sec_Top)
	SELECT DISTINCT	    
		SM.I_Student_Detail_ID,
		--BEM.I_Batch_Exam_ID,
		BEM.I_Term_ID,
		BEM.I_Exam_Component_ID ,
		NULL AS I_Marks,
		O.I_Order, 
		0 AS B_Sec_Top, 
		0 AS B_All_Sec_Top
	FROM EXAMINATION.T_Student_Marks SM WITH (NOLOCK)
		INNER JOIN EXAMINATION.T_Batch_Exam_Map BEM WITH (NOLOCK) ON SM.I_Batch_Exam_ID = BEM.I_Batch_Exam_ID
		INNER JOIN #Modules M ON M.I_Module_ID = BEM.I_Module_ID AND M.I_Term_ID = BEM.I_Term_ID
		CROSS JOIN @Order O
	WHERE BEM.I_Batch_ID = @iBatchID
		AND SM.I_Student_Detail_ID = @iStudentID
		AND BEM.I_Status != 0	
	ORDER BY SM.I_Student_Detail_ID
	
	
	--DECLARE @MarksTemp AS TABLE 
	CREATE TABLE #MarksTemp(I_Student_Detail_ID INT
							,I_Batch_ID INT
							,I_Term_ID INT
							,I_Module_ID INT
							,I_Exam_Component_ID INT
							,I_Exam_Total NUMERIC(8,2))

   INSERT INTO #MarksTemp(I_Student_Detail_ID
                         ,I_Batch_ID
						 ,I_Term_ID
						 ,I_Module_ID
						 ,I_Exam_Component_ID
						 ,I_Exam_Total)
	SELECT SM.I_Student_Detail_ID
			,BEM.I_Batch_ID
			,BEM.I_Term_ID
			,BEM.I_Module_ID
			,BEM.I_Exam_Component_ID
			,ROUND(SM.I_Exam_Total,0)
				FROM T_Student_Batch_Master SBM WITH (NOLOCK) 
				     INNER JOIN EXAMINATION.T_Batch_Exam_Map BEM WITH (NOLOCK) ON SBM.I_Batch_ID = BEM.I_Batch_ID AND SBM.I_Course_ID = @iCourseID 
				     INNER JOIN EXAMINATION.T_Student_Marks SM WITH (NOLOCK) ON	 SM.I_Batch_Exam_ID = BEM.I_Batch_Exam_ID
					 INNER JOIN #Modules M ON M.I_Module_ID = BEM.I_Module_ID AND M.I_Term_Id = BEM.I_Term_ID
			WHERE  BEM.I_Status != 0

	DECLARE @MMWTTemp AS TABLE ( I_Term_ID INT
								,I_Module_ID INT
								,I_Exam_Component_ID INT								
								,I_TotMarks NUMERIC(8,2)
								,N_Weightage NUMERIC(8,2))

    INSERT INTO @MMWTTemp(I_Term_ID
						  ,I_Module_ID 
						  ,I_Exam_Component_ID
						  ,I_TotMarks
						  ,N_Weightage)
	SELECT 
		MTM.I_Term_ID
		,MTM.I_Module_ID
		,MES.I_Exam_Component_ID
		,MES.I_TotMarks
		,MES.N_Weightage
	FROM #Modules MTM 
		INNER JOIN T_Module_Eval_Strategy MES WITH (NOLOCK) ON MES.I_Module_ID = MTM.I_Module_ID AND MES.I_Term_ID = MTM.I_Term_ID
		INNER JOIN @Terms T ON T.I_Term_ID = MES.I_Term_ID AND T.I_Term_ID = MTM.I_Term_ID		
	WHERE MES.I_Status = 1
		  AND MES.I_Course_ID = @iCourseID 

	UPDATE T
	  SET I_Marks = (SELECT SUM(ROUND(I_Exam_Total,0)) 
				FROM EXAMINATION.T_Student_Marks SM WITH (NOLOCK)
					INNER JOIN EXAMINATION.T_Batch_Exam_Map BEM WITH (NOLOCK) ON SM.I_Batch_Exam_ID = BEM.I_Batch_Exam_ID
					INNER JOIN #Modules MTM ON BEM.I_Module_ID = MTM.I_Module_ID AND BEM.I_Term_ID = MTM.I_Term_ID
				WHERE SM.I_Student_Detail_ID = T.I_Student_Detail_ID
					AND BEM.I_Term_ID = T.I_Term_ID
					AND BEM.I_Exam_Component_ID = T.I_Exam_Component_ID
					AND BEM.I_Status != 0)
	FROM @ReturnTable T
		WHERE I_Order = 3
	
  
	UPDATE T
	  SET I_Marks_Per = (SELECT ROUND((CAST(I_Marks AS NUMERIC(8,2))/SUM(MES.I_TotMarks))*100,0)
				FROM @MMWTTemp MES  
					WHERE MES.I_Exam_Component_ID = T.I_Exam_Component_ID
					AND MES.I_Term_ID = T.I_Term_ID
					AND N_Weightage > 0)
	FROM @ReturnTable T
		WHERE I_Order = 3
 
	UPDATE T
	  SET I_Marks = (SELECT ROUND(SUM((ROUND(I_Exam_Total,0)/I_TotMarks)*N_Weightage ),0)
				FROM EXAMINATION.T_Student_Marks SM WITH (NOLOCK)
					INNER JOIN EXAMINATION.T_Batch_Exam_Map BEM WITH (NOLOCK) ON SM.I_Batch_Exam_ID = BEM.I_Batch_Exam_ID
					INNER JOIN  @MMWTTemp MTM  
							ON MTM.I_Term_ID = BEM.I_Term_ID
							AND MTM.I_Module_ID = BEM.I_Module_ID
							AND MTM.I_Exam_Component_ID = BEM.I_Exam_Component_ID
				WHERE SM.I_Student_Detail_ID = T.I_Student_Detail_ID
					AND BEM.I_Term_ID = T.I_Term_ID
					AND BEM.I_Exam_Component_ID = T.I_Exam_Component_ID
					AND BEM.I_Status != 0)
	FROM @ReturnTable T
		WHERE I_Order = 3
		
    DECLARE @MaxAvg AS TABLE (I_Batch_ID INT
							,I_Term_ID INT
							,I_Exam_Component_ID INT
							,I_MaxValue INT
							,I_AvgValue INT)

	INSERT INTO @MaxAvg(I_Batch_ID
						,I_Term_ID
						,I_Exam_Component_ID
						,I_MaxValue
						,I_AvgValue)
	SELECT I_Batch_ID
		  ,I_Term_ID
	      ,I_Exam_Component_ID  
		  ,MAX(Value) AS I_MaxValue
		  ,AVG(Value) AS I_AvgValue
	FROM (SELECT BEM.I_Batch_ID
		  ,BEM.I_Term_ID
	      ,BEM.I_Exam_Component_ID	
		  ,I_Student_Detail_ID	  
		  ,ROUND(SUM((ROUND(BEM.I_Exam_Total,0)/I_TotMarks)*N_Weightage),0) AS Value
	FROM #MarksTemp BEM
		INNER JOIN  @MMWTTemp MTM  
							ON MTM.I_Term_ID = BEM.I_Term_ID
							AND MTM.I_Module_ID = BEM.I_Module_ID
							AND MTM.I_Exam_Component_ID = BEM.I_Exam_Component_ID
	--WHERE BEM.I_Batch_Id = @iBatchId
	GROUP BY BEM.I_Batch_ID, BEM.I_Term_ID, I_Student_Detail_ID, BEM.I_Exam_Component_ID) T
	GROUP BY I_Batch_ID, I_Term_ID, I_Exam_Component_ID
	ORDER BY I_Batch_ID, I_Term_ID, I_Exam_Component_ID
	
		
    --Sec avg
    UPDATE T
		SET I_Marks = I.Value
	FROM @ReturnTable T
		INNER JOIN (SELECT I_Exam_Component_ID
							,I_Term_ID
							,I_AvgValue AS Value
					FROM @MaxAvg
					WHERE I_Batch_ID = @iBatchID				
					) I ON I.I_Exam_Component_ID = T.I_Exam_Component_ID
					AND I.I_Term_ID = T.I_Term_ID 
		WHERE I_Order = 1

     --Sec Max
	 UPDATE T
		SET I_Marks = I.Value
	FROM @ReturnTable T
			INNER JOIN (SELECT I_Exam_Component_ID
								,I_Term_ID
								,I_MaxValue AS Value
					FROM @MaxAvg
					WHERE I_Batch_ID = @iBatchID					
					) I ON I.I_Exam_Component_ID = T.I_Exam_Component_ID
					AND I.I_Term_ID =T.I_Term_ID 
		WHERE I_Order = 2


		--All Sec Max
   UPDATE T
		SET I_Marks = (SELECT MAX(I_MaxValue)
						FROM @MaxAvg I
						WHERE I.I_Term_ID = T.I_Term_ID
							AND I.I_Exam_Component_ID = T.I_Exam_Component_ID) 
	FROM @ReturnTable T
		WHERE I_Order = 4

		--All Sec Avg
	 UPDATE T
		SET I_Marks = (SELECT AVG(I_AvgValue)
						FROM @MaxAvg I
						WHERE I.I_Term_ID = T.I_Term_ID
							AND I.I_Exam_Component_ID = T.I_Exam_Component_ID) 
	FROM @ReturnTable T
		WHERE I_Order = 5

		
	 ------------------------------------------

	 
--Update sec max flag
DECLARE @Max AS TABLE (I_Term_ID INT
						,I_Exam_Component_ID INT
						,I_Marks NUMERIC(8,2)) 

INSERT INTO @Max(I_Term_ID
				,I_Exam_Component_ID
				,I_Marks)
SELECT I_Term_ID
		,I_Exam_Component_ID
		,MAX(I_Marks)
FROM @ReturnTable
WHERE I_Order= 2
GROUP BY I_Term_ID
		,I_Exam_Component_ID


UPDATE T
	SET B_Sec_Top = (CASE WHEN M.I_Marks = (SELECT I_Marks FROM @ReturnTable
									WHERE I_Term_ID = T.I_Term_ID
									AND I_Exam_Component_ID = T.I_Exam_Component_ID
									AND I_Student_Detail_ID = T.I_Student_Detail_ID
									AND I_Order=3) THEN 1 ELSE 0 END)
FROM @ReturnTable T 
	INNER JOIN @Max M ON M.I_Term_ID = T.I_Term_ID
			AND M.I_Exam_Component_ID = T.I_Exam_Component_ID 

--Update all sec max flag
DELETE FROM @Max
INSERT INTO @Max(I_Term_ID
				,I_Exam_Component_ID
				,I_Marks)
SELECT I_Term_ID
		,I_Exam_Component_ID
		,MAX(I_Marks)
FROM @ReturnTable
WHERE I_Order= 4
GROUP BY I_Term_ID
		,I_Exam_Component_ID

UPDATE T
	SET B_All_Sec_Top = (CASE WHEN M.I_Marks = (SELECT I_Marks FROM @ReturnTable
									WHERE I_Term_ID = T.I_Term_ID
									AND I_Exam_Component_ID = T.I_Exam_Component_ID
									AND I_Student_Detail_ID = T.I_Student_Detail_ID
									AND I_Order = 3) THEN 1 ELSE 0 END)
FROM @ReturnTable T 
	INNER JOIN @Max M ON M.I_Term_ID = T.I_Term_ID
			AND M.I_Exam_Component_ID = T.I_Exam_Component_ID 




--UPDATE PERFORMANCE LEVEL
DECLARE @CheckT1 AS TABLE (I_Student_Detail_ID INT
							,I_Exam_Component_ID INT
							,I_Marks NUMERIC(8,2)) 
DECLARE @CheckT2 AS TABLE (I_Student_Detail_ID INT
							,I_Exam_Component_ID INT
							,I_Marks NUMERIC(8,2)) 
DECLARE @CheckT3 AS TABLE (I_Student_Detail_ID INT
							,I_Exam_Component_ID INT
							,I_Marks NUMERIC(8,2)) 

INSERT INTO @CheckT1(I_Student_Detail_ID
				,I_Exam_Component_ID
				,I_Marks)
SELECT  I_Student_Detail_ID
		,I_Exam_Component_ID
		,I_Marks_Per
FROM @ReturnTable
WHERE I_Order= 3
	AND I_Term_ID = (SELECT I_Term_ID FROM @Terms WHERE I_Sequence =1)

INSERT INTO @CheckT2(I_Student_Detail_ID
				,I_Exam_Component_ID
				,I_Marks)
SELECT  I_Student_Detail_ID
		,I_Exam_Component_ID
		,I_Marks_Per
FROM @ReturnTable
WHERE I_Order= 3
	AND I_Term_ID = (SELECT I_Term_ID FROM @Terms WHERE I_Sequence = 2)

INSERT INTO @CheckT3(I_Student_Detail_ID
				,I_Exam_Component_ID
				,I_Marks)
SELECT  I_Student_Detail_ID
		,I_Exam_Component_ID
		,I_Marks_Per
FROM @ReturnTable
WHERE I_Order= 3
	AND I_Term_ID = (SELECT I_Term_ID FROM @Terms WHERE I_Sequence = 3)


UPDATE T
	SET I_Perm_Level = (CASE WHEN M2 > M1 THEN 1 
							 WHEN M2 < M1 THEN 2
							 WHEN M2 = M1 THEN 3  	
						ELSE 0 END)
FROM @ReturnTable T 
	INNER JOIN (SELECT M1.I_Student_Detail_ID
						,M1.I_Exam_Component_ID
						,M1.I_Marks AS M1
						,M2.I_Marks AS M2
					FROM @CheckT1 M1 
					INNER JOIN @CheckT2 M2 ON M2.I_Student_Detail_ID = M1.I_Student_Detail_ID
						AND M2.I_Exam_Component_Id = M1.I_Exam_Component_ID ) M ON M.I_Student_Detail_ID = T.I_Student_Detail_ID
							AND M.I_Exam_Component_ID = T.I_Exam_Component_ID
WHERE T.I_Term_ID = (SELECT I_Term_ID 
					 FROM @Terms 
					 WHERE I_Sequence = 2)



UPDATE T
	SET I_Perm_Level = (CASE WHEN M3 > M2  THEN 1 
							 WHEN M3 < M2  THEN 2
							 WHEN M3 = M2  THEN 3  	
						ELSE 0 END)
FROM @ReturnTable T 
	INNER JOIN (SELECT M2.I_Student_Detail_ID
						,M2.I_Exam_Component_ID
						,M2.I_Marks AS M2
						,M3.I_Marks AS M3
					FROM @CheckT2 M2 
					INNER JOIN @CheckT3 M3 ON M2.I_Student_Detail_ID = M3.I_Student_Detail_ID
						AND M2.I_Exam_Component_Id = M3.I_Exam_Component_ID ) M ON M.I_Student_Detail_ID = T.I_Student_Detail_ID
							AND M.I_Exam_Component_ID = T.I_Exam_Component_ID
WHERE T.I_Term_ID = (SELECT I_Term_ID FROM @Terms WHERE I_Sequence = 3)
	
	DROP TABLE #MarksTemp

	
	
	--Return resultset
	SELECT     t2.I_Student_ID
				,t2.I_Term_ID
				,t2.S_Term_Name
				,t2.I_Exam_Component_ID 
                ,t2.S_Exam_Component_Name
				,t3.I_Marks
				,t3.I_Order
				,t3.B_Sec_Top
				,t3.B_All_Sec_Top
				,t3.I_Perm_Level
				,t2.I_Sequence
				,t2.I_Exam_Component_Sequence
				,REPORT.fnGetStudentGradeDetails(t3.I_Marks) AS S_Grade
	FROM    (SELECT DISTINCT 
                          I_Student_ID
						  ,I_Term_ID
						  ,S_Term_Name
						  ,I_Exam_Component_ID 
                          ,S_Exam_Component_Name
						  ,I_Sequence
						  ,I_Exam_Component_Sequence
                       FROM  @Student) AS t2 
                             INNER JOIN @ReturnTable AS t3 ON t2.I_Student_ID = t3.I_Student_Detail_ID AND t2.I_Term_ID = t3.I_Term_ID AND t2.I_Exam_Component_ID = t3.I_Exam_Component_ID
	WHERE I_Student_ID = @iStudentID
	ORDER BY t2.I_Term_ID
			,t2.I_Exam_Component_ID
			,t3.I_Order
END
