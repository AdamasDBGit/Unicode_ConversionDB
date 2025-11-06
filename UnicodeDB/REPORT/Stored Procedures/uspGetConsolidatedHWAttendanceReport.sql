CREATE PROCEDURE [REPORT].[uspGetConsolidatedHWAttendanceReport]
    (
      @iBrandID INT ,
      @sHierarchyListID VARCHAR(MAX) ,
      @dtStartDate DATE ,
      @dtEndDate DATE
    )
AS 
    BEGIN
    
    SET NOCOUNT ON;
    
		 CREATE TABLE #temp
                    (
                      CentreID INT ,
                      BatchID INT ,
                      SchDate DATE ,
                      StdStrength INT
                    )
                    
         CREATE TABLE #temp1
         (
         CentreID INT,
         CentreName VARCHAR(MAX),
         WeekNo INT,
         WeekName VARCHAR(MAX),
         DayN VARCHAR(MAX),
         SchDay DATE,
         BatchID INT,
         BatchName VARCHAR(MAX),
         BatchStrength INT,
         Attended INT
         )           


                INSERT  INTO #temp
                        ( CentreID ,
                          BatchID ,
                          SchDate ,
                          StdStrength
                        )
                        SELECT  T1.I_Center_ID ,
                                T1.I_Batch_ID ,
                                T1.Dt_Schedule_Date ,
                                dbo.fnGetHistoricalBatchStrength(T1.I_Batch_ID,
                                                              T1.Dt_Schedule_Date)
                        FROM    ( SELECT DISTINCT
                                            TTTM.I_Center_ID ,
                                            TTTM.I_Batch_ID ,
                                            TTTM.Dt_Schedule_Date
                                  FROM      dbo.T_TimeTable_Master TTTM
                                            INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TTTM.I_Center_ID = TCHND.I_Center_ID
                                  WHERE     TTTM.I_Status = 1
                                            AND TCHND.I_Center_ID IN (
                                            SELECT  FGCFR.centerID
                                            FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
                                                              @iBrandID) FGCFR )
                                            AND ( TTTM.Dt_Schedule_Date >= @dtStartDate
                                                  AND TTTM.Dt_Schedule_Date < DATEADD(d,
                                                              1, @dtEndDate)
                                                )
                                ) T1

				INSERT INTO #temp1
				        ( CentreID ,
				          CentreName ,
				          WeekNo,
				          WeekName ,
				          DayN ,
				          SchDay ,
				          BatchID ,
				          BatchName ,
				          BatchStrength ,
				          Attended
				        )
				
                SELECT  TCHND.I_Center_ID ,
                        TCHND.S_Center_Name ,
                        DATEPART(WEEK, TTTM.Dt_Schedule_Date) AS WNo,
                        'Week' + ' '
                        + CAST(DATEPART(WEEK, TTTM.Dt_Schedule_Date) AS VARCHAR) AS WeekNo ,
                        DATENAME(dw, TTTM.Dt_Schedule_Date) AS Dateday ,
                        TTTM.Dt_Schedule_Date AS SchDate ,
                        TSBM.I_Batch_ID ,
                        TSBM.S_Batch_Name ,
                        T3.StdStrength AS ToAttend ,
                        COUNT(DISTINCT TSA.I_Student_Detail_ID) AS Attended
        --ISNULL(dbo.fnGetHistoricalBatchStrength(TSBM.I_Batch_ID,TTTM.Dt_Schedule_Date),0) AS ToAttend
                FROM    dbo.T_TimeTable_Master TTTM
                        INNER JOIN dbo.T_Student_Batch_Master TSBM ON TTTM.I_Batch_ID = TSBM.I_Batch_ID
                        INNER JOIN dbo.T_Center_Batch_Details TCBD ON TSBM.I_Batch_ID = TCBD.I_Batch_ID
                        INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TCBD.I_Centre_Id = TCHND.I_Center_ID
                        LEFT JOIN #temp T3 ON TTTM.I_Batch_ID = T3.BatchID
                                              AND TTTM.I_Center_ID = T3.CentreID
                                              AND TTTM.Dt_Schedule_Date = T3.SchDate
                        LEFT JOIN dbo.T_Student_Attendance TSA ON TTTM.I_TimeTable_ID = TSA.I_TimeTable_ID
                WHERE   TCHND.I_Center_ID IN (
                        SELECT  FGCFR.centerID
                        FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
                                                           @iBrandID) FGCFR )
                        AND ( TTTM.Dt_Schedule_Date >= @dtStartDate
                              AND TTTM.Dt_Schedule_Date < DATEADD(d, 1,
                                                              @dtEndDate)
                            )
                        AND TTTM.I_Status = 1
                GROUP BY TCHND.I_Center_ID ,
                        TCHND.S_Center_Name ,
						DATEPART(WEEK, TTTM.Dt_Schedule_Date),
                        'Week' + ' '
                        + CAST(DATEPART(WEEK, TTTM.Dt_Schedule_Date) AS VARCHAR) ,
                        DATENAME(dw, TTTM.Dt_Schedule_Date) ,
                        TTTM.Dt_Schedule_Date ,
                        TSBM.I_Batch_ID ,
                        TSBM.S_Batch_Name ,
                        T3.StdStrength
        --dbo.fnGetHistoricalBatchStrength(TSBM.I_Batch_ID,TTTM.Dt_Schedule_Date)
                ORDER BY TTTM.Dt_Schedule_Date 
                
                
                
                SELECT * FROM #temp1;     
        
   

      
    END
