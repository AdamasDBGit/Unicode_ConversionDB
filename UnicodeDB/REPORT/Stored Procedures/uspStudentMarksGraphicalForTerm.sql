--EXEC REPORT.uspStudentMarksGraphicalForTerm @iBatchId = 783, @iStudentId = 4695,@iTermId =12
CREATE  PROCEDURE [REPORT].[uspStudentMarksGraphicalForTerm] 
	@iBatchID INT
	,@iStudentID INT
	,@iTermID INT
AS
BEGIN	

  --DECLARE @Terms AS TABLE (I_Term_ID INT,I_Sequence INT)

  DECLARE @iCourseID INT
  SET @iCourseID = (SELECT TOP 1 I_Course_ID FROM T_Student_Batch_Master AS tsbm WITH (NOLOCK) WHERE I_Batch_ID = @iBatchID)


   DECLARE @Student AS TABLE(I_Student_ID INT
							,I_Course_ID INT 
							,I_Module_ID INT
							,S_Module_Name VARCHAR(250)
							,I_Exam_Component_ID INT
							,S_Exam_Component_Name VARCHAR(200)
							,I_Batch_Exam_ID INT
							,I_Sequence INT)

   INSERT INTO @Student(I_Student_ID
						,I_Course_ID
						,I_Module_ID
						,S_Module_Name
						,I_Exam_Component_ID
						,S_Exam_Component_Name
						,I_Batch_Exam_ID
						,I_Sequence)
	SELECT DISTINCT
		TSBD.I_Student_ID
		,TSBM.I_Course_ID
		,BEM.I_Module_ID
		,MM.S_Module_Name
		,ECM.I_Exam_Component_ID
		,ECM.S_Component_Name
		,BEM.I_Batch_Exam_ID
		,MTM.I_Sequence
	FROM EXAMINATION.T_Batch_Exam_Map  BEM WITH (NOLOCK)
		INNER JOIN T_Exam_Component_Master ECM WITH (NOLOCK) ON ECM.I_Exam_Component_ID = BEM.I_Exam_Component_ID
		INNER JOIN dbo.T_Student_Batch_Details TSBD WITH (NOLOCK) ON TSBD.I_Batch_ID = BEM.I_Batch_ID
		INNER JOIN dbo.T_Student_Batch_Master AS TSBM WITH (NOLOCK)  ON TSBM.I_Batch_ID = TSBD.I_Batch_ID
		--INNER JOIN T_Course_Master TCM WITH (NOLOCK) ON TCM.I_Course_ID = TSBM.I_Course_ID
		INNER JOIN T_Module_Master MM  WITH (NOLOCK) ON MM.I_Module_ID = BEM.I_Module_ID
		INNER JOIN T_Module_Term_Map MTM WITH (NOLOCK) ON MTM.I_Module_ID = MM.I_Module_ID AND MTM.I_Module_ID = BEM.I_Module_ID
			
	WHERE BEM.I_Batch_ID= @iBatchID
		AND TSBD.I_Student_ID = @iStudentID
		AND TSBD.I_Status IN (1, 2 ) 
		AND MTM.I_Status = 1
		AND BEM.I_Term_ID = @iTermID
	UNION 
	SELECT DISTINCT
		TSBD.I_Student_ID
		,TSBM.I_Course_ID
		,0
		,'Total'
		,ECM.I_Exam_Component_ID
		,ECM.S_Component_Name
		,0
		,10 --Hard Coded
	FROM EXAMINATION.T_Batch_Exam_Map  BEM WITH (NOLOCK)
		INNER JOIN T_Exam_Component_Master ECM WITH (NOLOCK) ON ECM.I_Exam_Component_ID = BEM.I_Exam_Component_ID
		INNER JOIN dbo.T_Student_Batch_Details TSBD WITH (NOLOCK) ON TSBD.I_Batch_ID = BEM.I_Batch_ID
		INNER JOIN dbo.T_Student_Batch_Master AS TSBM WITH (NOLOCK)  ON TSBM.I_Batch_ID = TSBD.I_Batch_ID
		--INNER JOIN T_Course_Master TCM WITH (NOLOCK) ON TCM.I_Course_ID = TSBM.I_Course_ID
			
	WHERE BEM.I_Batch_ID= @iBatchID
		AND TSBD.I_Student_ID = @iStudentID
		AND TSBD.I_Status IN (1, 2 )
		AND BEM.I_Term_ID = @iTermID

	--Script 3
	DECLARE @bSecTop BIT = 0
	DECLARE @bAllSecTop BIT = 0

	DECLARE @Order AS TABLE(I_Order INT)

	INSERT INTO @Order(I_Order)
	VALUES(1),(2),(3),(4),(5)


	DECLARE @ReturnTable AS TABLE (I_Student_Detail_ID INT
						,I_Batch_Exam_ID INT
						,I_Module_ID INT
						,I_Exam_Component_ID INT
						,I_Marks INT
						,I_Order INT
						,B_Sec_Top BIT
						,B_All_Sec_Top BIT
						,I_Perm_Level INT) --1Up,2Down,3Same

	INSERT INTO @ReturnTable(I_Student_Detail_ID
							,I_Batch_Exam_ID
							,I_Module_ID
							,I_Exam_Component_ID
							,I_Marks
							,I_Order
							,B_Sec_Top
							,B_All_Sec_Top)
	SELECT DISTINCT	    
		SM.I_Student_Detail_ID,
		BEM.I_Batch_Exam_ID,
		BEM.I_Module_ID,
		BEM.I_Exam_Component_ID ,
		NULL AS I_Marks,
		O.I_Order, 
		0 AS B_Sec_Top, 
		0 AS B_All_Sec_Top
	FROM EXAMINATION.T_Student_Marks SM WITH (NOLOCK)
		INNER JOIN EXAMINATION.T_Batch_Exam_Map BEM WITH (NOLOCK) ON SM.I_Batch_Exam_ID = BEM.I_Batch_Exam_ID
		CROSS JOIN @Order O
	WHERE BEM.I_Batch_ID = @iBatchID
		AND SM.I_Student_Detail_ID = @iStudentID	
	UNION
	SELECT DISTINCT	    
		SM.I_Student_Detail_ID,
		0,
		0 AS I_Module_ID,
		BEM.I_Exam_Component_ID ,
		NULL AS I_Marks,
		O.I_Order, 
		0 AS B_Sec_Top, 
		0 AS B_All_Sec_Top
	FROM EXAMINATION.T_Student_Marks SM WITH (NOLOCK)
		INNER JOIN EXAMINATION.T_Batch_Exam_Map BEM WITH (NOLOCK) ON SM.I_Batch_Exam_ID = BEM.I_Batch_Exam_ID
		CROSS JOIN @Order O
	WHERE BEM.I_Batch_ID = @iBatchID
		AND SM.I_Student_Detail_ID = @iStudentID

	

	UPDATE T
	  SET I_Marks = (SELECT SUM(ROUND(I_Exam_Total ,0))
				FROM EXAMINATION.T_Student_Marks SM WITH (NOLOCK)
					INNER JOIN EXAMINATION.T_Batch_Exam_Map BEM WITH (NOLOCK) ON SM.I_Batch_Exam_ID = BEM.I_Batch_Exam_ID
				WHERE SM.I_Student_Detail_ID = T.I_Student_Detail_ID
					AND BEM.I_Batch_Exam_ID = T.I_Batch_Exam_ID
					AND BEM.I_Exam_Component_ID = T.I_Exam_Component_ID)
	FROM @ReturnTable T
		WHERE I_Order =3
			AND T.I_Module_ID !=0

	UPDATE T
	  SET I_Marks = (SELECT SUM(ROUND(I_Exam_Total ,0))
				FROM EXAMINATION.T_Student_Marks SM WITH (NOLOCK)
					INNER JOIN EXAMINATION.T_Batch_Exam_Map BEM WITH (NOLOCK) ON SM.I_Batch_Exam_ID = BEM.I_Batch_Exam_ID
				WHERE SM.I_Student_Detail_ID = T.I_Student_Detail_ID
					AND BEM.I_Batch_ID = @iBatchID
					AND BEM.I_Term_ID = @iTermID
					AND BEM.I_Exam_Component_ID = T.I_Exam_Component_ID)
	FROM @ReturnTable T
		WHERE I_Order =3
			AND T.I_Module_ID =0



    DECLARE @MaxAvg AS TABLE (I_Batch_ID INT, I_Term_ID INT, I_Module_ID INT,I_Exam_Component_ID INT, I_MaxValue INT, I_AvgValue INT)

	INSERT INTO @MaxAvg(I_Batch_ID,I_Term_ID,I_Module_ID,I_Exam_Component_ID,I_MaxValue,I_AvgValue)
	SELECT I_Batch_ID
		  ,I_Term_ID
		  ,I_Module_ID
	      ,I_Exam_Component_ID  
		  ,MAX(Value) AS I_MaxValue
		  ,AVG(Value) AS I_AvgValue
	FROM (SELECT BEM.I_Batch_ID
		  ,I_Term_ID
		  ,I_Module_ID
	      ,I_Exam_Component_ID	
		  ,I_Student_Detail_ID	  
		  ,SUM(ROUND(SM.I_Exam_Total,0)) AS Value
	FROM EXAMINATION.T_Student_Marks SM WITH (NOLOCK)
		INNER JOIN EXAMINATION.T_Batch_Exam_Map BEM WITH (NOLOCK) ON SM.I_Batch_Exam_ID = BEM.I_Batch_Exam_ID
		INNER JOIN T_Student_Batch_Master SBM WITH (NOLOCK)  ON SBM.I_Batch_ID = BEM.I_Batch_ID AND SBM.I_Course_ID = @iCourseID
	--WHERE BEM.I_Batch_ID = @iBatchID
	GROUP BY BEM.I_Batch_ID,I_Term_ID,I_Module_ID,I_Student_Detail_ID,I_Exam_Component_ID) T
	GROUP BY I_Batch_ID,I_Term_ID,I_Module_ID,I_Exam_Component_ID
	

	INSERT INTO @MaxAvg(I_Batch_ID,I_Term_ID,I_Module_ID,I_Exam_Component_ID,I_MaxValue,I_AvgValue)
	SELECT I_Batch_ID
		  ,I_Term_ID
		  ,0
	      ,I_Exam_Component_ID  
		  ,MAX(Value) AS I_MaxValue
		  ,AVG(Value) AS I_AvgValue
	FROM (SELECT BEM.I_Batch_ID
		  ,I_Term_ID
	      ,I_Exam_Component_ID	
		  ,I_Student_Detail_ID	  
		  ,SUM(ROUND(SM.I_Exam_Total,0)) AS Value
	FROM EXAMINATION.T_Student_Marks SM WITH (NOLOCK)
		INNER JOIN EXAMINATION.T_Batch_Exam_Map BEM WITH (NOLOCK) ON SM.I_Batch_Exam_ID = BEM.I_Batch_Exam_ID
		INNER JOIN T_Student_Batch_Master SBM WITH (NOLOCK)  ON SBM.I_Batch_ID = BEM.I_Batch_ID AND SBM.I_Course_ID = @iCourseId
		WHERE BEM.I_Term_ID = @iTermId
	GROUP BY BEM.I_Batch_ID,I_Term_ID,I_Student_Detail_ID,I_Exam_Component_ID) T
	GROUP BY I_Batch_Id,I_Term_ID,I_Exam_Component_ID
	ORDER BY I_Batch_Id,I_Term_ID,I_Exam_Component_ID
	
		
    --Sec avg
    UPDATE T
		SET I_Marks =   I.Value
	FROM @ReturnTable T
		INNER JOIN (SELECT I_Exam_Component_ID,I_Module_ID,I_AvgValue AS Value
					FROM @MaxAvg
					WHERE I_Batch_ID = @iBatchID				
					) I ON I.I_Exam_Component_ID = T.I_Exam_Component_ID
					AND I.I_Module_ID =T.I_Module_ID 
		WHERE I_Order = 1

     --Sec Max
	 UPDATE T
		SET I_Marks = I.Value
	FROM @ReturnTable T
			INNER JOIN (SELECT I_Exam_Component_ID,I_Module_ID,I_MaxValue AS Value
					FROM @MaxAvg
					WHERE I_Batch_Id = @iBatchID					
					) I ON I.I_Exam_Component_ID = T.I_Exam_Component_ID
					AND I.I_Module_ID =T.I_Module_ID 
		WHERE I_Order = 2


		--All Sec Max
   UPDATE T
		SET I_Marks = (SELECT MAX(I_MaxValue)
						FROM @MaxAvg I
						WHERE I.I_Module_ID = T.I_Module_ID
							AND I.I_Exam_Component_ID = T.I_Exam_Component_ID) 
	FROM @ReturnTable T
		WHERE I_Order = 4

		--All Sec Avg
	 UPDATE T
		SET I_Marks = (SELECT AVG(I_AvgValue)
						FROM @MaxAvg I
						WHERE I.I_Module_ID = T.I_Module_ID
							AND I.I_Exam_Component_ID = T.I_Exam_Component_ID) 
	FROM @ReturnTable T
		WHERE I_Order = 5

	--HardCoded 
	 --UPDATE @ReturnTable SET B_Sec_Top = 1	 
	 --UPDATE @ReturnTable SET B_All_Sec_Top = 1
	
	  --UPDATE @ReturnTable SET I_Perm_Level = 0 --1Up,2Down,3Same

	 --SELECT * FROM @ReturnTable

	
	 ------------------------------------------

	 
--Update sec max flag
DECLARE @Max AS TABLE (I_Module_ID INT, I_Exam_Component_ID INT,I_Marks INT) 

INSERT INTO @Max(I_Module_ID
				,I_Exam_Component_ID
				,I_Marks)
SELECT I_Module_ID
		,I_Exam_Component_ID
		,MAX(I_Marks)
FROM @ReturnTable
WHERE I_Order= 2
GROUP BY I_Module_ID
		,I_Exam_Component_ID


UPDATE T
	SET B_Sec_Top = (CASE WHEN M.I_Marks = (SELECT I_Marks FROM @ReturnTable
									WHERE I_Module_ID = T.I_Module_ID
									AND I_Exam_Component_ID = T.I_Exam_Component_ID
									AND I_Student_Detail_ID = T.I_Student_Detail_ID
									AND I_Order=3) THEN 1 ELSE 0 END)
FROM @ReturnTable T 
	INNER JOIN @Max M ON M.I_Module_ID = T.I_Module_ID
			AND M.I_Exam_Component_ID = T.I_Exam_Component_ID 

--Update all sec max flag
DELETE FROM @Max
INSERT INTO @Max(I_Module_ID
				,I_Exam_Component_ID
				,I_Marks)
SELECT I_Module_ID
		,I_Exam_Component_ID
		,MAX(I_Marks)
FROM @ReturnTable
WHERE I_Order= 4
GROUP BY I_Module_ID
		,I_Exam_Component_ID

UPDATE T
	SET B_All_Sec_Top = (CASE WHEN M.I_Marks = (SELECT I_Marks FROM @ReturnTable
									WHERE I_Module_ID = T.I_Module_ID
									AND I_Exam_Component_ID = T.I_Exam_Component_ID
									AND I_Student_Detail_ID = T.I_Student_Detail_ID
									AND I_Order=3) THEN 1 ELSE 0 END)
FROM @ReturnTable T 
	INNER JOIN @Max M ON M.I_Module_ID = T.I_Module_ID
			AND M.I_Exam_Component_Id = T.I_Exam_Component_ID 

--PERFORMANCE LEVEL

	
	

	--Return resultset
	SELECT     t2.I_Student_ID, t2.I_Module_ID AS I_Term_ID, t2.S_Module_Name  AS S_Term_Name, t2.I_Exam_Component_ID, 
                      t2.S_Exam_Component_Name, t3.I_Marks, t3.I_Order, t3.B_Sec_Top, t3.B_All_Sec_Top, t3.I_Perm_Level,t2.I_Sequence
	FROM    (SELECT DISTINCT 
                          I_Student_ID,I_Module_ID ,S_Module_Name, I_Exam_Component_ID, 
                          S_Exam_Component_Name,I_Sequence
                       FROM  @Student) AS t2 
                             INNER JOIN @ReturnTable AS t3 ON t2.I_Student_ID = t3.I_Student_Detail_ID AND t2.I_Module_ID = t3.I_Module_ID AND t2.I_Exam_Component_ID = t3.I_Exam_Component_ID
	WHERE I_Student_ID =@iStudentID
	 AND t2.S_Module_Name NOT LIKE '%ADCHK%'--akash
	UNION 
	SELECT @iStudentId,MTM.I_Module_ID ,MM.S_Module_Name, EC.I_Exam_Component_ID,EC.S_Exam_Component_Name
	,NULL AS I_Marks, O.I_Order AS I_Order, 0 AS B_Sec_Top, 0 AS B_All_Sec_Top, NULL AS I_Perm_Level,MTM.I_Sequence AS I_Sequence
		FROM T_Module_Term_Map MTM WITH (NOLOCK)
	CROSS JOIN (SELECT DISTINCT I_Exam_Component_ID,S_Exam_Component_Name FROM @Student) EC
	LEFT JOIN (SELECT DISTINCT 
                I_Student_ID,I_Module_ID ,S_Module_Name, I_Exam_Component_ID, 
                S_Exam_Component_Name
            FROM  @Student) S  ON MTM.I_Module_ID = S.I_Module_ID AND S.I_Exam_Component_ID = EC.I_Exam_Component_ID
	INNER JOIN T_Module_master MM  WITH (NOLOCK) ON MM.I_Module_ID = MTM.I_Module_ID
	CROSS JOIN @Order O
	WHERE S.I_Exam_Component_ID IS NULL
		AND MTM.I_Term_ID = @iTermID
		AND MTM.I_Status =1
		AND MM.S_Module_Name NOT LIKE '%ADCHK%'--akash

	ORDER BY t2.I_Sequence,t2.I_Module_ID,t2.I_Exam_Component_ID,t3.I_Order
END
