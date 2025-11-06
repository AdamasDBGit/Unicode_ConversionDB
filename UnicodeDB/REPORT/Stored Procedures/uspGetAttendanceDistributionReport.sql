
--EXEC [REPORT].[uspGetAttendanceDistributionReport] '127',109,'2013-08-01','2013-08-31',12,34
CREATE PROCEDURE [REPORT].[uspGetAttendanceDistributionReport]
    (
      @sHierarchyList VARCHAR(MAX) ,
      @iBrandID INT ,
      @StartDate DATE ,
      @EndDate DATE ,
      @CourseId INT = NULL ,
      @TermId INT = NULL
	
    )
AS 
    BEGIN TRY
--Declare @pHierachyID varchar(max),@pBranndID INT,@StartDate date,@EndDate Date
--SELECT @pHierachyID='127',@pBranndID=109,@StartDate='2012-03-01',@EndDate='2013-03-30'

--SELECT * FROM dbo.fnGetCentersForReports(@pHierachyID, @pBranndID) AS fgcfr

        DECLARE @tempResult TABLE
            (
              id INT IDENTITY ,
              HierachyID INT ,
              BrandID INT ,
              centreId INT ,
              centrecode VARCHAR(100) ,
              centrename VARCHAR(MAX)
            )
	
        DECLARE @Result TABLE
            (
              id INT IDENTITY ,
              centreId INT ,
              Batch_Start DATE,
              centrename VARCHAR(MAX) ,
              CourseID INT ,
              CourseName VARCHAR(250) ,
              TermID INT ,
              TermName VARCHAR(250) ,
              BatchID INT ,
              BatchName VARCHAR(250) ,
              TotalStudentNo INT ,
              I_Total_Session_Count INT ,
              StudentAbsentNo INT ,
              Student40No INT ,
              Student50No INT ,
              Student60No INT ,
              Student70No INT ,
              Student80No INT ,
              Student90No INT ,
              Student95No INT ,
              Student100No INT
            )
	
	
	
		
        DECLARE @tempTransactionResult TABLE
            (
              centreId INT ,
              centrename VARCHAR(MAX) ,
              CourseID INT ,
              CourseName VARCHAR(250) ,
              TermID INT ,
              TermName VARCHAR(250) ,
              BatchID INT ,
              BatchName VARCHAR(250) ,
              I_TimeTable_ID INT ,
              I_Student_ID INT ,
              Dt_Schedule_Date DATE ,
              I_Total_Session_Count INT
            )
	
	
	
        INSERT  INTO @tempResult
                ( BrandID ,
                  HierachyID ,
                  centreId ,
                  centrecode ,
                  centrename 
                )
                SELECT  *
                FROM    dbo.fnGetCentersForReports(@sHierarchyList, @iBrandID)
                        AS fgcfr
	
	
	

        INSERT  INTO @tempTransactionResult
                ( centreId ,
                  centrename ,
                  CourseID ,
                  CourseName ,
                  TermID ,
                  TermName ,
                  BatchID ,
                  BatchName ,
                  I_TimeTable_ID ,
                  I_Student_ID ,
                  Dt_Schedule_Date ,
                  I_Total_Session_Count 
	          )
                SELECT   DISTINCT
                        tcbd.I_Centre_Id ,
                        b.centrename ,
                        tsbm.I_Course_ID ,
                        tcm.S_Course_Name ,
                        tttm.I_Term_ID ,
                        ttm.S_Term_Name ,
                        tcbd.I_Batch_ID ,
                        tsbm.S_Batch_Name ,
                        tsa.I_TimeTable_ID ,
                        tsbd.I_Student_ID ,
                        tttm.Dt_Schedule_Date ,
                        ( SELECT    COUNT(*)
                          FROM      T_TimeTable_Master TTM1
                          WHERE     TTM1.I_Center_ID = b.centreId
                                    AND TTM1.I_Batch_ID = tsbm.I_Batch_ID
                                    AND TTM1.I_Term_ID = tttm.I_Term_ID
                                    AND CAST(TTM1.Dt_Schedule_Date AS DATE) BETWEEN @StartDate
                                                              AND
                                                              @EndDate
                        )
                FROM    dbo.T_Center_Batch_Details AS tcbd WITH ( NOLOCK )
                        INNER JOIN @tempResult b ON tcbd.I_Centre_Id = b.centreId
                        INNER JOIN dbo.T_Student_Batch_Master AS tsbm WITH ( NOLOCK ) ON tcbd.I_Batch_ID = tsbm.I_Batch_ID
                        INNER JOIN dbo.T_Course_Master AS tcm WITH ( NOLOCK ) ON tsbm.I_Course_ID = tcm.I_Course_ID
                        INNER JOIN dbo.T_Student_Batch_Details AS tsbd WITH ( NOLOCK ) ON tsbd.I_Batch_ID = tcbd.I_Batch_ID
                                                              AND tsbd.I_Status = 1
                        INNER JOIN dbo.T_Student_Center_Detail AS tscd WITH ( NOLOCK ) ON tscd.I_Student_Detail_ID = tsbd.I_Student_ID
                                                              AND tscd.I_Centre_Id = tcbd.I_Centre_Id
                        INNER JOIN dbo.T_Student_Attendance AS tsa WITH ( NOLOCK ) ON tsa.I_Student_Detail_ID = tscd.I_Student_Detail_ID
                        INNER JOIN dbo.T_TimeTable_Master AS tttm WITH ( NOLOCK ) ON tsa.I_TimeTable_ID = tttm.I_TimeTable_ID
                        INNER JOIN dbo.T_Term_Master AS ttm WITH ( NOLOCK ) ON tttm.I_Term_ID = ttm.I_Term_ID
                WHERE   CAST(tttm.Dt_Schedule_Date AS DATE) BETWEEN @StartDate
                                                            AND
                                                              @EndDate
                        AND tttm.I_Term_ID = COALESCE(@TermId, tttm.I_Term_ID)
                        AND tsbm.I_Course_ID = COALESCE(@CourseId,
                                                        tsbm.I_Course_ID)
	
	
        INSERT  INTO @Result
                ( centreId ,
                  centrename ,
                  CourseID ,
                  CourseName ,
                  TermID ,
                  TermName ,
                  BatchID ,
                  BatchName ,
                  I_Total_Session_Count
	
	          )
                SELECT DISTINCT
                        centreId ,
                        centrename ,
                        CourseID ,
                        CourseName ,
                        TermID ,
                        TermName ,
                        BatchID ,
                        BatchName ,
                        I_Total_Session_Count
                FROM    @tempTransactionResult 
	
	
	
        UPDATE  T
        SET     TotalStudentNo = A.tno
        FROM    @Result T
                INNER JOIN ( SELECT V.I_Centre_Id ,
                                    V.I_Course_ID ,
                                    V.I_Batch_ID ,
                                    COUNT(*) tno
                             FROM   ( SELECT DISTINCT
                                                tcbd.I_Centre_Id ,
                                                tsbm.I_Course_ID ,
                                                tcbd.I_Batch_ID ,
                                                tsbd.I_Student_ID
                                      FROM      dbo.T_Center_Batch_Details AS tcbd
                                                WITH ( NOLOCK )
                                                INNER JOIN @tempResult b ON tcbd.I_Centre_Id = b.centreId
                                                INNER JOIN dbo.T_Student_Batch_Master
                                                AS tsbm WITH ( NOLOCK ) ON tcbd.I_Batch_ID = tsbm.I_Batch_ID
                                                INNER JOIN dbo.T_Student_Batch_Details
                                                AS tsbd WITH ( NOLOCK ) ON tsbd.I_Batch_ID = tcbd.I_Batch_ID AND tsbd.I_Status = 1
                                                INNER JOIN dbo.T_Student_Center_Detail
                                                AS tscd WITH ( NOLOCK ) ON tscd.I_Student_Detail_ID = tsbd.I_Student_ID
                                                              AND tscd.I_Centre_Id = tcbd.I_Centre_Id
                                    ) V
                             GROUP BY V.I_Centre_Id ,
                                    V.I_Course_ID ,
                                    V.I_Batch_ID
                           ) A ON A.I_Centre_Id = T.centreId
                                  AND A.I_Course_ID = T.CourseID
                                  AND A.I_Batch_ID = T.BatchID


        UPDATE  @Result
        SET     Student40No = V.pertcent40NO ,
                Student50No = V.pertcent50NO ,
                Student60No = V.pertcent60NO ,
                Student70No = v.pertcent70NO ,
                Student80No = v.pertcent80NO ,
                Student90No = v.pertcent90NO ,
                Student95No = v.pertcent95NO ,
                Student100No = v.pertcent100NO
        FROM    @Result T
                INNER JOIN ( SELECT Vr.centreId ,
                                    Vr.CourseID ,
                                    Vr.TermID ,
                                    Vr.BatchID ,
                                    SUM(vr.Is40pertcent) pertcent40NO ,
                                    SUM(vr.Is50pertcent) pertcent50NO ,
                                    SUM(vr.Is60pertcent) pertcent60NO ,
                                    SUM(vr.Is70pertcent) pertcent70NO ,
                                    SUM(vr.Is80pertcent) pertcent80NO ,
                                    SUM(vr.Is90pertcent) pertcent90NO ,
                                    SUM(vr.Is95pertcent) pertcent95NO ,
                                    SUM(vr.Is100pertcent) pertcent100NO
                             FROM   ( SELECT    centreId ,
                                                CourseID ,
                                                TermID ,
                                                BatchID ,
                                                I_Student_ID ,
                                                I_Total_Session_Count ,
                                                CASE WHEN I_Total_Session_Count > 0
                                                     THEN CASE
                                                              WHEN CAST(ROUND(( CONVERT(DECIMAL, COUNT(*))
                                                              / CONVERT(DECIMAL, I_Total_Session_Count) )
                                                              * 100, 0) AS INT) < 40
                                                              THEN 1
                                                              ELSE 0
                                                          END
                                                     ELSE 0
                                                END Is40pertcent ,
                                                CASE WHEN I_Total_Session_Count > 0
                                                     THEN CASE
                                                              WHEN ( CAST(ROUND(( CONVERT(DECIMAL, COUNT(*))
                                                              / CONVERT(DECIMAL, I_Total_Session_Count) )
                                                              * 100, 0) AS INT) < 50 )
                                                              AND ( CAST(ROUND(( CONVERT(DECIMAL, COUNT(*))
                                                              / CONVERT(DECIMAL, I_Total_Session_Count) )
                                                              * 100, 0) AS INT) >= 40 )
                                                              THEN 1
                                                              ELSE 0
                                                          END
                                                     ELSE 0
                                                END Is50pertcent ,
                                                CASE WHEN I_Total_Session_Count > 0
                                                     THEN CASE
                                                              WHEN ( CAST(ROUND(( CONVERT(DECIMAL, COUNT(*))
                                                              / CONVERT(DECIMAL, I_Total_Session_Count) )
                                                              * 100, 0) AS INT) < 60 )
                                                              AND ( CAST(ROUND(( CONVERT(DECIMAL, COUNT(*))
                                                              / CONVERT(DECIMAL, I_Total_Session_Count) )
                                                              * 100, 0) AS INT) >= 50 )
                                                              THEN 1
                                                              ELSE 0
                                                          END
                                                     ELSE 0
                                                END Is60pertcent ,
                                                CASE WHEN I_Total_Session_Count > 0
                                                     THEN CASE
                                                              WHEN ( CAST(ROUND(( CONVERT(DECIMAL, COUNT(*))
                                                              / CONVERT(DECIMAL, I_Total_Session_Count) )
                                                              * 100, 0) AS INT) < 70 )
                                                              AND ( CAST(ROUND(( CONVERT(DECIMAL, COUNT(*))
                                                              / CONVERT(DECIMAL, I_Total_Session_Count) )
                                                              * 100, 0) AS INT) >= 60 )
                                                              THEN 1
                                                              ELSE 0
                                                          END
                                                     ELSE 0
                                                END Is70pertcent ,
                                                CASE WHEN I_Total_Session_Count > 0
                                                     THEN CASE
                                                              WHEN ( CAST(ROUND(( CONVERT(DECIMAL, COUNT(*))
                                                              / CONVERT(DECIMAL, I_Total_Session_Count) )
                                                              * 100, 0) AS INT) < 80 )
                                                              AND ( CAST(ROUND(( CONVERT(DECIMAL, COUNT(*))
                                                              / CONVERT(DECIMAL, I_Total_Session_Count) )
                                                              * 100, 0) AS INT) >= 70 )
                                                              THEN 1
                                                              ELSE 0
                                                          END
                                                     ELSE 0
                                                END Is80pertcent ,
                                                CASE WHEN I_Total_Session_Count > 0
                                                     THEN CASE
                                                              WHEN ( CAST(ROUND(( CONVERT(DECIMAL, COUNT(*))
                                                              / CONVERT(DECIMAL, I_Total_Session_Count) )
                                                              * 100, 0) AS INT) < 90 )
                                                              AND ( CAST(ROUND(( CONVERT(DECIMAL, COUNT(*))
                                                              / CONVERT(DECIMAL, I_Total_Session_Count) )
                                                              * 100, 0) AS INT) >= 80 )
                                                              THEN 1
                                                              ELSE 0
                                                          END
                                                     ELSE 0
                                                END Is90pertcent ,
                                                CASE WHEN I_Total_Session_Count > 0
                                                     THEN CASE
                                                              WHEN ( CAST(ROUND(( CONVERT(DECIMAL, COUNT(*))
                                                              / CONVERT(DECIMAL, I_Total_Session_Count) )
                                                              * 100, 0) AS INT) < 95 )
                                                              AND ( CAST(ROUND(( CONVERT(DECIMAL, COUNT(*))
                                                              / CONVERT(DECIMAL, I_Total_Session_Count) )
                                                              * 100, 0) AS INT) >= 90 )
                                                              THEN 1
                                                              ELSE 0
                                                          END
                                                     ELSE 0
                                                END Is95pertcent ,
                                                CASE WHEN I_Total_Session_Count > 0
                                                     THEN CASE
                                                              WHEN ( CAST(ROUND(( CONVERT(DECIMAL, COUNT(*))
                                                              / CONVERT(DECIMAL, I_Total_Session_Count) )
                                                              * 100, 0) AS INT) <= 100 )
                                                              AND ( CAST(ROUND(( CONVERT(DECIMAL, COUNT(*))
                                                              / CONVERT(DECIMAL, I_Total_Session_Count) )
                                                              * 100, 0) AS INT) >= 95 )
                                                              THEN 1
                                                              ELSE 0
                                                          END
                                                     ELSE 0
                                                END Is100pertcent
                                      FROM      @tempTransactionResult
                                      GROUP BY  centreId ,
                                                CourseID ,
                                                TermID ,
                                                BatchID ,
                                                I_Student_ID ,
                                                I_Total_Session_Count
                                    ) Vr
                             GROUP BY vr.centreId ,
                                    vr.CourseID ,
                                    vr.TermID ,
                                    vr.BatchID
                           ) V ON v.centreId = T.centreId
                                  AND v.CourseID = T.CourseID
                                  AND V.TermID = T.TermID
                                  AND V.BatchID = T.BatchID
	
	
        UPDATE  @Result
        SET     StudentAbsentNo = TotalStudentNo - ( ISNULL(Student40No, 0)
                                                     + ISNULL(Student50No, 0)
                                                     + ISNULL(Student60No, 0)
                                                     + ISNULL(Student70No, 0)
                                                     + ISNULL(Student80No, 0)
                                                     + ISNULL(Student90No, 0)
                                                     + ISNULL(Student95No, 0)
                                                     + ISNULL(Student100No, 0) )
                                                     
         UPDATE T 
         
         SET T.Batch_Start=X.Dt_BatchStartDate
         
         FROM 
         
         @Result T 
         
         INNER JOIN
         
         (SELECT I_Batch_ID,CAST(Dt_BatchStartDate AS DATE) AS Dt_BatchStartDate FROM T_Student_Batch_Master A INNER JOIN @Result B ON B.BatchID=A.I_Batch_ID) X
         
         ON X.I_Batch_ID=T.BatchID
         
	
        SELECT  R.*,FN2.instanceChain
        FROM    @Result R
        INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList,
                                                              @iBrandID) FN1 ON R.centreId = FN1.CenterID
                        INNER JOIN [dbo].[fnGetInstanceNameChainForReports](@sHierarchyList,
                                                              @iBrandID) FN2 ON FN1.HierarchyDetailID = FN2.HierarchyDetailID
	
	
	


    END TRY

    BEGIN CATCH
	
        DECLARE @ErrMsg NVARCHAR(4000) ,
            @ErrSeverity INT

        SELECT  @ErrMsg = ERROR_MESSAGE() ,
                @ErrSeverity = ERROR_SEVERITY()

        RAISERROR(@ErrMsg, @ErrSeverity, 1)
    END CATCH
