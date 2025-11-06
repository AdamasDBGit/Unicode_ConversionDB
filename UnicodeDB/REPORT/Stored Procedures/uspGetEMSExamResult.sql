CREATE PROCEDURE [REPORT].[uspGetEMSExamResult]
    (
      @dtStartDate DATE ,
      @dtEndDate DATE ,
      @sHierarchyListID VARCHAR(MAX) ,
      @iBrandID INT ,
      @sBatchID VARCHAR(MAX) = NULL
    )
AS 
    BEGIN


        CREATE TABLE #temp
            (
              Course VARCHAR(MAX) ,
              Ecat VARCHAR(MAX) ,
              EName VARCHAR(MAX) ,
              StudentID VARCHAR(MAX) ,
              StudentName VARCHAR(MAX) ,
              Marks DECIMAL(14, 2) ,
              SubjectID INT ,
              SubName VARCHAR(MAX) ,
              SubTotalMarks DECIMAL(14, 2) ,
              EStatus VARCHAR(MAX) ,
              OverallRank INT ,
              ExamDate DATE
            )
            
        CREATE TABLE #temp1
            (
              Course VARCHAR(MAX) ,
              Ecat VARCHAR(MAX) ,
              EName VARCHAR(MAX) ,
              StudentID VARCHAR(MAX) ,
              StudentName VARCHAR(MAX) ,
              ExamDate DATE ,
              EStatus VARCHAR(MAX) ,
              Marks DECIMAL(14, 2) ,
              OverallRank INT ,
              BatchID INT ,
              BatchName VARCHAR(MAX) ,
              CenterID INT ,
              CenterName VARCHAR(MAX) ,
              BrandName VARCHAR(MAX) ,
              BatchRank INT ,
              CenterRank INT ,
              ContactNo VARCHAR(20) ,
              StateRank INT
            )

        DECLARE @dtStart VARCHAR(MAX)
        DECLARE @dtEnd VARCHAR(MAX)
        DECLARE @Sql NVARCHAR(500)


        SET @dtEnd = CAST(@dtEndDate AS VARCHAR)
        SET @dtStart = CAST(@dtStartDate AS VARCHAR)
--SET @Sql='SELECT * from RICE_EMS.EXAMINATION.T_ExamResult_Archive where ExamDate=@dtStart'

        SET @Sql = 'SELECT * FROM OPENQUERY(QBOLE,''select * from RICE_EMS.EXAMINATION.T_ExamResult_Archive where ExamDate between '''''
            + @dtStart + '''''and ''''' + @dtEnd + ''''''')' 
            
        INSERT  INTO #temp
                EXECUTE ( @Sql
                       )
        
        INSERT  INTO #temp1
                ( Course ,
                  Ecat ,
                  EName ,
                  StudentID ,
                  StudentName ,
                  ExamDate ,
                  EStatus ,
                  Marks ,
                  OverallRank
                 
                )
                SELECT DISTINCT
                        TTT.Course ,
                        TTT.Ecat ,
                        TTT.EName ,
                        TTT.StudentID ,
                        TTT.StudentName ,
                        TTT.ExamDate ,
                        TTT.EStatus ,
                        TTT.Marks ,
                        TTT.OverallRank
                FROM    #temp TTT
        
        
        UPDATE  TT
        SET     TT.BatchID = TTT.BatchID ,
                TT.BatchName = TTT.BatchName 
                --TT.ContactNo = TTT.ContactNo
        FROM    #temp1 TT
                INNER JOIN ( 
                --SELECT T1.StudentID ,
                --                    dbo.fnGetHistoricalBatchID(TSD.I_Student_Detail_ID,
                --                                              GETDATE()) AS BatchID ,
                --                    dbo.fnGetHistoricalBatchName(TSD.I_Student_Detail_ID,
                --                                              GETDATE()) AS BatchName ,
                --                    TSD.S_Mobile_No AS ContactNo
                --             FROM   #temp T1
                --                    INNER JOIN dbo.T_Student_Detail TSD ON T1.StudentID = TSD.S_Student_ID
															SELECT T1.I_Student_ID AS StudentID ,
                                                    T2.I_Batch_ID AS BatchID,
                                                    T2.S_Batch_Name AS BatchName
                                             FROM   ( SELECT  TSD.I_Student_Detail_ID,TSD.S_Student_ID AS I_Student_ID ,
                                                              MAX(TSBD2.I_Student_Batch_ID) AS ID
                                                      FROM    dbo.T_Student_Batch_Details TSBD2
                                                      INNER JOIN dbo.T_Student_Detail TSD ON TSBD2.I_Student_ID=TSD.I_Student_Detail_ID
                                                      WHERE   TSBD2.I_Status IN (
                                                              1, 3 )
                                                      GROUP BY TSD.I_Student_Detail_ID,TSD.S_Student_ID
                                                    ) T1
                                                    INNER JOIN ( SELECT
                                                              TSBD3.I_Student_ID ,
                                                              TSBD3.I_Student_Batch_ID AS ID ,
                                                              TSBD3.I_Batch_ID,
                                                              TSBM.S_Batch_Name
                                                              FROM
                                                              dbo.T_Student_Batch_Details TSBD3
                                                              INNER JOIN dbo.T_Student_Batch_Master TSBM ON TSBD3.I_Batch_ID = TSBM.I_Batch_ID
                                                              WHERE
                                                              TSBD3.I_Status IN (
                                                              1, 3 )
                                                              ) T2 ON T1.I_Student_Detail_ID = T2.I_Student_ID
                                                              AND T1.ID = T2.ID
                           ) TTT ON TT.StudentID = TTT.StudentID
                           
                           
                           UPDATE TT
                           SET TT.ContactNo=TSD.S_Mobile_No
                           FROM
                           #temp1 TT
                           INNER JOIN dbo.T_Student_Detail TSD ON TT.StudentID=TSD.S_Student_ID
        
        
        UPDATE  TT
        SET     TT.CenterID = T1.I_Center_ID ,
                TT.CenterName = T1.S_Center_Name ,
                TT.BrandName = T1.S_Brand_Name
        FROM    #temp1 TT
                INNER JOIN ( SELECT TCBD.I_Batch_ID ,
                                    TCHND.I_Center_ID ,
                                    TCHND.S_Center_Name ,
                                    TCHND.S_Brand_Name
                             FROM   dbo.T_Center_Batch_Details TCBD
                                    INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TCBD.I_Centre_Id = TCHND.I_Center_ID
                           ) T1 ON TT.BatchID = T1.I_Batch_ID
                           
        DECLARE @Exam VARCHAR(MAX)
        DECLARE ExamSelector CURSOR
        FOR
        SELECT DISTINCT EName FROM #temp TT
                           
        OPEN ExamSelector
        FETCH NEXT FROM ExamSelector
                           INTO @Exam
                           
        WHILE @@FETCH_STATUS = 0 
            BEGIN
                PRINT @Exam
                UPDATE  T2
                SET     T2.BatchRank = T3.BatchRank
                FROM    #temp1 T2
                        INNER JOIN ( SELECT T1.EName ,
                                            T1.BatchID ,
                                            T1.StudentID ,
                                            DENSE_RANK() OVER ( PARTITION BY T1.BatchID ORDER BY T1.Marks DESC ) AS BatchRank
                                     FROM   #temp1 T1
                                     WHERE  T1.EName = @Exam
                                   ) T3 ON T2.BatchID = T3.BatchID
                                           AND T2.StudentID = T3.StudentID
                                           AND T2.EName = T3.EName
                                           
                                   
                                   
                UPDATE  T2
                SET     T2.CenterRank = T3.CenterRank
                FROM    #temp1 T2
                        INNER JOIN ( SELECT T1.EName ,
                                            T1.CenterID ,
                                            T1.StudentID ,
                                            DENSE_RANK() OVER ( PARTITION BY CenterID ORDER BY Marks DESC ) AS CenterRank
                                     FROM   #temp1 T1
                                     WHERE  T1.EName = @Exam
                                   ) T3 ON T2.StudentID = T3.StudentID
                                           AND T2.CenterID = T3.CenterID
                                           AND T2.EName = T3.EName
                                   
                                   
                UPDATE  T2
                SET     T2.StateRank = T3.StateRank
                FROM    #temp1 T2
                        INNER JOIN ( SELECT T1.EName ,
                                            T1.CenterID ,
                                            T1.StudentID ,
                                            DENSE_RANK() OVER ( PARTITION BY EName ORDER BY Marks DESC ) AS StateRank
                                     FROM   #temp1 T1
                                     WHERE  T1.EName = @Exam
                                   ) T3 ON T2.StudentID = T3.StudentID
                                           AND T2.CenterID = T3.CenterID
                                           AND T2.EName = T3.EName
                                   
                                   
                FETCH NEXT FROM ExamSelector
                                   INTO @Exam
                                   
            END
                                   
        CLOSE ExamSelector
        DEALLOCATE ExamSelector
                                   
        
        

        IF ( @sBatchID IS NULL
             OR @sBatchID = ''
           ) 
            BEGIN
                SELECT  *
                FROM    #temp1 TT
                WHERE   TT.CenterID IN (
                        SELECT  FGCFR.centerID
                        FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
                                                           @iBrandID) FGCFR )
                ORDER BY TT.EName ,
                        TT.CenterID ,
                        TT.BatchID ,
                        TT.Marks
            END
        ELSE 
            BEGIN
                SELECT  *
                FROM    #temp1 TT
                WHERE   TT.CenterID IN (
                        SELECT  FGCFR.centerID
                        FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
                                                           @iBrandID) FGCFR )
                        AND TT.BatchID IN (
                        SELECT  CAST(FSR.Val AS INT)
                        FROM    dbo.fnString2Rows(@sBatchID, ',') FSR )
                ORDER BY TT.EName ,
                        TT.CenterID ,
                        TT.BatchID ,
                        TT.Marks
            END
        

    END

