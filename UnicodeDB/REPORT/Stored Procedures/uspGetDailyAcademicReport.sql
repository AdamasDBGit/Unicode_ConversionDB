CREATE PROCEDURE [REPORT].[uspGetDailyAcademicReport]
    (
      @iBrandID INT ,
      @sHierarchyIDList VARCHAR(MAX) ,
      @dtStartDate DATE ,
      @dtEndDate DATE ,
      @sBatchID VARCHAR(MAX) = NULL
    )
AS 
    BEGIN

        IF ( @sBatchID IS NULL ) 
            BEGIN

                SELECT  T1.I_Center_ID ,
                        T1.S_Center_Name ,
                        T1.I_Course_ID ,
                        T1.S_Course_Name ,
                        T1.I_Batch_ID ,
                        T1.S_Batch_Name ,
                        T1.BatchStrength ,
                        T2.AllottedClass ,
                        T3.TotalAttendance ,
                        T4.AllottedHW ,
                        T5.TotalHWSubmission ,
                        CAST(( ( CAST(T3.TotalAttendance AS DECIMAL(14, 2))
                                 / ( CAST(T1.BatchStrength AS DECIMAL(14, 2))
                                     * CAST(T2.AllottedClass AS DECIMAL(14, 2)) ) )
                               * 100 ) AS DECIMAL(14, 2)) AS AttendancePercentage ,
                        CAST(( ( CAST(T5.TotalHWSubmission AS DECIMAL(14, 2))
                                 / ( CAST(T1.BatchStrength AS DECIMAL(14, 2))
                                     * CAST(T4.AllottedHW AS DECIMAL(14, 2)) ) )
                               * 100 ) AS DECIMAL(14, 2)) AS HWSubmissionPercentage
                FROM    ( SELECT    TCHND.I_Center_ID ,
                                    TCHND.S_Center_Name ,
                                    TCM.I_Course_ID ,
                                    TCM.S_Course_Name ,
                                    TSBM.I_Batch_ID ,
                                    TSBM.S_Batch_Name ,
                                    COUNT(DISTINCT TSD.S_Student_ID) AS BatchStrength
                          FROM      dbo.T_Student_Detail TSD
                                    INNER JOIN dbo.T_Student_Batch_Details TSBD
                                    WITH ( NOLOCK ) ON TSD.I_Student_Detail_ID = TSBD.I_Student_ID
                                    INNER JOIN dbo.T_Student_Batch_Master TSBM
                                    WITH ( NOLOCK ) ON TSBD.I_Batch_ID = TSBM.I_Batch_ID
                                    INNER JOIN dbo.T_Center_Batch_Details TCBD
                                    WITH ( NOLOCK ) ON TSBM.I_Batch_ID = TCBD.I_Batch_ID
                                    INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND
                                    WITH ( NOLOCK ) ON TCBD.I_Centre_Id = TCHND.I_Center_ID
                                    INNER JOIN dbo.T_Course_Master TCM WITH ( NOLOCK ) ON TSBM.I_Course_ID = TCM.I_Course_ID
                                    INNER JOIN ( SELECT TSSDA.I_Student_Detail_ID
                                                 FROM   dbo.T_Student_Status_Details_Archive TSSDA
                                                        WITH ( NOLOCK )
                                                 WHERE  I_Student_Status_ID = 1
                                                        AND I_Status = 1 AND CONVERT(DATE,TSSDA.Dt_Crtd_On)=CONVERT(DATE,@dtEndDate)
                                               ) TTT ON TSD.I_Student_Detail_ID = TTT.I_Student_Detail_ID
                          WHERE     TSBD.I_Status = 1
                                    AND TCHND.I_Center_ID IN (
                                    SELECT  FGCFR.centerID
                                    FROM    dbo.fnGetCentersForReports(@sHierarchyIDList,
                                                              @iBrandID) FGCFR )
                          GROUP BY  TCHND.I_Center_ID ,
                                    TCHND.S_Center_Name ,
                                    TCM.I_Course_ID ,
                                    TCM.S_Course_Name ,
                                    TSBM.I_Batch_ID ,
                                    TSBM.S_Batch_Name
                        ) T1
                        LEFT JOIN ( SELECT  TTTM.I_Batch_ID ,
                                            COUNT(DISTINCT TTTM.I_TimeTable_ID) AS AllottedClass
                                    FROM    dbo.T_TimeTable_Master TTTM WITH ( NOLOCK )
                                    WHERE   TTTM.I_Status = 1
                                            AND ( TTTM.Dt_Schedule_Date >= @dtStartDate
                                                  AND TTTM.Dt_Schedule_Date < DATEADD(d,
                                                              1, @dtEndDate)
                                                )
                                            AND TTTM.I_Center_ID IN (
                                            SELECT  FGCFR.centerID
                                            FROM    dbo.fnGetCentersForReports(@sHierarchyIDList,
                                                              @iBrandID) FGCFR )
                                    GROUP BY TTTM.I_Batch_ID
                                  ) T2 ON T1.I_Batch_ID = T2.I_Batch_ID
                        LEFT JOIN ( SELECT  TT.I_Batch_ID ,
                                            SUM(TT.TotalAttendance) AS TotalAttendance
                                    FROM    ( SELECT    TTTM.I_Batch_ID ,
                                                        TTTM.I_TimeTable_ID ,
                                                        COUNT(DISTINCT TSA.I_Student_Detail_ID) AS TotalAttendance
                                              FROM      dbo.T_TimeTable_Master TTTM
                                                        WITH ( NOLOCK )
                                                        INNER JOIN dbo.T_Student_Attendance TSA
                                                        WITH ( NOLOCK ) ON TTTM.I_TimeTable_ID = TSA.I_TimeTable_ID
                                                        INNER JOIN dbo.T_Student_Batch_Details TSBD2
                                                        WITH ( NOLOCK ) ON TTTM.I_Batch_ID = TSBD2.I_Batch_ID
                                                              AND TSBD2.I_Student_ID = TSA.I_Student_Detail_ID
                                              WHERE     TTTM.I_Status = 1
                                                        AND ( TTTM.Dt_Schedule_Date >= @dtStartDate
                                                              AND TTTM.Dt_Schedule_Date < DATEADD(d,
                                                              1, @dtEndDate)
                                                            )
                                                        AND TTTM.I_Center_ID IN (
                                                        SELECT
                                                              FGCFR.centerID
                                                        FROM  dbo.fnGetCentersForReports(@sHierarchyIDList,
                                                              @iBrandID) FGCFR )
                                                        AND TSBD2.I_Status = 1
                                              GROUP BY  TTTM.I_Batch_ID ,
                                                        TTTM.I_TimeTable_ID
                                            ) TT
                                    GROUP BY TT.I_Batch_ID
                                  ) T3 ON T1.I_Batch_ID = T3.I_Batch_ID
                        LEFT JOIN ( SELECT  THM.I_Batch_ID ,
                                            COUNT(DISTINCT THM.I_Homework_ID) AS AllottedHW
                                    FROM    EXAMINATION.T_Homework_Master THM
                                            WITH ( NOLOCK )
                                    WHERE   THM.I_Status = 1
                                            AND ( THM.Dt_Submission_Date >= @dtStartDate
                                                  AND THM.Dt_Submission_Date < DATEADD(d,
                                                              1, @dtEndDate)
                                                )
                                            AND THM.I_Center_ID IN (
                                            SELECT  FGCFR.centerID
                                            FROM    dbo.fnGetCentersForReports(@sHierarchyIDList,
                                                              @iBrandID) FGCFR )
                                    GROUP BY THM.I_Batch_ID
                                  ) T4 ON T1.I_Batch_ID = T4.I_Batch_ID
                        LEFT JOIN ( SELECT  THM.I_Batch_ID ,
                                            COUNT(THS.I_Student_Detail_ID) AS TotalHWSubmission
                                    FROM    EXAMINATION.T_Homework_Master THM
                                            WITH ( NOLOCK )
                                            INNER JOIN EXAMINATION.T_Homework_Submission THS
                                            WITH ( NOLOCK ) ON THM.I_Homework_ID = THS.I_Homework_ID
                                            INNER JOIN dbo.T_Student_Batch_Details TSBD3
                                            WITH ( NOLOCK ) ON THS.I_Student_Detail_ID = TSBD3.I_Student_ID
                                                              AND THM.I_Batch_ID = TSBD3.I_Batch_ID
                                    WHERE   THM.I_Status = 1
                                            AND ( THM.Dt_Submission_Date >= @dtStartDate
                                                  AND THM.Dt_Submission_Date < DATEADD(d,
                                                              1, @dtEndDate)
                                                )
                                            AND THM.I_Center_ID IN (
                                            SELECT  FGCFR.centerID
                                            FROM    dbo.fnGetCentersForReports(@sHierarchyIDList,
                                                              @iBrandID) FGCFR )
                                            AND TSBD3.I_Status = 1
                                    GROUP BY THM.I_Batch_ID
                                  ) T5 ON T1.I_Batch_ID = T5.I_Batch_ID
                  
            END
                  
        ELSE 
            BEGIN
                  
                SELECT  T1.I_Center_ID ,
                        T1.S_Center_Name ,
                        T1.I_Course_ID ,
                        T1.S_Course_Name ,
                        T1.I_Batch_ID ,
                        T1.S_Batch_Name ,
                        T1.BatchStrength ,
                        T2.AllottedClass ,
                        T3.TotalAttendance ,
                        T4.AllottedHW ,
                        T5.TotalHWSubmission ,
                        CAST(( ( CAST(T3.TotalAttendance AS DECIMAL(14, 2))
                                 / ( CAST(T1.BatchStrength AS DECIMAL(14, 2))
                                     * CAST(T2.AllottedClass AS DECIMAL(14, 2)) ) )
                               * 100 ) AS DECIMAL(14, 2)) AS AttendancePercentage ,
                        CAST(( ( CAST(T5.TotalHWSubmission AS DECIMAL(14, 2))
                                 / ( CAST(T1.BatchStrength AS DECIMAL(14, 2))
                                     * CAST(T4.AllottedHW AS DECIMAL(14, 2)) ) )
                               * 100 ) AS DECIMAL(14, 2)) AS HWSubmissionPercentage
                FROM    ( SELECT    TCHND.I_Center_ID ,
                                    TCHND.S_Center_Name ,
                                    TCM.I_Course_ID ,
                                    TCM.S_Course_Name ,
                                    TSBM.I_Batch_ID ,
                                    TSBM.S_Batch_Name ,
                                    COUNT(DISTINCT TSD.S_Student_ID) AS BatchStrength
                          FROM      dbo.T_Student_Detail TSD
                                    INNER JOIN dbo.T_Student_Batch_Details TSBD ON TSD.I_Student_Detail_ID = TSBD.I_Student_ID
                                    INNER JOIN dbo.T_Student_Batch_Master TSBM ON TSBD.I_Batch_ID = TSBM.I_Batch_ID
                                    INNER JOIN dbo.T_Center_Batch_Details TCBD ON TSBM.I_Batch_ID = TCBD.I_Batch_ID
                                    INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TCBD.I_Centre_Id = TCHND.I_Center_ID
                                    INNER JOIN dbo.T_Course_Master TCM ON TSBM.I_Course_ID = TCM.I_Course_ID
                                    INNER JOIN ( SELECT TSSD.I_Student_Detail_ID
                                                 FROM   dbo.T_Student_Status_Details_Archive TSSD
                                                        WITH ( NOLOCK )
                                                 WHERE  I_Student_Status_ID = 1
                                                        AND I_Status = 1 AND CONVERT(DATE,TSSD.Dt_Crtd_On)=CONVERT(DATE,@dtEndDate)
                                               ) TTT ON TSD.I_Student_Detail_ID = TTT.I_Student_Detail_ID
                          WHERE     TSBD.I_Status = 1
                                    AND TSBD.I_Batch_ID IN (
                                    SELECT  CAST(FSR.Val AS INT)
                                    FROM    dbo.fnString2Rows(@sBatchID, ',') FSR )
                                    AND TCHND.I_Center_ID IN (
                                    SELECT  FGCFR.centerID
                                    FROM    dbo.fnGetCentersForReports(@sHierarchyIDList,
                                                              @iBrandID) FGCFR )
                          GROUP BY  TCHND.I_Center_ID ,
                                    TCHND.S_Center_Name ,
                                    TCM.I_Course_ID ,
                                    TCM.S_Course_Name ,
                                    TSBM.I_Batch_ID ,
                                    TSBM.S_Batch_Name
                        ) T1
                        LEFT JOIN ( SELECT  TTTM.I_Batch_ID ,
                                            COUNT(DISTINCT TTTM.I_TimeTable_ID) AS AllottedClass
                                    FROM    dbo.T_TimeTable_Master TTTM
                                    WHERE   TTTM.I_Status = 1
                                            AND ( TTTM.Dt_Schedule_Date >= @dtStartDate
                                                  AND TTTM.Dt_Schedule_Date < DATEADD(d,
                                                              1, @dtEndDate)
                                                )
                                            AND TTTM.I_Center_ID IN (
                                            SELECT  FGCFR.centerID
                                            FROM    dbo.fnGetCentersForReports(@sHierarchyIDList,
                                                              @iBrandID) FGCFR )
                                    GROUP BY TTTM.I_Batch_ID
                                  ) T2 ON T1.I_Batch_ID = T2.I_Batch_ID
                        LEFT JOIN ( SELECT  TT.I_Batch_ID ,
                                            SUM(TT.TotalAttendance) AS TotalAttendance
                                    FROM    ( SELECT    TTTM.I_Batch_ID ,
                                                        TTTM.I_TimeTable_ID ,
                                                        COUNT(DISTINCT TSA.I_Student_Detail_ID) AS TotalAttendance
                                              FROM      dbo.T_TimeTable_Master TTTM
                                                        WITH ( NOLOCK )
                                                        INNER JOIN dbo.T_Student_Attendance TSA
                                                        WITH ( NOLOCK ) ON TTTM.I_TimeTable_ID = TSA.I_TimeTable_ID
                                                        INNER JOIN dbo.T_Student_Batch_Details TSBD2
                                                        WITH ( NOLOCK ) ON TTTM.I_Batch_ID = TSBD2.I_Batch_ID
                                                              AND TSBD2.I_Student_ID = TSA.I_Student_Detail_ID
                                              WHERE     TTTM.I_Status = 1
                                                        AND ( TTTM.Dt_Schedule_Date >= @dtStartDate
                                                              AND TTTM.Dt_Schedule_Date < DATEADD(d,
                                                              1, @dtEndDate)
                                                            )
                                                        AND TTTM.I_Center_ID IN (
                                                        SELECT
                                                              FGCFR.centerID
                                                        FROM  dbo.fnGetCentersForReports(@sHierarchyIDList,
                                                              @iBrandID) FGCFR )
                                                        AND TSBD2.I_Status = 1
                                              GROUP BY  TTTM.I_Batch_ID ,
                                                        TTTM.I_TimeTable_ID
                                            ) TT
                                    GROUP BY TT.I_Batch_ID
                                  ) T3 ON T1.I_Batch_ID = T3.I_Batch_ID
                        LEFT JOIN ( SELECT  THM.I_Batch_ID ,
                                            COUNT(DISTINCT THM.I_Homework_ID) AS AllottedHW
                                    FROM    EXAMINATION.T_Homework_Master THM
                                    WHERE   THM.I_Status = 1
                                            AND ( THM.Dt_Submission_Date >= @dtStartDate
                                                  AND THM.Dt_Submission_Date < DATEADD(d,
                                                              1, @dtEndDate)
                                                )
                                            AND THM.I_Center_ID IN (
                                            SELECT  FGCFR.centerID
                                            FROM    dbo.fnGetCentersForReports(@sHierarchyIDList,
                                                              @iBrandID) FGCFR )
                                    GROUP BY THM.I_Batch_ID
                                  ) T4 ON T1.I_Batch_ID = T4.I_Batch_ID
                        LEFT JOIN ( SELECT  THM.I_Batch_ID ,
                                            COUNT(THS.I_Student_Detail_ID) AS TotalHWSubmission
                                    FROM    EXAMINATION.T_Homework_Master THM
                                            INNER JOIN EXAMINATION.T_Homework_Submission THS ON THM.I_Homework_ID = THS.I_Homework_ID
                                            INNER JOIN dbo.T_Student_Batch_Details TSBD ON THS.I_Student_Detail_ID = TSBD.I_Student_ID
                                                              AND THM.I_Batch_ID = TSBD.I_Batch_ID
                                    WHERE   THM.I_Status = 1
                                            AND ( THM.Dt_Submission_Date >= @dtStartDate
                                                  AND THM.Dt_Submission_Date < DATEADD(d,
                                                              1, @dtEndDate)
                                                )
                                            AND THM.I_Center_ID IN (
                                            SELECT  FGCFR.centerID
                                            FROM    dbo.fnGetCentersForReports(@sHierarchyIDList,
                                                              @iBrandID) FGCFR )
                                            AND TSBD.I_Status = 1
                                    GROUP BY THM.I_Batch_ID
                                  ) T5 ON T1.I_Batch_ID = T5.I_Batch_ID
                  	
            END
                  
    END
