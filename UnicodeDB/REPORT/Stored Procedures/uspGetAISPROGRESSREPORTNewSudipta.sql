CREATE PROCEDURE [REPORT].[uspGetAISPROGRESSREPORTNewSudipta] 
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
            @sStudentID VARCHAR(250) , 
            @t1 INT= 0 ,--Akash 
            @t2 INT= 0 ,--Akash 
            @t3 INT= NULL--Akash 

        SELECT  @iCourseID = tsbm.I_Course_ID , 
                @sBatchName = tsbm.S_Batch_Name , 
                @sCourierName = tcm.S_Course_Name , 
                @sClass = tcm.s_course_desc 
        FROM    dbo.T_Student_Batch_Master AS tsbm 
                INNER JOIN T_Course_Master tcm ON tcm.I_Course_ID = tsbm.I_Course_ID 
        WHERE   tsbm.I_Batch_ID = @iBatchID 

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
              ModuleID1Marks NUMERIC(8, 2) , 
              ModuleID2 INT , 
              ModuleID2Marks NUMERIC(8, 2) , 
              ModuleID3 INT , 
              ModuleID3Marks NUMERIC(8, 2) , 
              ModuleID4 INT , 
              ModuleID4Marks NUMERIC(8, 2) , 
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
              I_Exam_Component_ID INT , 
              S_Exam_Component_Name VARCHAR(200) , 
              I_Module_ID1 INT , 
              ModuleID1FullMarks INT , 
              I_Exam_Total1 NUMERIC(8, 2) , 
              I_Module_ID2 INT , 
              ModuleID2FullMarks INT , 
              I_Exam_Total2 NUMERIC(8, 2) , 
              I_Module_ID3 INT , 
              ModuleID3FullMarks INT , 
              I_Exam_Total3 NUMERIC(8, 2) , 
              I_Module_ID4 INT , 
              ModuleID4FullMarks INT , 
              I_Exam_Total4 NUMERIC(8, 2) , 
              TotalMarks NUMERIC(8, 2) , 
              totalGrade VARCHAR(5) , 
              HighestMarks NUMERIC(8, 2) , 
              HighestGrade VARCHAR(5) , 
              classname VARCHAR(15) , 
              Term1TotalMarks NUMERIC(8, 2) , 
              Term2TotalMarks NUMERIC(8, 2) , 
              Term3TotalMarks NUMERIC(8, 2) , 
              Cum1 NUMERIC(8, 2) , 
              cum2 NUMERIC(8, 2) , 
              cum3 NUMERIC(8, 2) , 
              cumTotal NUMERIC(8, 2) ,
              Cum40 NUMERIC(8, 2) , 
              cum60 NUMERIC(8, 2) ,
              cum4060Total NUMERIC(8, 2) , 
              --cum3 NUMERIC(8, 2) , 
              T2M1 NUMERIC(8, 2) , 
              T2M2 NUMERIC(8, 2) , 
              T2M3 NUMERIC(8, 2) , 
              T2M4 NUMERIC(8, 2) , 
              TermOne NUMERIC(8, 2) , 
              totalgradeT1 VARCHAR(5) , 
              totalgradeT2 VARCHAR(5) , 
              B_Optional BIT , 
              I_term_sequence INT,
              ExamComponentSeq INT 
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
                  I_Exam_Component_ID , 
                  S_Exam_Component_Name , 
                  classname , 
                  B_Optional , 
                  I_term_sequence,
                  ExamComponentSeq 
                ) 
                SELECT DISTINCT 
                        tsd.I_Student_Detail_ID , 
                        TSD.S_Student_ID , 
                        TSD.S_First_Name + ' ' + ISNULL(TSD.S_Middle_Name, '') 
                        + ' ' + TSD.S_Last_Name StudentName , 
                        @iCourseID , 
                        @sCourierName , 
                        @iBatchID , 
                        @sBatchName , 
                        TBEM.I_Term_ID , 
                        TTM.S_Term_Name , 
                        TBEM.I_Exam_Component_ID , 
                        tecm.S_Component_Name , 
                        @sClass , 
                        tbem.B_Optional , 
                        TCM.I_Sequence,
                        tecm.I_Sequence_No 
                FROM    EXAMINATION.T_Batch_Exam_Map AS tbem WITH ( NOLOCK ) 
                        INNER JOIN EXAMINATION.T_Student_Marks TSM WITH ( NOLOCK ) ON tsm.I_Batch_Exam_ID = tbem.I_Batch_Exam_ID 
                        INNER JOIN dbo.T_Student_Detail AS tsd WITH ( NOLOCK ) ON tsm.I_Student_Detail_ID = tsd.I_Student_Detail_ID 
                        INNER JOIN dbo.T_Student_Batch_Details TSBD WITH ( NOLOCK ) ON TSD.I_Student_Detail_ID = TSBD.I_Student_ID 
                                                              AND TSBD.I_Status IN ( 
                                                              1, 2 ) 
  --- 
                        INNER JOIN dbo.T_Student_Batch_Details TSBD1 WITH ( NOLOCK ) ON TSD.I_Student_Detail_ID = TSBD1.I_Student_ID 
                                                              AND TSBD1.I_Status IN ( 
                                                              1, 2, 0 ) 
                                                              AND tsbd1.I_Batch_ID = tbem.I_Batch_ID 
                        INNER JOIN dbo.T_Student_Batch_Master SBM WITH ( NOLOCK ) ON TSBD1.I_Batch_ID = SBM.I_Batch_ID 
                                                              AND SBM.I_Course_ID = @iCourseID 
                                                              AND SBM.I_Status = 2 
  -- 
                        INNER JOIN dbo.T_Term_Master TTM WITH ( NOLOCK ) ON TBEM.I_Term_ID = TTM.I_Term_ID 
  -- 
                        INNER JOIN ( SELECT I_Term_ID , 
                                            ROW_NUMBER() OVER ( PARTITION BY I_Course_ID ORDER BY I_Sequence ) I_Sequence 
                                     FROM   dbo.T_Term_Course_Map WITH ( NOLOCK ) 
                                     WHERE  I_Course_ID = @iCourseID 
                                            AND I_Status = 1 
                                   ) TCM ON TCM.I_Term_ID = TTM.I_Term_ID 
  -- 
                        INNER JOIN dbo.T_Exam_Component_Master AS tecm WITH ( NOLOCK ) ON TBEM.I_Exam_Component_ID = tecm.I_Exam_Component_ID 
                WHERE   TSBD.I_Batch_ID = @iBatchID 
                        AND tbem.I_Term_ID = ISNULL(@iTermID, tbem.I_Term_ID) 
                        AND TSM.I_Student_Detail_ID = ISNULL(@istudentid, 
                                                             TSM.I_Student_Detail_ID) 
                ORDER BY tsd.I_Student_Detail_ID ,tecm.I_Sequence_No, 
                        TBEM.I_Exam_Component_ID 
  
  
  --Update #tblResult SET I_Exam_Total1=isnull(I_Exam_Total1,0)+isnull(I_Exam_Total2,0)+isnull(I_Exam_Total3,0) 
  --  where   I_Exam_Component_ID =24 
    
  --Update #tblResult SET I_Exam_Total2 =null,I_Exam_Total3=NULL 
  --  where   I_Exam_Component_ID =24 
  
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
                  ModuleID1Marks , 
                  ModuleID2 , 
                  ModuleID2Marks , 
                  ModuleID3 , 
                  ModuleID3Marks , 
                  ModuleID4 , 
                  ModuleID4Marks 
                          
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
                        CASE WHEN tmtm.I_Sequence = 1 THEN TBEM.I_Module_ID 
                             ELSE NULL 
                        END ModuleID1 , 
                        CASE WHEN tmtm.I_Sequence = 1 THEN TSM.I_Exam_Total 
                             ELSE NULL 
                        END ModuleID1Marks , 
                        CASE WHEN tmtm.I_Sequence = 2 THEN TBEM.I_Module_ID 
                             ELSE NULL 
                        END ModuleID2 , 
                        CASE WHEN tmtm.I_Sequence = 2 THEN TSM.I_Exam_Total 
                             ELSE NULL 
                        END ModuleID2Marks , 
                        CASE WHEN tmtm.I_Sequence = 3 THEN TBEM.I_Module_ID 
                             ELSE NULL 
                        END ModuleID3 , 
                        CASE WHEN tmtm.I_Sequence = 3 THEN TSM.I_Exam_Total 
                             ELSE NULL 
                        END ModuleID3Marks , 
                        CASE WHEN tmtm.I_Sequence = 4 THEN TBEM.I_Module_ID 
                             ELSE NULL 
                        END ModuleID4 , 
                        CASE WHEN tmtm.I_Sequence = 4 THEN TSM.I_Exam_Total 
                             ELSE NULL 
                        END ModuleID4Marks 
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
                WHERE   ttcm.I_Course_ID = @iCourseID 
  
  
  
  --select * from #tbltempResult 
  
        UPDATE  T 
        SET     I_Module_ID1 = V.ModuleID1 , 
                I_Exam_Total1 = V.ModuleID1Marks 
        FROM    #tblResult T 
                INNER JOIN #tbltempResult V ON T.I_Course_ID = V.I_Course_ID 
                                               AND T.I_Term_ID = V.I_Term_ID 
                                               AND T.I_Student_Detail_ID = V.I_Student_Detail_ID 
                                               AND T.I_Exam_Component_ID = V.I_Exam_Component_ID 
                                               AND V.GradeSequence = 1 
                                               --AND T.I_Batch_ID = V.I_Batch_ID 
            
  
        UPDATE  T 
        SET     I_Module_ID2 = V.ModuleID2 , 
                I_Exam_Total2 = V.ModuleID2Marks 
        FROM    #tblResult T 
                INNER JOIN #tbltempResult V ON T.I_Course_ID = V.I_Course_ID 
                                               AND T.I_Term_ID = V.I_Term_ID 
                                               AND T.I_Student_Detail_ID = V.I_Student_Detail_ID 
                                               AND T.I_Exam_Component_ID = V.I_Exam_Component_ID 
                                               AND V.GradeSequence = 2 
                                               --AND T.I_Batch_ID = V.I_Batch_ID 
                          
        UPDATE  T 
        SET     I_Module_ID3 = V.ModuleID3 , 
                I_Exam_Total3 = V.ModuleID3Marks 
        FROM    #tblResult T 
                INNER JOIN #tbltempResult V ON T.I_Course_ID = V.I_Course_ID 
                                               AND T.I_Term_ID = V.I_Term_ID 
                                               AND T.I_Student_Detail_ID = V.I_Student_Detail_ID 
                                               AND T.I_Exam_Component_ID = V.I_Exam_Component_ID 
                                               AND V.GradeSequence = 3 
                                              -- AND T.I_Batch_ID = V.I_Batch_ID 
                          
        UPDATE  T 
        SET     I_Module_ID4 = V.ModuleID4 , 
                I_Exam_Total4 = V.ModuleID4Marks 
        FROM    #tblResult T 
                INNER JOIN #tbltempResult V ON T.I_Course_ID = V.I_Course_ID 
                                               AND T.I_Term_ID = V.I_Term_ID 
                                               AND T.I_Student_Detail_ID = V.I_Student_Detail_ID 
                                               AND T.I_Exam_Component_ID = V.I_Exam_Component_ID 
                                               AND V.GradeSequence = 4 
                                               --AND T.I_Batch_ID = V.I_Batch_ID 
  
          
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
  
  
     --Akash Modifications 
      
        
        UPDATE  #tblResult 
        SET     Term1TotalMarks = ROUND(ISNULL(I_Exam_Total1, 0), 0) 
                + ROUND(ISNULL(I_Exam_Total2, 0), 0) 
                + ROUND(ISNULL(I_Exam_Total3, 0), 0) 
                + ROUND(ISNULL(I_Exam_Total4, 0), 0) 
        WHERE   I_term_sequence = 1 --I_Term_ID=@t1--(select distinct I_Term_ID from (select ROW_NUMBER() over (order by I_Term_ID asc) as rownumber,I_Term_ID from #tblResult)as foo1 
      --where rownumber=1) 
        UPDATE  #tblResult 
        SET     Term1TotalMarks = NULL 
        WHERE   I_Exam_Total1 IS NULL 
                AND I_Exam_Total2 IS NULL 
                AND I_Exam_Total3 IS NULL 
                AND I_Exam_Total4 IS NULL 
  
        UPDATE  #tblResult 
        SET     Term2TotalMarks = ROUND(ISNULL(I_Exam_Total1, 0), 0) 
                + ROUND(ISNULL(I_Exam_Total2, 0), 0) 
                + ROUND(ISNULL(I_Exam_Total3, 0), 0) 
                + ROUND(ISNULL(I_Exam_Total4, 0), 0) 
        WHERE   I_term_sequence = 2--I_Term_ID=@t2--(select distinct I_Term_ID from (select ROW_NUMBER() over (order by I_Term_ID asc) as rownumber,I_Term_ID from #tblResult)as foo2 
      --where rownumber=2) 
        UPDATE  #tblResult 
        SET     Term2TotalMarks = NULL 
        WHERE   I_Exam_Total1 IS NULL 
                AND I_Exam_Total2 IS NULL 
                AND I_Exam_Total3 IS NULL 
                AND I_Exam_Total4 IS NULL 
  
        UPDATE  #tblResult 
        SET     Term3TotalMarks = ROUND(ISNULL(I_Exam_Total1, 0), 0) 
                + ROUND(ISNULL(I_Exam_Total2, 0), 0) 
                + ROUND(ISNULL(I_Exam_Total3, 0), 0) 
                + ROUND(ISNULL(I_Exam_Total4, 0), 0) 
        WHERE   I_term_sequence = 3--I_Term_ID=@t3--(select distinct I_Term_ID from (select ROW_NUMBER() over (order by I_Term_ID asc) as rownumber,I_Term_ID from #tblResult)as foo3 
    --  where rownumber=3) 
        UPDATE  #tblResult 
        SET     Term3TotalMarks = NULL 
        WHERE   I_Exam_Total1 IS NULL 
                AND I_Exam_Total2 IS NULL 
                AND I_Exam_Total3 IS NULL 
                AND I_Exam_Total4 IS NULL 
  
        UPDATE  #tblResult 
        SET     TermOne = #tblResult.Term1TotalMarks         
        
        UPDATE  #tblResult 
        SET     Cum1 = ROUND(0.3 * ISNULL(Term1TotalMarks, 0), 0) 
        UPDATE  #tblResult 
        SET     Cum1 = NULL 
        WHERE   Term1TotalMarks IS NULL 
    
        UPDATE  #tblResult 
        SET     cum2 = ROUND(0.2 * ISNULL(Term2TotalMarks, 0), 0) 
        UPDATE  #tblResult 
        SET     cum2 = NULL 
        WHERE   Term2TotalMarks IS NULL
        
        --akash 2.3.2016
        UPDATE  #tblResult 
        SET     Cum40 = ROUND(0.4 * ISNULL(Term1TotalMarks, 0), 0) 
        UPDATE  #tblResult 
        SET     Cum40 = NULL 
        WHERE   Term1TotalMarks IS NULL 
    
        UPDATE  #tblResult 
        SET     cum60 = ROUND(0.6 * ISNULL(Term2TotalMarks, 0), 0) 
        UPDATE  #tblResult 
        SET     cum60 = NULL 
        WHERE   Term2TotalMarks IS NULL
        
        UPDATE  #tblResult 
        SET     cum4060Total = ROUND(ISNULL(Cum40, 0), 0) + ROUND(ISNULL(cum60, 0), 
                                                             0) 
                --+ ROUND(ISNULL(cum3, 0), 0) 
        --akash 2.3.2016 
    
        UPDATE  #tblResult 
        SET     cum3 = ROUND(0.5 * ISNULL(Term3TotalMarks, 0), 0) 
        UPDATE  #tblResult 
        SET     cum3 = NULL 
        WHERE   Term3TotalMarks IS NULL 
    
        UPDATE  #tblResult 
        SET     cumTotal = ROUND(ISNULL(Cum1, 0), 0) + ROUND(ISNULL(cum2, 0), 
                                                             0) 
                + ROUND(ISNULL(cum3, 0), 0) 
    
        UPDATE  #tblResult 
        SET     T2M1 = ROUND(ISNULL(I_Exam_Total1, 0), 0) 
        WHERE   I_term_sequence = 2 
        UPDATE  #tblResult 
        SET     T2M1 = NULL 
        WHERE   I_Exam_Total1 IS NULL 
                AND I_term_sequence = 2 
    
        UPDATE  #tblResult 
        SET     T2M2 = ROUND(ISNULL(I_Exam_Total2, 0), 0) 
        WHERE   I_term_sequence = 2 
        UPDATE  #tblResult 
        SET     T2M2 = NULL 
        WHERE   I_Exam_Total2 IS NULL 
                AND I_term_sequence = 2 
    
        UPDATE  #tblResult 
        SET     T2M3 = ROUND(ISNULL(I_Exam_Total3, 0), 0) 
        WHERE   I_term_sequence = 2 
        UPDATE  #tblResult 
        SET     T2M3 = NULL 
        WHERE   I_Exam_Total3 IS NULL 
                AND I_term_sequence = 2 
    
        UPDATE  #tblResult 
        SET     T2M4 = ROUND(ISNULL(I_Exam_Total4, 0), 0) 
        WHERE   I_term_sequence = 2 
        UPDATE  #tblResult 
        SET     T2M4 = NULL 
        WHERE   I_Exam_Total4 IS NULL 
                AND I_term_sequence = 2 
    
    
    ---Akash modifications 
          
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
                                                SUM(ROUND(ISNULL(I_Exam_Total, 
                                                              0), 0)) Marks 
                                      FROM      EXAMINATION.T_Student_Marks AS tsm 
                                                WITH ( NOLOCK ) 
                                                INNER JOIN EXAMINATION.T_Batch_Exam_Map tbem 
                                                WITH ( NOLOCK ) ON tbem.I_Batch_Exam_ID = tsm.I_Batch_Exam_ID 
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
          
          
              
    --Update #tblResult SET  I_Exam_Total1 =null,I_Exam_Total2 =null,I_Exam_Total3=NULL,I_Exam_Total4=NULL WHERE B_Optional = 1 


        IF ( UPPER(RTRIM(LTRIM(@sClass))) = UPPER('Class 9') 
             OR UPPER(RTRIM(LTRIM(@sClass))) = UPPER('Class 12') 
             OR UPPER(RTRIM(LTRIM(@sClass))) = UPPER('Class 10') 
             OR UPPER(RTRIM(LTRIM(@sClass))) = UPPER('Class 11') 
           ) 
            BEGIN 
    
                ------Update #tblResult SET  I_Exam_Total1 =null,I_Exam_Total2 =null,I_Exam_Total3=NULL,I_Exam_Total4=NULL 
                ------where   I_Exam_Component_ID IN (25,46) 
                    
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
                WHERE   I_Exam_Component_ID IN ( 25, 46 , 59) 
                UPDATE  #tblResult 
                SET     totalGrade = 'A+' 
                WHERE   CAST(ROUND(TotalMarks, 0) AS INT) = 100 
                        AND I_Exam_Component_ID IN ( 25, 46 , 59 ) 
                UPDATE  #tblResult 
                SET     HighestGrade = ( SELECT Grade 
                                         FROM   #tblGradeMst 
                                         WHERE  CAST(ROUND(HighestMarks, 0) AS INT) >= FromMarks 
                                                AND CAST(ROUND(HighestMarks, 0) AS INT) < ToMarks 
                                       ) 
                WHERE   I_Exam_Component_ID IN ( 25, 46 ,59 ) 
                                
                                --Akash Modifications 
                                
                UPDATE  #tblResult 
                SET     totalgradeT1 = ( SELECT Grade 
                                         FROM   #tblGradeMst 
                                         WHERE  CAST(ROUND(Term1TotalMarks, 0) AS INT) >= FromMarks 
                                                AND CAST(ROUND(Term1TotalMarks, 
                                                              0) AS INT) < ToMarks 
                                       ) 
                WHERE   I_Exam_Component_ID IN ( 25, 46 ,59 ) 
                        AND I_Term_ID = @t1 
                UPDATE  #tblResult 
                SET     totalgradeT1 = 'A+' 
                WHERE   CAST(ROUND(Term1TotalMarks, 0) AS INT) = 100 
                        AND I_Exam_Component_ID IN ( 25, 46 ,59 ) 
                        AND I_Term_ID = @t1 
                                
                                
                UPDATE  #tblResult 
                SET     totalgradeT2 = ( SELECT Grade 
                                         FROM   #tblGradeMst 
                                         WHERE  CAST(ROUND(Term2TotalMarks, 0) AS INT) >= FromMarks 
                                                AND CAST(ROUND(Term2TotalMarks, 
                                                              0) AS INT) < ToMarks 
                                       ) 
                WHERE   I_Exam_Component_ID IN ( 25, 46 ,59  ) 
                        AND I_Term_ID = @t2 
                UPDATE  #tblResult 
                SET     totalgradeT2 = 'A+' 
                WHERE   CAST(ROUND(Term2TotalMarks, 0) AS INT) = 100 
                        AND I_Exam_Component_ID IN ( 25, 46 ,59 ) 
                        AND I_Term_ID = @t2 
                
                                
                                --Akash Modifications 
    
                UPDATE  #tblResult 
                SET     HighestGrade = 'A+' 
                WHERE   CAST(ROUND(HighestMarks, 0) AS INT) = 100 
                        AND I_Exam_Component_ID IN ( 25, 46 ,59 ) 
                
                UPDATE  #tblResult 
                SET     I_Exam_Total1 = 0 , 
                        TotalMarks = 0 
                WHERE   I_Exam_Component_ID IN ( 25, 46,59 ) 
                UPDATE  #tblResult 
                SET     I_Exam_Total1 = 0 , 
                        Term1TotalMarks = 0 
                WHERE   I_Exam_Component_ID IN ( 25, 46,59 ) 
                UPDATE  #tblResult 
                SET     I_Exam_Total1 = 0 , 
                        Term2TotalMarks = 0 
                WHERE   I_Exam_Component_ID IN ( 25, 46,59 ) 
                UPDATE  #tblResult 
                SET     I_Exam_Total1 = 0 , 
                        Term3TotalMarks = 0 
                WHERE   I_Exam_Component_ID IN ( 25, 46 ,59) 

            END 
        SELECT  I_Student_Detail_ID , 
                S_Student_ID , 
                S_Student_Name , 
                tr.I_Course_ID , 
                S_Course_Name , 
                I_Batch_ID , 
                S_Batch_Name , 
                I_Term_ID , 
                S_Term_Name , 
                tr.I_Exam_Component_ID , 
                S_Exam_Component_Name , 
                I_Module_ID1 , 
                CAST(ROUND(ModuleID1FullMarks, 0) AS INT) ModuleID1FullMarks , 
                CAST(ROUND(I_Exam_Total1, 0) AS INT) I_Exam_Total1 , 
                I_Module_ID2 , 
                CAST(ROUND(ModuleID4FullMarks, 0) AS INT) ModuleID2FullMarks , 
                CAST(ROUND(I_Exam_Total2, 0) AS INT) I_Exam_Total2 , 
                I_Module_ID3 , 
                CAST(ROUND(ModuleID3FullMarks, 0) AS INT) ModuleID3FullMarks , 
                CAST(ROUND(I_Exam_Total3, 0) AS INT) I_Exam_Total3 , 
                I_Module_ID4 , 
                CAST(ROUND(ModuleID4FullMarks, 0) AS INT) ModuleID4FullMarks , 
                CAST(ROUND(I_Exam_Total4, 0) AS INT) I_Exam_Total4 , 
                CAST(ROUND(TotalMarks, 0) AS INT) TotalMarks , 
                CAST(ROUND(Term1TotalMarks, 0) AS INT) Term1TotalMarks , 
                CAST(ROUND(Term2TotalMarks, 0) AS INT) Term2TotalMarks , 
                CAST(ROUND(Term3TotalMarks, 0) AS INT) Term3TotalMarks , 
                CAST(ROUND(Cum1, 0) AS INT) Cumulative1 , 
                CAST(ROUND(cum2, 0) AS INT) Cumulative2 , 
                CAST(ROUND(cum3, 0) AS INT) Cumulative3 , 
                CAST(ROUND(cumTotal, 0) AS INT) CumulativeTotal ,
                --akash 2.3.2016
                CAST(ROUND(Cum40, 0) AS INT) Cumulative40 , 
                CAST(ROUND(cum60, 0) AS INT) Cumulative60 ,
                CAST(ROUND(cum4060Total, 0) AS INT) Cumulative4060Total ,
                --akash 2.3.2016 
                CAST(ROUND(T2M1, 0) AS INT) T2M1 , 
                CAST(ROUND(T2M2, 0) AS INT) T2M2 , 
                CAST(ROUND(T2M3, 0) AS INT) T2M3 , 
                CAST(ROUND(T2M4, 0) AS INT) T2M4 , 
                CAST(ROUND(TermOne, 0) AS INT) TermOne , 
                totalGrade , 
                totalgradeT1 , 
                totalgradeT2 , 
                CAST(ROUND(HighestMarks, 0) AS INT) HighestMarks , 
                HighestGrade , 
                classname , 
                REPORT.fnGetStudentAttendanceDetails(I_Student_Detail_ID, 
                                                     I_Term_ID, I_Batch_ID) AS Attendance , 
                REPORT.fnGetStudentConductDetails(I_Student_Detail_ID, 
                                                  I_Term_ID, I_Batch_ID) AS Conduct , 
                B_Optional , 
                I_term_sequence,
			  ECM.I_Sequence_No AS I_Exam_Component_Sequence
			   FROM #tblResult AS tr  
			   INNER JOIN T_Exam_Component_Master ECM ON ECM.I_Exam_Component_ID = TR.I_Exam_Component_ID     
        ORDER BY I_Term_ID DESC --added to get the highestmasrks and attendance                         
    END
