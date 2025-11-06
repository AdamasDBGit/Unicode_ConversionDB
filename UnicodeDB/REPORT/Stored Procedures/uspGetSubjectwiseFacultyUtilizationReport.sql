CREATE PROCEDURE [REPORT].[uspGetSubjectwiseFacultyUtilizationReport]
    (
      @iBrandID INT ,
      @sHierarchyListID VARCHAR(MAX) ,
      @dtStartDate DATE ,
      @dtEndDate DATE
    )
AS 
    BEGIN


        SELECT  DISTINCT
                TESM.I_Skill_ID ,
                TESM.S_Skill_Desc ,
                TED.I_Employee_ID ,
                TED.S_First_Name + ' ' + ISNULL(TED.S_Middle_Name, '') + ' '
                + TED.S_Last_Name AS FacultyName ,
                TCHND.I_Center_ID ,
                TCHND.S_Center_Name ,
                TTTM.I_TimeTable_ID AS AllottedClasses ,
                CONVERT(DATE, TTTM.Dt_Schedule_Date) ScheduledDate ,
                SubjectwiseCount.AllotedCount
        FROM    dbo.T_TimeTable_Master TTTM
                INNER JOIN dbo.T_TimeTable_Faculty_Map TTTFM ON TTTM.I_TimeTable_ID = TTTFM.I_TimeTable_ID
                INNER JOIN dbo.T_Employee_Dtls TED ON TTTFM.I_Employee_ID = TED.I_Employee_ID
                INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TTTM.I_Center_ID = TCHND.I_Center_ID
                INNER JOIN dbo.T_Session_Master TSM ON TTTM.I_Session_ID = TSM.I_Session_ID
                INNER  JOIN dbo.T_EOS_Skill_Master TESM ON TSM.I_Skill_ID = TESM.I_Skill_ID
                INNER  JOIN ( SELECT  TESM.I_Skill_ID AS SkillID ,
                                    TESM.S_Skill_Desc AS SkillName ,
                                    COUNT(DISTINCT TTTM.I_TimeTable_ID) AS AllotedCount
                            FROM    dbo.T_TimeTable_Master TTTM
                                    INNER JOIN dbo.T_TimeTable_Faculty_Map TTTFM ON TTTM.I_TimeTable_ID = TTTFM.I_TimeTable_ID
                                    INNER JOIN dbo.T_Employee_Dtls TED ON TTTFM.I_Employee_ID = TED.I_Employee_ID
                                    INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TTTM.I_Center_ID = TCHND.I_Center_ID
                                    INNER  JOIN dbo.T_Session_Master TSM ON TTTM.I_Session_ID = TSM.I_Session_ID
                                    INNER JOIN dbo.T_EOS_Skill_Master TESM ON TSM.I_Skill_ID = TESM.I_Skill_ID
                            WHERE   ( TTTM.Dt_Schedule_Date >= @dtStartDate
                                      AND TTTM.Dt_Schedule_Date < @dtEndDate
                                    )
                                    AND TCHND.I_Center_ID IN (
                                    SELECT  FGCFR.centerID
                                    FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
                                                              @iBrandID) FGCFR )
        AND TTTM.I_Session_ID IS NOT NULL
                                    AND TTTM.I_Status = 1
                                    AND TTTFM.B_Is_Actual = 1
                            GROUP BY TESM.I_Skill_ID ,
                                    TESM.S_Skill_Desc
                          ) SubjectwiseCount ON TSM.I_Skill_ID = SubjectwiseCount.SkillID
        WHERE   ( TTTM.Dt_Schedule_Date >= @dtStartDate
                  AND TTTM.Dt_Schedule_Date < @dtEndDate
                )
                AND TCHND.I_Center_ID IN (
                SELECT  FGCFR.centerID
                FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
                                                   @iBrandID) FGCFR )
        AND TTTM.I_Session_ID IS NOT NULL
                AND TTTM.I_Status = 1
                AND TTTFM.B_Is_Actual = 1
--GROUP BY TESM.I_Skill_ID ,
--        TESM.S_Skill_Desc ,
--        TED.I_Employee_ID ,
--        TED.S_First_Name + ' ' + ISNULL(TED.S_Middle_Name, '') + ' '
--        + TED.S_Last_Name,
--        TCHND.I_Center_ID ,
--        TCHND.S_Center_Name 

    END
