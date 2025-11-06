--exec [REPORT].[uspGetAISPROGRESSREPORTNewIII] 2,107,9182,null,26132
CREATE PROCEDURE [REPORT].[uspGetAISPROGRESSREPORTNewIII]
    (
      @sHierarchyList VARCHAR(MAX) ,
      @iBrandID INT ,
      @iBatchID INT ,
      @iTermID INT = NULL ,
      @iStudentID INT = NULL
   
    )
AS
    BEGIN
        DECLARE @iCourseID INT ,
            @sCourierName VARCHAR(50) ,
            @sBatchName VARCHAR(100) ,
            @sClass VARCHAR(10) ,
            @iBatchExamID INT ,
            @iModuleID INT ,
            @iExamComponentID INT ,
            @sStudentName VARCHAR(250) ,
            @sStudentID VARCHAR(250)

        SELECT  @iCourseID = tsbm.I_Course_ID ,
                @sBatchName = tsbm.S_Batch_Name ,
                @sCourierName = tcm.S_Course_Name ,
                @sClass = tcm.S_Course_Desc
        FROM    dbo.T_Student_Batch_Master AS tsbm
                INNER JOIN T_Course_Master tcm ON tcm.I_Course_ID = tsbm.I_Course_ID
        WHERE   tsbm.I_Batch_ID = @iBatchID


		DECLARE  @AdChks AS TABLE (I_RID INT,I_Term_Id INT,I_Module_Id INT,  I_Sequence INT,S_Module_Name VARCHAR(250))

		INSERT INTO @AdChks(I_RID,I_Term_Id,I_Module_Id,I_Sequence,S_Module_Name)
		SELECT ROW_NUMBER() OVER ( PARTITION BY MTM.I_Term_ID ORDER BY MTM.I_Sequence ) RID,
				TCM.I_Term_Id , MTM.I_Module_Id, MTM.I_Sequence ,MM.S_Module_Name         
        FROM   dbo.T_Term_Course_Map TCM WITH ( NOLOCK ) 
				INNER JOIN T_Module_Term_Map MTM WITH ( NOLOCK ) ON MTM.I_Term_ID = TCM.I_Term_ID
				INNER JOIN T_Module_Master MM  WITH ( NOLOCK ) ON MM.I_Module_ID = MTM.I_Module_ID
        WHERE  I_Course_ID = @iCourseID 
            AND TCM.I_Status = 1 
			AND MTM.I_Status = 1
			AND MM.S_Module_Name LIKE '%ADCHK%'	

        CREATE TABLE #tbltempResult
            (
              I_Center_ID INT ,
              I_Batch_Exam_ID INT ,
              I_Batch_ID INT ,
              I_Course_ID INT ,
              courseSequence INT ,
              I_Term_ID INT ,
              I_Module_ID INT ,
              S_Module_Name VARCHAR(250) ,
              I_Exam_Component_ID INT ,
              S_Component_Name VARCHAR(250) ,
              GradeSequence INT ,
              I_Student_Detail_ID INT ,
              I_Exam_Total NUMERIC(8, 2) ,
              ModuleID1 INT , 			 
			  ModuleID1FullMarks INT , --Added As Per New Format 2018-19 
			  ModuleID1Weightage NUMERIC(8, 2) ,--Added As Per New Format 2018-19 
              ModuleID1Marks NUMERIC(8, 2) , 
              ModuleID2 INT ,
			  ModuleID2FullMarks INT , --Added As Per New Format 2018-19 
			  ModuleID2Weightage NUMERIC(8, 2) ,--Added As Per New Format 2018-19 
              ModuleID2Marks NUMERIC(8, 2) , 
              ModuleID3 INT , 
			  ModuleID3FullMarks INT , --Added As Per New Format 2018-19 
			  ModuleID3Weightage NUMERIC(8, 2) ,--Added As Per New Format 2018-19 
              ModuleID3Marks NUMERIC(8, 2) , 
              ModuleID4 INT ,
			  ModuleID4FullMarks INT , --Added As Per New Format 2018-19 
			  ModuleID4Weightage NUMERIC(8, 2) , --Added As Per New Format 2018-19 
              ModuleID4Marks NUMERIC(8, 2) ,

			  /* --Added As Per New Format 2018-19 START*/
			  ModuleID5 INT ,
			  ModuleID5FullMarks INT , 
			  ModuleID5Weightage NUMERIC(8, 2) , 
              ModuleID5Marks NUMERIC(8, 2) ,
			  ModuleID6 INT ,
			  ModuleID6FullMarks INT , 
			  ModuleID6Weightage NUMERIC(8, 2) , 
              ModuleID6Marks NUMERIC(8, 2) ,
			  ModuleID7 INT ,
			  ModuleID7FullMarks INT , 
			  ModuleID7Weightage NUMERIC(8, 2) , 
              ModuleID7Marks NUMERIC(8, 2) ,
			  ModuleID8 INT ,
			  ModuleID8FullMarks INT , 
			  ModuleID8Weightage NUMERIC(8, 2) , 
              ModuleID8Marks NUMERIC(8, 2) ,
			  /* --Added As Per New Format 2018-19 END*/

              B_Optional BIT
            )
			
  
              
        CREATE TABLE #tblResult
            (
              I_Student_Detail_ID INT ,
              S_Student_ID VARCHAR(250) ,
              S_Student_Name VARCHAR(150) ,
              I_Course_ID INT ,
              S_Course_Name VARCHAR(250) ,
              I_Batch_ID INT ,
              S_Batch_Name VARCHAR(250) ,
              I_Term_ID INT ,
              S_Term_Name VARCHAR(250) ,
			  I_Term_Sequence INT, 
              I_Exam_Component_ID INT ,
              S_Exam_Component_Name VARCHAR(200) ,
              I_Sequence INT,
              I_Module_ID1 INT ,
              ModuleID1FullMarks INT , 
			  ModuleID1Weightage NUMERIC(8, 2) , 
              I_Exam_Total1 NUMERIC(8, 2) , 
              I_Module_ID2 INT , 
              ModuleID2FullMarks INT , 
			  ModuleID2Weightage NUMERIC(8, 2) , 
              I_Exam_Total2 NUMERIC(8, 2) , 
              I_Module_ID3 INT ,
              ModuleID3FullMarks INT , 
			  ModuleID3Weightage NUMERIC(8, 2) , 
              I_Exam_Total3 NUMERIC(8, 2) , 
              I_Module_ID4 INT , 
              ModuleID4FullMarks INT , 
			  ModuleID4Weightage NUMERIC(8, 2) , 
              I_Exam_Total4 NUMERIC(8, 2) , 
              TotalMarks NUMERIC(8, 2) ,
              totalGrade VARCHAR(5) ,
              HighestMarks NUMERIC(8, 2) ,
              HighestGrade VARCHAR(5) ,
              classname VARCHAR(15) ,
              B_Optional BIT
            )
            
            
        INSERT  INTO #tblResult
                ( I_Student_Detail_ID ,
                  S_Student_ID ,
                  S_Student_Name ,
                  I_Course_ID ,
                  S_Course_Name ,
                  I_Batch_ID ,
                  S_Batch_Name ,
                  I_Term_ID ,
                  S_Term_Name ,
				  I_Term_Sequence ,
                  I_Exam_Component_ID ,
                  S_Exam_Component_Name ,
                  I_Sequence,
                  classname ,
                  B_Optional            
            
                )
                SELECT DISTINCT
                        tsd.I_Student_Detail_ID ,
                        tsd.S_Student_ID ,
                        tsd.S_First_Name + ' ' + ISNULL(tsd.S_Middle_Name, '')
        + ' ' + tsd.S_Last_Name StudentName ,
                        @iCourseID ,
                        @sCourierName ,
                        @iBatchID ,
                        @sBatchName ,
                        tbem.I_Term_ID ,
                        TTM.S_Term_Name ,
						TCM.I_Sequence ,
                        tbem.I_Exam_Component_ID ,
                        tecm.S_Component_Name ,
                        tecm.I_Sequence_No,
                        @sClass ,
                        tbem.B_Optional
                FROM    EXAMINATION.T_Batch_Exam_Map AS tbem WITH ( NOLOCK )
                        INNER JOIN EXAMINATION.T_Student_Marks TSM WITH ( NOLOCK ) ON TSM.I_Batch_Exam_ID = tbem.I_Batch_Exam_ID
                        INNER JOIN dbo.T_Student_Detail AS tsd WITH ( NOLOCK ) ON TSM.I_Student_Detail_ID = tsd.I_Student_Detail_ID
                        INNER JOIN dbo.T_Student_Batch_Details TSBD WITH ( NOLOCK ) ON tsd.I_Student_Detail_ID = TSBD.I_Student_ID
                                                              AND TSBD.I_Status IN (
                                                              1, 2 )
                        INNER JOIN dbo.T_Term_Master TTM WITH ( NOLOCK ) ON tbem.I_Term_ID = TTM.I_Term_ID
						INNER JOIN dbo.T_Term_Course_Map TCM ON TCM.I_Term_ID = tbem.I_Term_ID AND TCM.I_Term_ID = TTM.I_Term_ID AND TCM.I_Course_ID = @iCourseID
                        INNER JOIN dbo.T_Exam_Component_Master AS tecm WITH ( NOLOCK ) ON tbem.I_Exam_Component_ID = tecm.I_Exam_Component_ID
                        INNER JOIN dbo.T_Module_Eval_Strategy AS TMES ON TMES.I_Exam_Component_ID = tbem.I_Exam_Component_ID AND TMES.I_Module_ID = tbem.I_Module_ID AND TMES.I_Term_ID = tbem.I_Term_ID AND TMES.I_Status=1
                WHERE   tbem.I_Batch_ID = @iBatchID
                        AND tbem.I_Term_ID = ISNULL(@iTermID, tbem.I_Term_ID)
                        AND TSM.I_Student_Detail_ID = ISNULL(@iStudentID,
                                                             TSM.I_Student_Detail_ID)
                ORDER BY tsd.I_Student_Detail_ID ,
						tecm.I_Sequence_No
                        --tbem.I_Exam_Component_ID
  
  
  
  
        INSERT  INTO #tbltempResult
                ( I_Center_ID ,
                  I_Batch_Exam_ID ,
                  I_Batch_ID ,
                  I_Course_ID ,
                  courseSequence ,
                  I_Term_ID ,
                  I_Module_ID ,
                  S_Module_Name ,
                  I_Exam_Component_ID ,
                  S_Component_Name ,
                  GradeSequence ,
                  I_Student_Detail_ID ,
                  I_Exam_Total ,
                  ModuleID1 , 
				  ModuleID1FullMarks ,
				  ModuleID1Weightage ,
                  ModuleID1Marks , 
                  ModuleID2 , 
				  ModuleID2FullMarks ,
				  ModuleID2Weightage ,
                  ModuleID2Marks , 
                  ModuleID3 , 
				  ModuleID3FullMarks ,
				  ModuleID3Weightage ,
                  ModuleID3Marks , 
                  ModuleID4 , 
				  ModuleID4FullMarks ,
				  ModuleID4Weightage ,
                  ModuleID4Marks,

				  --Added As Per New Format 2018-19 START
				  ModuleID5 , 
				  ModuleID5FullMarks ,
				  ModuleID5Weightage ,
                  ModuleID5Marks,
				  ModuleID6 , 
				  ModuleID6FullMarks ,
				  ModuleID6Weightage ,
                  ModuleID6Marks,
				  ModuleID7 , 
				  ModuleID7FullMarks ,
				  ModuleID7Weightage ,
                  ModuleID7Marks,
				  ModuleID8 , 
				  ModuleID8FullMarks ,
				  ModuleID8Weightage ,
                  ModuleID8Marks
                  --Added As Per New Format 2018-19 END 
                         
                )
                SELECT  TSM.I_Center_ID ,
                        TSM.I_Batch_Exam_ID ,
                        TBEM.I_Batch_ID ,
                        tsbm.I_Course_ID ,
                        ttcm.I_Sequence courseSequence ,
                        TBEM.I_Term_ID ,
                        TBEM.I_Module_ID ,
                        tmm.S_Module_Name ,
                        TBEM.I_Exam_Component_ID ,
                        tecm.S_Component_Name ,
                        tmtm.I_Sequence GradeSequence ,
                        TSM.I_Student_Detail_ID ,
                        TSM.I_Exam_Total ,
                        --Changed/Added As Per New Format 2018-19 START 
                        CASE WHEN tmtm.I_Sequence = 1  THEN TBEM.I_Module_ID 
                             ELSE NULL 
                        END ModuleID1 , 
						CASE WHEN tmtm.I_Sequence = 1 THEN MES.I_TotMarks 
                             ELSE NULL 
                        END ModuleID1FullMarks ,
						CASE WHEN tmtm.I_Sequence = 1  THEN MES.N_Weightage
                             ELSE NULL 
                        END ModuleID1Weightage ,
                        CASE WHEN tmtm.I_Sequence = 1  THEN (ROUND(TSM.I_Exam_Total,0)*MES.N_Weightage)/MES.I_TotMarks 
                             ELSE NULL 
                        END ModuleID1Marks , 
                        CASE WHEN tmtm.I_Sequence = 2  THEN TBEM.I_Module_ID 
                             ELSE NULL 
                        END ModuleID2 , 
						CASE WHEN tmtm.I_Sequence = 2  THEN MES.I_TotMarks 
                             ELSE NULL 
                        END ModuleID2FullMarks ,
						CASE WHEN tmtm.I_Sequence = 2  THEN MES.N_Weightage 
                             ELSE NULL 
                        END ModuleID2Weightage ,
                        CASE WHEN tmtm.I_Sequence = 2  THEN (ROUND(TSM.I_Exam_Total,0)*MES.N_Weightage)/MES.I_TotMarks 
                             ELSE NULL 
                        END ModuleID2Marks , 
                        CASE WHEN tmtm.I_Sequence = 3  THEN TBEM.I_Module_ID 
                             ELSE NULL 
                        END ModuleID3 , 
						CASE WHEN tmtm.I_Sequence = 3  THEN MES.I_TotMarks 
                             ELSE NULL 
                        END ModuleID3FullMarks ,
						CASE WHEN tmtm.I_Sequence = 3  THEN MES.N_Weightage 
                             ELSE NULL 
                        END ModuleID3Weightage ,
                        CASE WHEN tmtm.I_Sequence = 3  THEN (ROUND(TSM.I_Exam_Total,0)*MES.N_Weightage)/MES.I_TotMarks 
                             ELSE NULL 
                        END ModuleID3Marks , 
                        CASE WHEN tmtm.I_Sequence = 4  THEN TBEM.I_Module_ID 
                             ELSE NULL 
                        END ModuleID4 , 
						CASE WHEN tmtm.I_Sequence = 4  THEN MES.I_TotMarks 
                             ELSE NULL 
                        END ModuleID4FullMarks ,
						CASE WHEN tmtm.I_Sequence = 4  THEN MES.N_Weightage 
                             ELSE NULL 
                        END ModuleID4Weightage ,
                        CASE WHEN tmtm.I_Sequence = 4  THEN (ROUND(TSM.I_Exam_Total,0)*MES.N_Weightage)/MES.I_TotMarks 
                             ELSE NULL 
                        END ModuleID4Marks,

						CASE WHEN tmtm.I_Sequence = (SELECT I_Sequence FROM @AdChks WHERE I_RID = 1 AND I_Term_Id = tmtm.I_Term_ID) THEN TBEM.I_Module_ID 
                             ELSE NULL 
                        END ModuleID5 , 
						CASE WHEN tmtm.I_Sequence = (SELECT I_Sequence FROM @AdChks WHERE I_RID = 1 AND I_Term_Id = tmtm.I_Term_ID) THEN MES.I_TotMarks 
                             ELSE NULL 
                        END ModuleID5FullMarks ,
						CASE WHEN tmtm.I_Sequence = (SELECT I_Sequence FROM @AdChks WHERE I_RID = 1 AND I_Term_Id = tmtm.I_Term_ID) THEN MES.N_Weightage
                             ELSE NULL 
                        END ModuleID5Weightage ,
                        CASE WHEN tmtm.I_Sequence = (SELECT I_Sequence FROM @AdChks WHERE I_RID = 1 AND I_Term_Id = tmtm.I_Term_ID) THEN (ROUND(TSM.I_Exam_Total,0)*MES.N_Weightage)/MES.I_TotMarks 
                             ELSE NULL 
                        END ModuleID5Marks,
						CASE WHEN tmtm.I_Sequence = (SELECT I_Sequence FROM @AdChks WHERE I_RID = 2 AND I_Term_Id = tmtm.I_Term_ID) THEN TBEM.I_Module_ID 
                             ELSE NULL 
                        END ModuleID6 , 
						CASE WHEN tmtm.I_Sequence = (SELECT I_Sequence FROM @AdChks WHERE I_RID = 2 AND I_Term_Id = tmtm.I_Term_ID) THEN MES.I_TotMarks 
                             ELSE NULL 
                        END ModuleID6FullMarks ,
						CASE WHEN tmtm.I_Sequence = (SELECT I_Sequence FROM @AdChks WHERE I_RID = 2 AND I_Term_Id = tmtm.I_Term_ID) THEN MES.N_Weightage 
                             ELSE NULL 
                        END ModuleID6Weightage ,
                        CASE WHEN tmtm.I_Sequence = (SELECT I_Sequence FROM @AdChks WHERE I_RID = 2 AND I_Term_Id = tmtm.I_Term_ID) THEN (ROUND(TSM.I_Exam_Total,0)*MES.N_Weightage)/MES.I_TotMarks 
                             ELSE NULL 
                        END ModuleID6Marks,
						CASE WHEN tmtm.I_Sequence = (SELECT I_Sequence FROM @AdChks WHERE I_RID = 3 AND I_Term_Id = tmtm.I_Term_ID) THEN TBEM.I_Module_ID 
                             ELSE NULL 
                        END ModuleID7 , 
						CASE WHEN tmtm.I_Sequence = (SELECT I_Sequence FROM @AdChks WHERE I_RID = 3 AND I_Term_Id = tmtm.I_Term_ID) THEN MES.I_TotMarks 
                             ELSE NULL 
                        END ModuleID7FullMarks ,
						CASE WHEN tmtm.I_Sequence = (SELECT I_Sequence FROM @AdChks WHERE I_RID = 3 AND I_Term_Id = tmtm.I_Term_ID) THEN MES.N_Weightage
                             ELSE NULL 
                        END ModuleID7Weightage ,
                        CASE WHEN tmtm.I_Sequence = (SELECT I_Sequence FROM @AdChks WHERE I_RID = 3 AND I_Term_Id = tmtm.I_Term_ID) THEN (ROUND(TSM.I_Exam_Total,0)*MES.N_Weightage)/MES.I_TotMarks 
                             ELSE NULL 
                        END ModuleID7Marks,
						CASE WHEN tmtm.I_Sequence = (SELECT I_Sequence FROM @AdChks WHERE I_RID = 4 AND I_Term_Id = tmtm.I_Term_ID) THEN TBEM.I_Module_ID 
                             ELSE NULL 
                        END ModuleID8 , 
						CASE WHEN tmtm.I_Sequence = (SELECT I_Sequence FROM @AdChks WHERE I_RID = 4 AND I_Term_Id = tmtm.I_Term_ID) THEN MES.I_TotMarks 
                             ELSE NULL 
                        END ModuleID8FullMarks ,
						CASE WHEN tmtm.I_Sequence = (SELECT I_Sequence FROM @AdChks WHERE I_RID = 4 AND I_Term_Id = tmtm.I_Term_ID) THEN MES.N_Weightage 
                             ELSE NULL 
                        END ModuleID8Weightage ,
                        CASE WHEN tmtm.I_Sequence = (SELECT I_Sequence FROM @AdChks WHERE I_RID = 4 AND I_Term_Id = tmtm.I_Term_ID) THEN (ROUND(TSM.I_Exam_Total,0)*MES.N_Weightage)/MES.I_TotMarks 
                             ELSE NULL 
                        END ModuleID8Marks
						--Changed/Added As Per New Format 2018-19 END 
               FROM    EXAMINATION.T_Student_Marks TSM WITH ( NOLOCK ) 
                        INNER JOIN EXAMINATION.T_Batch_Exam_Map TBEM WITH ( NOLOCK ) ON TBEM.I_Batch_Exam_ID = TSM.I_Batch_Exam_ID 
                        INNER JOIN dbo.T_Exam_Component_Master AS tecm WITH ( NOLOCK ) ON tbem.I_Exam_Component_ID = tecm.I_Exam_Component_ID 
                        INNER JOIN dbo.T_Module_Master AS tmm WITH ( NOLOCK ) ON TBEM.I_Module_ID = tmm.I_Module_ID 
                        INNER JOIN dbo.T_Module_Term_Map AS tmtm WITH ( NOLOCK ) ON tbem.I_Module_ID = tmtm.I_Module_ID 
                                                              AND tbem.I_Term_ID = tmtm.I_Term_ID 
                                                              AND tmtm.I_Status = 1 
                                                              
                        INNER JOIN dbo.T_Term_Course_Map AS ttcm WITH ( NOLOCK ) ON tmtm.I_Term_ID = ttcm.I_Term_ID 
                                                              AND ttcm.I_Status = 1
                        INNER JOIN dbo.T_Student_Batch_Master tsbm WITH ( NOLOCK ) ON tsbm.I_Batch_ID = tbem.I_Batch_ID 
                        INNER JOIN #tblResult A ON TSM.I_Student_Detail_ID = A.I_Student_Detail_ID 
								AND A.I_Exam_Component_ID = tecm.I_Exam_Component_ID
								AND A.I_Term_ID = tmtm.I_Term_ID
								
						--Added As Per New Format 2018-19 [To Pick as per weightage] 
						INNER JOIN T_Module_Eval_Strategy MES WITH ( NOLOCK ) ON MES.I_Course_ID = ttcm.I_Course_ID
							AND MES.I_Module_ID = tmtm.I_Module_ID
							AND MES.I_Term_ID = tmtm.I_Term_ID
							AND MES.I_Exam_Component_ID = tecm.I_Exam_Component_ID
							AND MES.I_Status = 1
							AND MES.N_Weightage > 0
						  
                WHERE   ttcm.I_Course_ID = @iCourseID 
						AND TBEM.I_Status != 0
  
  
 
  --select * from #tbltempResult ORDER BY I_Exam_Component_ID, I_Module_ID
		--SELECT * FROM #tblResult
		
        
		UPDATE  T
        SET     I_Module_ID1 = V.ModuleID1 ,
                I_Exam_Total1 = V.ModuleID1Marks
        FROM    #tblResult T
                INNER JOIN (SELECT I_Course_ID,I_Term_ID,I_Student_Detail_ID,I_Exam_Component_ID,I_Batch_ID,MIN(ModuleID1) AS ModuleID1,SUM(ModuleID1Marks) AS ModuleID1Marks
										FROM #tbltempResult WHERE GradeSequence= 1
										GROUP BY I_Course_ID,I_Term_ID,I_Student_Detail_ID,I_Exam_Component_ID,I_Batch_ID) V ON T.I_Course_ID = V.I_Course_ID
                                               AND T.I_Term_ID = V.I_Term_ID
                                               AND T.I_Student_Detail_ID = V.I_Student_Detail_ID
                                               AND T.I_Exam_Component_ID = V.I_Exam_Component_ID
                                               --AND V.GradeSequence = 1
                                               AND T.I_Batch_ID = V.I_Batch_ID
                                               
        UPDATE  T
        SET     I_Module_ID2 = V.ModuleID2 ,
                I_Exam_Total2 = V.ModuleID2Marks
        FROM    #tblResult T
                INNER JOIN #tbltempResult V ON T.I_Course_ID = V.I_Course_ID
                                               AND T.I_Term_ID = V.I_Term_ID
                                               AND T.I_Student_Detail_ID = V.I_Student_Detail_ID
                                               AND T.I_Exam_Component_ID = V.I_Exam_Component_ID
                                               AND V.GradeSequence = 2
                                               AND T.I_Batch_ID = V.I_Batch_ID
			  
        UPDATE  T
        SET     I_Module_ID3 = V.ModuleID3 ,
                I_Exam_Total3 = V.ModuleID3Marks
        FROM    #tblResult T
                INNER JOIN #tbltempResult V ON T.I_Course_ID = V.I_Course_ID
                                               AND T.I_Term_ID = V.I_Term_ID
                                               AND T.I_Student_Detail_ID = V.I_Student_Detail_ID
                                               AND T.I_Exam_Component_ID = V.I_Exam_Component_ID
                                               AND V.GradeSequence = 3
                                               AND T.I_Batch_ID = V.I_Batch_ID
			  
        UPDATE  T
        SET     I_Module_ID4 = V.ModuleID4 ,
                I_Exam_Total4 = V.ModuleID4Marks
        FROM    #tblResult T
                INNER JOIN #tbltempResult V ON T.I_Course_ID = V.I_Course_ID
                                               AND T.I_Term_ID = V.I_Term_ID
                                               AND T.I_Student_Detail_ID = V.I_Student_Detail_ID
                                               AND T.I_Exam_Component_ID = V.I_Exam_Component_ID
                                               AND V.GradeSequence = 4
                                               AND T.I_Batch_ID = V.I_Batch_ID
  
          
        UPDATE  #tblResult
        SET     TotalMarks = ROUND(ISNULL(I_Exam_Total1, 0), 0)
                + ROUND(ISNULL(I_Exam_Total2, 0), 0)
                + ROUND(ISNULL(I_Exam_Total3, 0), 0)
                + ROUND(ISNULL(I_Exam_Total4, 0), 0)
        UPDATE  #tblResult
        SET     TotalMarks = NULL
        WHERE   I_Exam_Total1 IS NULL
                AND I_Exam_Total2 IS NULL
                AND I_Exam_Total3 IS NULL
                AND I_Exam_Total4 IS NULL	     
        
          
    
         
        UPDATE  T 
        SET     HighestMarks = VR.Marks 
        FROM    #tblResult T 
                INNER JOIN ( SELECT V.I_Course_ID , 
                                    V.I_Term_ID , 
                                    V.I_Exam_Component_ID , 
                                    MAX(V.Marks) Marks 
                             FROM   ( SELECT    tsbm.I_Course_ID , 
                                                tmtm.I_Term_ID , 
                                                tbem.I_Exam_Component_ID , 
                                                tsm.I_Student_Detail_ID , 
                                                SUM((ROUND(ISNULL(I_Exam_Total, 
                                                              0), 0)*tmes.N_Weightage)/tmes.I_TotMarks ) Marks  --Changed As Per New Format 2018-19
                                      FROM      EXAMINATION.T_Student_Marks AS tsm 
                                                WITH ( NOLOCK ) 
                                                INNER JOIN EXAMINATION.T_Batch_Exam_Map tbem 
                                                WITH ( NOLOCK ) ON tbem.I_Batch_Exam_ID = tsm.I_Batch_Exam_ID AND tbem.I_Status=1
                                                INNER JOIN ( SELECT 
                                                              I_Student_ID , 
                                                              I_Batch_ID , 
                                                              MAX(I_Status) I_Status 
                                                             FROM 
                                                              dbo.T_Student_Batch_Details 
                                                             GROUP BY I_Student_ID , 
                                                              I_Batch_ID 
                                                           ) AS tsbd ON tsbd.I_Batch_ID = tbem.I_Batch_ID 
                                                              AND tsbd.I_Student_ID = tsm.I_Student_Detail_ID 
                                                              AND tsbd.I_Status IN ( 
                                                              0, 1, 2 ) 
                                                INNER JOIN dbo.T_Student_Batch_Master tsbm 
                                                WITH ( NOLOCK ) ON tsbm.I_Batch_ID = tbem.I_Batch_ID 
                                                              AND tsbm.I_Course_ID = @icourseid 
                                                INNER JOIN dbo.T_Module_Term_Map 
                                                AS tmtm WITH ( NOLOCK ) ON tbem.I_Module_ID = tmtm.I_Module_ID 
                                                              AND tbem.I_Term_ID = tmtm.I_Term_ID 
                                                              AND tmtm.I_Status = 1 
                                                INNER JOIN dbo.T_Module_Eval_Strategy 
                                                AS tmes WITH ( NOLOCK ) ON tmes.I_Module_ID = tbem.I_Module_ID 
                                                              AND tmes.I_Term_ID = tbem.I_Term_ID 
                                                              AND tmes.I_Exam_Component_ID = tbem.I_Exam_Component_ID 
                                                              AND tmes.I_Status = 1 
                                                INNER JOIN dbo.T_Exam_Component_Master 
                                                AS tecm WITH ( NOLOCK ) ON tbem.I_Exam_Component_ID = tecm.I_Exam_Component_ID 
                                      GROUP BY  tsbm.I_Course_ID , 
                                                tmtm.I_Term_ID , 
                                                tbem.I_Exam_Component_ID , 
                                                tsm.I_Student_Detail_ID 
                                    ) V 
                             GROUP BY V.I_Course_ID , 
                                    V.I_Term_ID , 
                                    V.I_Exam_Component_ID 
                           ) VR ON T.I_Course_ID = VR.I_Course_ID 
                                   AND T.I_Term_ID = VR.I_Term_ID 
                                   AND VR.I_Exam_Component_ID = T.I_Exam_Component_ID 
          
    
    ---AKASH 22.10.2019---
    CREATE TABLE #tblGradeMst 
                    ( 
                      ID INT IDENTITY , 
                      FromMarks NUMERIC(8, 2) , 
                      ToMarks NUMERIC(8, 2) , 
                      Grade VARCHAR(5) 
                    ) 
              
              
                INSERT  INTO #tblGradeMst 
                        ( FromMarks, ToMarks, Grade ) 
                VALUES  ( 0, 40, 'F' ) 
                INSERT  INTO #tblGradeMst 
                        ( FromMarks, ToMarks, Grade ) 
                VALUES  ( 40, 50, 'C' ) 
                INSERT  INTO #tblGradeMst 
                        ( FromMarks, ToMarks, Grade ) 
                VALUES  ( 50, 60, 'C+' ) 
                INSERT  INTO #tblGradeMst 
                        ( FromMarks, ToMarks, Grade ) 
                VALUES  ( 60, 70, 'B' ) 
                INSERT  INTO #tblGradeMst 
                        ( FromMarks, ToMarks, Grade ) 
                VALUES  ( 70, 80, 'B+' ) 
                INSERT  INTO #tblGradeMst 
                        ( FromMarks, ToMarks, Grade ) 
                VALUES  ( 80, 90, 'A' ) 
                INSERT  INTO #tblGradeMst 
                        ( FromMarks, ToMarks, Grade ) 
                VALUES  ( 90, 100, 'A+' ) 
                
                UPDATE  #tblResult 
                SET     totalGrade = ( SELECT   Grade 
                                       FROM     #tblGradeMst 
                                       WHERE    CAST(ROUND(TotalMarks, 0) AS INT) >= FromMarks 
                                                AND CAST(ROUND(TotalMarks, 0) AS INT) < ToMarks 
                                     ) 
                WHERE   I_Exam_Component_ID IN ( 25, 46, 59 ) 
                UPDATE  #tblResult 
                SET     totalGrade = 'A+' 
                WHERE   CAST(ROUND(TotalMarks, 0) AS INT) = 100 
                        AND I_Exam_Component_ID IN ( 25, 46, 59 ) 
                UPDATE  #tblResult 
                SET     HighestGrade = ( SELECT Grade 
                                         FROM   #tblGradeMst 
                                         WHERE  CAST(ROUND(HighestMarks, 0) AS INT) >= FromMarks 
                                                AND CAST(ROUND(HighestMarks, 0) AS INT) < ToMarks 
                                       ) 
                WHERE   I_Exam_Component_ID IN ( 25, 46, 59 ) 
                
                UPDATE  #tblResult 
                SET     I_Exam_Total1 = 0 , 
                        TotalMarks = 0 
                WHERE   I_Exam_Component_ID IN ( 25, 46, 59 ) 
                
         ---AKASH 22.10.2019---       
    
    
    /* Akash 18/9/2014
    IF(upper(rtrim(ltrim(@sClass)))=upper('Class 3') or upper(rtrim(ltrim(@sClass)))=upper('Class 4')  )
    BEGIN     
			Update #tblResult SET  I_Exam_Total1 =null,I_Exam_Total2 =null,I_Exam_Total3=NULL,I_Exam_Total4=NULL
			where   I_Exam_Component_ID IN (24,45)--Spelling
			
			
		 
   END
    
  Akash 18/9/2014  */ 
  
  /* */
   
        SELECT  I_Student_Detail_ID ,
                S_Student_ID ,
                S_Student_Name ,
                tr.I_Course_ID ,
                S_Course_Name ,
                I_Batch_ID ,
                S_Batch_Name ,
                I_Term_ID ,
                S_Term_Name ,
				I_Term_Sequence ,
                tr.I_Exam_Component_ID ,
                S_Exam_Component_Name ,
                tr.I_Sequence,
                I_Module_ID1 ,
                CAST(ROUND(ModuleID1FullMarks, 0) AS INT) ModuleID1FullMarks ,
				ModuleID1Weightage,
                CAST(ROUND(I_Exam_Total1, 0) AS INT) I_Exam_Total1 ,
                I_Module_ID2 ,
                CAST(ROUND(ModuleID4FullMarks, 0) AS INT) ModuleID2FullMarks ,
				ModuleID2Weightage,
                CAST(ROUND(I_Exam_Total2, 0) AS INT) I_Exam_Total2 ,
                I_Module_ID3 ,
                CAST(ROUND(ModuleID3FullMarks, 0) AS INT) ModuleID3FullMarks ,
				--ModuleID4Weightage,
                CAST(ROUND(I_Exam_Total3, 0) AS INT) I_Exam_Total3 ,
                I_Module_ID4 ,
                CAST(ROUND(ModuleID4FullMarks, 0) AS INT) ModuleID4FullMarks ,
				ModuleID4Weightage,
                CAST(ROUND(I_Exam_Total4, 0) AS INT) I_Exam_Total4 ,
                CAST(ROUND(TotalMarks, 0) AS INT) TotalMarks ,
                totalGrade ,
                CAST(ROUND(HighestMarks, 0) AS INT) HighestMarks ,
                HighestGrade ,
                classname ,
                REPORT.fnGetStudentAttendanceDetails(I_Student_Detail_ID,
                                                     I_Term_ID, I_Batch_ID) AS Attendance ,
                REPORT.fnGetStudentConductDetails(I_Student_Detail_ID,
                                                  I_Term_ID, I_Batch_ID) AS Conduct ,
                B_Optional,
			  ECM.I_Sequence_No AS I_Exam_Component_Sequence
			   FROM #tblResult AS tr  
			   INNER JOIN T_Exam_Component_Master ECM ON ECM.I_Exam_Component_ID = TR.I_Exam_Component_ID                       
    END
