CREATE PROCEDURE [REPORT].[uspGetPlannedVSActualRoutine]
(
@iBrandID INT,
@sHierarchyList VARCHAR(MAX),
@dtFromDate DATE,
@dtEndDate DATE,
@sBatchList VARCHAR(MAX)=NULL,
@sFacultyList VARCHAR(MAX)=NULL
)
AS
BEGIN

CREATE TABLE #tempfac
(
FacultyID INT
)
CREATE TABLE #tempbatch
(
BatchID INT
)
INSERT INTO #tempbatch
        ( BatchID )
SELECT CAST(FSR.Val AS INT) FROM dbo.fnString2Rows(@sBatchList,',') FSR

INSERT INTO #tempfac
	        ( FacultyID )
	SELECT CAST(FSR.Val AS INT) FROM dbo.fnString2Rows(@sFacultyList,',') FSR
	
	--SELECT COUNT(*) FROM #tempfac

IF ((SELECT COUNT(*) FROM #tempfac)=0)
BEGIN
	INSERT INTO #tempfac
	        ( FacultyID )
	SELECT TED.I_Employee_ID FROM dbo.T_Employee_Dtls TED
	INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TED.I_Centre_Id=TCHND.I_Center_ID
	WHERE
	TCHND.I_Brand_ID=@iBrandID AND TED.I_Status=3
END

--SELECT * FROM #tempfac T;
IF ((SELECT COUNT(*) FROM #tempbatch)!=0)
BEGIN
SELECT  DISTINCT PT.Center ,
        PT.PlannedDate ,
        PT.PlannedBatch ,
        PT.PPeriod ,
        PT.PSubject,
        PT.PlannedSession ,
        PT.PlannedFaculty ,
        AT.ActualDate ,
        AT.ActualBatch ,
        AT.APeriod ,
        AT.ASubject,
        AT.ActualSession ,
        AT.ActualFaculty,
        AT.AttnMarked
FROM    ( SELECT    TCHND.S_Center_Name AS Center ,
                    TTTMP.I_TimeTable_ID AS PlannedID ,
                    CONVERT(DATE, TTTMP.Dt_Schedule_Date) AS PlannedDate ,
                    TSBM.S_Batch_Name AS PlannedBatch ,
                    CAST(CAST(LEFT(CONVERT(TIME, TCTM.Dt_Start_Time), 5) AS VARCHAR)
                    + '  to '
                    + CAST(LEFT(CONVERT(TIME, TCTM.Dt_End_Time), 5) AS VARCHAR) AS VARCHAR) AS PPeriod ,
                    --TESM.S_Skill_Desc AS PSubject,
                    XX.S_Skill_Desc AS PSubject,
                    TTTMP.S_Session_Name AS PlannedSession ,
                    TED.S_First_Name + ' ' + ISNULL(TED.S_Middle_Name, '')
                    + ' ' + TED.S_Last_Name AS PlannedFaculty
          FROM      dbo.T_TimeTable_Master_Planned TTTMP
                    INNER JOIN dbo.T_Student_Batch_Master TSBM ON TTTMP.I_Batch_ID = TSBM.I_Batch_ID
                    INNER JOIN dbo.T_Center_Timeslot_Master TCTM ON TTTMP.I_TimeSlot_ID = TCTM.I_TimeSlot_ID
                    INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TTTMP.I_Center_ID = TCHND.I_Center_ID
                    INNER JOIN dbo.T_Employee_Dtls TED ON TTTMP.I_Employee_ID = TED.I_Employee_ID
                    CROSS APPLY (SELECT TSM.I_Session_ID,TESM.S_Skill_Desc FROM dbo.T_Session_Master TSM
                    INNER JOIN dbo.T_EOS_Skill_Master TESM ON TSM.I_Skill_ID = TESM.I_Skill_ID WHERE TSM.I_Status=1) XX
          WHERE     TTTMP.I_Batch_ID IS NOT NULL
                    AND TTTMP.Dt_Schedule_Date >=@dtFromDate
                    AND TTTMP.Dt_Schedule_Date < DATEADD(d,1,@dtEndDate)
                    AND TCHND.I_Center_ID IN (SELECT FGCFR.centerID FROM dbo.fnGetCentersForReports(@sHierarchyList,@iBrandID) FGCFR)
                    AND TSBM.I_Batch_ID IN (SELECT CAST(FSR.Val AS INT) FROM dbo.fnString2Rows(@sBatchList,',') FSR)
                    AND TTTMP.I_Employee_ID IN (SELECT FacultyID FROM #tempfac T)
                    --AND TSM.I_Session_ID=1
                    AND TTTMP.I_Session_ID=XX.I_Session_ID
        ) PT
        INNER JOIN ( SELECT TCHND.S_Center_Name AS Center ,
                            TTTM.I_TimeTable_ID AS ActualID ,
                            CONVERT(DATE, TTTM.Dt_Schedule_Date) AS ActualDate ,
                            TSBM.S_Batch_Name AS ActualBatch ,
                            CAST(CAST(LEFT(CONVERT(TIME, TCTM.Dt_Start_Time),
                                           5) AS VARCHAR) + '  to '
                            + CAST(LEFT(CONVERT(TIME, TCTM.Dt_End_Time), 5) AS VARCHAR) AS VARCHAR) AS APeriod ,
                            XX.S_Skill_Desc AS ASubject,
                            TTTM.S_Session_Name AS ActualSession ,
                            TED.S_First_Name + ' ' + ISNULL(TED.S_Middle_Name,
                                                            '') + ' '
                            + TED.S_Last_Name AS ActualFaculty,
                            TTTM.I_Is_Complete AS AttnMarked
                     FROM   dbo.T_TimeTable_Master TTTM
                            INNER JOIN dbo.T_Student_Batch_Master TSBM ON TTTM.I_Batch_ID = TSBM.I_Batch_ID
                            INNER JOIN dbo.T_Center_Timeslot_Master TCTM ON TTTM.I_TimeSlot_ID = TCTM.I_TimeSlot_ID
                            INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TTTM.I_Center_ID = TCHND.I_Center_ID
                            LEFT JOIN dbo.T_TimeTable_Faculty_Map TTTFM ON TTTM.I_TimeTable_ID = TTTFM.I_TimeTable_ID
                                                              AND TTTFM.B_Is_Actual IN  (1,0)
                            LEFT JOIN dbo.T_Employee_Dtls TED ON TTTFM.I_Employee_ID = TED.I_Employee_ID
                          CROSS APPLY (SELECT TSM.I_Session_ID,TESM.S_Skill_Desc FROM dbo.T_Session_Master TSM
                    INNER JOIN dbo.T_EOS_Skill_Master TESM ON TSM.I_Skill_ID = TESM.I_Skill_ID WHERE TSM.I_Status=1) XX
                     WHERE  TTTM.I_Batch_ID IS NOT NULL
                            AND TTTM.Dt_Schedule_Date >= @dtFromDate
                    AND TTTM.Dt_Schedule_Date < DATEADD(d,1,@dtEndDate)
                    AND TCHND.I_Center_ID IN (SELECT FGCFR.centerID FROM dbo.fnGetCentersForReports(@sHierarchyList,@iBrandID) FGCFR)
                    AND TSBM.I_Batch_ID IN (SELECT CAST(FSR.Val AS INT) FROM dbo.fnString2Rows(@sBatchList,',') FSR)
                    AND TTTFM.I_Employee_ID IN (SELECT FacultyID FROM #tempfac T)
                    AND TTTM.I_Status=1
                    --AND TSM.I_Session_ID=1
                     AND TTTM.I_Session_ID=XX.I_Session_ID
                   ) AT ON PT.PlannedID = AT.ActualID
ORDER BY PT.Center ,
        PT.PlannedDate ,
        PT.PlannedBatch ,
        PT.PPeriod
        END
        
        ELSE
        SELECT  DISTINCT PT.Center ,
        PT.PlannedDate ,
        PT.PlannedBatch ,
        PT.PPeriod ,
        PT.PSubject,
        PT.PlannedSession ,
        PT.PlannedFaculty ,
        AT.ActualDate ,
        AT.ActualBatch ,
        AT.APeriod ,
        AT.ASubject,
        AT.ActualSession ,
        AT.ActualFaculty,
        AT.AttnMarked
FROM    ( SELECT    TCHND.S_Center_Name AS Center ,
                    TTTMP.I_TimeTable_ID AS PlannedID ,
                    CONVERT(DATE, TTTMP.Dt_Schedule_Date) AS PlannedDate ,
                    TSBM.S_Batch_Name AS PlannedBatch ,
                    CAST(CAST(LEFT(CONVERT(TIME, TCTM.Dt_Start_Time), 5) AS VARCHAR)
                    + '  to '
                    + CAST(LEFT(CONVERT(TIME, TCTM.Dt_End_Time), 5) AS VARCHAR) AS VARCHAR) AS PPeriod ,
                    XX.S_Skill_Desc AS PSubject,
                    TTTMP.S_Session_Name AS PlannedSession ,
                    TED.S_First_Name + ' ' + ISNULL(TED.S_Middle_Name, '')
                    + ' ' + TED.S_Last_Name AS PlannedFaculty
          FROM      dbo.T_TimeTable_Master_Planned TTTMP
                    INNER JOIN dbo.T_Student_Batch_Master TSBM ON TTTMP.I_Batch_ID = TSBM.I_Batch_ID
                    INNER JOIN dbo.T_Center_Timeslot_Master TCTM ON TTTMP.I_TimeSlot_ID = TCTM.I_TimeSlot_ID
                    INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TTTMP.I_Center_ID = TCHND.I_Center_ID
                    INNER JOIN dbo.T_Employee_Dtls TED ON TTTMP.I_Employee_ID = TED.I_Employee_ID
                    CROSS APPLY (SELECT TSM.I_Session_ID,TESM.S_Skill_Desc FROM dbo.T_Session_Master TSM
                    INNER JOIN dbo.T_EOS_Skill_Master TESM ON TSM.I_Skill_ID = TESM.I_Skill_ID WHERE TSM.I_Status=1) XX
          WHERE     TTTMP.I_Batch_ID IS NOT NULL
                    AND TTTMP.Dt_Schedule_Date >= @dtFromDate
                    AND TTTMP.Dt_Schedule_Date < DATEADD(d,1,@dtEndDate)
                    AND TCHND.I_Center_ID IN (SELECT FGCFR.centerID FROM dbo.fnGetCentersForReports(@sHierarchyList,@iBrandID) FGCFR)
                    --AND TSBM.I_Batch_ID IN (SELECT CAST(FSR.Val AS INT) FROM dbo.fnString2Rows(@sBatchList,',') FSR)
                    AND TTTMP.I_Employee_ID IN (SELECT FacultyID FROM #tempfac T)
                    --AND TSM.I_Session_ID=1
                     AND TTTMP.I_Session_ID=XX.I_Session_ID
        ) PT
        INNER JOIN ( SELECT TCHND.S_Center_Name AS Center ,
                            TTTM.I_TimeTable_ID AS ActualID ,
                            CONVERT(DATE, TTTM.Dt_Schedule_Date) AS ActualDate ,
                            TSBM.S_Batch_Name AS ActualBatch ,
                            CAST(CAST(LEFT(CONVERT(TIME, TCTM.Dt_Start_Time),
                                           5) AS VARCHAR) + '  to '
                            + CAST(LEFT(CONVERT(TIME, TCTM.Dt_End_Time), 5) AS VARCHAR) AS VARCHAR) AS APeriod ,
                            XX.S_Skill_Desc AS ASubject,
                            TTTM.S_Session_Name AS ActualSession ,
                            TED.S_First_Name + ' ' + ISNULL(TED.S_Middle_Name,
                                                            '') + ' '
                            + TED.S_Last_Name AS ActualFaculty,
                            TTTM.I_Is_Complete AS AttnMarked
                     FROM   dbo.T_TimeTable_Master TTTM
                            INNER JOIN dbo.T_Student_Batch_Master TSBM ON TTTM.I_Batch_ID = TSBM.I_Batch_ID
                            INNER JOIN dbo.T_Center_Timeslot_Master TCTM ON TTTM.I_TimeSlot_ID = TCTM.I_TimeSlot_ID
                            INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TTTM.I_Center_ID = TCHND.I_Center_ID
                            LEFT JOIN dbo.T_TimeTable_Faculty_Map TTTFM ON TTTM.I_TimeTable_ID = TTTFM.I_TimeTable_ID
                                                              AND TTTFM.B_Is_Actual IN (1,0)
                            LEFT JOIN dbo.T_Employee_Dtls TED ON TTTFM.I_Employee_ID = TED.I_Employee_ID
                            CROSS APPLY (SELECT TSM.I_Session_ID,TESM.S_Skill_Desc FROM dbo.T_Session_Master TSM
                    INNER JOIN dbo.T_EOS_Skill_Master TESM ON TSM.I_Skill_ID = TESM.I_Skill_ID WHERE TSM.I_Status=1) XX
                     WHERE  TTTM.I_Batch_ID IS NOT NULL
                            AND TTTM.Dt_Schedule_Date >= @dtFromDate
                    AND TTTM.Dt_Schedule_Date < DATEADD(d,1,@dtEndDate)
                    AND TCHND.I_Center_ID IN (SELECT FGCFR.centerID FROM dbo.fnGetCentersForReports(@sHierarchyList,@iBrandID) FGCFR)
                    --AND TSBM.I_Batch_ID IN (SELECT CAST(FSR.Val AS INT) FROM dbo.fnString2Rows(@sBatchList,',') FSR)
                    AND TTTFM.I_Employee_ID IN (SELECT FacultyID FROM #tempfac T)
                    AND TTTM.I_Status=1
                    --AND TSM.I_Session_ID=1
                     AND TTTM.I_Session_ID=XX.I_Session_ID
                   ) AT ON PT.PlannedID = AT.ActualID
ORDER BY PT.Center ,
        PT.PlannedDate ,
        PT.PlannedBatch ,
        PT.PPeriod
        
        END
