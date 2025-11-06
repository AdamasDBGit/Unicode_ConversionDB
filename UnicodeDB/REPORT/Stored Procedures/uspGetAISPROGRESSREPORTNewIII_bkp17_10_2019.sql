
--exec [REPORT].[uspGetAISPROGRESSREPORTNew] 758,null,null
CREATE PROCEDURE [REPORT].[uspGetAISPROGRESSREPORTNewIII_bkp17_10_2019]
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
              I_Sequence INT,
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
                        INNER JOIN dbo.T_Exam_Component_Master AS tecm WITH ( NOLOCK ) ON tbem.I_Exam_Component_ID = tecm.I_Exam_Component_ID
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
                        INNER JOIN dbo.T_Exam_Component_Master AS tecm WITH ( NOLOCK ) ON TBEM.I_Exam_Component_ID = tecm.I_Exam_Component_ID
                        INNER JOIN dbo.T_Module_Master AS tmm WITH ( NOLOCK ) ON TBEM.I_Module_ID = tmm.I_Module_ID
                        INNER JOIN dbo.T_Module_Term_Map AS tmtm WITH ( NOLOCK ) ON TBEM.I_Module_ID = tmtm.I_Module_ID
                                                              AND TBEM.I_Term_ID = tmtm.I_Term_ID
                                                              AND tmtm.I_Status = 1
                        INNER JOIN dbo.T_Term_Course_Map AS ttcm WITH ( NOLOCK ) ON tmtm.I_Term_ID = ttcm.I_Term_ID
                                                              AND ttcm.I_Status = 1
                        INNER JOIN dbo.T_Student_Batch_Master tsbm WITH ( NOLOCK ) ON tsbm.I_Batch_ID = TBEM.I_Batch_ID
                        INNER JOIN #tblResult A ON TSM.I_Student_Detail_ID = A.I_Student_Detail_ID
                        WHERE
						tmm.S_Module_Name NOT LIKE '%ADCHK%'
  
  
 
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
                                                SUM(ROUND(ISNULL(I_Exam_Total,
                                                              0), 0)) Marks
                                      FROM      EXAMINATION.T_Student_Marks AS tsm
                                                WITH ( NOLOCK )
                                                INNER JOIN EXAMINATION.T_Batch_Exam_Map tbem
                                                WITH ( NOLOCK ) ON tbem.I_Batch_Exam_ID = tsm.I_Batch_Exam_ID
                                                INNER JOIN dbo.T_Student_Batch_Details
                                                AS tsbd ON tsbd.I_Batch_ID = tbem.I_Batch_ID
                                                           AND tsbd.I_Student_ID = tsm.I_Student_Detail_ID
                                                           AND tsbd.I_Status IN (
                                                           1, 2 )
                                                INNER JOIN dbo.T_Student_Batch_Master tsbm
                                                WITH ( NOLOCK ) ON tsbm.I_Batch_ID = tbem.I_Batch_ID
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
                                                INNER JOIN dbo.T_Module_Master AS TMM WITH (NOLOCK) ON TMM.I_Module_ID = tbem.I_Module_ID AND TMM.I_Module_ID = tmtm.I_Module_ID
                                                WHERE
                                                tsbm.I_Course_ID=@iCourseID
												AND TMM.S_Module_Name NOT LIKE '%ADCHK%'
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
                I_Course_ID ,
                S_Course_Name ,
                I_Batch_ID ,
                S_Batch_Name ,
                I_Term_ID ,
                S_Term_Name ,
                I_Exam_Component_ID ,
                S_Exam_Component_Name ,
                tr.I_Sequence,
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
                totalGrade ,
                CAST(ROUND(HighestMarks, 0) AS INT) HighestMarks ,
                HighestGrade ,
                classname ,
                REPORT.fnGetStudentAttendanceDetails(I_Student_Detail_ID,
                                                     I_Term_ID, I_Batch_ID) AS Attendance ,
                REPORT.fnGetStudentConductDetails(I_Student_Detail_ID,
                                                  I_Term_ID, I_Batch_ID) AS Conduct ,
                B_Optional
        FROM    #tblResult AS tr                        
    END
