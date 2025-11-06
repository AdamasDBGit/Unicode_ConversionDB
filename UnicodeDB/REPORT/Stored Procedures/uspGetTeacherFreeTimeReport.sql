CREATE PROCEDURE [REPORT].[uspGetTeacherFreeTimeReport]
    (
      @iBrandID INT ,
      @HierarchyListID VARCHAR(MAX),
      @dtOnDate DATE,
      @sFacultyName VARCHAR(MAX)
    )
AS 
    BEGIN
		
		IF(@sFacultyName='ALL')
		BEGIN
        SELECT  T3.I_Employee_ID ,
                T3.FacultyName ,
                T3.Period ,
                CASE WHEN T4.I_Employee_ID IS NULL THEN 'YES'
                     WHEN T4.I_Employee_ID IS NOT NULL THEN 'NO'
                END AS Availability
        FROM    ( SELECT    T1.I_Employee_ID ,
                            T1.FacultyName ,
                            T2.Period
                  FROM      ( SELECT    TED.I_Employee_ID ,
                                        TED.S_First_Name + ' '
                                        + ISNULL(TED.S_Middle_Name, '') + ' '
                                        + TED.S_Last_Name AS FacultyName
                              FROM      dbo.T_Employee_Dtls TED
										INNER JOIN dbo.T_TimeTable_Faculty_Map TTTFM ON TED.I_Employee_ID = TTTFM.I_Employee_ID
                INNER JOIN dbo.T_TimeTable_Master TTTM ON TTTFM.I_TimeTable_ID = TTTM.I_TimeTable_ID
                INNER JOIN dbo.T_User_Master TUM ON TED.I_Employee_ID = TUM.I_Reference_ID
        WHERE   TED.I_Status = 3
                AND TTTM.I_Status = 1
                AND TTTFM.B_Is_Actual IN ( 0, 1 )
                AND TTTM.I_Center_ID IN (
                SELECT  FGCFR.centerID
                FROM    dbo.fnGetCentersForReports(@HierarchyListID,
                                                   @iBrandID) FGCFR )
                AND CONVERT(DATE, TTTM.Dt_Schedule_Date) = CONVERT(DATE, @dtOnDate)
                              --          INNER JOIN EOS.T_Employee_Role_Map TERM ON TED.I_Employee_ID = TERM.I_Employee_ID
                              --          INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TED.I_Centre_Id = TCHND.I_Center_ID
                              --WHERE     TED.I_Status = 3
                              --          AND TERM.I_Role_ID = 18
                              --          AND TCHND.I_Brand_ID = @iBrandID --AND TED.I_Employee_ID=410
                              --          --AND TED.I_Employee_ID IN (SELECT CAST(FSR.Val AS INT) FROM dbo.fnString2Rows(@sFacultyName,',') FSR)
                            ) T1
                            CROSS JOIN ( SELECT DISTINCT
                                                CAST(CAST(LEFT(CONVERT(TIME, TCTM.Dt_Start_Time),
                                                              5) AS VARCHAR)
                                                + '  to '
                                                + CAST(LEFT(CONVERT(TIME, TCTM.Dt_End_Time),
                                                            5) AS VARCHAR) AS VARCHAR) AS Period
                                         FROM   dbo.T_Center_Timeslot_Master TCTM
                                                INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TCTM.I_Center_ID = TCHND.I_Center_ID
                                                INNER JOIN dbo.T_Centre_Master TCM ON TCHND.I_Center_ID = TCM.I_Centre_Id
                                         WHERE  TCHND.I_Brand_ID = @iBrandID
                                                AND TCTM.I_Status = 1
                                                AND TCM.S_Center_Code NOT LIKE 'FR-%'
                                       ) T2
                ) T3
                LEFT JOIN ( SELECT DISTINCT
                                    CAST(CAST(LEFT(CONVERT(TIME, TCTM.Dt_Start_Time),
                                                   5) AS VARCHAR) + '  to '
                                    + CAST(LEFT(CONVERT(TIME, TCTM.Dt_End_Time),
                                                5) AS VARCHAR) AS VARCHAR) AS Period ,
                                    TTTFM.I_Employee_ID
                            FROM    dbo.T_TimeTable_Faculty_Map TTTFM
                                    INNER JOIN dbo.T_TimeTable_Master TTTM ON TTTFM.I_TimeTable_ID = TTTM.I_TimeTable_ID
                                    INNER JOIN dbo.T_Center_Timeslot_Master TCTM ON TTTM.I_TimeSlot_ID = TCTM.I_TimeSlot_ID
                                    INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TTTM.I_Center_ID = TCHND.I_Center_ID
                                    INNER JOIN dbo.T_Centre_Master TCM ON TCHND.I_Center_ID = TCM.I_Centre_Id
                            WHERE   TTTFM.B_Is_Actual IN ( 1, 0 )
                                    AND TTTM.I_Status = 1
                                    AND TCHND.I_Brand_ID = @iBrandID
                                    AND CONVERT(DATE, TTTM.Dt_Schedule_Date) = CONVERT(DATE, @dtOnDate)
                                    --AND TTTFM.I_Employee_ID IN (SELECT CAST(FSR.Val AS INT) FROM dbo.fnString2Rows(@sFacultyName,',') FSR)
                          ) T4 ON T3.I_Employee_ID = T4.I_Employee_ID
                                  AND T3.Period = T4.Period
        ORDER BY T3.I_Employee_ID
        END
        ELSE
        BEGIN
        	SELECT  T3.I_Employee_ID ,
                T3.FacultyName ,
                T3.Period ,
                CASE WHEN T4.I_Employee_ID IS NULL THEN 'YES'
                     WHEN T4.I_Employee_ID IS NOT NULL THEN 'NO'
                END AS Availability
        FROM    ( SELECT    T1.I_Employee_ID ,
                            T1.FacultyName ,
                            T2.Period
                  FROM      ( SELECT    TED.I_Employee_ID ,
                                        TED.S_First_Name + ' '
                                        + ISNULL(TED.S_Middle_Name, '') + ' '
                                        + TED.S_Last_Name AS FacultyName
                              FROM      dbo.T_Employee_Dtls TED
                                        INNER JOIN EOS.T_Employee_Role_Map TERM ON TED.I_Employee_ID = TERM.I_Employee_ID
                                        INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TED.I_Centre_Id = TCHND.I_Center_ID
                              WHERE     TED.I_Status = 3
                                        AND TERM.I_Role_ID = 18
                                        AND TCHND.I_Brand_ID = @iBrandID --AND TED.I_Employee_ID=410
                                        AND TED.I_Employee_ID IN (SELECT CAST(FSR.Val AS INT) FROM dbo.fnString2Rows(@sFacultyName,',') FSR)
                            ) T1
                            CROSS JOIN ( SELECT DISTINCT
                                                CAST(CAST(LEFT(CONVERT(TIME, TCTM.Dt_Start_Time),
                                                              5) AS VARCHAR)
                                                + '  to '
                                                + CAST(LEFT(CONVERT(TIME, TCTM.Dt_End_Time),
                                                            5) AS VARCHAR) AS VARCHAR) AS Period
                                         FROM   dbo.T_Center_Timeslot_Master TCTM
                                                INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TCTM.I_Center_ID = TCHND.I_Center_ID
                                                INNER JOIN dbo.T_Centre_Master TCM ON TCHND.I_Center_ID = TCM.I_Centre_Id
                                         WHERE  TCHND.I_Brand_ID = @iBrandID
                                                AND TCTM.I_Status = 1
                                                AND TCM.S_Center_Code NOT LIKE 'FR-%'
                                       ) T2
                ) T3
                LEFT JOIN ( SELECT DISTINCT
                                    CAST(CAST(LEFT(CONVERT(TIME, TCTM.Dt_Start_Time),
                                                   5) AS VARCHAR) + '  to '
                                    + CAST(LEFT(CONVERT(TIME, TCTM.Dt_End_Time),
                                                5) AS VARCHAR) AS VARCHAR) AS Period ,
                                    TTTFM.I_Employee_ID
                            FROM    dbo.T_TimeTable_Faculty_Map TTTFM
                                    INNER JOIN dbo.T_TimeTable_Master TTTM ON TTTFM.I_TimeTable_ID = TTTM.I_TimeTable_ID
                                    INNER JOIN dbo.T_Center_Timeslot_Master TCTM ON TTTM.I_TimeSlot_ID = TCTM.I_TimeSlot_ID
                                    INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TTTM.I_Center_ID = TCHND.I_Center_ID
                                    INNER JOIN dbo.T_Centre_Master TCM ON TCHND.I_Center_ID = TCM.I_Centre_Id
                            WHERE   TTTFM.B_Is_Actual IN ( 1, 0 )
                                    AND TTTM.I_Status = 1
                                    AND TCHND.I_Brand_ID = @iBrandID
                                    AND CONVERT(DATE, TTTM.Dt_Schedule_Date) = CONVERT(DATE, @dtOnDate)
                                    AND TTTFM.I_Employee_ID IN (SELECT CAST(FSR.Val AS INT) FROM dbo.fnString2Rows(@sFacultyName,',') FSR)
                                    --AND TTTM.I_Is_Complete = 0
                          ) T4 ON T3.I_Employee_ID = T4.I_Employee_ID
                                  AND T3.Period = T4.Period
        ORDER BY T3.I_Employee_ID
        END


    END
