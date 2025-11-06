

--EXEC [REPORT].[uspGetStudentAttendanceSummaryReport] '88',109,null,null,9,2013
CREATE PROCEDURE [REPORT].[uspGetStudentAttendanceSummaryReporttemp]
    (
      @sHierarchyList VARCHAR(MAX) ,
      @iBrandID INT ,
      @iBatchID INT = NULL ,
      @iTermID INT = NULL ,
      @iMonth INT = NULL ,
      @iYear INT = NULL,
      @dtStartDate DATETIME,
      @dtEndDate DATETIME
    )
AS 
    BEGIN TRY

        DECLARE @StartDate AS DATE ,
            @EndDate AS DATE
            
        SET @StartDate=@dtStartDate
        SET @EndDate=@dtEndDate    

        --SET @StartDate = CAST(@iYear AS VARCHAR) + '-'
        --    + CAST(@iMonth AS VARCHAR) + '-' + '01' 
        --SET @EndDate = DATEADD(dd, -1, DATEADD(mm, 1, @StartDate))
        PRINT @StartDate
        PRINT @EndDate
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
              CentreId INT ,
              CentreName VARCHAR(100) ,
              CourseID INT ,
              CourseName VARCHAR(150) ,
              DepartmentId INT ,
              Department VARCHAR(250) ,
              [TotalNoOfStudent] INT ,
              [TotalClass] INT ,
              [AttendedClass] INT ,
              InPercentage DECIMAL(14,2)--DECIMAL(10, 2)
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
	
        INSERT  INTO @Result
                ( CentreId ,
                  CentreName ,
                  DepartmentId ,
                  Department ,
                  CourseID ,
                  CourseName ,
                  [TotalClass]
		)
                SELECT  TCM2.I_Centre_Id ,
                        TCM2.S_Center_Name ,
                        TSBM.I_Batch_ID ,
                        TSBM.S_Batch_Name ,
                        TCM.I_Course_ID ,
                        TCM.S_Course_Name ,
                        COUNT(DISTINCT TTTM.I_TimeTable_ID)
                FROM    dbo.T_TimeTable_Master TTTM
                        INNER JOIN dbo.T_Student_Batch_Master TSBM ON TTTM.I_Batch_ID = TSBM.I_Batch_ID
                        INNER JOIN dbo.T_Center_Batch_Details TCBD ON TSBM.I_Batch_ID = TCBD.I_Batch_ID
                        INNER JOIN dbo.T_Course_Master TCM ON TSBM.I_Course_ID = TCM.I_Course_ID
                        INNER JOIN dbo.T_Centre_Master TCM2 ON TCBD.I_Centre_Id = TCM2.I_Centre_Id
                        INNER JOIN @tempResult A ON TCBD.I_Centre_Id = A.centreId
                WHERE   TSBM.I_Batch_ID = ISNULL(@iBatchID, TSBM.I_Batch_ID)
                        AND TTTM.Dt_Schedule_Date >= @StartDate
                        AND TTTM.Dt_Schedule_Date < DATEADD(d,1,@EndDate)
                        AND TTTM.I_Status = 1
                        --AND TTCM.I_Status = 1
                GROUP BY TCM2.I_Centre_Id ,
                        TCM2.S_Center_Name ,
                        TCM.I_Course_ID ,
                        TCM.S_Course_Name ,
                        TSBM.I_Batch_ID ,
                        TSBM.S_Batch_Name

                ORDER BY TSBM.S_Batch_Name	
                
        SELECT * FROM @Result AS R        
	
        --UPDATE  T
        --SET     T.TotalNoOfStudent = A.TotStudent
        --FROM    @Result T
        --        INNER JOIN ( SELECT --TCBD.I_Centre_Id AS I_Center_ID ,
        --                            R.DepartmentId AS I_Batch_ID ,
        --                            COUNT(DISTINCT SABD.I_Student_ID) AS TotStudent
        --                     FROM   
        --                     --dbo.T_Student_Batch_Details TSBD
        --                     --       INNER JOIN dbo.T_Student_Batch_Master TSBM ON TSBD.I_Batch_ID = TSBM.I_Batch_ID
        --                     --       INNER JOIN dbo.T_Center_Batch_Details TCBD ON TSBM.I_Batch_ID = TCBD.I_Batch_ID
        --                     --       INNER JOIN @tempResult A ON TCBD.I_Centre_Id = A.centreId
        --                     --       INNER JOIN dbo.T_Course_Master TCM ON TSBM.I_Course_ID = TCM.I_Course_ID
        --                     @Result AS R
        --                     INNER JOIN dbo.StudentActiveBatchDuration AS SABD ON R.DepartmentId=SABD.I_Batch_ID
        --                     WHERE  --TSBD.I_Status = 1
        --                     @EndDate BETWEEN SABD.ActiveFromDate AND SABD.ActiveToDate
        --                     GROUP BY R.DepartmentId
        --                   ) A ON --T.CentreId = A.I_Center_ID
        --                          T.DepartmentId = A.I_Batch_ID
                                  
	
	
	
        UPDATE  T
        SET     T.[AttendedClass] = A.noattend
        FROM    @Result T
                INNER JOIN ( SELECT tttm.I_Center_ID ,
                                    tttm.I_Batch_ID ,
                                    COUNT(*) noattend
                             FROM   dbo.T_TimeTable_Master AS tttm
                                    INNER JOIN @tempResult A ON tttm.I_Center_ID = A.centreId
                                    INNER JOIN dbo.T_Student_Attendance AS tsa ON tsa.I_TimeTable_ID = tttm.I_TimeTable_ID
                             WHERE  CAST(tttm.Dt_Schedule_Date AS DATE) BETWEEN @StartDate
                                                              AND
                                                              @EndDate
                             GROUP BY tttm.I_Center_ID ,
                                    tttm.I_Batch_ID 
                           ) A ON T.CentreId = A.I_Center_ID
                                  AND T.DepartmentId = A.I_Batch_ID
                                  --AND T.TermID = A.I_Term_ID
	
	
		--UPDATE  @Result
  --      SET     AttendedClass = ROUND(( [AttendedClass]
  --                                      / ( ISNULL([TotalClass], 0) ) ), 0)
	
	
  --      UPDATE  @Result
  --      SET     InPercentage = ROUND(( ( CAST([AttendedClass] AS FLOAT)
  --                                       / CAST(( ISNULL([TotalNoOfStudent], 0)
  --                                                 ) AS FLOAT) )
  --                                     * 100 ), 2)
        
        
  --      UPDATE @Result SET InPercentage=100.00 WHERE InPercentage>100
	
        SELECT  R.* 
                --FN2.instanceChain
        FROM    @Result R
                --INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList,
                --                                          @iBrandID) FN1 ON R.CentreID = FN1.CenterID
                --INNER JOIN [dbo].[fnGetInstanceNameChainForReports](@sHierarchyList,
                --                                              @iBrandID) FN2 ON FN1.HierarchyDetailID = FN2.HierarchyDetailID

	
	
	


    END TRY

    BEGIN CATCH
	
        DECLARE @ErrMsg NVARCHAR(4000) ,
            @ErrSeverity INT

        SELECT  @ErrMsg = ERROR_MESSAGE() ,
                @ErrSeverity = ERROR_SEVERITY()

        RAISERROR(@ErrMsg, @ErrSeverity, 1)
    END CATCH
