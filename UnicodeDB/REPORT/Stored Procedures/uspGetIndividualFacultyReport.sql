CREATE PROCEDURE [REPORT].[uspGetIndividualFacultyReport]  
    (  
    @sHierarchyList varchar(MAX),  
   @iBrandID int,  
      @FacultyId INT=NULL,  
      @StartDate DATETIME = NULL,  
      @EndDate DATETIME = NULL  
    )  
AS   
    BEGIN  
      
DECLARE @FacultyName VARCHAR(200)  
SELECT @FacultyName = COALESCE(S_Title,'') + ' ' + S_First_Name + ' ' + COALESCE(S_Middle_Name,'') + ' ' + S_Last_Name FROM dbo.T_Employee_Dtls AS TED WHERE TED.I_Employee_ID =ISNULL( @FacultyId,TED.I_Employee_ID )  
DECLARE @MaxPeriod INT  
SET @MaxPeriod = 6  
  
  DECLARE @S_Instance_Chain VARCHAR(500)
	
	SELECT TOP 1 @S_Instance_Chain = FN2.instanceChain FROM [dbo].[fnGetInstanceNameChainForReports](@sHierarchyList,
                                      @iBrandID) FN2
   WHERE FN2.HierarchyDetailID IN 
   (SELECT HierarchyDetailID FROM [fnGetCentersForReports](@sHierarchyList, @iBrandID))
  
 DECLARE @tempResult TABLE  
 (  
  id int identity,  
  HierachyID INT,  
  BrandID INT,  
  centreId INT,  
  centrecode varchar(100),  
  centrename varchar(max)  
    
 )  
   
   
  INSERT INTO @tempResult  
   (  
    BrandID ,  
    HierachyID ,  
    centreId ,  
    centrecode ,  
    centrename   
      
      )  
       SELECT fgcfr.*  
       FROM dbo.fnGetCentersForReports(@sHierarchyList,@iBrandID) AS fgcfr  
   
CREATE TABLE #DateTimeSlotMap  
(  
  Dt_Schedule_Date DATETIME,  
  I_Center_ID INT,  
  I_Batch_ID INT,  
  I_TimeSlot_ID INT,  
  Dt_Start_Time DATETIME,  
  Dt_End_Time DATETIME,  
  I_TimeTable_ID INT,  
  I_Student_Present INT  
)  
  
SELECT TSA.I_TimeTable_ID,  
COUNT(DISTINCT TSA.I_Student_Detail_ID)  AS I_Student_Present  
INTO #StudentAttendance  
FROM dbo.T_Student_Attendance AS TSA   
INNER JOIN  dbo.T_Student_Detail AS tsd ON TSA.I_Student_Detail_ID=tsd.I_Student_Detail_ID  
INNER JOIN dbo.T_Student_Center_Detail AS tscd with(nolock) ON tscd.I_Student_Detail_ID = tsd.I_Student_Detail_ID  
INNER JOIN @tempResult TR ON TR.centreId=tscd.I_Centre_Id  
GROUP BY TSA.I_TimeTable_ID  
  
INSERT INTO #DateTimeSlotMap  
SELECT distinct TTTM.Dt_Schedule_Date,  
  TTTM.I_Center_ID,  
  TTTM.I_Batch_ID,  
  TTTM.I_TimeSlot_ID,  
  TCTM.Dt_Start_Time,  
  TCTM.Dt_End_Time,  
  TTTM.I_TimeTable_ID,  
  SA.I_Student_Present  
FROM dbo.T_TimeTable_Faculty_Map AS TTTFM  
INNER JOIN dbo.T_TimeTable_Master AS TTTM ON TTTFM.I_TimeTable_ID = TTTM.I_TimeTable_ID  
INNER JOIN dbo.T_Center_Timeslot_Master AS TCTM ON TTTM.I_TimeSlot_ID = TCTM.I_TimeSlot_ID  
INNER JOIN #StudentAttendance SA ON SA.I_TimeTable_ID = TTTFM.I_TimeTable_ID  
WHERE I_Employee_ID = ISNULL(@FacultyId,I_Employee_ID)  
AND TTTM.Dt_Schedule_Date BETWEEN ISNULL(@StartDate,TTTM.Dt_Schedule_Date) AND ISNULL(@EndDate,TTTM.Dt_Schedule_Date)  
--AND TTTFM.B_Is_Actual = 1  
ORDER BY TTTM.Dt_Schedule_Date,TCTM.Dt_Start_Time  
  
SELECT A.Dt_Schedule_Date,A.I_Center_ID,COUNT(1) AS TotalSlotCount,CAST(NULL AS INT) AS RemainingSlotCount  
INTO #DateTimeSlotCount  
FROM #DateTimeSlotMap A  
INNER JOIN @tempResult B ON A.I_Center_ID=B.centreId  
GROUP BY A.Dt_Schedule_Date,A.I_Center_ID  
  
--SELECT * FROM #DateTimeSlotMap  
  
UPDATE #DateTimeSlotCount  
SET RemainingSlotCount = @MaxPeriod - TotalSlotCount  
  
;with Numbers(n) as (  
    select ROW_NUMBER() OVER (ORDER BY object_id) from sys.objects  
)  
INSERT INTO #DateTimeSlotMap  
select DTS.Dt_Schedule_Date,DTS.I_Center_ID, NULL AS I_Batch_ID,NULL AS I_TimeSlot_ID,NULL AS Dt_Start_Time, NULL AS Dt_End_Time, NULL AS I_TimeTable_ID, NULL AS I_Student_Present  
from #DateTimeSlotCount DTS INNER JOIN Numbers NUM  
    on DTS.RemainingSlotCount >= NUM.n  
    INNER JOIN @tempResult TR ON TR.centreId=DTS.I_Center_ID  
ORDER BY DTS.Dt_Schedule_Date,DTS.I_Center_ID  
  
SELECT CenterBatch.I_Center_ID,CenterBatch.I_Batch_ID,CAST(NULL AS VARCHAR(100)) AS S_Batch_Name,COUNT(TSCD.I_Student_Detail_ID) AS Student_Strength   
INTO #CenterBatchStudentStrength  
FROM dbo.T_Student_Batch_Details AS TSBD  
 INNER JOIN dbo.T_Student_Center_Detail AS TSCD  
 ON TSBD.I_Student_ID = TSCD.I_Student_Detail_ID  AND (TSBD.I_Status=1 or TSBD.I_Status=2) 
   
 INNER JOIN  
(SELECT DISTINCT I_Center_ID,  
    I_Batch_ID      
FROM #DateTimeSlotMap WHERE I_Batch_ID IS NOT NULL) CenterBatch ON CenterBatch.I_Batch_ID = TSBD.I_Batch_ID   
                 AND CenterBatch.I_Center_ID = TSCD.I_Centre_Id  
INNER JOIN @tempResult B ON CenterBatch.I_Center_ID=B.centreId                   
GROUP BY CenterBatch.I_Center_ID,CenterBatch.I_Batch_ID  
ORDER BY CenterBatch.I_Center_ID,CenterBatch.I_Batch_ID  
  
UPDATE CBSS  
SET S_Batch_Name = TSBM.S_Batch_Name  
FROM #CenterBatchStudentStrength CBSS  
INNER JOIN dbo.T_Student_Batch_Master AS TSBM ON CBSS.I_Batch_ID = TSBM.I_Batch_ID  
  
--SELECT * FROM #CenterBatchStudentStrength  
  
  
SELECT IDENTITY(INT,1,1) AS RowId,*,CAST(NULL AS INT) AS TimeSlotId  
INTO #DateTimeSlotMap2  
FROM #DateTimeSlotMap  
ORDER BY Dt_Schedule_Date,CASE WHEN Dt_Start_Time IS NULL THEN 1 ELSE 0 END,Dt_Start_Time  
  
UPDATE #DateTimeSlotMap2  
SET TimeSlotId = CASE WHEN RowId % 6 <> 0 THEN RowId % 6 ELSE 6 END  
  
--SELECT * FROM #DateTimeSlotMap2  
  
SELECT DISTINCT Dt_Schedule_Date,  
I_Center_ID,  
CAST(NULL AS INT) AS I_Batch_ID_1,  
CAST(NULL AS VARCHAR(100)) AS S_Batch_Name_1,  
CAST(NULL AS DATETIME) AS StartTime1,  
CAST(NULL AS DATETIME) AS EndTime1,  
CAST(NULL AS INT) AS I_Student_Strength_1,  
CAST(NULL AS INT) AS I_Student_Present_1,  
CAST(NULL AS NUMERIC(5,2)) AS I_Student_Percentage_1,  
CAST(NULL AS INT) AS I_Batch_ID_2,  
CAST(NULL AS VARCHAR(100)) AS S_Batch_Name_2,  
CAST(NULL AS DATETIME) AS StartTime2,  
CAST(NULL AS DATETIME) AS EndTime2,  
CAST(NULL AS INT) AS I_Student_Strength_2,  
CAST(NULL AS INT) AS I_Student_Present_2,  
CAST(NULL AS NUMERIC(5,2)) AS I_Student_Percentage_2,  
CAST(NULL AS INT) AS I_Batch_ID_3,  
CAST(NULL AS VARCHAR(100)) AS S_Batch_Name_3,  
CAST(NULL AS DATETIME) AS StartTime3,  
CAST(NULL AS DATETIME) AS EndTime3,  
CAST(NULL AS INT) AS I_Student_Strength_3,  
CAST(NULL AS INT) AS I_Student_Present_3,  
CAST(NULL AS NUMERIC(5,2)) AS I_Student_Percentage_3,  
CAST(NULL AS INT) AS I_Batch_ID_4,  
CAST(NULL AS VARCHAR(100)) AS S_Batch_Name_4,  
CAST(NULL AS DATETIME) AS StartTime4,  
CAST(NULL AS DATETIME) AS EndTime4,  
CAST(NULL AS INT) AS I_Student_Strength_4,  
CAST(NULL AS INT) AS I_Student_Present_4,  
CAST(NULL AS NUMERIC(5,2)) AS I_Student_Percentage_4,  
CAST(NULL AS INT) AS I_Batch_ID_5,  
CAST(NULL AS VARCHAR(100)) AS S_Batch_Name_5,  
CAST(NULL AS DATETIME) AS StartTime5,  
CAST(NULL AS DATETIME) AS EndTime5,  
CAST(NULL AS INT) AS I_Student_Strength_5,  
CAST(NULL AS INT) AS I_Student_Present_5,  
CAST(NULL AS NUMERIC(5,2)) AS I_Student_Percentage_5,  
CAST(NULL AS INT) AS I_Batch_ID_6,  
CAST(NULL AS VARCHAR(100)) AS S_Batch_Name_6,  
CAST(NULL AS DATETIME) AS StartTime6,  
CAST(NULL AS DATETIME) AS EndTime6,  
CAST(NULL AS INT) AS I_Student_Strength_6,  
CAST(NULL AS INT) AS I_Student_Present_6,  
CAST(NULL AS NUMERIC(5,2)) AS I_Student_Percentage_6  
INTO #PeriodTable  
FROM #DateTimeSlotMap2 where I_Center_ID in (select centreId from @tempResult)  
  
  
  
UPDATE PT  
SET   I_Batch_ID_1 = (CASE WHEN TimeSlotId = 1 THEN I_Batch_ID END),  
      StartTime1  = (CASE WHEN TimeSlotId = 1 THEN Dt_Start_Time END),  
      EndTime1  = (CASE WHEN TimeSlotId = 1 THEN Dt_End_Time END),  
      I_Student_Present_1 = (CASE WHEN TimeSlotId = 1 THEN I_Student_Present END)  
FROM #PeriodTable PT  
INNER JOIN #DateTimeSlotMap2 T  
ON PT.Dt_Schedule_Date = T.Dt_Schedule_Date AND PT.I_Center_ID = T.I_Center_ID  
WHERE TimeSlotId = 1  
  
  
UPDATE PT  
SET   I_Batch_ID_2 = (CASE WHEN TimeSlotId = 2 THEN I_Batch_ID END),  
      StartTime2  = (CASE WHEN TimeSlotId = 2 THEN Dt_Start_Time END),  
      EndTime2   = (CASE WHEN TimeSlotId = 2 THEN Dt_End_Time END),  
      I_Student_Present_2 = (CASE WHEN TimeSlotId = 2 THEN I_Student_Present END)  
FROM #PeriodTable PT  
INNER JOIN #DateTimeSlotMap2 T  
ON PT.Dt_Schedule_Date = T.Dt_Schedule_Date  
AND PT.I_Center_ID = T.I_Center_ID  
WHERE TimeSlotId = 2  
   
UPDATE PT  
SET   I_Batch_ID_3 = (CASE WHEN TimeSlotId = 3 THEN I_Batch_ID END),  
      StartTime3   = (CASE WHEN TimeSlotId = 3 THEN Dt_Start_Time END),  
      EndTime3   = (CASE WHEN TimeSlotId = 3 THEN Dt_End_Time END),  
      I_Student_Present_3 = (CASE WHEN TimeSlotId = 3 THEN I_Student_Present END)  
FROM #PeriodTable PT  
INNER JOIN #DateTimeSlotMap2 T  
ON PT.Dt_Schedule_Date = T.Dt_Schedule_Date  
AND PT.I_Center_ID = T.I_Center_ID  
WHERE TimeSlotId = 3  
   
UPDATE PT  
SET   I_Batch_ID_4 = (CASE WHEN TimeSlotId = 4 THEN I_Batch_ID END),  
      StartTime4   = (CASE WHEN TimeSlotId = 4 THEN Dt_Start_Time END),  
      EndTime4   = (CASE WHEN TimeSlotId = 4 THEN Dt_End_Time END),  
      I_Student_Present_4 = (CASE WHEN TimeSlotId = 4 THEN I_Student_Present END)  
FROM #PeriodTable PT  
INNER JOIN #DateTimeSlotMap2 T  
ON PT.Dt_Schedule_Date = T.Dt_Schedule_Date  
AND PT.I_Center_ID = T.I_Center_ID  
WHERE TimeSlotId = 4  
   
UPDATE PT  
SET   I_Batch_ID_5 = (CASE WHEN TimeSlotId = 5 THEN I_Batch_ID END),  
      StartTime5   = (CASE WHEN TimeSlotId = 5 THEN Dt_Start_Time END),  
      EndTime5   = (CASE WHEN TimeSlotId = 5 THEN Dt_End_Time END),  
      I_Student_Present_5 = (CASE WHEN TimeSlotId = 5 THEN I_Student_Present END)  
FROM #PeriodTable PT  
INNER JOIN #DateTimeSlotMap2 T  
ON PT.Dt_Schedule_Date = T.Dt_Schedule_Date  
AND PT.I_Center_ID = T.I_Center_ID  
WHERE TimeSlotId = 5  
   
UPDATE PT  
SET   I_Batch_ID_6 = (CASE WHEN TimeSlotId = 6 THEN I_Batch_ID END),  
      StartTime6   = (CASE WHEN TimeSlotId = 6 THEN Dt_Start_Time END),  
      EndTime6  = (CASE WHEN TimeSlotId = 6 THEN Dt_End_Time END),  
      I_Student_Present_6 = (CASE WHEN TimeSlotId = 6 THEN I_Student_Present END)  
FROM #PeriodTable PT  
INNER JOIN #DateTimeSlotMap2 T  
ON PT.Dt_Schedule_Date = T.Dt_Schedule_Date  
AND PT.I_Center_ID = T.I_Center_ID  
WHERE TimeSlotId = 6  
  
  
UPDATE PT  
SET  I_Student_Strength_1 = CBSS1.Student_Strength,  
  S_Batch_Name_1 = S_Batch_Name  
FROM #PeriodTable PT  
INNER JOIN #CenterBatchStudentStrength AS CBSS1  
ON PT.I_Batch_ID_1 = CBSS1.I_Batch_ID AND PT.I_Center_ID = CBSS1.I_Center_ID  
  
UPDATE PT  
SET  I_Student_Strength_2 = CBSS2.Student_Strength,  
  S_Batch_Name_2 = S_Batch_Name  
FROM #PeriodTable PT  
INNER JOIN #CenterBatchStudentStrength AS CBSS2  
ON PT.I_Batch_ID_2 = CBSS2.I_Batch_ID AND PT.I_Center_ID = CBSS2.I_Center_ID  
  
UPDATE PT  
SET  I_Student_Strength_3 = CBSS3.Student_Strength,  
  S_Batch_Name_3 = S_Batch_Name  
FROM #PeriodTable PT  
INNER JOIN #CenterBatchStudentStrength AS CBSS3  
ON PT.I_Batch_ID_3 = CBSS3.I_Batch_ID AND PT.I_Center_ID = CBSS3.I_Center_ID  
  
UPDATE PT  
SET  I_Student_Strength_4 = CBSS4.Student_Strength,  
  S_Batch_Name_4 = S_Batch_Name  
FROM #PeriodTable PT  
INNER JOIN #CenterBatchStudentStrength AS CBSS4  
ON PT.I_Batch_ID_4 = CBSS4.I_Batch_ID AND PT.I_Center_ID = CBSS4.I_Center_ID  
  
UPDATE PT  
SET  I_Student_Strength_5 = CBSS5.Student_Strength,  
  S_Batch_Name_5 = S_Batch_Name  
FROM #PeriodTable PT  
INNER JOIN #CenterBatchStudentStrength AS CBSS5  
ON PT.I_Batch_ID_5 = CBSS5.I_Batch_ID AND PT.I_Center_ID = CBSS5.I_Center_ID  
  
UPDATE PT  
SET  I_Student_Strength_6 = CBSS6.Student_Strength,  
  S_Batch_Name_6 = S_Batch_Name  
FROM #PeriodTable PT  
INNER JOIN #CenterBatchStudentStrength AS CBSS6  
ON PT.I_Batch_ID_6 = CBSS6.I_Batch_ID AND PT.I_Center_ID = CBSS6.I_Center_ID  
  
--SELECT * FROM #PeriodTable ORDER BY Dt_Schedule_Date  
   
SELECT   @FacultyName AS S_Faculty_Name,  
    CONVERT(VARCHAR(10),Dt_Schedule_Date,101) AS Dt_Schedule_Date,  
    PT.I_Center_ID,  
    TCM.S_Center_Name,   
    I_Batch_ID_1,  
    S_Batch_Name_1,  
    LTRIM(RIGHT(CONVERT(VARCHAR(20),StartTime1,100),7)) + ' - ' + LTRIM(RIGHT(CONVERT(VARCHAR(20),EndTime1,100),7)) AS Period1,  
    CAST(DATEDIFF(SS,StartTime1,EndTime1) AS INT) AS Period1Duration_Sec,  
    CAST(DATEDIFF(SS,StartTime1,EndTime1)/3600 AS VARCHAR)+':'+ CAST((DATEDIFF(SS,StartTime1,EndTime1)%3600)/60 AS VARCHAR) AS Period1Duration,  
    I_Student_Strength_1,  
    I_Student_Present_1,  
      CASE WHEN ISNULL(I_Student_Strength_1,0) <> 0 THEN CONVERT(NUMERIC(5, 2), ROUND(( I_Student_Present_1  
                                                 * 100 )  
                                               / I_Student_Strength_1, 2)) ELSE 0 END AS I_Student_Percentage_1,  
    I_Batch_ID_2,  
      S_Batch_Name_2,  
    LTRIM(RIGHT(CONVERT(VARCHAR(20),StartTime2,100),7)) + ' - ' + LTRIM(RIGHT(CONVERT(VARCHAR(20),EndTime2,100),7)) AS Period2,  
    CAST(DATEDIFF(SS,StartTime2,EndTime2) AS INT) AS Period2Duration_Sec,  
    CAST(DATEDIFF(SS,StartTime2,EndTime2)/3600 AS VARCHAR)+':'+ CAST((DATEDIFF(SS,StartTime2,EndTime2)%3600)/60 AS VARCHAR) AS Period2Duration,  
    I_Student_Strength_2,  
    I_Student_Present_2,  
    CASE WHEN ISNULL(I_Student_Strength_2,0) <> 0 THEN CONVERT(NUMERIC(5, 2), ROUND(( I_Student_Present_2  
                                     * 100 )  
                                   / I_Student_Strength_2, 2)) ELSE 0 END AS I_Student_Percentage_2,  
    I_Batch_ID_3,  
    S_Batch_Name_3,  
    LTRIM(RIGHT(CONVERT(VARCHAR(20),StartTime3,100),7)) + ' - ' + LTRIM(RIGHT(CONVERT(VARCHAR(20),EndTime3,100),7)) AS Period3,  
    CAST(DATEDIFF(SS,StartTime3,EndTime3) AS INT) AS Period3Duration_Sec,  
    CAST(DATEDIFF(SS,StartTime3,EndTime3)/3600 AS VARCHAR)+':'+ CAST((DATEDIFF(SS,StartTime3,EndTime3)%3600)/60 AS VARCHAR) AS Period3Duration,  
    I_Student_Strength_3,  
      I_Student_Present_3,  
    CASE WHEN ISNULL(I_Student_Strength_3,0) <> 0 THEN CONVERT(NUMERIC(5, 2), ROUND(( I_Student_Present_3  
                                     * 100 )  
                                   / I_Student_Strength_3, 2)) ELSE 0 END AS I_Student_Percentage_3,  
    I_Batch_ID_4,  
    S_Batch_Name_4,  
    LTRIM(RIGHT(CONVERT(VARCHAR(20),StartTime4,100),7)) + ' - ' + LTRIM(RIGHT(CONVERT(VARCHAR(20),EndTime4,100),7)) AS Period4,  
      CAST(DATEDIFF(SS,StartTime4,EndTime4) AS INT) AS Period4Duration_Sec,  
    CAST(DATEDIFF(SS,StartTime4,EndTime4)/3600 AS VARCHAR)+':'+ CAST((DATEDIFF(SS,StartTime4,EndTime4)%3600)/60 AS VARCHAR) AS Period4Duration,  
    I_Student_Strength_4,  
    I_Student_Present_4,  
      CASE WHEN ISNULL(I_Student_Strength_4,0) <> 0 THEN CONVERT(NUMERIC(5, 2), ROUND(( I_Student_Present_4  
                             * 100 )  
                           / I_Student_Strength_4, 2)) ELSE 0 END AS I_Student_Percentage_4,  
    I_Batch_ID_5,  
    S_Batch_Name_5,  
    LTRIM(RIGHT(CONVERT(VARCHAR(20),StartTime5,100),7)) + ' - ' + LTRIM(RIGHT(CONVERT(VARCHAR(20),EndTime5,100),7)) AS Period5,  
      CAST(DATEDIFF(SS,StartTime5,EndTime5) AS INT) AS Period5Duration_Sec,  
    CAST(DATEDIFF(SS,StartTime5,EndTime5)/3600 AS VARCHAR)+':'+ CAST((DATEDIFF(SS,StartTime5,EndTime5)%3600)/60 AS VARCHAR) AS Period5Duration,  
    I_Student_Strength_5,  
      I_Student_Present_5,  
    CASE WHEN ISNULL(I_Student_Strength_5,0) <> 0 THEN CONVERT(NUMERIC(5, 2), ROUND(( I_Student_Present_5  
        * 100 )  
         / I_Student_Strength_5, 2)) ELSE 0 END AS I_Student_Percentage_5,  
    I_Batch_ID_6,  
    S_Batch_Name_6,  
    LTRIM(RIGHT(CONVERT(VARCHAR(20),StartTime6,100),7)) + ' - ' + LTRIM(RIGHT(CONVERT(VARCHAR(20),EndTime6,100),7)) AS Period6,  
      CAST(DATEDIFF(SS,StartTime6,EndTime6) AS INT) AS Period6Duration_Sec,  
    CAST(DATEDIFF(SS,StartTime6,EndTime6)/3600 AS VARCHAR)+':'+ CAST((DATEDIFF(SS,StartTime6,EndTime6)%3600)/60 AS VARCHAR) AS Period6Duration,  
    I_Student_Strength_6,  
    I_Student_Present_6,  
    CASE WHEN ISNULL(I_Student_Strength_6,0) <> 0 THEN CONVERT(NUMERIC(5, 2), ROUND(( I_Student_Present_6  
        * 100 )  
         / I_Student_Strength_6, 2)) ELSE 0 END AS I_Student_Percentage_6,  
    CAST(NULL AS INT) AS TotalDuration_Sec,  
    CAST(NULL AS VARCHAR) AS TotalDuration  
INTO #TimeTable  
FROM #PeriodTable PT  
INNER JOIN dbo.T_Centre_Master AS TCM ON TCM.I_Centre_Id = PT.I_Center_ID  
  
UPDATE #TimeTable  
SET TotalDuration_Sec = ISNULL(Period1Duration_Sec,0) + ISNULL(Period2Duration_Sec,0) + ISNULL(Period3Duration_Sec,0) + ISNULL(Period4Duration_Sec,0)  
      + ISNULL(Period5Duration_Sec,0) + ISNULL(Period6Duration_Sec,0)  
        
UPDATE #TimeTable  
SET TotalDuration = CAST(TotalDuration_Sec/3600 AS VARCHAR)+':'+ CAST((TotalDuration_Sec%3600)/60 AS VARCHAR)  
   
   
 SELECT *, @S_Instance_Chain AS S_Instance_Chain FROM #TimeTable  
  
DROP TABLE #StudentAttendance  
DROP TABLE #CenterBatchStudentStrength  
DROP TABLE #TimeTable  
DROP TABLE #PeriodTable  
DROP TABLE #DateTimeSlotMap  
DROP TABLE #DateTimeSlotCount  
DROP TABLE #DateTimeSlotMap2  
  
END
