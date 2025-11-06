

--EXEC REPORT.uspStudentWeightageGraphicalForTerm @iBatchId = 783, @iStudentId = 4695,@iTermId =12
--EXEC REPORT.uspStudentWeightageGraphicalForTerm @iBatchId = 1057, @iStudentId = 4400,@iTermId =370
--EXEC REPORT.uspStudentWeightageGraphicalForTerm @iBatchId = 1057, @iStudentId = 4400,@iTermId =371
--EXEC REPORT.uspStudentWeightageGraphicalForTerm @iBatchId = 8058, @iStudentId = 6060, @iTermId =1253

CREATE PROCEDURE [REPORT].[uspStudentWeightageGraphicalForTerm] 
	@iBatchID INT
	,@iStudentID INT
	,@iTermID INT
AS
BEGIN	

	DECLARE @MGWtg AS TABLE (I_Term_ID INT
							,I_ModuleGroup_ID INT
							,N_Weightage INT)

	INSERT INTO @MGWtg(I_Term_ID
					   ,I_ModuleGroup_ID
					   ,N_Weightage)
    SELECT
		N.I_Term_ID
		,N.I_ModuleGroup_ID
		,N.N_Weightage
	FROM (SELECT --Get Module Group wise weightage
			MTM.I_ModuleGroup_ID
			,MTM.I_Term_ID,
			SUM(MTM.N_Weightage) AS N_Weightage
		FROM T_Student_Batch_Master SBM WITH (NOLOCK) 
			INNER JOIN T_Term_Course_Map TCM WITH (NOLOCK) ON TCM.I_Course_ID = SBM.I_Course_ID
			INNER JOIN T_Module_Term_Map MTM WITH (NOLOCK) ON MTM.I_Term_ID = TCM.I_Term_ID
		WHERE SBM.I_Batch_ID = @iBatchID
			AND TCM.I_Status = 1
			AND MTM.I_Status = 1
		GROUP BY MTM.I_ModuleGroup_ID
				,MTM.I_Term_ID) N

  --DECLARE @Modules AS TABLE 
  CREATE TABLE #Modules(I_Module_Group_ID INT
						,S_Module_Group_Name VARCHAR(255)
						,I_Module_ID INT
						,N_Weightage INT
						,I_Sequence INT)

  INSERT INTO #Modules(I_Module_Group_ID
						,S_Module_Group_Name
						,I_Module_ID
						,N_Weightage
						,I_Sequence)
	SELECT
		MTM.I_ModuleGroup_ID
		,MGM.S_ModuleGroup_Name
		,MTM.I_Module_ID
		,MTM.N_Weightage
		,MTM.I_Sequence
	FROM T_Module_Term_Map MTM WITH (NOLOCK) --All Modules Expected to be mapped with some module group
		INNER JOIN T_ModuleGroup_Master MGM WITH (NOLOCK) ON MGM.I_ModuleGroup_ID = MTM.I_ModuleGroup_ID
	WHERE MTM.I_Term_ID = @iTermID
		AND MTM.I_Status = 1
		--AND MTM.N_Weightage > 0
		AND MTM.I_Module_ID IN (SELECT I_Module_ID 
								FROM T_Module_Eval_Strategy MES WITH (NOLOCK) 
								WHERE MES.I_Term_ID = @iTermID
								AND MES.N_Weightage > 0
								AND MES.I_Status = 1)

 DECLARE @ExamComponents AS TABLE (I_Exam_Component_ID INT)

 INSERT INTO @ExamComponents(I_Exam_Component_ID)
 SELECT DISTINCT MES.I_Exam_Component_ID 
		FROM #Modules MTM
			INNER JOIN T_Module_Eval_Strategy MES WITH (NOLOCK) ON MES.I_Term_ID = @iTermID 
				AND MES.I_Module_ID = MTM.I_Module_ID
			AND MES.N_Weightage > 0
			AND MES.I_Status = 1

  DECLARE @iCourseID INT
  SET @iCourseID = (SELECT I_Course_ID 
					FROM T_Student_Batch_Master AS tsbm WITH (NOLOCK) 
					WHERE I_Batch_ID = @iBatchID)


   DECLARE @Student AS TABLE(I_Student_ID INT
							,I_Course_ID INT 
							,I_Module_ID INT
							,S_Module_Name VARCHAR(250)
							,I_Exam_Component_ID INT
							,S_Exam_Component_Name VARCHAR(200)
							,I_Batch_Exam_ID INT
							,I_Sequence INT
							,I_Exam_Component_Sequence INT
							,I_Type INT)

   INSERT INTO @Student(I_Student_ID
						,I_Course_ID
						,I_Module_ID
						,S_Module_Name
						,I_Exam_Component_ID
						,S_Exam_Component_Name
						,I_Batch_Exam_ID
						,I_Sequence
						,I_Exam_Component_Sequence
						,I_Type)
	SELECT DISTINCT
		TSBD.I_Student_ID
		,TSBM.I_Course_ID  
		,(CASE WHEN MTM.I_Module_Group_ID IS NOT NULL THEN MTM.I_Module_Group_ID ELSE BEM.I_Module_ID END) 
		,(CASE WHEN MTM.I_Module_Group_ID IS NOT NULL THEN MTM.S_Module_Group_Name COLLATE DATABASE_DEFAULT ELSE ISNULL(MM.S_Display_Name, MM.S_Module_Name) END)
			+ ' (' + CONVERT(VARCHAR(5),(SELECT TOP 1 MG.N_Weightage AS N_Weightage 
							FROM @MGWtg MG
								WHERE MG.I_ModuleGroup_ID = MTM.I_Module_Group_ID
									AND MG.I_Term_ID = BEM.I_Term_ID)) + ')'
		,ECM.I_Exam_Component_ID
		,ECM.S_Component_Name
		,(CASE WHEN MTM.I_Module_Group_ID IS NOT NULL THEN MTM.I_Module_Group_ID ELSE BEM.I_Batch_Exam_ID END) 
		,(CASE WHEN MTM.I_Module_Group_ID IS NOT NULL THEN NULL ELSE MTM.I_Sequence END)
		,ECM.I_Sequence_No
		,(CASE WHEN MTM.I_Module_Group_ID IS NOT NULL THEN 2 ELSE 1 END)
	FROM EXAMINATION.T_Batch_Exam_Map BEM WITH (NOLOCK)
		INNER JOIN T_Exam_Component_Master ECM WITH (NOLOCK) ON ECM.I_Exam_Component_ID = BEM.I_Exam_Component_ID
		INNER JOIN dbo.T_Student_Batch_Details TSBD WITH (NOLOCK) ON TSBD.I_Batch_ID = BEM.I_Batch_ID
		INNER JOIN dbo.T_Student_Batch_Master AS TSBM WITH (NOLOCK) ON TSBM.I_Batch_ID = TSBD.I_Batch_ID
		--INNER JOIN T_Course_Master TCM WITH (NOLOCK) ON TCM.I_Course_ID = TSBM.I_Course_ID
		INNER JOIN T_Module_Master MM WITH (NOLOCK) ON MM.I_Module_ID = BEM.I_Module_ID
		INNER JOIN #Modules MTM ON MTM.I_Module_ID = MM.I_Module_ID AND MTM.I_Module_ID = BEM.I_Module_ID		
		INNER JOIN @ExamComponents MES ON MES.I_Exam_Component_ID = ECM.I_Exam_Component_ID
			
	WHERE BEM.I_Batch_ID= @iBatchID
		AND TSBD.I_Student_ID = @iStudentID
		AND TSBD.I_Status IN (1, 2 ) 
		--AND MTM.I_Status = 1		
		AND BEM.I_Term_ID = @iTermID
		AND ISNULL(ECM.B_Exclude_In_Report,0) = 0
		AND BEM.I_Status != 0

	UNION 
	SELECT DISTINCT
		TSBD.I_Student_ID
		,TSBM.I_Course_ID
		,0
		,'Total (' + CONVERT(VARCHAR(5),(SELECT SUM(N_Weightage) FROM #Modules)) + ')'
		,ECM.I_Exam_Component_ID
		,ECM.S_Component_Name
		,0
		,100 --Hard Coded/sequence
		,ECM.I_Sequence_No
		,3
	FROM EXAMINATION.T_Batch_Exam_Map  BEM WITH (NOLOCK)
		INNER JOIN T_Exam_Component_Master ECM WITH (NOLOCK) ON ECM.I_Exam_Component_ID = BEM.I_Exam_Component_ID
		INNER JOIN dbo.T_Student_Batch_Details TSBD WITH (NOLOCK) ON TSBD.I_Batch_ID = BEM.I_Batch_ID
		INNER JOIN dbo.T_Student_Batch_Master AS TSBM WITH (NOLOCK)  ON TSBM.I_Batch_ID = TSBD.I_Batch_ID
		INNER JOIN @ExamComponents MES ON MES.I_Exam_Component_ID = BEM.I_Exam_Component_ID
			
	WHERE BEM.I_Batch_ID = @iBatchID
		AND TSBD.I_Student_ID = @iStudentID
		AND TSBD.I_Status IN (1, 2)
		AND BEM.I_Term_ID = @iTermID
	    AND ISNULL(ECM.B_Exclude_In_Report,0) = 0
	    AND BEM.I_Status != 0
   

	--Script 3
	DECLARE @bSecTop BIT = 0
	DECLARE @bAllSecTop BIT = 0

	DECLARE @Order AS TABLE(I_Order INT)

	INSERT INTO @Order(I_Order)
	VALUES(1),(2),(3),(4),(5)


	DECLARE @ReturnTable AS TABLE (I_Student_Detail_ID INT
						,I_Batch_Exam_ID INT
						,I_Term_Id INT
						,I_Module_ID INT
						,I_Exam_Component_ID INT
						,I_Marks NUMERIC(8,2)
						,I_Marks_Per NUMERIC(8,2)
						,I_Order INT
						,B_Sec_Top INT
						,B_All_Sec_Top INT
						,I_Perm_Level INT --1Up,2Down,3Same
						,I_Type INT) 

	INSERT INTO @ReturnTable(I_Student_Detail_ID
							,I_Batch_Exam_ID
							,I_Term_Id
							,I_Module_ID
							,I_Exam_Component_ID
							,I_Marks
							,I_Order
							,B_Sec_Top
							,B_All_Sec_Top
							,I_Type)
	SELECT DISTINCT	    
		SM.I_Student_Detail_ID,
		(CASE WHEN MTM.I_Module_Group_Id IS NOT NULL THEN MTM.I_Module_Group_Id ELSE BEM.I_Batch_Exam_ID END),
		BEM.I_Term_Id,
		(CASE WHEN MTM.I_Module_Group_Id IS NOT NULL THEN MTM.I_Module_Group_Id ELSE BEM.I_Module_ID END),
		BEM.I_Exam_Component_ID ,
		NULL AS I_Marks,
		O.I_Order, 
		0 AS B_Sec_Top, 
		0 AS B_All_Sec_Top,
		(CASE WHEN MTM.I_Module_Group_Id IS NOT NULL THEN 2 ELSE 1 END)
	FROM EXAMINATION.T_Student_Marks SM WITH (NOLOCK)
		INNER JOIN EXAMINATION.T_Batch_Exam_Map BEM WITH (NOLOCK) ON SM.I_Batch_Exam_ID = BEM.I_Batch_Exam_ID
		INNER JOIN #Modules MTM ON MTM.I_Module_ID = BEM.I_Module_ID
		CROSS JOIN @Order O
	WHERE BEM.I_Batch_ID = @iBatchID
		AND SM.I_Student_Detail_ID = @iStudentID
		AND BEM.I_Status != 0	
	UNION
	SELECT DISTINCT	    
		SM.I_Student_Detail_ID,
		0,
		0 AS I_Term_Id,
		0 AS I_Module_ID,
		BEM.I_Exam_Component_ID ,
		NULL AS I_Marks,
		O.I_Order, 
		0 AS B_Sec_Top, 
		0 AS B_All_Sec_Top,
		3
	FROM EXAMINATION.T_Student_Marks SM WITH (NOLOCK)
		INNER JOIN EXAMINATION.T_Batch_Exam_Map BEM WITH (NOLOCK) ON SM.I_Batch_Exam_ID = BEM.I_Batch_Exam_ID
		INNER JOIN #Modules MTM ON MTM.I_Module_ID = BEM.I_Module_ID
		CROSS JOIN @Order O
	WHERE BEM.I_Batch_ID = @iBatchID
		AND SM.I_Student_Detail_ID = @iStudentID
		AND BEM.I_Status != 0

    --SELECT * FROM @ReturnTable

	--DECLARE @MarksTemp AS TABLE 
	CREATE TABLE #MarksTemp(I_Student_Detail_ID INT
					,I_Batch_Exam_ID INT
					,I_Batch_ID INT
					,I_Term_ID INT
					,I_Module_ID INT
					,I_Exam_Component_ID INT
					,I_Exam_Total NUMERIC(8,2))

   INSERT INTO #MarksTemp(I_Student_Detail_ID
						 ,I_Batch_Exam_ID
                         ,I_Batch_ID
						 ,I_Term_ID
						 ,I_Module_ID
						 ,I_Exam_Component_ID
						 ,I_Exam_Total)
	SELECT SM.I_Student_Detail_ID
			,BEM.I_Batch_Exam_ID
			,BEM.I_Batch_ID
			,BEM.I_Term_ID
			,BEM.I_Module_ID
			,BEM.I_Exam_Component_ID
			,ROUND(SM.I_Exam_Total,0)
				FROM T_Student_Batch_Master SBM WITH (NOLOCK) 
				     INNER JOIN EXAMINATION.T_Batch_Exam_Map BEM WITH (NOLOCK) ON SBM.I_Batch_ID = BEM.I_Batch_ID AND SBM.I_Course_ID = @iCourseID 
				     INNER JOIN EXAMINATION.T_Student_Marks SM WITH (NOLOCK) ON	SM.I_Batch_Exam_ID = BEM.I_Batch_Exam_ID
					 INNER JOIN #Modules MTM ON MTM.I_Module_ID = BEM.I_Module_ID												  
				 WHERE BEM.I_Term_ID = @iTermID
				 AND BEM.I_Status != 0

	--DECLARE @MMWTTemp AS TABLE 
	CREATE TABLE #MMWTTemp(I_Term_ID INT
							,I_Module_ID INT
							,I_Exam_Component_ID INT								
							,I_TotMarks NUMERIC(8,2)
							,N_Weightage NUMERIC(8,2))

    INSERT INTO #MMWTTemp(I_Term_ID
						  ,I_Module_ID 
						  ,I_Exam_Component_ID
						  ,I_TotMarks
						  ,N_Weightage)
	SELECT 
		MTM.I_Term_ID
		,MTM.I_Module_ID
		,I_Exam_Component_ID
		,MES.I_TotMarks
		,MES.N_Weightage
	FROM T_Module_Term_Map MTM WITH (NOLOCK)
		INNER JOIN T_Module_Eval_Strategy MES WITH (NOLOCK) ON MES.I_Module_ID = MTM.I_Module_ID 
		AND MES.I_Term_ID = MTM.I_Term_ID
		
	WHERE MTM.I_Status = 1
		  AND MES.I_Status = 1
		  AND MTM.I_Term_ID = @iTermID
		  AND MES.I_Course_ID = @iCourseID 
    
	/*
	DELETE T 
	 FROM @ReturnTable T
	 INNER JOIN #MMWTTemp M ON M.I_Module_ID = T.I_Module_ID
				AND M.I_Exam_Component_Id = T.I_Exam_Component_ID
				AND N_Weightage =0*/

	--SELECT * FROM @MMWTTemp

	--Performance Level Not Required for Weightage/Term breakup
	/*UPDATE T
	  SET I_Marks = (SELECT SUM(ROUND(I_Exam_Total ,0))
				FROM /*EXAMINATION.T_Student_Marks SM WITH (NOLOCK)
					INNER JOIN EXAMINATION.T_Batch_Exam_Map BEM WITH (NOLOCK) ON SM.I_Batch_Exam_ID = BEM.I_Batch_Exam_ID*/
					#MarksTemp SM
				WHERE SM.I_Student_Detail_ID = T.I_Student_Detail_ID
					AND SM.I_Batch_Exam_ID = T.I_Batch_Exam_ID)
	FROM @ReturnTable T
		WHERE I_Order = 3
			AND T.I_Module_ID != 0
			AND T.I_Type = 1

	UPDATE T
	  SET I_Marks_Per = (SELECT (CAST(I_Marks AS NUMERIC(8,2))/SUM(MES.I_TotMarks))*100
				FROM T_Module_Eval_Strategy MES WITH (NOLOCK)  
					WHERE MES.I_Course_ID = @iCourseID 
					AND MES.I_Exam_Component_ID = T.I_Exam_Component_ID
					AND MES.I_Term_ID = T.I_Term_ID
					AND MES.I_Module_ID = T.I_Module_ID
					AND MES.I_Status = 1)
	FROM @ReturnTable T
		WHERE I_Order = 3
			AND T.I_Module_ID != 0
			AND T.I_Type = 1*/

	UPDATE T
	  SET I_Marks = (SELECT ROUND(SUM((I_Exam_Total/I_TotMarks)*MT.N_Weightage) ,0)
				FROM #MarksTemp SM
					INNER JOIN #Modules MTM ON  MTM.I_Module_ID = SM.I_Module_ID
					INNER JOIN  #MMWTTemp MT  
							ON MT.I_Term_ID = SM.I_Term_ID
							AND MT.I_Module_ID = SM.I_Module_ID
							AND MT.I_Exam_Component_ID = SM.I_Exam_Component_ID
				WHERE SM.I_Student_Detail_ID = T.I_Student_Detail_ID
					AND SM.I_Batch_ID = @iBatchID
					AND SM.I_Term_ID = @iTermID
					AND SM.I_Exam_Component_ID = T.I_Exam_Component_ID)
	FROM @ReturnTable T
		WHERE I_Order = 3
			AND T.I_Module_ID = 0



	-----
	
	UPDATE T
	  SET I_Marks = (SELECT ROUND(SUM((I_Exam_Total/I_TotMarks)*N_Weightage ),0)
				FROM #MarksTemp SM
					INNER JOIN  #MMWTTemp MTM  
							ON MTM.I_Term_ID = SM.I_Term_ID
							AND MTM.I_Module_ID = SM.I_Module_ID
							AND MTM.I_Exam_Component_ID = SM.I_Exam_Component_ID
				WHERE SM.I_Student_Detail_ID = T.I_Student_Detail_ID
					AND SM.I_Batch_Exam_ID = T.I_Batch_Exam_ID
					AND SM.I_Exam_Component_ID = T.I_Exam_Component_ID)
	FROM @ReturnTable T
		WHERE I_Order = 3
			AND T.I_Module_ID != 0
	        AND T.I_Type = 1

	UPDATE T
	  SET I_Marks = (SELECT ROUND(SUM((I_Exam_Total/I_TotMarks)*MTM.N_Weightage) ,0)
				FROM #MarksTemp SM
					INNER JOIN  #MMWTTemp MTM  
							ON MTM.I_Term_ID = SM.I_Term_ID
							AND MTM.I_Module_ID = SM.I_Module_ID
							AND MTM.I_Exam_Component_ID = SM.I_Exam_Component_ID
					INNER JOIN #Modules M ON M.I_Module_Group_Id = T.I_Batch_Exam_ID AND M.I_Module_Id = SM.I_Module_ID
				WHERE SM.I_Student_Detail_ID = T.I_Student_Detail_ID
					--AND SM.I_Batch_Exam_ID = T.I_Batch_Exam_ID
					AND SM.I_Exam_Component_ID = T.I_Exam_Component_ID)
	FROM @ReturnTable T
		WHERE I_Order = 3
			AND T.I_Module_ID != 0
	        AND T.I_Type = 2
	

    DECLARE @MaxAvg AS TABLE (I_Batch_ID INT
							  ,I_Term_ID INT
							  ,I_Module_ID INT
							  ,I_Exam_Component_ID INT
							  ,I_MaxValue INT
							  ,I_AvgValue INT
							  ,I_Type INT)
	
	INSERT INTO @MaxAvg(I_Batch_ID
						,I_Term_ID
						,I_Module_ID
						,I_Exam_Component_ID
						,I_MaxValue
						,I_AvgValue
						,I_Type)
	SELECT I_Batch_ID
		  ,I_Term_ID
		  ,I_Module_ID
	      ,I_Exam_Component_ID  
		  ,MAX(Value) AS I_MaxValue
		  ,AVG(Value) AS I_AvgValue
		  ,I_Type
	FROM (SELECT BEM.I_Batch_ID
		  ,BEM.I_Term_ID
		  ,BEM.I_Module_ID
	      ,BEM.I_Exam_Component_ID	
		  ,I_Student_Detail_ID	  
		  ,ROUND(SUM((BEM.I_Exam_Total/I_TotMarks)*MTM.N_Weightage),0) AS Value
		  ,1 AS I_Type
	FROM #MarksTemp BEM
		INNER JOIN  #MMWTTemp MTM  
							ON MTM.I_Term_ID = BEM.I_Term_ID
							AND MTM.I_Module_ID = BEM.I_Module_ID
							AND MTM.I_Exam_Component_ID = BEM.I_Exam_Component_ID
		INNER JOIN #Modules M ON  M.I_Module_ID = BEM.I_Module_ID AND M.I_Module_Group_Id IS NULL
	--WHERE BEM.I_Batch_ID = @iBatchID
	GROUP BY BEM.I_Batch_ID,BEM.I_Term_ID,BEM.I_Module_ID,I_Student_Detail_ID,BEM.I_Exam_Component_ID) T
	GROUP BY I_Batch_ID,I_Term_ID,I_Module_ID,I_Exam_Component_ID,I_Type

	
	INSERT INTO @MaxAvg(I_Batch_ID
						,I_Term_ID
						,I_Module_ID
						,I_Exam_Component_ID
						,I_MaxValue
						,I_AvgValue
						,I_Type)
	SELECT I_Batch_ID
		  ,I_Term_ID
		  ,I_Module_ID
	      ,I_Exam_Component_ID  
		  ,MAX(Value) AS I_MaxValue
		  ,AVG(Value) AS I_AvgValue
		  ,I_Type
	FROM (SELECT BEM.I_Batch_ID
				  ,BEM.I_Term_ID
				  ,M.I_Module_Group_Id AS I_Module_ID
				  ,BEM.I_Exam_Component_ID	
				  ,I_Student_Detail_ID	  
				  ,ROUND(SUM((BEM.I_Exam_Total/I_TotMarks)*MTM.N_Weightage),0) AS Value
				  ,2 AS I_Type
	FROM #MarksTemp BEM
		INNER JOIN  #MMWTTemp MTM  
							ON MTM.I_Term_ID = BEM.I_Term_ID
							AND MTM.I_Module_ID = BEM.I_Module_ID
							AND MTM.I_Exam_Component_ID = BEM.I_Exam_Component_ID
		INNER JOIN #Modules M ON  M.I_Module_ID = BEM.I_Module_ID AND M.I_Module_Group_Id IS NOT NULL
	--WHERE BEM.I_Batch_ID = @iBatchID
	GROUP BY BEM.I_Batch_ID,BEM.I_Term_ID,M.I_Module_Group_Id,I_Student_Detail_ID,BEM.I_Exam_Component_ID) T
	GROUP BY I_Batch_ID,I_Term_ID,I_Module_ID,I_Exam_Component_ID,I_Type
	
	

	INSERT INTO @MaxAvg(I_Batch_ID
						,I_Term_ID
						,I_Module_ID
						,I_Exam_Component_ID
						,I_MaxValue
						,I_AvgValue
						,I_Type)
	SELECT I_Batch_ID
		  ,I_Term_ID
		  ,0
	      ,I_Exam_Component_ID  
		  ,MAX(Value) AS I_MaxValue
		  ,AVG(Value) AS I_AvgValue
		  ,3 AS I_Type
	FROM (SELECT BEM.I_Batch_ID
		  ,BEM.I_Term_ID
	      ,BEM.I_Exam_Component_ID	
		  ,BEM.I_Student_Detail_ID	  
		  ,ROUND(SUM((BEM.I_Exam_Total/I_TotMarks)*MTM.N_Weightage),0) AS Value
	FROM #MarksTemp BEM
		INNER JOIN  #MMWTTemp MTM  
							ON MTM.I_Term_ID = BEM.I_Term_ID
							AND MTM.I_Module_ID = BEM.I_Module_ID
							AND MTM.I_Exam_Component_ID = BEM.I_Exam_Component_ID
		INNER JOIN #Modules M ON  M.I_Module_ID = BEM.I_Module_ID
		WHERE BEM.I_Term_ID = @iTermId
	GROUP BY BEM.I_Batch_ID,BEM.I_Term_ID,I_Student_Detail_ID,BEM.I_Exam_Component_ID) T
	GROUP BY I_Batch_Id,I_Term_ID,I_Exam_Component_ID
	
		
    --Sec avg
    UPDATE T
		SET I_Marks =   I.Value
	FROM @ReturnTable T
		INNER JOIN (SELECT I_Exam_Component_ID
							,I_Module_ID
							,I_AvgValue AS Value
							,I_Type
					FROM @MaxAvg
					WHERE I_Batch_ID = @iBatchID				
					) I ON I.I_Exam_Component_ID = T.I_Exam_Component_ID
					AND I.I_Module_ID =T.I_Module_ID 
					AND I.I_Type =T.I_Type
		WHERE I_Order = 1


     --Sec Max
	 UPDATE T
		SET I_Marks = I.Value
	FROM @ReturnTable T
			INNER JOIN (SELECT I_Exam_Component_ID
								,I_Module_ID
								,I_MaxValue AS Value
								,I_Type
					FROM @MaxAvg
					WHERE I_Batch_Id = @iBatchID					
					) I ON I.I_Exam_Component_ID = T.I_Exam_Component_ID
					AND I.I_Module_ID =T.I_Module_ID 
					AND I.I_Type =T.I_Type
		WHERE I_Order = 2

	
	--All Sec Max
    UPDATE T
		SET I_Marks = (SELECT MAX(I_MaxValue)
						FROM @MaxAvg I
						WHERE I.I_Module_ID = T.I_Module_ID
							AND I.I_Exam_Component_ID = T.I_Exam_Component_ID
							AND I.I_Type =T.I_Type) 
	FROM @ReturnTable T
		WHERE I_Order = 4


	--All Sec Avg
	 UPDATE T
		SET I_Marks = (SELECT AVG(I_AvgValue)
						FROM @MaxAvg I
						WHERE I.I_Module_ID = T.I_Module_ID
							AND I.I_Exam_Component_ID = T.I_Exam_Component_ID
							AND I.I_Type =T.I_Type) 
	FROM @ReturnTable T
		WHERE I_Order = 5
		
	 ------------------------------------------

	 
--Update sec max flag
DECLARE @Max AS TABLE (I_Module_ID INT
						,I_Exam_Component_ID INT
						,I_Marks NUMERIC(8,2)
						,I_Type INT) 

INSERT INTO @Max(I_Module_ID
				,I_Exam_Component_ID
				,I_Type
				,I_Marks)
SELECT I_Module_ID
		,I_Exam_Component_ID
		,I_Type
		,MAX(I_Marks)
FROM @ReturnTable
WHERE I_Order= 2
GROUP BY I_Module_ID
		,I_Exam_Component_ID
		,I_Type

UPDATE T
	SET B_Sec_Top = (CASE WHEN M.I_Marks = (SELECT I_Marks FROM @ReturnTable
									WHERE I_Module_ID = T.I_Module_ID
									AND I_Exam_Component_ID = T.I_Exam_Component_ID
									AND I_Student_Detail_ID = T.I_Student_Detail_ID
									AND I_Order=3
									AND I_Type = T.I_Type) THEN 1 ELSE 0 END)
FROM @ReturnTable T 
	INNER JOIN @Max M ON M.I_Module_ID = T.I_Module_ID
			AND M.I_Exam_Component_ID = T.I_Exam_Component_ID 
			AND M.I_Type = T.I_Type

--Update all sec max flag
DELETE FROM @Max
INSERT INTO @Max(I_Module_ID
				,I_Exam_Component_ID
				,I_Type
				,I_Marks)
SELECT I_Module_ID
		,I_Exam_Component_ID
		,I_Type
		,MAX(I_Marks)
FROM @ReturnTable
WHERE I_Order= 4
GROUP BY I_Module_ID
		,I_Exam_Component_ID
		,I_Type

UPDATE T
	SET B_All_Sec_Top = (CASE WHEN M.I_Marks = (SELECT I_Marks FROM @ReturnTable
									WHERE I_Module_ID = T.I_Module_ID
									AND I_Exam_Component_ID = T.I_Exam_Component_ID
									AND I_Student_Detail_ID = T.I_Student_Detail_ID
									AND I_Order=3
									AND I_Type = T.I_Type) THEN 1 ELSE 0 END)
FROM @ReturnTable T 
	INNER JOIN @Max M ON M.I_Module_ID = T.I_Module_ID
			AND M.I_Exam_Component_Id = T.I_Exam_Component_ID 
			AND M.I_Type = T.I_Type
			
	/**/

--PERFORMANCE LEVEL
/*

--Performance Level Commented in Case of Weightage Wise as, it is based on ModuleGroups

DECLARE @CheckT1 AS TABLE (I_Student_Detail_ID INT ,I_Exam_Component_ID INT,I_Marks NUMERIC(8,2)) 
DECLARE @CheckT2 AS TABLE (I_Student_Detail_ID INT ,I_Exam_Component_ID INT,I_Marks NUMERIC(8,2)) 
DECLARE @CheckT3 AS TABLE (I_Student_Detail_ID INT ,I_Exam_Component_ID INT,I_Marks NUMERIC(8,2)) 
DECLARE @CheckT4 AS TABLE (I_Student_Detail_ID INT ,I_Exam_Component_ID INT,I_Marks NUMERIC(8,2)) 

INSERT INTO @CheckT1(I_Student_Detail_ID
				,I_Exam_Component_ID
				,I_Marks)
SELECT  I_Student_Detail_ID
		,I_Exam_Component_ID
		,I_Marks_Per
FROM @ReturnTable
WHERE I_Order= 3
	AND I_Module_ID = (SELECT I_Module_ID FROM #Modules WHERE I_Sequence = 1)

INSERT INTO @CheckT2(I_Student_Detail_ID
				,I_Exam_Component_ID
				,I_Marks)
SELECT  I_Student_Detail_ID
		,I_Exam_Component_ID
		,I_Marks_Per
FROM @ReturnTable
WHERE I_Order= 3
	AND I_Module_ID = (SELECT I_Module_ID FROM #Modules WHERE I_Sequence = 2)

INSERT INTO @CheckT3(I_Student_Detail_ID
				,I_Exam_Component_ID
				,I_Marks)
SELECT  I_Student_Detail_ID
		,I_Exam_Component_ID
		,I_Marks_Per
FROM @ReturnTable
WHERE I_Order= 3
	AND I_Module_ID = (SELECT I_Module_ID FROM #Modules WHERE I_Sequence = 3)


INSERT INTO @CheckT4(I_Student_Detail_ID
				,I_Exam_Component_ID
				,I_Marks)
SELECT  I_Student_Detail_ID
		,I_Exam_Component_ID
		,I_Marks_Per
FROM @ReturnTable
WHERE I_Order= 3
	AND I_Module_ID = (SELECT I_Module_ID FROM #Modules WHERE I_Sequence = 4)


UPDATE T
	SET I_Perm_Level = (CASE WHEN M2 > M1  THEN 1 
							 WHEN M2 < M1  THEN 2
							 WHEN M2 = M1  THEN 3  	
						ELSE 0 END)
FROM @ReturnTable T 
	INNER JOIN (SELECT M1.I_Student_Detail_ID,M1.I_Exam_Component_ID , M1.I_Marks as M1,M2.I_Marks as M2
					FROM @CheckT1 M1 
					INNER JOIN @CheckT2 M2 ON M2.I_Student_Detail_ID = M1.I_Student_Detail_ID
						AND M2.I_Exam_Component_Id = M1.I_Exam_Component_ID ) M ON M.I_Student_Detail_ID = T.I_Student_Detail_ID
							AND M.I_Exam_Component_ID = T.I_Exam_Component_ID
WHERE T.I_Module_ID = (SELECT I_Module_ID FROM #Modules WHERE I_Sequence = 2)



UPDATE T
	SET I_Perm_Level = (CASE WHEN M3 > M2  THEN 1 
							 WHEN M3 < M2  THEN 2
							 WHEN M3 = M2  THEN 3  	
						ELSE 0 END)
FROM @ReturnTable T 
	INNER JOIN (SELECT M2.I_Student_Detail_ID,M2.I_Exam_Component_ID , M2.I_Marks as M2,M3.I_Marks as M3
					FROM @CheckT2 M2 
					INNER JOIN @CheckT3 M3 ON M2.I_Student_Detail_ID = M3.I_Student_Detail_ID
						AND M2.I_Exam_Component_Id = M3.I_Exam_Component_ID ) M ON M.I_Student_Detail_ID = T.I_Student_Detail_ID
							AND M.I_Exam_Component_ID = T.I_Exam_Component_ID
WHERE T.I_Module_ID = (SELECT I_Module_ID FROM #Modules WHERE I_Sequence = 3)


UPDATE T
	SET I_Perm_Level = (CASE WHEN M4 > M3  THEN 1 
							 WHEN M4 < M3  THEN 2
							 WHEN M4 = M3  THEN 3  	
						ELSE 0 END)
FROM @ReturnTable T 
	INNER JOIN (SELECT M3.I_Student_Detail_ID,M3.I_Exam_Component_ID , M3.I_Marks as M3,M4.I_Marks as M4
					FROM @CheckT3 M3 
					INNER JOIN @CheckT4 M4 ON M3.I_Student_Detail_ID = M3.I_Student_Detail_ID
						AND M3.I_Exam_Component_Id = M3.I_Exam_Component_ID ) M ON M.I_Student_Detail_ID = T.I_Student_Detail_ID
							AND M.I_Exam_Component_ID = T.I_Exam_Component_ID
WHERE T.I_Module_ID = (SELECT I_Module_ID FROM #Modules WHERE I_Sequence = 4)
*/	
	

	--Return resultset

	UPDATE T 
		SET T.I_Marks = NULL
			,B_Sec_Top = NULL
			,B_All_Sec_Top = NULL
	 FROM @ReturnTable T
	 INNER JOIN #MMWTTemp M ON M.I_Module_ID = T.I_Module_ID
				AND M.I_Exam_Component_Id = T.I_Exam_Component_ID
				AND M.N_Weightage = 0



	SELECT     t2.I_Student_ID
				,t2.I_Module_ID AS I_Term_ID
				,t2.S_Module_Name  AS S_Term_Name
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
						  ,I_Module_ID
						  ,S_Module_Name
						  ,I_Exam_Component_ID, 
                          S_Exam_Component_Name
						  ,I_Sequence
						  ,I_Exam_Component_Sequence
						  ,I_Type
                       FROM  @Student) AS t2 
                             INNER JOIN @ReturnTable AS t3 ON t2.I_Student_ID = t3.I_Student_Detail_ID AND t2.I_Module_ID = t3.I_Module_ID AND t2.I_Exam_Component_ID = t3.I_Exam_Component_ID AND t2.I_Type = t3.I_Type
			WHERE I_Student_ID = @iStudentID
			UNION 
			SELECT @iStudentId,MTM.I_Module_ID 
					,MM.S_Module_Name + ' (' + CONVERT(VARCHAR(5),(SELECT SUM(N_Weightage) AS N_Weightage 
									FROM #Modules 
							WHERE I_Module_ID = MTM.I_Module_ID)) + ')'
					,EC.I_Exam_Component_ID
					,EC.S_Exam_Component_Name
					,NULL AS I_Marks
					,O.I_Order AS I_Order
					,0 AS B_Sec_Top
					,0 AS B_All_Sec_Top
					,NULL AS I_Perm_Level
					,MTM.I_Sequence AS I_Sequence
					,S.I_Exam_Component_Sequence
					,NULL AS S_Grade
				FROM T_Module_Term_Map MTM WITH (NOLOCK)
			CROSS JOIN (SELECT DISTINCT I_Exam_Component_ID
										,S_Exam_Component_Name FROM @Student) EC
			LEFT JOIN (SELECT DISTINCT 
						I_Student_ID
						,I_Module_ID 
						,S_Module_Name  
						,I_Exam_Component_ID, 
						S_Exam_Component_Name
						,I_Exam_Component_Sequence
					FROM  @Student) S  ON MTM.I_Module_ID = S.I_Module_ID AND S.I_Exam_Component_ID = EC.I_Exam_Component_ID
			INNER JOIN T_Module_master MM WITH (NOLOCK) ON MM.I_Module_ID = MTM.I_Module_ID
			CROSS JOIN @Order O
			WHERE S.I_Exam_Component_ID IS NULL
				AND MTM.I_Term_ID = @iTermID
				AND MTM.I_Status = 1
				AND MTM.I_ModuleGroup_Id IS NULL
				AND MTM.N_Weightage > 0
			UNION 
			SELECT DISTINCT @iStudentId,MTM.I_ModuleGroup_ID 
					,MM.S_ModuleGroup_Name + ' (' + CONVERT(VARCHAR(5),(SELECT SUM(N_Weightage) AS N_Weightage 
									FROM #Modules 
							WHERE I_Module_Group_Id = MTM.I_ModuleGroup_ID)) + ')' 
				    ,EC.I_Exam_Component_ID
					,EC.S_Exam_Component_Name
				    ,NULL AS I_Marks
					,O.I_Order AS I_Order
					,0 AS B_Sec_Top
					,0 AS B_All_Sec_Top
					,NULL AS I_Perm_Level
					,MTM.I_Sequence AS I_Sequence
					,S.I_Exam_Component_Sequence
				   ,NULL AS S_Grade
			FROM T_Module_Term_Map MTM WITH (NOLOCK)
			CROSS JOIN (SELECT DISTINCT I_Exam_Component_ID
								,S_Exam_Component_Name 
							FROM @Student) EC
			LEFT JOIN (SELECT DISTINCT 
						I_Student_ID
						,I_Module_ID
						,S_Module_Name
						,I_Exam_Component_ID, 
						S_Exam_Component_Name
						,I_Exam_Component_Sequence
					FROM  @Student) S  ON MTM.I_Module_ID = S.I_Module_ID AND S.I_Exam_Component_ID = EC.I_Exam_Component_ID
			INNER JOIN T_ModuleGroup_Master MM  WITH (NOLOCK) ON MM.I_ModuleGroup_ID = MTM.I_ModuleGroup_ID
			CROSS JOIN @Order O
			WHERE S.I_Exam_Component_ID IS NULL
				AND MTM.I_Term_ID = @iTermID
				AND MTM.I_Status = 1
				AND MTM.I_ModuleGroup_Id IS NOT NULL
				AND MTM.N_Weightage > 0

	ORDER BY t2.I_Sequence,t2.I_Module_ID,t2.I_Exam_Component_ID,t3.I_Order
END
