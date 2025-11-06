CREATE PROCEDURE [REPORT].[uspGetMonthlyExamDetailReport]
    (
      @iBrandID INT ,
      @sHierarchyListID VARCHAR(MAX) ,
      @dtExamDate DATETIME
    )
AS
    BEGIN
    
    
        DECLARE @passThreshhold INT= 40
        DECLARE @Increment INT= 20

        CREATE TABLE #MTEXDTLS
            (
              BrandID INT ,
              BrandName VARCHAR(MAX) ,
              CenterID INT ,
              CenterName VARCHAR(MAX) ,
              CourseID INT ,
              CourseName VARCHAR(MAX) ,
              TermID INT ,
              TermName VARCHAR(MAX) ,
              BatchID INT ,
              BatchName VARCHAR(MAX) ,
              BatchStrength INT ,
              ExamAttendance INT ,
              ExamAttendancePercentage DECIMAL(14, 2) ,
              PassCount INT ,
              PassPercent DECIMAL(14, 2) ,
              LessEqualThreshold INT ,
              GThresholdIncr1 INT ,
              GThresholdIncr2 INT,
              GThresholdIncr3 INT,
              Maths INT,
              GI INT,
              English INT
            )
            
            
        CREATE TABLE #MARKS
            (
              I_Batch_ID INT ,
              I_Term_ID INT,
              I_Student_Detail_ID INT ,
              SubjectName VARCHAR(MAX) ,
              MarksObtained DECIMAL(14, 2) ,
              TotalMarks DECIMAL(14, 2)
            )
            
            
        INSERT  INTO #MTEXDTLS
                ( BrandID ,
                  BrandName ,
                  CenterID ,
                  CenterName ,
                  CourseID ,
                  CourseName ,
                  TermID ,
                  TermName ,
                  BatchID ,
                  BatchName
                )
                SELECT  DISTINCT
                        TCHND.I_Brand_ID ,
                        TCHND.S_Brand_Name ,
                        TCHND.I_Center_ID ,
                        TCHND.S_Center_Name ,
                        TCM.I_Course_ID ,
                        TCM.S_Course_Name ,
                        TTM.I_Term_ID ,
                        TTM.S_Term_Name ,
                        TSBM.I_Batch_ID ,
                        TSBM.S_Batch_Name
                FROM    EXAMINATION.T_Student_Marks AS TSM
                        INNER JOIN EXAMINATION.T_Batch_Exam_Map AS TBEM ON TBEM.I_Batch_Exam_ID = TSM.I_Batch_Exam_ID
                        INNER JOIN dbo.T_Student_Batch_Master AS TSBM ON TSBM.I_Batch_ID = TBEM.I_Batch_ID
                        INNER JOIN dbo.T_Term_Master AS TTM ON TTM.I_Term_ID = TBEM.I_Term_ID
                        INNER JOIN dbo.T_Center_Hierarchy_Name_Details AS TCHND ON TCHND.I_Center_ID = TSM.I_Center_ID
                        INNER JOIN dbo.T_Course_Master AS TCM ON TCM.I_Course_ID = TSBM.I_Course_ID
                WHERE   TBEM.I_Status = 1
                        AND TCHND.I_Center_ID IN (
                        SELECT  FGCFR.centerID
                        FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
                                                           @iBrandID) AS FGCFR )
                        AND TSM.Dt_Exam_Date = @dtExamDate
                        --AND TSBM.I_Batch_ID=8013
                        
                        
                        
        INSERT  INTO #MARKS
                ( I_Batch_ID ,
				I_Term_ID,
                  I_Student_Detail_ID ,
                  SubjectName ,
                  MarksObtained ,
                  TotalMarks
                )
                SELECT  TSBM.I_Batch_ID ,
						TBEM.I_Term_ID,
                        TSM.I_Student_Detail_ID ,
                        TECM.S_Component_Name ,
                        ISNULL(SUM(TSM.I_Exam_Total), 0) AS MarksObtained ,
                        ISNULL(SUM(TTES.I_TotMarks), 0) AS TotalMarks
                FROM    EXAMINATION.T_Student_Marks AS TSM
                        INNER JOIN EXAMINATION.T_Batch_Exam_Map AS TBEM ON TBEM.I_Batch_Exam_ID = TSM.I_Batch_Exam_ID
                        INNER JOIN dbo.T_Student_Batch_Master AS TSBM ON TSBM.I_Batch_ID = TBEM.I_Batch_ID
                        INNER JOIN dbo.T_Exam_Component_Master AS TECM ON TECM.I_Exam_Component_ID = TBEM.I_Exam_Component_ID
                        INNER JOIN dbo.T_Term_Eval_Strategy AS TTES ON TTES.I_Exam_Component_ID = TBEM.I_Exam_Component_ID
                                                              AND TTES.I_Term_ID = TBEM.I_Term_ID
                        INNER JOIN dbo.T_Student_Detail AS TSD ON TSD.I_Student_Detail_ID = TSM.I_Student_Detail_ID
                WHERE   TSM.Dt_Exam_Date = @dtExamDate
                        AND TBEM.I_Status = 1
                        AND TTES.I_Status = 1
                GROUP BY TSBM.I_Batch_ID ,
						TBEM.I_Term_ID,
                        TSM.I_Student_Detail_ID,
                        TECM.S_Component_Name
                
                
        UPDATE  T1
        SET     T1.BatchStrength = T2.StdStrength
        FROM    #MTEXDTLS AS T1
                INNER JOIN ( SELECT B.BatchID ,
                                    B.BatchName ,
                                    COUNT(DISTINCT SABD.I_Student_ID) AS StdStrength
                             FROM   #MTEXDTLS AS B
                                    INNER JOIN dbo.StudentActiveBatchDuration
                                    AS SABD ON B.BatchID = SABD.I_Batch_ID
                             WHERE  @dtExamDate BETWEEN SABD.ActiveFromDate
                                                AND     SABD.ActiveToDate
--AND B.BatchID=7715
GROUP BY                            B.BatchID ,
                                    B.BatchName
                           ) T2 ON T2.BatchID = T1.BatchID 
                   
        UPDATE  T1
        SET     T1.ExamAttendance = T2.AttnCount
        FROM    #MTEXDTLS AS T1
                INNER JOIN ( SELECT TBEM.I_Batch_ID ,TBEM.I_Term_ID,
                                    COUNT(DISTINCT TSM.I_Student_Detail_ID) AS AttnCount
                             FROM   EXAMINATION.T_Student_Marks AS TSM
                                    INNER JOIN EXAMINATION.T_Batch_Exam_Map AS TBEM ON TBEM.I_Batch_Exam_ID = TSM.I_Batch_Exam_ID
                             WHERE  TBEM.I_Status = 1
                                    AND TSM.Dt_Exam_Date = @dtExamDate
                             GROUP BY TBEM.I_Batch_ID,TBEM.I_Term_ID
                           ) T2 ON T1.BatchID = T2.I_Batch_ID AND T1.TermID=T2.I_Term_ID
 
 
        UPDATE  #MTEXDTLS
        SET     ExamAttendancePercentage = ROUND(( ( CAST(ISNULL(ExamAttendance,
                                                              0) AS DECIMAL(14,
                                                              2))
                                                     / CAST(ISNULL(BatchStrength,
                                                              1) AS DECIMAL(14,
                                                              2)) ) * 100 ), 0)
                                                              
                                                              
        UPDATE  T1
        SET     T1.PassCount = T5.PassCount
        FROM    #MTEXDTLS AS T1
                INNER JOIN ( SELECT T4.I_Batch_ID ,T4.I_Term_ID,
                                    COUNT(DISTINCT T4.I_Student_Detail_ID) AS PassCount
                             FROM   ( SELECT    T3.I_Batch_ID ,
												T3.I_Term_ID,
                                                T3.I_Student_Detail_ID ,
                                                ROUND(( CAST(( SUM(ISNULL(T3.MarksObtained,0))
                                                              / SUM(ISNULL(T3.TotalMarks,0)) ) AS DECIMAL(14,
                                                              2)) * 100 ), 0) AS PercentageMarks
                                      FROM      ( SELECT * FROM #MARKS AS M
                                                ) T3
                                                GROUP BY T3.I_Batch_ID ,T3.I_Term_ID,
                                                T3.I_Student_Detail_ID
                                    ) T4
                             WHERE  T4.PercentageMarks >= @passThreshhold
                             GROUP BY T4.I_Batch_ID,T4.I_Term_ID
                           ) T5 ON T1.BatchID = T5.I_Batch_ID AND T1.TermID=T5.I_Term_ID 
                           
                           
        UPDATE  #MTEXDTLS
        SET     PassPercent = ROUND(( ( CAST(ISNULL(PassCount, 0) AS DECIMAL(14,
                                                              2))
                                        / CAST(ISNULL(ExamAttendance, 1) AS DECIMAL(14,
                                                              2)) ) * 100 ), 0)
        
        --SELECT M.I_Batch_ID,M.I_Student_Detail_ID,SUM(ISNULL(M.MarksObtained,0))/SUM(ISNULL(M.TotalMarks,0)) *100 AS PercentMarks FROM #MARKS AS M
        --WHERE
        --M.I_Batch_ID=8013 
        --GROUP BY M.I_Batch_ID,M.I_Student_Detail_ID
        ----ORDER BY M.I_Student_Detail_ID
        
        
        UPDATE T1  
        SET
        T1.LessEqualThreshold=T2.StdCount
        FROM
        #MTEXDTLS AS T1
        INNER JOIN
        (                                                    
        SELECT TX.I_Batch_ID,TX.I_Term_ID,COUNT(DISTINCT TX.I_Student_Detail_ID) AS StdCount FROM
        (                                                                                         
        SELECT M.I_Batch_ID,M.I_Term_ID,M.I_Student_Detail_ID,(SUM(ISNULL(M.MarksObtained,0))/SUM(ISNULL(M.TotalMarks,0)))*100 AS PercentMarks FROM #MARKS AS M 
        GROUP BY M.I_Batch_ID,M.I_Term_ID,M.I_Student_Detail_ID
        ) TX
        WHERE TX.PercentMarks<@passThreshhold
        GROUP BY TX.I_Batch_ID,TX.I_Term_ID
        ) T2 ON T1.BatchID=T2.I_Batch_ID AND T1.TermID=T2.I_Term_ID
        
        
        
        
        UPDATE T1  
        SET
        T1.GThresholdIncr1=T2.StdCount
        FROM
        #MTEXDTLS AS T1
        INNER JOIN
        (                                                    
        SELECT TX.I_Batch_ID,TX.I_Term_ID,COUNT(DISTINCT TX.I_Student_Detail_ID) AS StdCount FROM
        (                                                                                         
        SELECT M.I_Batch_ID,M.I_Term_ID,M.I_Student_Detail_ID,(SUM(ISNULL(M.MarksObtained,0))/SUM(ISNULL(M.TotalMarks,0)))*100 AS PercentMarks FROM #MARKS AS M 
        GROUP BY M.I_Batch_ID,M.I_Term_ID,M.I_Student_Detail_ID
        ) TX
        WHERE (TX.PercentMarks>=@passThreshhold AND TX.PercentMarks<@passThreshhold+10)--40 to 49
        GROUP BY TX.I_Batch_ID,TX.I_Term_ID
        ) T2 ON T1.BatchID=T2.I_Batch_ID AND T1.TermID=T2.I_Term_ID
        
        
        
        UPDATE T1  
        SET
        T1.GThresholdIncr2=T2.StdCount
        FROM
        #MTEXDTLS AS T1
        INNER JOIN
        (                                                    
        SELECT TX.I_Batch_ID,TX.I_Term_ID,COUNT(DISTINCT TX.I_Student_Detail_ID) AS StdCount FROM
        (                                                                                         
        SELECT M.I_Batch_ID,M.I_Term_ID,M.I_Student_Detail_ID,(SUM(ISNULL(M.MarksObtained,0))/SUM(ISNULL(M.TotalMarks,0)))*100 AS PercentMarks FROM #MARKS AS M 
        GROUP BY M.I_Batch_ID,M.I_Term_ID,M.I_Student_Detail_ID
        ) TX
        --WHERE (TX.PercentMarks>=@passThreshhold+@Increment)
        WHERE (TX.PercentMarks>=@passThreshhold+10 AND TX.PercentMarks<@passThreshhold+@Increment)--50 to 59
        GROUP BY TX.I_Batch_ID,TX.I_Term_ID
        ) T2 ON T1.BatchID=T2.I_Batch_ID AND T1.TermID=T2.I_Term_ID 
        
        
        UPDATE T1  
        SET
        T1.GThresholdIncr3=T2.StdCount
        FROM
        #MTEXDTLS AS T1
        INNER JOIN
        (                                                    
        SELECT TX.I_Batch_ID,TX.I_Term_ID,COUNT(DISTINCT TX.I_Student_Detail_ID) AS StdCount FROM
        (                                                                                         
        SELECT M.I_Batch_ID,M.I_Term_ID,M.I_Student_Detail_ID,(SUM(ISNULL(M.MarksObtained,0))/SUM(ISNULL(M.TotalMarks,0)))*100 AS PercentMarks FROM #MARKS AS M 
        GROUP BY M.I_Batch_ID,M.I_Term_ID,M.I_Student_Detail_ID
        ) TX
        WHERE (TX.PercentMarks>=@passThreshhold+@Increment)-->60
        --WHERE (TX.PercentMarks>=@passThreshhold+10 AND TX.PercentMarks<@passThreshhold+@Increment)--50 to 59
        GROUP BY TX.I_Batch_ID,TX.I_Term_ID
        ) T2 ON T1.BatchID=T2.I_Batch_ID  AND T1.TermID=T2.I_Term_ID
        
        
        
        
        UPDATE T1  
        SET
        T1.English=T2.StdCount
        FROM
        #MTEXDTLS AS T1
        INNER JOIN
        (                                                    
        SELECT TX.I_Batch_ID,TX.I_Term_ID,COUNT(DISTINCT TX.I_Student_Detail_ID) AS StdCount FROM
        (                                                                                         
        SELECT M.I_Batch_ID,M.I_Term_ID,M.I_Student_Detail_ID,(SUM(ISNULL(M.MarksObtained,0))/SUM(ISNULL(M.TotalMarks,0)))*100 AS PercentMarks FROM #MARKS AS M
        WHERE
        M.SubjectName='English' 
        GROUP BY M.I_Batch_ID,M.I_Term_ID,M.I_Student_Detail_ID
        ) TX
        WHERE (TX.PercentMarks>=@passThreshhold)
        GROUP BY TX.I_Batch_ID,TX.I_Term_ID
        ) T2 ON T1.BatchID=T2.I_Batch_ID  AND T1.TermID=T2.I_Term_ID
        
        
        
        UPDATE T1  
        SET
        T1.Maths=T2.StdCount
        FROM
        #MTEXDTLS AS T1
        INNER JOIN
        (                                                    
        SELECT TX.I_Batch_ID,TX.I_Term_ID,COUNT(DISTINCT TX.I_Student_Detail_ID) AS StdCount FROM
        (                                                                                         
        SELECT M.I_Batch_ID,M.I_Term_ID,M.I_Student_Detail_ID,(SUM(ISNULL(M.MarksObtained,0))/SUM(ISNULL(M.TotalMarks,0)))*100 AS PercentMarks FROM #MARKS AS M
        WHERE
        M.SubjectName='Mathematics' 
        GROUP BY M.I_Batch_ID,M.I_Term_ID,M.I_Student_Detail_ID
        ) TX
        WHERE (TX.PercentMarks>=@passThreshhold)
        GROUP BY TX.I_Batch_ID,TX.I_Term_ID
        ) T2 ON T1.BatchID=T2.I_Batch_ID AND T1.TermID=T2.I_Term_ID 
        
        
        
        UPDATE T1  
        SET
        T1.GI=T2.StdCount
        FROM
        #MTEXDTLS AS T1
        INNER JOIN
        (                                                    
        SELECT TX.I_Batch_ID,TX.I_Term_ID,COUNT(DISTINCT TX.I_Student_Detail_ID) AS StdCount FROM
        (                                                                                         
        SELECT M.I_Batch_ID,M.I_Term_ID,M.I_Student_Detail_ID,(SUM(ISNULL(M.MarksObtained,0))/SUM(ISNULL(M.TotalMarks,0)))*100 AS PercentMarks FROM #MARKS AS M
        WHERE
        M.SubjectName='General Intelligence' 
        GROUP BY M.I_Batch_ID,M.I_Term_ID,M.I_Student_Detail_ID
        ) TX
        WHERE (TX.PercentMarks>=@passThreshhold)
        GROUP BY TX.I_Batch_ID,TX.I_Term_ID
        ) T2 ON T1.BatchID=T2.I_Batch_ID AND T1.TermID=T2.I_Term_ID    
        
        
        
        
        
                
        SELECT  *
        FROM    #MTEXDTLS AS M  
        
        --SELECT * FROM #MARKS AS M                                          



    END
