CREATE PROCEDURE [REPORT].[uspGetStudentInformationServiceAppraisalSubReport]
    (
      @iStudentDetailID INT
    )
AS 
    BEGIN

        SELECT  T1.I_Student_Detail_ID ,
                T1.I_Term_ID ,
                T1.I_Batch_ID ,
                T1.S_Term_Name ,
                T1.StudentMarks ,
                T2.Overall_Rank AS StateRank ,
                T3.Center_Rank ,
                T4.Batch_Rank ,
                T5.HWAssigned ,
                T6.HWSubmitted ,
                T7.ClassAlloted ,
                T8.ClassAttended ,
                CAST(( ( CAST(T8.ClassAttended AS DECIMAL(14, 2))
                         / CAST(T7.ClassAlloted AS DECIMAL(14, 2)) ) * 100 ) AS DECIMAL(14,
                                                              2)) AS AttendancePercentage
        FROM    ( SELECT    TSD.I_Student_Detail_ID ,
                            TBEM.I_Batch_ID ,
                            TTM.I_Term_ID ,
                            TTM.S_Term_Name ,
                            SUM(TSM.I_Exam_Total) AS StudentMarks
                  FROM      EXAMINATION.T_Student_Marks TSM
                            INNER JOIN EXAMINATION.T_Batch_Exam_Map TBEM ON TSM.I_Batch_Exam_ID = TBEM.I_Batch_Exam_ID
                            INNER JOIN dbo.T_Term_Master TTM ON TBEM.I_Term_ID = TTM.I_Term_ID
                            INNER JOIN dbo.T_Student_Detail TSD ON TSM.I_Student_Detail_ID = TSD.I_Student_Detail_ID
                  WHERE     TSD.I_Student_Detail_ID = @iStudentDetailID--48508
                  GROUP BY  TSD.I_Student_Detail_ID ,
                            TBEM.I_Batch_ID ,
                            TTM.I_Term_ID ,
                            TTM.S_Term_Name
                ) T1
                LEFT JOIN ( SELECT  SM.I_Student_Detail_ID ,
                                    BEM.I_Term_ID ,
                                    DENSE_RANK() OVER ( PARTITION BY BEM.I_Term_ID ORDER BY SUM(ISNULL(SM.I_Exam_Total,
                                                              0)) DESC ) AS [Overall_Rank]
                            FROM    EXAMINATION.T_Student_Marks SM
                                    INNER JOIN EXAMINATION.T_Batch_Exam_Map BEM ON BEM.I_Batch_Exam_ID = SM.I_Batch_Exam_ID
 -- AND SM.Dt_Crtd_On<'2013-03-31'                   
                            GROUP BY I_Student_Detail_ID ,
                                    BEM.I_Term_ID
                          ) T2 ON T1.I_Student_Detail_ID = T2.I_Student_Detail_ID
                                  AND T1.I_Term_ID = T2.I_Term_ID
                LEFT JOIN ( SELECT  SM.I_Student_Detail_ID ,
                                    BEM.I_Term_ID ,
                                    DENSE_RANK() OVER ( PARTITION BY BEM.I_Term_ID,
                                                        SM.I_Center_ID ORDER BY SUM(ISNULL(SM.I_Exam_Total,
                                                              0)) DESC ) AS [Center_Rank]
                            FROM    EXAMINATION.T_Student_Marks SM
                                    INNER JOIN EXAMINATION.T_Batch_Exam_Map BEM ON BEM.I_Batch_Exam_ID = SM.I_Batch_Exam_ID
 -- AND SM.Dt_Crtd_On<'2013-03-31'                   
                            GROUP BY I_Student_Detail_ID ,
                                    BEM.I_Term_ID ,
                                    SM.I_Center_ID
                          ) T3 ON T1.I_Student_Detail_ID = T3.I_Student_Detail_ID
                                  AND T1.I_Term_ID = T3.I_Term_ID
                LEFT JOIN ( SELECT  SM.I_Student_Detail_ID ,
                                    BEM.I_Term_ID ,
                                    BEM.I_Batch_ID ,
                                    DENSE_RANK() OVER ( PARTITION BY BEM.I_Term_ID,
                                                        SM.I_Center_ID,
                                                        BEM.I_Batch_ID ORDER BY SUM(ISNULL(SM.I_Exam_Total,
                                                              0)) DESC ) AS [Batch_Rank]
                            FROM    EXAMINATION.T_Student_Marks SM
                                    INNER JOIN EXAMINATION.T_Batch_Exam_Map BEM ON BEM.I_Batch_Exam_ID = SM.I_Batch_Exam_ID
 -- AND SM.Dt_Crtd_On<'2013-03-31'                   
                            GROUP BY I_Student_Detail_ID ,
                                    BEM.I_Term_ID ,
                                    SM.I_Center_ID ,
                                    BEM.I_Batch_ID
                          ) T4 ON T1.I_Student_Detail_ID = T4.I_Student_Detail_ID
                                  AND T1.I_Term_ID = T4.I_Term_ID
                LEFT JOIN ( SELECT  THM.I_Term_ID ,
                                    THM.I_Batch_ID ,
                                    ISNULL(COUNT(DISTINCT THM.I_Homework_ID),
                                           0) AS HWAssigned
                            FROM    EXAMINATION.T_Homework_Master THM
                            WHERE   THM.I_Status = 1
                            GROUP BY THM.I_Term_ID ,
                                    THM.I_Batch_ID
                          ) T5 ON T1.I_Batch_ID = T5.I_Batch_ID
                                  AND T1.I_Term_ID = T5.I_Term_ID
                LEFT JOIN ( SELECT  THS.I_Student_Detail_ID ,
                                    THM2.I_Term_ID ,
                                    ISNULL(COUNT(DISTINCT THS.I_Homework_ID),
                                           0) AS HWSubmitted
                            FROM    EXAMINATION.T_Homework_Submission THS
                                    INNER JOIN EXAMINATION.T_Homework_Master THM2 ON THS.I_Homework_ID = THM2.I_Homework_ID
                            WHERE   THS.I_Status = 1
                                    AND THM2.I_Status = 1
                            GROUP BY THS.I_Student_Detail_ID ,
                                    THM2.I_Term_ID
                          ) T6 ON T1.I_Term_ID = T6.I_Term_ID
                                  AND T1.I_Student_Detail_ID = T6.I_Student_Detail_ID
                LEFT JOIN ( SELECT  TTTM.I_Batch_ID ,
                                    TTTM.I_Term_ID ,
                                    ISNULL(COUNT(DISTINCT TTTM.I_TimeTable_ID),
                                           0) AS ClassAlloted
                            FROM    dbo.T_TimeTable_Master TTTM
                            WHERE   TTTM.I_Status = 1
                            GROUP BY TTTM.I_Batch_ID ,
                                    TTTM.I_Term_ID
                          ) T7 ON T7.I_Batch_ID = T1.I_Batch_ID
                                  AND T7.I_Term_ID = T1.I_Term_ID
                LEFT JOIN ( SELECT  TSA.I_Student_Detail_ID ,
                                    TTTM.I_Term_ID ,
                                    ISNULL(COUNT(DISTINCT TSA.I_TimeTable_ID),
                                           0) AS ClassAttended
                            FROM    dbo.T_Student_Attendance TSA
                                    INNER JOIN dbo.T_TimeTable_Master TTTM ON TSA.I_TimeTable_ID = TTTM.I_TimeTable_ID
                            WHERE   TTTM.I_Status = 1
                            GROUP BY TSA.I_Student_Detail_ID ,
                                    TTTM.I_Term_ID
                          ) T8 ON T8.I_Student_Detail_ID = T1.I_Student_Detail_ID
                                  AND T8.I_Term_ID = T1.I_Term_ID
        ORDER BY T1.I_Student_Detail_ID ,
                T1.I_Term_ID
                                  
                                  
	
	
	
	
	
    END
