-- =============================================    
-- Author:  Arindam Roy    
-- Create date: 23/09/2010    
-- Description: This SP is for Student Attendance Log Report    
-- =============================================    
    
CREATE PROCEDURE [REPORT].[uspGetStudentAttendanceLogReport]   
(    
  @sHierarchyList VARCHAR(MAX),    
  @iBrandID INT,    
  @sBatchIDs VARCHAR(MAX) = NULL,    
  --@CenterID INT = NULL,    
  --@BatchID INT = NULL,    
  --@BatchCode VARCHAR (50),    
  --@EmployeeID INT = NULL,    
  --@EmpName VARCHAR(100) = NULL,    
  @FromDate DATETIME = NULL,    
  @ToDate  DATETIME = NULL    
)    
AS    
    
BEGIN    
    
 SET NOCOUNT ON;    
     
 --DECLARE @sCourseName VARCHAR(250)    
     
 --SELECT @sCourseName = tcm.S_Course_Name FROM [dbo].[T_Student_Batch_Master] AS SBM    
 --INNER JOIN [dbo].[T_Course_Master] AS tcm    
 --ON SBM.[I_Course_ID] = tcm.[I_Course_ID]    
 --WHERE SBM.[I_Batch_ID] = @BatchID    
     
     
 --DECLARE @sLoginID VARCHAR(50)    
 --SET @sLoginID = NULL    
 --IF (@EmployeeID IS NOT NULL)    
 --BEGIN    
 -- SELECT @sLoginID = [TUM].[S_Login_ID] FROM [dbo].[T_User_Master] AS TUM WHERE [TUM].[I_Reference_ID] = @EmployeeID     
 --END     
     
    
 DECLARE @BATCHSCHEDULEMASTER TABLE    
 (    
  ID INT IDENTITY(1, 1),    
  I_Centre_ID INT,    
  I_Batch_ID INT,    
  S_Batch_Name Varchar(100),    
  Dt_Start_Date DATETIME,    
  Dt_End_Date Datetime    
 )     
     
 Insert into @BATCHSCHEDULEMASTER    
 Select tttm.I_Center_ID,    
     tttm.I_Batch_ID,    
     SBT.S_Batch_Name,    
     Case When MIN(Isnull(tttm.Dt_Actual_Date,tttm.Dt_Schedule_Date))< @FromDate     
     then @FromDate else MIN(Isnull(tttm.Dt_Actual_Date,tttm.Dt_Schedule_Date)) End StartDate,    
     Case When MAX(Isnull(tttm.Dt_Actual_Date,tttm.Dt_Schedule_Date))> @ToDate     
     then @ToDate else MAX(Isnull(tttm.Dt_Actual_Date,tttm.Dt_Schedule_Date)) End EndDate    
 from dbo.T_TimeTable_Master AS tttm  
 Inner Join T_Student_Batch_Master SBT on tttm.I_Batch_ID=SBT.I_Batch_ID    
 Where (tttm.I_Center_ID IN (SELECT fnCenter.centerID FROM dbo.fnGetCentersForReports(@sHierarchyList,@iBrandID) AS fnCenter) OR tttm.I_Center_ID IS NULL)   
 AND tttm.I_Batch_ID IN (SELECT * FROM dbo.fnString2Rows(@sBatchIDs,','))    
 Group By tttm.I_Center_ID,tttm.I_Batch_ID,SBT.S_Batch_Name    
     
 DECLARE @CNT INT    
 DECLARE @TOTALCOUNT INT    
 SET @TOTALCOUNT=@@ROWCOUNT    
 SET @CNT=1    
     
 DECLARE @BATCHSCHEDULE TABLE    
 (    
  I_Centre_ID INT,    
  I_Batch_ID INT,    
  S_Batch_Name Varchar(100),    
  Dt_Schedule_Date DATETIME    
 )    
        
 DECLARE @BATCHSTARTDATE DATETIME    
 DECLARE @BATCHENDDATE DATETIME    
 DECLARE @ICENTERID INT    
 DECLARE @IBATCHID INT    
 DECLARE @sBATCHCODE VARCHAR(50)    
 WHILE @CNT<=@TOTALCOUNT    
 BEGIN    
  Select @ICENTERID=I_Centre_ID,    
      @IBATCHID=I_Batch_ID,    
      @sBATCHCODE=S_Batch_Name,    
      @BATCHSTARTDATE=Dt_Start_Date,    
      @BATCHENDDATE=Dt_End_Date    
  from @BATCHSCHEDULEMASTER     
  Where ID=@CNT    
    
  WHILE @BATCHSTARTDATE<=@BATCHENDDATE    
  BEGIN    
   INSERT @BATCHSCHEDULE VALUES(@ICENTERID,@IBATCHID,@sBATCHCODE,@BATCHSTARTDATE)    
   SET @BATCHSTARTDATE=@BATCHSTARTDATE+1    
  END    
  Set @CNT=@CNT+1    
 End    
     
SELECT TCM2.S_Course_Name,    
  1 AS Indicator,    
  SAD.I_Student_Detail_ID,    
  tttm.Dt_Schedule_Date,    
  SAD.Dt_Attendance_Date,    
  DATENAME ("DW",tttm.Dt_Schedule_Date) AS WeekName,    
  SBM.I_Centre_ID,    
  TCM.S_Center_Name,    
  SBM.I_Batch_ID,    
  SAD.I_Employee_ID,    
  SD.S_Student_ID,    
  LTRIM(ISNULL(SD.S_Title,'') + ' ') + SD.S_First_Name + ' ' + LTRIM(ISNULL(SD.S_Middle_Name,'') + ' ' + SD.S_Last_Name) as StudentName,    
  EmployeeName,    
  SBM.S_Batch_Name,    
  Case When SAD.Dt_Attendance_Date IS NULL then 0 else 1 end as PFlag    
INTO #TempStudentAttendance    
  From @BATCHSCHEDULE SBM    
  Inner Join dbo.T_Student_Batch_Details B on SBM.I_Batch_ID=B.I_Batch_ID    
  INNER JOIN dbo.T_Student_Batch_Master AS TSBM ON B.I_Batch_ID = TSBM.I_Batch_ID    
 INNER JOIN dbo.T_TimeTable_Master AS tttm ON TSBM.I_Batch_ID = tttm.I_Batch_ID  
  INNER JOIN dbo.T_Course_Master AS TCM2 ON TSBM.I_Course_ID = TCM2.I_Course_ID    
  Inner JOIN dbo.T_Student_Detail SD ON B.I_Student_ID=SD.I_Student_Detail_ID    
  LEFT OUTER JOIN dbo.T_Centre_Master TCM ON SBM.I_Centre_ID=TCM.I_Centre_Id    
  Left Join    
  (    
   Select SAD.Dt_Attendance_Date,SAD.I_Centre_ID,SAD.I_Batch_ID,    
   tum.I_Reference_ID AS I_Employee_ID,SBM.S_Batch_Name,SBD.I_Student_ID,SAD.I_Student_Detail_ID,    
   LTRIM(ISNULL(tum.S_Title,'') + ' ') + tum.S_First_Name + ' ' + LTRIM(isnull(tum.S_Middle_Name,'') + ' ' + tum.S_Last_Name) as EmployeeName,    
   [SAD].[S_Crtd_By]    
   From dbo.T_Student_Batch_Details SBD     
   Left Join dbo.T_Student_Attendance_Details SAD on SBD.I_Batch_ID=SAD.I_Batch_ID    
   and SBD.I_Student_ID=SAD.I_Student_Detail_ID    
   LEFT JOIN dbo.T_User_Master AS tum ON SAD.S_Crtd_By=tum.S_Login_ID    
   LEFT JOIN dbo.T_Student_Batch_Master SBM ON SAD.I_Batch_ID=SBM.I_Batch_ID    
   Where SBD.I_Batch_ID IN (SELECT * FROM dbo.fnString2Rows(@sBatchIDs,','))    
   --AND [SAD].[S_Crtd_By] = ISNULL(@sLoginID, [SAD].[S_Crtd_By])    
  )    
  as SAD --on SBM.I_Centre_ID=SAD.I_Centre_ID  And  
  on SBM.I_Batch_ID=SAD.I_Batch_ID    
  And B.I_Student_ID=SAD.I_Student_ID    
  AND (tttm.Dt_Schedule_Date=SAD.Dt_Attendance_Date or SAD.Dt_Attendance_Date is Null)      
  WHERE SBM.I_Batch_ID IN (SELECT * FROM dbo.fnString2Rows(@sBatchIDs,','))    
  AND DATEDIFF(dd, ISNULL(@FromDate, tttm.Dt_Schedule_Date),tttm.Dt_Schedule_Date) >= 0  
  AND DATEDIFF(dd, ISNULL(@ToDate, tttm.Dt_Schedule_Date),tttm.Dt_Schedule_Date) <= 0  
  --AND  tttm.Dt_Schedule_Date >= ISNULL(@FromDate, tttm.Dt_Schedule_Date)    
  --AND  tttm.Dt_Schedule_Date <= ISNULL(@ToDate, tttm.Dt_Schedule_Date)    
  AND SAD.I_Centre_Id IN (SELECT fnCenter.centerID FROM dbo.fnGetCentersForReports(@sHierarchyList,@iBrandID) AS fnCenter)  
    
    
 DECLARE @Schedule_Date DATETIME     
 SELECT @Schedule_Date = ISNULL(MIN (Dt_Schedule_Date),GETDATE()) FROM #TempStudentAttendance    
    
 INSERT INTO #TempStudentAttendance (S_Course_Name,Indicator,S_Student_ID,StudentName,Dt_Schedule_Date,WeekName,PFlag,S_Batch_Name,S_Center_Name)    
 VALUES ('AAAAA1',0,'ZZZZZZ1','No. of Students Absent',@Schedule_Date,DATENAME ("DW",@Schedule_Date),0,'ZZZZB','ZZZZC')    
    
 INSERT INTO #TempStudentAttendance (S_Course_Name,Indicator,S_Student_ID,StudentName,Dt_Schedule_Date,WeekName,PFlag,S_Batch_Name,S_Center_Name)    
 VALUES ('AAAAA1',0,'ZZZZZZ2','Module/ Session Number',@Schedule_Date,DATENAME ("DW",@Schedule_Date),0,'ZZZZB','ZZZZC')    
    
 INSERT INTO #TempStudentAttendance (S_Course_Name,Indicator,S_Student_ID,StudentName,Dt_Schedule_Date,WeekName,PFlag,S_Batch_Name,S_Center_Name)    
 VALUES ('AAAAA1',0,'ZZZZZZ3','Trainer Signature',@Schedule_Date,DATENAME ("DW",@Schedule_Date),0,'ZZZZB','ZZZZC')    
    
 INSERT INTO #TempStudentAttendance (S_Course_Name,Indicator,S_Student_ID,StudentName,Dt_Schedule_Date,WeekName,PFlag,S_Batch_Name,S_Center_Name)    
 VALUES ('AAAAA1',0,'ZZZZZZ4','Signature of Student (different student everyday)',@Schedule_Date,DATENAME ("DW",@Schedule_Date),0,'ZZZZB','ZZZZC')    
    
 INSERT INTO #TempStudentAttendance (S_Course_Name,Indicator,S_Student_ID,StudentName,Dt_Schedule_Date,WeekName,PFlag,S_Batch_Name,S_Center_Name)    
 VALUES ('AAAAA1',0,'ZZZZZZ5','Student Admission Number (who signed on that day)',@Schedule_Date,DATENAME ("DW",@Schedule_Date),0,'ZZZZB','ZZZZC')    
    
 SELECT * FROM #TempStudentAttendance ORDER BY Dt_Attendance_Date,S_Student_ID    
    
 DROP TABLE #TempStudentAttendance    
    
END
