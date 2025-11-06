CREATE PROCEDURE [REPORT].[uspGetAISAdcheckSummary]
    (
      @iBrandID INT ,
      @sHierarchyListID VARCHAR(MAX) ,
      @dtStartDate DATETIME ,
      @dtEndDate DATETIME ,
      @iTermID INT,
      @iModuleID INT=NULL,
      @iExamComponentID INT=NULL,
      @iFacultyID INT= NULL
    )
AS
    BEGIN

--DECLARE @iBrandID INT=107
--DECLARE @sHierarchyListID VARCHAR(MAX)='53'
--DECLARE @dtStartDate DATETIME='2019-01-25'
--DECLARE @dtEndDate DATETIME=GETDATE()
--DECLARE @iTermID INT


        CREATE TABLE #MRKDTLS
            (
              BatchID INT ,
              BatchName VARCHAR(MAX) ,
              TermID INT ,
              TermName VARCHAR(MAX) ,
              ModuleID INT ,
              ModuleName VARCHAR(MAX) ,
              ExamComponentID INT ,
              ExamComponentName VARCHAR(MAX) ,
              FacultyID INT ,
              FacultyName VARCHAR(MAX) ,
              StudentStrength INT ,
              StudentAttn INT ,
              AbsentCount INT ,
--StdCount INT,
              FullMarks INT ,
              Slot1 INT ,
              Slot2 INT ,
              Slot3 INT ,
              Slot4 INT
            )


        CREATE TABLE #MASTER
            (
              BatchID INT ,
              BatchName VARCHAR(MAX) ,
              TermID INT ,
              TermName VARCHAR(MAX) ,
              ModuleID INT ,
              ModuleName VARCHAR(MAX) ,
              ExamComponentID INT ,
              ExamComponentName VARCHAR(MAX) ,
              FacultyID INT ,
              FacultyName VARCHAR(MAX) ,
              FullMarks INT
            )



        INSERT  INTO #MASTER
                ( BatchID ,
                  BatchName ,
                  TermID ,
                  TermName ,
                  ModuleID ,
                  ModuleName ,
                  ExamComponentID ,
                  ExamComponentName ,
                  FacultyID ,
                  FacultyName ,
                  FullMarks
                )
                SELECT DISTINCT
                        TSBM.I_Batch_ID ,
                        TSBM.S_Batch_Name ,
                        TTM.I_Term_ID ,
                        TTM.S_Term_Name ,
                        TMM.I_Module_ID ,
                        TMM.S_Module_Name ,
                        TECM.I_Exam_Component_ID ,
                        TECM.S_Component_Name ,
                        TED.I_Employee_ID ,
                        TED.S_First_Name + ' ' + ISNULL(TED.S_Middle_Name, '')
                        + ' ' + TED.S_Last_Name AS FacultyName ,
                        TMES.I_TotMarks
                FROM    EXAMINATION.T_Student_Marks AS TSM
                        INNER JOIN EXAMINATION.T_Batch_Exam_Map AS TBEM ON TBEM.I_Batch_Exam_ID = TSM.I_Batch_Exam_ID
                        INNER JOIN dbo.T_Term_Master AS TTM ON TTM.I_Term_ID = TBEM.I_Term_ID
--INNER JOIN dbo.T_Module_Term_Map AS TMTM ON TMTM.I_Term_ID = TTM.I_Term_ID
                        INNER JOIN dbo.T_Module_Master AS TMM ON TMM.I_Module_ID = TBEM.I_Module_ID --AND TMM.I_Module_ID = TMTM.I_Module_ID
                        INNER JOIN dbo.T_Student_Batch_Master AS TSBM ON TSBM.I_Batch_ID = TBEM.I_Batch_ID
                        INNER JOIN dbo.T_Exam_Component_Master AS TECM ON TECM.I_Exam_Component_ID = TBEM.I_Exam_Component_ID
                        INNER JOIN EXAMINATION.T_Batch_Exam_Faculty_Map AS TBEFM ON TBEFM.I_Batch_Exam_ID = TBEM.I_Batch_Exam_ID
                        INNER JOIN dbo.T_Employee_Dtls AS TED ON TED.I_Employee_ID = TBEFM.I_Employee_ID
                        INNER JOIN dbo.T_Module_Eval_Strategy AS TMES ON TMES.I_Exam_Component_ID = TBEM.I_Exam_Component_ID
                                                              AND TMES.I_Module_ID = TBEM.I_Module_ID
                WHERE   TBEM.I_Status = 1
                        AND ( TSM.Dt_Exam_Date >= @dtStartDate
                              AND TSM.Dt_Exam_Date < DATEADD(d, 1, @dtEndDate)
                            )
                        AND TSM.I_Center_ID IN (
                        SELECT  FGCFR.centerID
                        FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
                                                           @iBrandID) AS FGCFR )
                        AND TMM.I_Status = 1
                        AND TTM.I_Status = 1
                        --AND TMM.S_Module_Name LIKE '%ADCHK%'
                        AND TMES.I_Status = 1
                        AND TMM.I_Module_ID IN (ISNULL(@iModuleID,TMM.I_Module_ID))
                        AND TECM.I_Exam_Component_ID IN (ISNULL(@iExamComponentID,TECM.I_Exam_Component_ID))
                        AND TED.I_Employee_ID IN (ISNULL(@iFacultyID,TED.I_Employee_ID))
                        AND TTM.I_Term_ID=@iTermID
                        
                        
                   


        INSERT  INTO #MRKDTLS
                ( BatchID ,
                  BatchName ,
                  TermID ,
                  TermName ,
                  ModuleID ,
                  ModuleName ,
                  ExamComponentID ,
                  ExamComponentName ,
                  FacultyID ,
                  FacultyName ,
                  FullMarks 
                )
                SELECT  *
                FROM    #MASTER AS M

/*
        UPDATE  T1
        SET     T1.StudentStrength = T2.BatchStrength
        FROM    #MRKDTLS AS T1
                INNER JOIN ( SELECT M.BatchID ,
                                    COUNT(DISTINCT TSBD.I_Student_ID) AS BatchStrength
                             FROM   dbo.T_Student_Batch_Details AS TSBD
                                    INNER JOIN #MASTER AS M ON M.BatchID = TSBD.I_Batch_ID
                             WHERE  TSBD.I_Status = 1
                             GROUP BY M.BatchID
                           ) T2 ON T2.BatchID = T1.BatchID


        UPDATE  T1
        SET     T1.StudentAttn = T2.Attn
        FROM    #MRKDTLS AS T1
                INNER JOIN ( SELECT TBEM.I_Batch_ID ,
                                    TBEM.I_Term_ID ,
                                    TBEM.I_Module_ID ,
                                    TBEM.I_Exam_Component_ID ,
                                    COUNT(DISTINCT TSM.I_Student_Detail_ID) AS Attn
                             FROM   EXAMINATION.T_Student_Marks AS TSM
                                    INNER JOIN EXAMINATION.T_Batch_Exam_Map AS TBEM ON TBEM.I_Batch_Exam_ID = TSM.I_Batch_Exam_ID
                             WHERE  TBEM.I_Status = 1
                                    AND ( TSM.Dt_Exam_Date >= @dtStartDate
                                          AND TSM.Dt_Exam_Date < DATEADD(d, 1,
                                                              @dtEndDate)
                                        )
                                    AND TSM.I_Center_ID IN (
                                    SELECT  FGCFR.centerID
                                    FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
                                                              @iBrandID) AS FGCFR )
                                    AND TSM.I_Exam_Total IS NOT NULL
                             GROUP BY TBEM.I_Batch_ID ,
                                    TBEM.I_Term_ID ,
                                    TBEM.I_Module_ID ,
                                    TBEM.I_Exam_Component_ID
                           ) T2 ON T1.BatchID = T2.I_Batch_ID
                                   AND T1.TermID = T2.I_Term_ID
                                   AND T1.ModuleID = T2.I_Module_ID
                                   AND T1.ExamComponentID = T2.I_Exam_Component_ID


        UPDATE  #MRKDTLS
        SET     AbsentCount = ISNULL(StudentStrength, 0) - ISNULL(StudentAttn,
                                                              0)


        UPDATE  T1
        SET     T1.Slot1 = T2.Std
        FROM    #MRKDTLS AS T1
                LEFT JOIN ( SELECT  TX.I_Batch_ID ,
                                    TX.I_Term_ID ,
                                    TX.I_Module_ID ,
                                    TX.I_Exam_Component_ID ,
                                    COUNT(DISTINCT TX.I_Student_Detail_ID) AS Std
                            FROM    ( SELECT    TBEM.I_Batch_ID ,
                                                TBEM.I_Term_ID ,
                                                TBEM.I_Module_ID ,
                                                TBEM.I_Exam_Component_ID ,
                                                TSM.I_Student_Detail_ID ,
                                                ( ( CAST(TSM.I_Exam_Total AS DECIMAL)
                                                    / CAST(TMES.I_TotMarks AS DECIMAL) )
                                                  * 100 ) AS PercentMarks
                                      FROM      EXAMINATION.T_Student_Marks AS TSM
                                                INNER JOIN EXAMINATION.T_Batch_Exam_Map
                                                AS TBEM ON TBEM.I_Batch_Exam_ID = TSM.I_Batch_Exam_ID
                                                INNER JOIN dbo.T_Module_Eval_Strategy
                                                AS TMES ON TMES.I_Exam_Component_ID = TBEM.I_Exam_Component_ID
                                                           AND TMES.I_Module_ID = TBEM.I_Module_ID
                                                           AND TMES.I_Term_ID = TBEM.I_Term_ID
                                                INNER JOIN dbo.T_Module_Master
                                                AS TMM ON TMM.I_Module_ID = TBEM.I_Module_ID
                                      WHERE     TBEM.I_Status = 1
                                                AND TMES.I_Status = 1
                                                AND ( TSM.Dt_Exam_Date >= @dtStartDate
                                                      AND TSM.Dt_Exam_Date < DATEADD(d,
                                                              1, @dtEndDate)
                                                    )
                                                AND TSM.I_Center_ID IN (
                                                SELECT  FGCFR.centerID
                                                FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
                                                              @iBrandID) AS FGCFR )
                                                AND TMM.S_Module_Name LIKE '%ADCHK%'
--GROUP BY TBEM.I_Batch_ID,TBEM.I_Term_ID,TBEM.I_Module_ID,TBEM.I_Exam_Component_ID,TSM.I_Student_Detail_ID
                                    ) TX
                            WHERE   TX.PercentMarks >= 0
                                    AND TX.PercentMarks <= 40 --AND TX.I_Batch_ID=8449
GROUP BY                            TX.I_Batch_ID ,
                                    TX.I_Term_ID ,
                                    TX.I_Module_ID ,
                                    TX.I_Exam_Component_ID
                          ) T2 ON T1.BatchID = T2.I_Batch_ID
                                  AND T1.TermID = T2.I_Term_ID
                                  AND T1.ModuleID = T2.I_Module_ID
                                  AND T1.ExamComponentID = T2.I_Exam_Component_ID



        UPDATE  T1
        SET     T1.Slot2 = T2.Std
        FROM    #MRKDTLS AS T1
                LEFT JOIN ( SELECT  TX.I_Batch_ID ,
                                    TX.I_Term_ID ,
                                    TX.I_Module_ID ,
                                    TX.I_Exam_Component_ID ,
                                    COUNT(DISTINCT TX.I_Student_Detail_ID) AS Std
                            FROM    ( SELECT    TBEM.I_Batch_ID ,
                                                TBEM.I_Term_ID ,
                                                TBEM.I_Module_ID ,
                                                TBEM.I_Exam_Component_ID ,
                                                TSM.I_Student_Detail_ID ,
                                                ( ( CAST(TSM.I_Exam_Total AS DECIMAL)
                                                    / CAST(TMES.I_TotMarks AS DECIMAL) )
                                                  * 100 ) AS PercentMarks
                                      FROM      EXAMINATION.T_Student_Marks AS TSM
                                                INNER JOIN EXAMINATION.T_Batch_Exam_Map
                                                AS TBEM ON TBEM.I_Batch_Exam_ID = TSM.I_Batch_Exam_ID
                                                INNER JOIN dbo.T_Module_Eval_Strategy
                                                AS TMES ON TMES.I_Exam_Component_ID = TBEM.I_Exam_Component_ID
                                                           AND TMES.I_Module_ID = TBEM.I_Module_ID
                                                           AND TMES.I_Term_ID = TBEM.I_Term_ID
                                                INNER JOIN dbo.T_Module_Master
                                                AS TMM ON TMM.I_Module_ID = TBEM.I_Module_ID
                                      WHERE     TBEM.I_Status = 1
                                                AND TMES.I_Status = 1
                                                AND ( TSM.Dt_Exam_Date >= @dtStartDate
                                                      AND TSM.Dt_Exam_Date < DATEADD(d,
                                                              1, @dtEndDate)
                                                    )
                                                AND TSM.I_Center_ID IN (
                                                SELECT  FGCFR.centerID
                                                FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
                                                              @iBrandID) AS FGCFR )
                                                AND TMM.S_Module_Name LIKE '%ADCHK%'
--GROUP BY TBEM.I_Batch_ID,TBEM.I_Term_ID,TBEM.I_Module_ID,TBEM.I_Exam_Component_ID,TSM.I_Student_Detail_ID
                                    ) TX
                            WHERE   TX.PercentMarks > 40
                                    AND TX.PercentMarks <= 60 --AND TX.I_Batch_ID=8449
GROUP BY                            TX.I_Batch_ID ,
                                    TX.I_Term_ID ,
                                    TX.I_Module_ID ,
                                    TX.I_Exam_Component_ID
                          ) T2 ON T1.BatchID = T2.I_Batch_ID
                                  AND T1.TermID = T2.I_Term_ID
                                  AND T1.ModuleID = T2.I_Module_ID
                                  AND T1.ExamComponentID = T2.I_Exam_Component_ID


        UPDATE  T1
        SET     T1.Slot3 = T2.Std
        FROM    #MRKDTLS AS T1
                LEFT JOIN ( SELECT  TX.I_Batch_ID ,
                                    TX.I_Term_ID ,
                                    TX.I_Module_ID ,
                                    TX.I_Exam_Component_ID ,
                                    COUNT(DISTINCT TX.I_Student_Detail_ID) AS Std
                            FROM    ( SELECT    TBEM.I_Batch_ID ,
                                                TBEM.I_Term_ID ,
                                                TBEM.I_Module_ID ,
                                                TBEM.I_Exam_Component_ID ,
                                                TSM.I_Student_Detail_ID ,
                                                ( ( CAST(TSM.I_Exam_Total AS DECIMAL)
                                                    / CAST(TMES.I_TotMarks AS DECIMAL) )
                                                  * 100 ) AS PercentMarks
                                      FROM      EXAMINATION.T_Student_Marks AS TSM
                                                INNER JOIN EXAMINATION.T_Batch_Exam_Map
                                                AS TBEM ON TBEM.I_Batch_Exam_ID = TSM.I_Batch_Exam_ID
                                                INNER JOIN dbo.T_Module_Eval_Strategy
                                                AS TMES ON TMES.I_Exam_Component_ID = TBEM.I_Exam_Component_ID
                                                           AND TMES.I_Module_ID = TBEM.I_Module_ID
                                                           AND TMES.I_Term_ID = TBEM.I_Term_ID
                                                INNER JOIN dbo.T_Module_Master
                                                AS TMM ON TMM.I_Module_ID = TBEM.I_Module_ID
                                      WHERE     TBEM.I_Status = 1
                                                AND TMES.I_Status = 1
                                                AND ( TSM.Dt_Exam_Date >= @dtStartDate
                                                      AND TSM.Dt_Exam_Date < DATEADD(d,
                                                              1, @dtEndDate)
                                                    )
                                                AND TSM.I_Center_ID IN (
                                                SELECT  FGCFR.centerID
                                                FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
                                                              @iBrandID) AS FGCFR )
                                                AND TMM.S_Module_Name LIKE '%ADCHK%'
--GROUP BY TBEM.I_Batch_ID,TBEM.I_Term_ID,TBEM.I_Module_ID,TBEM.I_Exam_Component_ID,TSM.I_Student_Detail_ID
                                    ) TX
                            WHERE   TX.PercentMarks > 60
                                    AND TX.PercentMarks <= 80 --AND TX.I_Batch_ID=8449
GROUP BY                            TX.I_Batch_ID ,
                                    TX.I_Term_ID ,
                                    TX.I_Module_ID ,
                                    TX.I_Exam_Component_ID
                          ) T2 ON T1.BatchID = T2.I_Batch_ID
                                  AND T1.TermID = T2.I_Term_ID
                                  AND T1.ModuleID = T2.I_Module_ID
                                  AND T1.ExamComponentID = T2.I_Exam_Component_ID

        UPDATE  T1
        SET     T1.Slot4 = T2.Std
        FROM    #MRKDTLS AS T1
                LEFT JOIN ( SELECT  TX.I_Batch_ID ,
                                    TX.I_Term_ID ,
                                    TX.I_Module_ID ,
                                    TX.I_Exam_Component_ID ,
                                    COUNT(DISTINCT TX.I_Student_Detail_ID) AS Std
                            FROM    ( SELECT    TBEM.I_Batch_ID ,
                                                TBEM.I_Term_ID ,
                                                TBEM.I_Module_ID ,
                                                TBEM.I_Exam_Component_ID ,
                                                TSM.I_Student_Detail_ID ,
                                                ( ( CAST(TSM.I_Exam_Total AS DECIMAL)
                                                    / CAST(TMES.I_TotMarks AS DECIMAL) )
                                                  * 100 ) AS PercentMarks
                                      FROM      EXAMINATION.T_Student_Marks AS TSM
                                                INNER JOIN EXAMINATION.T_Batch_Exam_Map
                                                AS TBEM ON TBEM.I_Batch_Exam_ID = TSM.I_Batch_Exam_ID
                                                INNER JOIN dbo.T_Module_Eval_Strategy
                                                AS TMES ON TMES.I_Exam_Component_ID = TBEM.I_Exam_Component_ID
                                                           AND TMES.I_Module_ID = TBEM.I_Module_ID
                                                           AND TMES.I_Term_ID = TBEM.I_Term_ID
                                                INNER JOIN dbo.T_Module_Master
                                                AS TMM ON TMM.I_Module_ID = TBEM.I_Module_ID
                                      WHERE     TBEM.I_Status = 1
                                                AND TMES.I_Status = 1
                                                AND ( TSM.Dt_Exam_Date >= @dtStartDate
                                                      AND TSM.Dt_Exam_Date < DATEADD(d,
                                                              1, @dtEndDate)
                                                    )
                                                AND TSM.I_Center_ID IN (
                                                SELECT  FGCFR.centerID
                                                FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
                                                              @iBrandID) AS FGCFR )
                                                AND TMM.S_Module_Name LIKE '%ADCHK%'
--GROUP BY TBEM.I_Batch_ID,TBEM.I_Term_ID,TBEM.I_Module_ID,TBEM.I_Exam_Component_ID,TSM.I_Student_Detail_ID
                                    ) TX
                            WHERE   TX.PercentMarks > 80
                                    AND TX.PercentMarks <= 100 --AND TX.I_Batch_ID=8449
GROUP BY                            TX.I_Batch_ID ,
                                    TX.I_Term_ID ,
                                    TX.I_Module_ID ,
                                    TX.I_Exam_Component_ID
                          ) T2 ON T1.BatchID = T2.I_Batch_ID
                                  AND T1.TermID = T2.I_Term_ID
                                  AND T1.ModuleID = T2.I_Module_ID
                                  AND T1.ExamComponentID = T2.I_Exam_Component_ID

*/

        SELECT DISTINCT M.TermID,M.TermName,M.ModuleID,M.ModuleName,M.ExamComponentID,M.ExamComponentName,M.FacultyID,M.FacultyName
        FROM    #MRKDTLS AS M
        




        DROP TABLE #MASTER
        DROP TABLE #MRKDTLS


    END
