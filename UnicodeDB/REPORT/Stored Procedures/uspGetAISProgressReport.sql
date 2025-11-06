CREATE PROCEDURE [REPORT].[uspGetAISProgressReport]
    (
      @iStudentID INT ,
      @iCourseID INT ,
      @iTermID INT
    )
AS 
    BEGIN
        DECLARE @sStudentName VARCHAR(250), @sStudentID VARCHAR(250)
		
        SELECT TOP 1
                @sStudentName = S_First_Name + ' ' + ISNULL(S_Middle_Name, '')
                + ' ' + S_Last_Name,
                @sStudentID = S_Student_ID
        FROM    dbo.T_Student_Detail AS tsd
        WHERE   I_Student_Detail_ID = @iStudentID
    
        CREATE TABLE #tblResult 
            (
              I_Student_ID INT ,
              S_Student_ID VARCHAR(250) ,
              S_Student_Name VARCHAR(150) ,
              I_Course_ID INT ,
              S_Course_Name VARCHAR(250) ,
              I_Term_ID1 INT ,
              I_Module_ID11 INT ,
              I_Module_ID12 INT ,
			  I_Term_ID2 INT ,
			  I_Module_ID21 INT ,
              I_Module_ID22 INT ,
              I_Term_ID3 INT ,
              I_Module_ID31 INT ,
              I_Module_ID32 INT ,
              I_Exam_Component_ID INT ,
              S_Exam_Component_Name VARCHAR(200) ,
              Internal_Marks1 INT ,
              Term_Marks1 INT ,
              Total_Marks1 INT ,
              Highest_Marks1 INT ,
              Internal_Marks2 INT ,
              Term_Marks2 INT ,
              Total_Marks2 INT ,
              Highest_Marks2 INT ,
              Internal_Marks3 INT ,
              Term_Marks3 INT ,
              Total_Marks3 INT ,
              Highest_Marks3 INT
            )
            
        INSERT  INTO #tblResult
                ( I_Student_ID ,
                  S_Student_ID ,
                  S_Student_Name ,
                  I_Course_ID ,
                  S_Course_Name ,
                  I_Exam_Component_ID ,
                  S_Exam_Component_Name                 
                )
    --            SELECT DISTINCT
    --                    @iStudentID ,
    --                    @sStudentName ,
    --                    @iCourseID ,
    --                    S_Course_Name ,
    --                    tecm.I_Exam_Component_ID ,
    --                    S_Component_Name
    --            FROM    dbo.T_Term_Eval_Strategy AS ttes
    --                    INNER JOIN dbo.T_Exam_Component_Master AS tecm ON ttes.I_Exam_Component_ID = tecm.I_Exam_Component_ID
    --                    INNER JOIN dbo.T_Course_Master AS tcm ON tecm.I_Course_ID = tcm.I_Course_ID
    --            WHERE   tcm.I_Course_ID = @iCourseID
    --                    AND I_Term_ID = @iTermID
                        
				--UNION
				
				SELECT DISTINCT
                        @iStudentID ,
                        @sStudentID ,
                        @sStudentName ,
                        @iCourseID ,
                        S_Course_Name ,
                        tecm.I_Exam_Component_ID ,
                        S_Component_Name
                FROM    dbo.T_Module_Eval_Strategy AS tmes
                        INNER JOIN dbo.T_Exam_Component_Master AS tecm ON tmes.I_Exam_Component_ID = tecm.I_Exam_Component_ID
                        INNER JOIN dbo.T_Course_Master AS tcm ON tmes.I_Course_ID = tcm.I_Course_ID
                WHERE   tcm.I_Course_ID = @iCourseID                        
                        
        UPDATE #tblResult SET Internal_Marks1 = tsm.I_Exam_Total, I_Term_ID1 = tbem.I_Term_ID, I_Module_ID11 = tbem.I_Module_ID
        FROM EXAMINATION.T_Student_Marks AS tsm
        INNER JOIN EXAMINATION.T_Batch_Exam_Map tbem ON tbem.I_Batch_Exam_ID = tsm.I_Batch_Exam_ID
        INNER JOIN dbo.T_Student_Batch_Master tsbm ON tsbm.I_Batch_ID = tbem.I_Batch_ID
		INNER JOIN dbo.T_Module_Term_Map AS tmtm ON tbem.I_Module_ID = tmtm.I_Module_ID AND tbem.I_Term_ID = tmtm.I_Term_ID AND tmtm.I_Sequence = 1 AND tmtm.I_Status = 1
		INNER JOIN dbo.T_Term_Course_Map AS ttcm ON tmtm.I_Term_ID = ttcm.I_Term_ID AND ttcm.I_Sequence = 1 AND ttcm.I_Status = 1
		INNER JOIN dbo.T_Module_Eval_Strategy AS tmes ON tmes.I_Module_ID = tbem.I_Module_ID AND tmes.I_Term_ID = tbem.I_Term_ID AND tmes.I_Exam_Component_ID = tbem.I_Exam_Component_ID
		INNER JOIN dbo.T_Exam_Component_Master AS tecm ON tbem.I_Exam_Component_ID = tecm.I_Exam_Component_ID
		WHERE ttcm.I_Course_ID = tsbm.I_Course_ID
		AND tsbm.I_Course_ID = @iCourseID
		AND tsm.I_Student_Detail_ID = @iStudentID
		AND #tblResult.I_Exam_Component_ID = tbem.I_Exam_Component_ID
		
		UPDATE #tblResult SET Term_Marks1 = I_Exam_Total, I_Term_ID1 = tbem.I_Term_ID, I_Module_ID12 = tbem.I_Module_ID
        FROM EXAMINATION.T_Student_Marks AS tsm		
        INNER JOIN EXAMINATION.T_Batch_Exam_Map tbem ON tbem.I_Batch_Exam_ID = tsm.I_Batch_Exam_ID
        INNER JOIN dbo.T_Student_Batch_Master tsbm ON tsbm.I_Batch_ID = tbem.I_Batch_ID
		INNER JOIN dbo.T_Module_Term_Map AS tmtm ON tbem.I_Module_ID = tmtm.I_Module_ID AND tbem.I_Term_ID = tmtm.I_Term_ID AND tmtm.I_Sequence = 2 AND tmtm.I_Status = 1
		INNER JOIN dbo.T_Term_Course_Map AS ttcm ON tmtm.I_Term_ID = ttcm.I_Term_ID AND ttcm.I_Sequence = 1 AND ttcm.I_Status = 1
		INNER JOIN dbo.T_Module_Eval_Strategy AS tmes ON tmes.I_Module_ID = tbem.I_Module_ID AND tmes.I_Term_ID = tbem.I_Term_ID AND tmes.I_Exam_Component_ID = tbem.I_Exam_Component_ID
		INNER JOIN dbo.T_Exam_Component_Master AS tecm ON tbem.I_Exam_Component_ID = tecm.I_Exam_Component_ID
		WHERE ttcm.I_Course_ID = tsbm.I_Course_ID
		AND tsbm.I_Course_ID = @iCourseID
		AND tsm.I_Student_Detail_ID = @iStudentID
		AND #tblResult.I_Exam_Component_ID = tbem.I_Exam_Component_ID
		
		--UPDATE @tblResult SET Highest_Marks1 = MAX(tstd.S_Term_Final_Marks)
		--FROM dbo.T_Student_Term_Detail AS tstd
		--WHERE tstd.I_Course_ID = @iCourseID
		--AND I_Term_ID = (SELECT TOP 1 I_Term_ID FROM dbo.T_Term_Course_Map 
		--WHERE I_Course_ID = @iCourseID AND I_Sequence = 1 AND I_Status = 1)
		
		UPDATE #tblResult SET Highest_Marks1 = (SELECT MAX(ISNULL(CASE WHEN tmtm.I_Sequence = 1 THEN tsm.I_Exam_Total END,0) 
				+ ISNULL(CASE WHEN tmtm.I_Sequence = 2 THEN I_Exam_Total END,0))
		FROM EXAMINATION.T_Student_Marks AS tsm
		INNER JOIN EXAMINATION.T_Batch_Exam_Map tbem ON tbem.I_Batch_Exam_ID = tsm.I_Batch_Exam_ID
		INNER JOIN dbo.T_Student_Batch_Master tsbm ON tsbm.I_Batch_ID = tbem.I_Batch_ID
		INNER JOIN dbo.T_Module_Term_Map AS tmtm ON tbem.I_Module_ID = tmtm.I_Module_ID AND tbem.I_Term_ID = tmtm.I_Term_ID AND tmtm.I_Status = 1
		INNER JOIN dbo.T_Term_Course_Map AS ttcm ON tmtm.I_Term_ID = ttcm.I_Term_ID AND ttcm.I_Sequence = 1 AND ttcm.I_Status = 1
		INNER JOIN dbo.T_Module_Eval_Strategy AS tmes ON tmes.I_Module_ID = tbem.I_Module_ID AND tmes.I_Term_ID = tbem.I_Term_ID AND tmes.I_Exam_Component_ID = tbem.I_Exam_Component_ID
		INNER JOIN dbo.T_Exam_Component_Master AS tecm ON tbem.I_Exam_Component_ID = tecm.I_Exam_Component_ID
		WHERE ttcm.I_Course_ID = tsbm.I_Course_ID
		AND tsbm.I_Course_ID = @iCourseID
		AND #tblResult.I_Exam_Component_ID = tbem.I_Exam_Component_ID)
				
		UPDATE #tblResult SET Internal_Marks2 = I_Exam_Total, I_Term_ID2 = tbem.I_Term_ID, I_Module_ID21 = tbem.I_Module_ID
        FROM EXAMINATION.T_Student_Marks AS tsm	
        INNER JOIN EXAMINATION.T_Batch_Exam_Map tbem ON tbem.I_Batch_Exam_ID = tsm.I_Batch_Exam_ID
        INNER JOIN dbo.T_Student_Batch_Master tsbm ON tsbm.I_Batch_ID = tbem.I_Batch_ID	
		INNER JOIN dbo.T_Module_Term_Map AS tmtm ON tbem.I_Module_ID = tmtm.I_Module_ID AND tbem.I_Term_ID = tmtm.I_Term_ID AND tmtm.I_Sequence = 1 AND tmtm.I_Status = 1
		INNER JOIN dbo.T_Term_Course_Map AS ttcm ON tmtm.I_Term_ID = ttcm.I_Term_ID AND ttcm.I_Sequence = 2 AND ttcm.I_Status = 1
		INNER JOIN dbo.T_Module_Eval_Strategy AS tmes ON tmes.I_Module_ID = tbem.I_Module_ID AND tmes.I_Term_ID = tbem.I_Term_ID AND tmes.I_Exam_Component_ID = tbem.I_Exam_Component_ID
		INNER JOIN dbo.T_Exam_Component_Master AS tecm ON tbem.I_Exam_Component_ID = tecm.I_Exam_Component_ID
		WHERE ttcm.I_Course_ID = tsbm.I_Course_ID
		AND tsbm.I_Course_ID = @iCourseID
		AND tsm.I_Student_Detail_ID = @iStudentID
		AND #tblResult.I_Exam_Component_ID = tbem.I_Exam_Component_ID
		
		UPDATE #tblResult SET Term_Marks2 = I_Exam_Total, I_Term_ID2 = tbem.I_Term_ID, I_Module_ID22 = tbem.I_Module_ID
        FROM EXAMINATION.T_Student_Marks AS tsm		
        INNER JOIN EXAMINATION.T_Batch_Exam_Map tbem ON tbem.I_Batch_Exam_ID = tsm.I_Batch_Exam_ID
        INNER JOIN dbo.T_Student_Batch_Master tsbm ON tsbm.I_Batch_ID = tbem.I_Batch_ID
		INNER JOIN dbo.T_Module_Term_Map AS tmtm ON tbem.I_Module_ID = tmtm.I_Module_ID AND tbem.I_Term_ID = tmtm.I_Term_ID AND tmtm.I_Sequence = 2 AND tmtm.I_Status = 1
		INNER JOIN dbo.T_Term_Course_Map AS ttcm ON tmtm.I_Term_ID = ttcm.I_Term_ID AND ttcm.I_Sequence = 2 AND ttcm.I_Status = 1
		INNER JOIN dbo.T_Module_Eval_Strategy AS tmes ON tmes.I_Module_ID = tbem.I_Module_ID AND tmes.I_Term_ID = tbem.I_Term_ID AND tmes.I_Exam_Component_ID = tbem.I_Exam_Component_ID
		INNER JOIN dbo.T_Exam_Component_Master AS tecm ON tbem.I_Exam_Component_ID = tecm.I_Exam_Component_ID
		WHERE ttcm.I_Course_ID = tsbm.I_Course_ID
		AND tsbm.I_Course_ID = @iCourseID
		AND tsm.I_Student_Detail_ID = @iStudentID
		AND #tblResult.I_Exam_Component_ID = tbem.I_Exam_Component_ID
		
		--UPDATE @tblResult SET Highest_Marks1 = MAX(tstd.S_Term_Final_Marks)
		--FROM dbo.T_Student_Term_Detail AS tstd
		--WHERE tstd.I_Course_ID = @iCourseID
		--AND I_Term_ID = (SELECT TOP 1 I_Term_ID FROM dbo.T_Term_Course_Map 
		--WHERE I_Course_ID = @iCourseID AND I_Sequence = 2 AND I_Status = 1)
		
		UPDATE #tblResult SET Highest_Marks2 = (SELECT MAX(ISNULL(CASE WHEN tmtm.I_Sequence = 1 THEN tsm.I_Exam_Total END,0) 
				+ ISNULL(CASE WHEN tmtm.I_Sequence = 2 THEN I_Exam_Total END,0))
		FROM EXAMINATION.T_Student_Marks AS tsm
		INNER JOIN EXAMINATION.T_Batch_Exam_Map tbem ON tbem.I_Batch_Exam_ID = tsm.I_Batch_Exam_ID
		INNER JOIN dbo.T_Student_Batch_Master tsbm ON tsbm.I_Batch_ID = tbem.I_Batch_ID
		INNER JOIN dbo.T_Module_Term_Map AS tmtm ON tbem.I_Module_ID = tmtm.I_Module_ID AND tbem.I_Term_ID = tmtm.I_Term_ID AND tmtm.I_Status = 1
		INNER JOIN dbo.T_Term_Course_Map AS ttcm ON tmtm.I_Term_ID = ttcm.I_Term_ID AND ttcm.I_Sequence = 2 AND ttcm.I_Status = 1
		INNER JOIN dbo.T_Module_Eval_Strategy AS tmes ON tmes.I_Module_ID = tbem.I_Module_ID AND tmes.I_Term_ID = tbem.I_Term_ID AND tmes.I_Exam_Component_ID = tbem.I_Exam_Component_ID
		INNER JOIN dbo.T_Exam_Component_Master AS tecm ON tbem.I_Exam_Component_ID = tecm.I_Exam_Component_ID
		WHERE ttcm.I_Course_ID = tsbm.I_Course_ID
		AND tsbm.I_Course_ID = @iCourseID
		AND #tblResult.I_Exam_Component_ID = tbem.I_Exam_Component_ID)
		
		UPDATE #tblResult SET Internal_Marks3 = I_Exam_Total, I_Term_ID3 = tbem.I_Term_ID, I_Module_ID31 = tbem.I_Module_ID
        FROM EXAMINATION.T_Student_Marks AS tsm		
        INNER JOIN EXAMINATION.T_Batch_Exam_Map tbem ON tbem.I_Batch_Exam_ID = tsm.I_Batch_Exam_ID
        INNER JOIN dbo.T_Student_Batch_Master tsbm ON tsbm.I_Batch_ID = tbem.I_Batch_ID
		INNER JOIN dbo.T_Module_Term_Map AS tmtm ON tbem.I_Module_ID = tmtm.I_Module_ID AND tbem.I_Term_ID = tmtm.I_Term_ID AND tmtm.I_Sequence = 1 AND tmtm.I_Status = 1
		INNER JOIN dbo.T_Term_Course_Map AS ttcm ON tmtm.I_Term_ID = ttcm.I_Term_ID AND ttcm.I_Sequence = 3 AND ttcm.I_Status = 1
		INNER JOIN dbo.T_Module_Eval_Strategy AS tmes ON tmes.I_Module_ID = tbem.I_Module_ID AND tmes.I_Term_ID = tbem.I_Term_ID AND tmes.I_Exam_Component_ID = tbem.I_Exam_Component_ID
		INNER JOIN dbo.T_Exam_Component_Master AS tecm ON tbem.I_Exam_Component_ID = tecm.I_Exam_Component_ID
		WHERE ttcm.I_Course_ID = tsbm.I_Course_ID
		AND tsbm.I_Course_ID = @iCourseID
		AND tsm.I_Student_Detail_ID = @iStudentID
		AND #tblResult.I_Exam_Component_ID = tbem.I_Exam_Component_ID
		
		UPDATE #tblResult SET Term_Marks3 = I_Exam_Total, I_Term_ID3 = tbem.I_Term_ID, I_Module_ID32 = tbem.I_Module_ID
        FROM EXAMINATION.T_Student_Marks AS tsm		
        INNER JOIN EXAMINATION.T_Batch_Exam_Map tbem ON tbem.I_Batch_Exam_ID = tsm.I_Batch_Exam_ID
        INNER JOIN dbo.T_Student_Batch_Master tsbm ON tsbm.I_Batch_ID = tbem.I_Batch_ID
		INNER JOIN dbo.T_Module_Term_Map AS tmtm ON tbem.I_Module_ID = tmtm.I_Module_ID AND tbem.I_Term_ID = tmtm.I_Term_ID AND tmtm.I_Sequence = 2 AND tmtm.I_Status = 1
		INNER JOIN dbo.T_Term_Course_Map AS ttcm ON tmtm.I_Term_ID = ttcm.I_Term_ID AND ttcm.I_Sequence = 3 AND ttcm.I_Status = 1
		INNER JOIN dbo.T_Module_Eval_Strategy AS tmes ON tmes.I_Module_ID = tbem.I_Module_ID AND tmes.I_Term_ID = tbem.I_Term_ID AND tmes.I_Exam_Component_ID = tbem.I_Exam_Component_ID
		INNER JOIN dbo.T_Exam_Component_Master AS tecm ON tbem.I_Exam_Component_ID = tecm.I_Exam_Component_ID
		WHERE ttcm.I_Course_ID = tsbm.I_Course_ID
		AND tsbm.I_Course_ID = @iCourseID
		AND tsm.I_Student_Detail_ID = @iStudentID
		AND #tblResult.I_Exam_Component_ID = tbem.I_Exam_Component_ID
		
		--UPDATE @tblResult SET Highest_Marks1 = MAX(tstd.S_Term_Final_Marks)
		--FROM dbo.T_Student_Term_Detail AS tstd
		--WHERE tstd.I_Course_ID = @iCourseID
		--AND I_Term_ID = (SELECT TOP 1 I_Term_ID FROM dbo.T_Term_Course_Map 
		--WHERE I_Course_ID = @iCourseID AND I_Sequence = 1 AND I_Status = 1)
		
		UPDATE #tblResult SET Highest_Marks3 = (SELECT MAX(ISNULL(CASE WHEN tmtm.I_Sequence = 1 THEN tsm.I_Exam_Total END,0) 
				+ ISNULL(CASE WHEN tmtm.I_Sequence = 2 THEN I_Exam_Total END,0))
		FROM EXAMINATION.T_Student_Marks AS tsm
		INNER JOIN EXAMINATION.T_Batch_Exam_Map tbem ON tbem.I_Batch_Exam_ID = tsm.I_Batch_Exam_ID
		INNER JOIN dbo.T_Student_Batch_Master tsbm ON tsbm.I_Batch_ID = tbem.I_Batch_ID
		INNER JOIN dbo.T_Module_Term_Map AS tmtm ON tbem.I_Module_ID = tmtm.I_Module_ID AND tbem.I_Term_ID = tmtm.I_Term_ID AND tmtm.I_Status = 1
		INNER JOIN dbo.T_Term_Course_Map AS ttcm ON tmtm.I_Term_ID = ttcm.I_Term_ID AND ttcm.I_Sequence = 3 AND ttcm.I_Status = 1
		INNER JOIN dbo.T_Module_Eval_Strategy AS tmes ON tmes.I_Module_ID = tbem.I_Module_ID AND tmes.I_Term_ID = tbem.I_Term_ID AND tmes.I_Exam_Component_ID = tbem.I_Exam_Component_ID
		INNER JOIN dbo.T_Exam_Component_Master AS tecm ON tbem.I_Exam_Component_ID = tecm.I_Exam_Component_ID
		WHERE ttcm.I_Course_ID = tsbm.I_Course_ID
		AND tsbm.I_Course_ID = @iCourseID
		AND #tblResult.I_Exam_Component_ID = tbem.I_Exam_Component_ID)
		
		UPDATE #tblResult SET	Total_Marks1 = ISNULL(Internal_Marks1,0) + ISNULL(Term_Marks1,0),
								Total_Marks2 = ISNULL(Internal_Marks2,0) + ISNULL(Term_Marks2,0),
								Total_Marks3 = ISNULL(Internal_Marks3,0) + ISNULL(Term_Marks3,0)

		SELECT * FROM #tblResult AS tr                        
    END
