CREATE PROCEDURE [REPORT].[uspGetBatchPerformanceAnalysisReport] --1718/RICE/6437
    (
      @iBrandID INT ,
      @sHierarchyListID VARCHAR(MAX) ,
      @dtStartDate DATETIME ,
      @dtEndDate DATETIME ,
      @sBatchList VARCHAR(MAX) = NULL ,
      @sStudentID VARCHAR(MAX) = NULL
    )
AS
    BEGIN


        CREATE TABLE #BATCHDTLS
            (
              CentreID INT ,
              CenterName VARCHAR(MAX) ,
              CourseID INT ,
              CourseName VARCHAR(MAX) ,
              BatchID INT ,
              BatchName VARCHAR(MAX) ,
              StudentDetID INT ,
              StudentID VARCHAR(MAX) ,
              StudentName VARCHAR(MAX) ,
              RollNo INT ,
              MPercentage DECIMAL(14, 2) ,
              APercentage DECIMAL(14, 2) ,
              HPercentage DECIMAL(14, 2)
            )


        IF ( @sStudentID IS NULL
             OR @sStudentID = ' '
             --OR @sStudentID NOT LIKE '%RICE%'
           )
            BEGIN

                IF ( @sBatchList IS NULL )
                    BEGIN
                    
                        INSERT  INTO #BATCHDTLS
                                ( CentreID ,
                                  CenterName ,
                                  CourseID ,
                                  CourseName ,
                                  BatchID ,
                                  BatchName ,
                                  StudentDetID ,
                                  StudentID ,
                                  StudentName ,
                                  RollNo
						        )
                                SELECT  TCHND.I_Center_ID ,
                                        TCHND.S_Center_Name ,
                                        TCM.I_Course_ID ,
                                        TCM.S_Course_Name ,
                                        TSBM.I_Batch_ID ,
                                        TSBM.S_Batch_Name ,
                                        TSD.I_Student_Detail_ID ,
                                        TSD.S_Student_ID ,
                                        TSD.S_First_Name + ' '
                                        + ISNULL(TSD.S_Middle_Name, '') + ' '
                                        + TSD.S_Last_Name AS StudentName ,
                                        TSD.I_RollNo
                                FROM    dbo.T_Student_Batch_Master AS TSBM
                                        INNER JOIN dbo.T_Student_Batch_Details
                                        AS TSBD ON TSBD.I_Batch_ID = TSBM.I_Batch_ID
                                        INNER JOIN dbo.T_Student_Detail AS TSD ON TSD.I_Student_Detail_ID = TSBD.I_Student_ID
                                        INNER JOIN dbo.T_Course_Master AS TCM ON TCM.I_Course_ID = TSBM.I_Course_ID
                                        INNER JOIN dbo.T_Center_Batch_Details
                                        AS TCBD ON TCBD.I_Batch_ID = TSBM.I_Batch_ID
                                        INNER JOIN dbo.T_Center_Hierarchy_Name_Details
                                        AS TCHND ON TCBD.I_Centre_Id = TCHND.I_Center_ID
                                WHERE   TSBM.Dt_Course_Expected_End_Date >= @dtStartDate
                                        AND TSBD.I_Status = 1
                                        AND TCHND.I_Center_ID IN (
                                        SELECT  FGCFR.centerID
                                        FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
                                                              @iBrandID) AS FGCFR )

                    END
                    
                ELSE
                    IF ( @sBatchList IS NOT NULL )
                        BEGIN
                    
                            INSERT  INTO #BATCHDTLS
                                    ( CentreID ,
                                      CenterName ,
                                      CourseID ,
                                      CourseName ,
                                      BatchID ,
                                      BatchName ,
                                      StudentDetID ,
                                      StudentID ,
                                      StudentName ,
                                      RollNo
						            )
                                    SELECT  TCHND.I_Center_ID ,
                                            TCHND.S_Center_Name ,
                                            TCM.I_Course_ID ,
                                            TCM.S_Course_Name ,
                                            TSBM.I_Batch_ID ,
                                            TSBM.S_Batch_Name ,
                                            TSD.I_Student_Detail_ID ,
                                            TSD.S_Student_ID ,
                                            TSD.S_First_Name + ' '
                                            + ISNULL(TSD.S_Middle_Name, '')
                                            + ' ' + TSD.S_Last_Name AS StudentName ,
                                            TSD.I_RollNo
                                    FROM    dbo.T_Student_Batch_Master AS TSBM
                                            INNER JOIN dbo.T_Student_Batch_Details
                                            AS TSBD ON TSBD.I_Batch_ID = TSBM.I_Batch_ID
                                            INNER JOIN dbo.T_Student_Detail AS TSD ON TSD.I_Student_Detail_ID = TSBD.I_Student_ID
                                            INNER JOIN dbo.T_Course_Master AS TCM ON TCM.I_Course_ID = TSBM.I_Course_ID
                                            INNER JOIN dbo.T_Center_Batch_Details
                                            AS TCBD ON TCBD.I_Batch_ID = TSBM.I_Batch_ID
                                            INNER JOIN dbo.T_Center_Hierarchy_Name_Details
                                            AS TCHND ON TCBD.I_Centre_Id = TCHND.I_Center_ID
                                    WHERE   TSBM.Dt_Course_Expected_End_Date >= @dtStartDate
                                            AND TSBD.I_Status = 1
                                            AND TSBM.I_Batch_ID IN (
                                            SELECT  CAST(FSR.Val AS INT)
                                            FROM    dbo.fnString2Rows(@sBatchList,
                                                              ',') AS FSR )
                                            AND TCHND.I_Center_ID IN (
                                            SELECT  FGCFR.centerID
                                            FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
                                                              @iBrandID) AS FGCFR )
                    
                        END
                    


            END
            
        ELSE
            BEGIN
            
                INSERT  INTO #BATCHDTLS
                        ( CentreID ,
                          CenterName ,
                          CourseID ,
                          CourseName ,
                          BatchID ,
                          BatchName ,
                          StudentDetID ,
                          StudentID ,
                          StudentName ,
                          RollNo
						 )
                        SELECT  TCHND.I_Center_ID ,
                                TCHND.S_Center_Name ,
                                TCM.I_Course_ID ,
                                TCM.S_Course_Name ,
                                TSBM.I_Batch_ID ,
                                TSBM.S_Batch_Name ,
                                TSD.I_Student_Detail_ID ,
                                TSD.S_Student_ID ,
                                TSD.S_First_Name + ' '
                                + ISNULL(TSD.S_Middle_Name, '') + ' '
                                + TSD.S_Last_Name AS StudentName ,
                                TSD.I_RollNo
                        FROM    dbo.T_Student_Batch_Master AS TSBM
                                INNER JOIN dbo.T_Student_Batch_Details AS TSBD ON TSBD.I_Batch_ID = TSBM.I_Batch_ID
                                INNER JOIN dbo.T_Student_Detail AS TSD ON TSD.I_Student_Detail_ID = TSBD.I_Student_ID
                                INNER JOIN dbo.T_Course_Master AS TCM ON TCM.I_Course_ID = TSBM.I_Course_ID
                                INNER JOIN dbo.T_Center_Batch_Details AS TCBD ON TCBD.I_Batch_ID = TSBM.I_Batch_ID
                                INNER JOIN dbo.T_Center_Hierarchy_Name_Details
                                AS TCHND ON TCBD.I_Centre_Id = TCHND.I_Center_ID
                        WHERE   TSBD.I_Status = 1
                                AND TSD.S_Student_ID = @sStudentID
                                AND TCHND.I_Center_ID IN (
                                SELECT  FGCFR.centerID
                                FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
                                                              @iBrandID) AS FGCFR )
            
            END
            

		--SELECT * FROM #BATCHDTLS AS B ORDER BY B.CenterName,B.CourseName,B.BatchName,B.RollNo
		
        UPDATE  T1
        SET     T1.MPercentage = T2.PercentageMonthlyExamMarks
        FROM    #BATCHDTLS AS T1
                INNER JOIN ( SELECT TCHND.I_Center_ID ,
                                    TCHND.S_Center_Name ,
                                    TCM.I_Course_ID ,
                                    TCM.S_Course_Name ,
                                    TTM.I_Term_ID ,
                                    TTM.S_Term_Name ,
                                    B.StudentDetID ,
                                    B.StudentID ,
        --TECM.I_Exam_Component_ID ,
        --TECM.S_Component_Name ,
                                    SUM(ISNULL(TSM.I_Exam_Total, 0)) AS MarksObtained ,
                                    SUM(ISNULL(TTES.I_TotMarks, 0)) AS TotalMarks ,
                                    CAST(ROUND(( ( SUM(ISNULL(TSM.I_Exam_Total,
                                                              0))
                                                   / SUM(ISNULL(TTES.I_TotMarks,
                                                              0)) ) * 100 ), 2) AS DECIMAL(14,
                                                              2)) AS PercentageMonthlyExamMarks
                             FROM   EXAMINATION.T_Student_Marks AS TSM
                                    INNER JOIN EXAMINATION.T_Batch_Exam_Map AS TBEM ON TBEM.I_Batch_Exam_ID = TSM.I_Batch_Exam_ID
                                    INNER JOIN dbo.T_Student_Batch_Master AS TSBM ON TSBM.I_Batch_ID = TBEM.I_Batch_ID
                                    INNER JOIN dbo.T_Term_Master AS TTM ON TTM.I_Term_ID = TBEM.I_Term_ID
                                    INNER JOIN dbo.T_Course_Master AS TCM ON TCM.I_Course_ID = TSBM.I_Course_ID
                                    INNER JOIN dbo.T_Center_Hierarchy_Name_Details
                                    AS TCHND ON TCHND.I_Center_ID = TSM.I_Center_ID
                --INNER JOIN dbo.T_Student_Detail AS TSD ON TSD.I_Student_Detail_ID = TSM.I_Student_Detail_ID
                                    INNER JOIN dbo.T_Exam_Component_Master AS TECM ON TECM.I_Exam_Component_ID = TBEM.I_Exam_Component_ID
                                    INNER JOIN dbo.T_Term_Eval_Strategy AS TTES ON TTES.I_Exam_Component_ID = TBEM.I_Exam_Component_ID
                                                              AND TTES.I_Term_ID = TBEM.I_Term_ID-- AND TTES.I_Course_ID = TCM.I_Course_ID
                                    INNER JOIN #BATCHDTLS AS B ON B.StudentDetID = TSM.I_Student_Detail_ID
                             WHERE  TSM.Dt_Exam_Date >= @dtStartDate
                                    AND TSM.Dt_Exam_Date < DATEADD(d, 1,
                                                              @dtEndDate)
                                    AND TBEM.I_Status = 1
                                    AND TCHND.I_Brand_ID = @iBrandID
                                    AND TTES.I_Status = 1
                --AND TSD.I_Student_Detail_ID = 79343
                             GROUP BY TCHND.I_Center_ID ,
                                    TCHND.S_Center_Name ,
                                    TCM.I_Course_ID ,
                                    TCM.S_Course_Name ,
                                    TTM.I_Term_ID ,
                                    TTM.S_Term_Name ,
                                    B.StudentDetID ,
                                    B.StudentID 
        --TECM.I_Exam_Component_ID ,
        --TECM.S_Component_Name 
                           ) T2 ON T2.StudentDetID = T1.StudentDetID
        
        
        
        UPDATE  T1
        SET     T1.APercentage = T2.APercentage
        FROM    #BATCHDTLS AS T1
                INNER JOIN ( SELECT TAllot.BatchID ,
                                    TAttn.StudentDetID ,
                                    ( ( CAST(TAttn.AttendanceCount AS DECIMAL(14,
                                                              2))
                                        / CAST(TAllot.AllottedClasses AS DECIMAL(14,
                                                              2)) ) * 100 ) AS APercentage
                             FROM   ( SELECT    B.BatchID ,
                                                ISNULL(COUNT(DISTINCT TTTM.I_TimeTable_ID),
                                                       0) AS AllottedClasses
                                      FROM      dbo.T_TimeTable_Master AS TTTM
                                                INNER JOIN #BATCHDTLS AS B ON B.BatchID = TTTM.I_Batch_ID
                                      WHERE     TTTM.Dt_Schedule_Date >= @dtStartDate
                                                AND TTTM.Dt_Schedule_Date < DATEADD(d,
                                                              1, @dtEndDate)
                                                AND TTTM.I_Status = 1
                                      GROUP BY  B.BatchID
                                    ) TAllot
                                    INNER JOIN ( SELECT B.BatchID ,
                                                        B.StudentDetID ,
                                                        COUNT(DISTINCT TTTM.I_TimeTable_ID) AS AttendanceCount
                                                 FROM   dbo.T_Student_Attendance
                                                        AS TSA
                                                        INNER JOIN dbo.T_TimeTable_Master
                                                        AS TTTM ON TTTM.I_TimeTable_ID = TSA.I_TimeTable_ID
                                                        INNER JOIN #BATCHDTLS
                                                        AS B ON B.StudentDetID = TSA.I_Student_Detail_ID
                                                 WHERE  TTTM.Dt_Schedule_Date >= @dtStartDate
                                                        AND TTTM.Dt_Schedule_Date < DATEADD(d,
                                                              1, @dtEndDate)
                                                        AND TTTM.I_Status = 1
                                                 GROUP BY B.BatchID ,
                                                        B.StudentDetID
                                               ) TAttn ON TAttn.BatchID = TAllot.BatchID
                           ) T2 ON T2.BatchID = T1.BatchID
                                   AND T2.StudentDetID = T1.StudentDetID
        
        
        
        
        UPDATE  T1
        SET     T1.HPercentage = T2.HPercentage
        FROM    #BATCHDTLS AS T1
                INNER JOIN ( SELECT AHW.BatchID ,
                                    SHW.StudentDetID ,
                                    ( ( CAST(SHW.HWSubmission AS DECIMAL(14, 2))
                                        / CAST(AHW.AllottedHW AS DECIMAL(14, 2)) )
                                      * 100 ) AS HPercentage
                             FROM   ( SELECT    B.BatchID ,
                                                COUNT(DISTINCT THM.I_Homework_ID) AS AllottedHW
                                      FROM      EXAMINATION.T_Homework_Master
                                                AS THM
                                                INNER JOIN #BATCHDTLS AS B ON B.BatchID = THM.I_Batch_ID
                                      WHERE     THM.Dt_Submission_Date >= @dtStartDate
                                                AND THM.Dt_Submission_Date < DATEADD(d,
                                                              1, @dtEndDate)
                                                AND THM.I_Status = 1
                                      GROUP BY  B.BatchID
                                    ) AHW
                                    INNER JOIN ( SELECT B.BatchID ,
                                                        B.StudentDetID ,
                                                        COUNT(DISTINCT THM.I_Homework_ID) AS HWSubmission
                                                 FROM   EXAMINATION.T_Homework_Submission
                                                        AS THS
                                                        INNER JOIN EXAMINATION.T_Homework_Master
                                                        AS THM ON THM.I_Homework_ID = THS.I_Homework_ID
                                                        INNER JOIN #BATCHDTLS
                                                        AS B ON B.StudentDetID = THS.I_Student_Detail_ID
                                                 WHERE  THM.Dt_Submission_Date >= @dtStartDate
                                                        AND THM.Dt_Submission_Date < DATEADD(d,
                                                              1, @dtEndDate)
                                                        AND THM.I_Status = 1
                                                 GROUP BY B.BatchID ,
                                                        B.StudentDetID
                                               ) SHW ON SHW.BatchID = AHW.BatchID
                           ) T2 ON T2.BatchID = T1.BatchID
                                   AND T2.StudentDetID = T1.StudentDetID
        
        
        UPDATE #BATCHDTLS SET APercentage=100.00 WHERE ISNULL(APercentage,0)>100.00
        --UPDATE #BATCHDTLS SET HPercentage=100.00 WHERE ISNULL(HPercentage,0)>100.00
        
        SELECT  *
        FROM    #BATCHDTLS AS B
        ORDER BY B.CenterName ,
                B.CourseName ,
                B.BatchName ,
                B.RollNo
        
        
        
    END
