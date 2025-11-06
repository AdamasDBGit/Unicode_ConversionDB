CREATE PROCEDURE [REPORT].[uspGetConsolidatedHWSubmissionReport]
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
         Submitted INT
         )           


                INSERT  INTO #temp
                        ( CentreID ,
                          BatchID ,
                          SchDate ,
                          StdStrength
                        )
                        SELECT  T1.I_Center_ID ,
                                T1.I_Batch_ID ,
                                T1.Dt_Submission_Date ,
                                dbo.fnGetHistoricalBatchStrength(T1.I_Batch_ID,
                                                              T1.Dt_Submission_Date)
                        FROM    ( SELECT DISTINCT
                                            THM.I_Center_ID ,
                                            THM.I_Batch_ID ,
                                            THM.Dt_Submission_Date
                                  FROM      EXAMINATION.T_Homework_Master THM
                                            INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON THM.I_Center_ID = TCHND.I_Center_ID
                                  WHERE     THM.I_Status = 1
                                            AND TCHND.I_Center_ID IN (
                                            SELECT  FGCFR.centerID
                                            FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
                                                              @iBrandID) FGCFR )
                                            AND ( THM.Dt_Submission_Date >= @dtStartDate
                                                  AND THM.Dt_Submission_Date < DATEADD(d,
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
				          Submitted
				        )
				
                SELECT  TCHND.I_Center_ID ,
                        TCHND.S_Center_Name ,
                        DATEPART(WEEK, THM.Dt_Submission_Date) AS WNo,
                        'Week' + ' '
                        + CAST(DATEPART(WEEK, THM.Dt_Submission_Date) AS VARCHAR) AS WeekNo ,
                        DATENAME(dw, THM.Dt_Submission_Date) AS Dateday ,
                        THM.Dt_Submission_Date AS SchDate ,
                        TSBM.I_Batch_ID ,
                        TSBM.S_Batch_Name ,
                        T3.StdStrength AS ToSubmit ,
                        COUNT(DISTINCT THS.I_Student_Detail_ID) AS Submitted
                        --CAST(((CAST(COUNT(DISTINCT THS.I_Student_Detail_ID) AS DECIMAL(14,1))/CAST(T3.StdStrength AS DECIMAL(14,1)))*100) AS DECIMAL(14,1)) AS Percentage
        --ISNULL(dbo.fnGetHistoricalBatchStrength(TSBM.I_Batch_ID,TTTM.Dt_Schedule_Date),0) AS ToAttend
                FROM    EXAMINATION.T_Homework_Master THM
                        INNER JOIN dbo.T_Student_Batch_Master TSBM ON THM.I_Batch_ID = TSBM.I_Batch_ID
                        INNER JOIN dbo.T_Center_Batch_Details TCBD ON TSBM.I_Batch_ID = TCBD.I_Batch_ID
                        INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TCBD.I_Centre_Id = TCHND.I_Center_ID
                        LEFT JOIN #temp T3 ON THM.I_Batch_ID = T3.BatchID
                                              AND THM.I_Center_ID = T3.CentreID
                                              AND THM.Dt_Submission_Date = T3.SchDate
                        LEFT JOIN EXAMINATION.T_Homework_Submission THS ON THM.I_Homework_ID=THS.I_Homework_ID
                WHERE   TCHND.I_Center_ID IN (
                        SELECT  FGCFR.centerID
                        FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
                                                           @iBrandID) FGCFR )
                        AND ( THM.Dt_Submission_Date >= @dtStartDate
                              AND THM.Dt_Submission_Date < DATEADD(d, 1,
                                                              @dtEndDate)
                            )
                        AND THM.I_Status = 1
                GROUP BY TCHND.I_Center_ID ,
                        TCHND.S_Center_Name ,
						DATEPART(WEEK, THM.Dt_Submission_Date),
                        'Week' + ' '
                        + CAST(DATEPART(WEEK, THM.Dt_Submission_Date) AS VARCHAR) ,
                        DATENAME(dw, THM.Dt_Submission_Date) ,
                        THM.Dt_Submission_Date,
                        TSBM.I_Batch_ID ,
                        TSBM.S_Batch_Name ,
                        T3.StdStrength
        --dbo.fnGetHistoricalBatchStrength(TSBM.I_Batch_ID,TTTM.Dt_Schedule_Date)
                ORDER BY THM.Dt_Submission_Date 
                
                
                
                SELECT * FROM #temp1;     
        
   

      
    END
