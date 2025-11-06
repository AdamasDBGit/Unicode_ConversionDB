/*CREATE TABLE #temp
(
sBranch VARCHAR(20),
sFaculty VARCHAR(100),
sSubject VARCHAR(50),
iBatchId INT,
sBatch VARCHAR(20),
iBatchStrength INT,
iAttn INT,
dtDate DATE,
sPeriod VARCHAR(50)
)

INSERT INTO #temp
        ( sBranch ,
          sFaculty ,
          sSubject ,
          iBatchId,
          sBatch,
          sPeriod,
          dtDate 
        )
        */
CREATE PROCEDURE [REPORT].[uspGetFacultyUtilizationSlotwise]
    @iBrandID INT ,
    @sHierarchyListID VARCHAR(MAX) ,
    @dtStartDate DATE ,
    @dtEndDate DATE ,
    @iEmployeeID INT=NULL
AS 
    BEGIN
    
                SELECT  xx.sCenter ,
                        xx.TimeTable ,
                        xx.sFaculty ,
                        xx.sSub ,
                        xx.iBatch ,
                        xx.Batch ,
                        xx.sPeriod ,
                        xx.sDate ,
                        xx.BatchStr ,
                        COUNT(DISTINCT TSA.I_Student_Detail_ID) AS StdAttn
                FROM    ( SELECT    TT.Center AS sCenter ,
                                    TT.itTable AS TimeTable ,
                                    TT.Faculty AS sFaculty ,
                                    TT.Sub AS sSub ,
                                    TT.iBatchID AS iBatch ,
                                    TT.sBatch AS Batch ,
                                    TT.Period AS sPeriod ,
                                    TT.dtDate AS sDate ,
                                    COUNT(DISTINCT TSD.S_Student_ID) AS BatchStr
                          FROM      ( SELECT    TCHND.S_Center_Name AS Center ,
                                                TTTM.I_TimeTable_ID AS itTable ,
                                                TED.S_First_Name+' '+
                                                + ISNULL(TED.S_Middle_Name,
                                                         ' ')+' '+
                                                + TED.S_Last_Name AS Faculty ,
                                                TESM.S_Skill_Desc AS Sub ,
                                                TTTM.I_Batch_ID AS iBatchID ,
                                                TSBM.S_Batch_Name AS sBatch ,
                                                CAST(CAST(LEFT(CONVERT(TIME, TCTM.Dt_Start_Time),
                                                              5) AS VARCHAR)
                                                + '  to '
                                                + CAST(LEFT(CONVERT(TIME, TCTM.Dt_End_Time),
                                                            5) AS VARCHAR) AS VARCHAR) AS Period ,
                                                CONVERT(DATE, TTTM.Dt_Schedule_Date) AS dtDate
                                      FROM      dbo.T_Employee_Dtls TED
                                                INNER JOIN dbo.T_TimeTable_Faculty_Map TTTFM ON TED.I_Employee_ID = TTTFM.I_Employee_ID
                                                INNER JOIN dbo.T_TimeTable_Master TTTM ON TTTFM.I_TimeTable_ID = TTTM.I_TimeTable_ID
                                                INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TTTM.I_Center_ID = TCHND.I_Center_ID
                                                INNER JOIN dbo.T_Session_Master TSM ON TTTM.I_Session_ID = TSM.I_Session_ID
                                                INNER JOIN dbo.T_EOS_Skill_Master TESM ON TSM.I_Skill_ID = TESM.I_Skill_ID
                                                INNER JOIN dbo.T_Center_Timeslot_Master TCTM ON TTTM.I_TimeSlot_ID = TCTM.I_TimeSlot_ID
                                                              AND TTTM.I_Center_ID = TCTM.I_Center_ID
                                                INNER JOIN dbo.T_Student_Batch_Master TSBM ON TTTM.I_Batch_ID = TSBM.I_Batch_ID
                                      WHERE     TTTFM.B_Is_Actual = 1
                                                AND TCHND.I_Brand_ID = @iBrandID
                                                AND TTTM.I_Center_ID IN (
                                                SELECT  fnCenter.centerID
                                                FROM    fnGetCentersForReports(@sHierarchyListID,
                                                              @iBrandID) fnCenter )
                                                AND TTTM.I_Status = 1
                                                AND TTTM.Dt_Schedule_Date >= @dtStartDate
                                                AND TTTM.Dt_Schedule_Date < DATEADD(d,
                                                              1, @dtEndDate)
                                                AND TED.I_Employee_ID = ISNULL(@iEmployeeID,TED.I_Employee_ID)
--ORDER BY CONVERT(DATE, TTTM.Dt_Schedule_Date) ,
--        TCHND.S_Center_Name ,
--        TED.S_First_Name + ISNULL(TED.S_Middle_Name, ' ') + TED.S_Last_Name
                                      
                                    ) TT
                                    INNER JOIN dbo.T_Student_Batch_Details TSBD ON TT.iBatchID = TSBD.I_Batch_ID
                                    INNER JOIN dbo.T_Student_Detail TSD ON TSBD.I_Student_ID = TSD.I_Student_Detail_ID
                          WHERE     TSBD.I_Status = 1
                                    AND TSD.I_Status = 1
                          GROUP BY  TT.Center ,
                                    TT.itTable ,
                                    TT.Faculty ,
                                    TT.Sub ,
                                    TT.iBatchID ,
                                    TT.sBatch ,
                                    TT.Period ,
                                    TT.dtDate
                        ) XX
                        INNER JOIN dbo.T_TimeTable_Master TTTM2 ON XX.iBatch = TTTM2.I_Batch_ID
                                                              AND xx.TimeTable = TTTM2.I_TimeTable_ID
                        INNER JOIN dbo.T_Student_Attendance TSA ON TTTM2.I_TimeTable_ID = TSA.I_TimeTable_ID
                WHERE   TTTM2.I_Status = 1
                GROUP BY xx.sCenter ,
                        xx.TimeTable ,
                        xx.sFaculty ,
                        xx.sSub ,
                        xx.iBatch ,
                        xx.Batch ,
                        xx.sPeriod ,
                        xx.sDate ,
                        xx.BatchStr
            
            
        
    END
        --SELECT * FROM #temp T;
        
        --DROP TABLE #temp;
