CREATE PROCEDURE [REPORT].[uspGetStudentBatchSchedulingNew]
    (
      -- Add the parameters for the stored procedure here    
      @iBrandID INT ,
      @sHierarchyList VARCHAR(MAX) ,
      @EndDate DATETIME ,
      @iCourseID VARCHAR(800) = NULL ,
      @StartDate DATETIME    
    )
AS 
    BEGIN TRY    
    
        IF @iCourseID IS NULL 
            BEGIN    
                SELECT  [TBCD].[I_Brand_ID] ,
                        TBM.S_Brand_Code ,
                        [TCM].centerName AS S_Center_Name ,
                        [TSBM].[S_Batch_Code] ,
                        [TSBM].S_Batch_Name ,
                        CM.S_Course_Name ,
                        CFM.S_CourseFamily_Name ,
                        [TSBM].[Dt_BatchStartDate] ,
                        [TSBM].[Dt_Course_Expected_End_Date] ,
                        [TSBM].[Dt_Course_Actual_End_Date] ,
                        TSBM.Dt_BatchIntroductionDate ,
                        TDPM.S_Pattern_Name ,
                        TSBM.I_TimeSlot_ID ,
                        TCBD.Max_Strength ,
                        StudentCount.NoOfStudents ,
                        HistStudentCount.HistNoOfStudents ,
                        ActualModSess.PM,
                        ActualModSess.AM,
                        ActualModSess.PS,
                        ActualModSess.ASess,
                        [TSBM].[b_IsHOBatch] ,
                        ISNULL([TCBD].[I_Status], [TSBM].[I_Status]) AS [Status] ,
                        ( SELECT    SUM(A.I_Total_Session_Count) TotSeasonCount
                          FROM      T_Term_Master A
                                    INNER JOIN T_Term_Course_Map B ON A.I_Term_ID = B.I_Term_ID
                                    INNER JOIN T_Course_Master C ON B.I_Course_ID = C.I_Course_ID
                          WHERE     C.I_Course_ID = @iCourseID
                                    AND C.I_Brand_ID = @iBrandID
                        ) AS PlannedSessionCount ,
                        ( SELECT    COUNT(*)
                          FROM      dbo.T_TimeTable_Master TM
                          WHERE     TM.Dt_Schedule_Date BETWEEN @StartDate
                                                        AND   @EndDate
                                    AND TM.I_Batch_ID = TCBD.I_Batch_ID
                                    AND ( TM.I_Center_ID = TCBD.I_Centre_Id
                                          OR TM.I_Center_ID IS NULL
                                        )
                        ) AS PlannedSessionCountBeforeEndDate ,
                        ( SELECT    MIN(Dt_Actual_Date)
                          FROM      dbo.T_TimeTable_Master TM
                          WHERE     TM.I_Batch_ID = [TSBM].[I_Batch_ID]
                                    AND TM.I_Center_ID = TCBD.I_Centre_Id
                        ) AS FirstAttendanceDate ,
                        ( SELECT    COUNT(I_Student_ID)
                          FROM      dbo.T_Student_Batch_Details SBD
                                    INNER JOIN dbo.T_Student_Detail SD ON SBD.I_Student_ID = SD.I_Student_Detail_ID
                                    INNER JOIN T_Enquiry_Regn_Detail ERD ON SD.I_Enquiry_Regn_ID = ERD.I_Enquiry_Regn_ID
                          WHERE     SBD.I_Batch_ID = TCBD.I_Batch_ID
                                    AND SBD.I_Status = 1
                                    AND ERD.I_Centre_Id = TCBD.I_Centre_Id
                        ) StudentEnrolled ,
                        ( SELECT    COUNT(SRD.I_Enquiry_Regn_ID)
                          FROM      T_Student_Registration_Details SRD
                                    INNER JOIN T_Enquiry_Regn_Detail ERD ON SRD.I_Enquiry_Regn_ID = ERD.I_Enquiry_Regn_ID
                          WHERE     SRD.I_Batch_ID = TCBD.I_Batch_ID
                                    AND I_Status = 1
                                    AND ERD.I_Centre_Id = TCBD.I_Centre_Id
                        ) StudentRegistered ,
                        ISNULL(ED.S_First_Name, '') + ' '
                        + ISNULL(ED.S_Middle_Name, '') + ' '
                        + ISNULL(ED.S_Last_Name, '') AS Faculty ,
                        ( SELECT    COUNT(*)
                          FROM      dbo.T_TimeTable_Master TM
                          WHERE     TM.Dt_Actual_Date IS NOT NULL
                                    AND TM.Dt_Schedule_Date <= GETDATE()
                                    AND TM.I_Batch_ID = TCBD.I_Batch_ID
                                    AND ( TM.I_Center_ID = TCBD.I_Centre_Id
                                          OR TM.I_Center_ID IS NULL
                                        )
                        ) AS ActualSessionCount ,
                        ( SELECT    SUM(A.I_Total_Session_Count) TotSeasonCount
                          FROM      T_Term_Master A
                                    INNER JOIN T_Term_Course_Map B ON A.I_Term_ID = B.I_Term_ID
                                    INNER JOIN T_Course_Master C ON B.I_Course_ID = C.I_Course_ID
                          WHERE     C.I_Course_ID = @iCourseID
                                    AND C.I_Brand_ID = @iBrandID
                        ) AS TotalSessionCount ,
                        ( SELECT    CAST(CAST(LEFT(MIN(CONVERT(TIME, TCTM.Dt_Start_Time)),
                                                   5) AS VARCHAR) + '  to '
                                    + CAST(LEFT(MAX(CONVERT(TIME, TCTM.Dt_End_Time)),
                                                5) AS VARCHAR) AS VARCHAR) AS TimeSlot
                          FROM      dbo.T_Center_Timeslot_Master TCTM
                                    INNER JOIN dbo.fnGetCentersForReports(@sHierarchyList,
                                                              @iBrandID) AS FCR ON TCTM.I_Center_ID = FCR.centerID
                        ) AS TimeSlot
                FROM    dbo.T_Center_Batch_Details AS TCBD
                        INNER JOIN dbo.fnGetCentersForReports(@sHierarchyList,
                                                              @iBrandID) AS TCM ON TCBD.I_Centre_Id = TCM.centerID
                        INNER JOIN dbo.T_Student_Batch_Master AS TSBM ON TCBD.I_Batch_ID = TSBM.I_Batch_ID
                        INNER JOIN dbo.T_Brand_Center_Details AS TBCD ON TCBD.I_Centre_Id = TBCD.I_Centre_Id
                        INNER JOIN dbo.T_Brand_Master TBM ON TBCD.I_Brand_ID = TBM.I_Brand_ID
                        INNER JOIN dbo.T_Course_Master CM ON TSBM.I_Course_ID = CM.I_Course_ID
                        INNER JOIN dbo.T_CourseFamily_Master CFM ON CM.I_CourseFamily_ID = CFM.I_CourseFamily_ID
                        INNER JOIN dbo.T_Delivery_Pattern_Master TDPM ON TSBM.I_Delivery_Pattern_ID = TDPM.I_Delivery_Pattern_ID
                        INNER JOIN ( SELECT YY.HistoricalBatch ,
                                            COUNT(DISTINCT YY.I_Student_ID) AS HistNoOfStudents
                                     FROM   ( SELECT    TSBD.I_Student_ID ,
                                                        dbo.fnGetHistoricalBatchID(TSBD.I_Student_ID,
                                                              TSBM2.Dt_BatchStartDate) AS HistoricalBatch
                                              FROM      dbo.T_Student_Batch_Details TSBD
                                              INNER JOIN dbo.T_Student_Batch_Master TSBM2 ON TSBD.I_Batch_ID = TSBM2.I_Batch_ID
                                                        INNER JOIN dbo.T_Center_Batch_Details TCBD2 ON TSBD.I_Batch_ID = TCBD2.I_Batch_ID
                                                        INNER JOIN dbo.[fnGetCentersForReports](@sHierarchyList,
                                                              @iBrandID) AS FCR ON [TCBD2].[I_Centre_Id] = [FCR].centerID
                                              WHERE     TSBD.I_Status IN ( 0,
                                                              1, 2 )
                                            ) YY
                                     GROUP BY YY.HistoricalBatch
                                   ) HistStudentCount ON TSBM.I_Batch_ID = HistStudentCount.HistoricalBatch
                        LEFT JOIN ( SELECT  TSBD1.I_Batch_ID ,
                                            COUNT(DISTINCT TSBD1.I_Student_ID) AS NoOfStudents
                                    FROM    dbo.T_Student_Batch_Details TSBD1
                                    WHERE   TSBD1.I_Status = 1
                                    GROUP BY TSBD1.I_Batch_ID
                                  ) StudentCount ON TCBD.I_Batch_ID = StudentCount.I_Batch_ID
                        LEFT JOIN ( SELECT  AA.PT ,
                                            AA.PB ,
                                            AA.PSch ,
                                            AA.PM ,
                                            AA.PS ,
                                            BB.AM ,
                                            BB.ASess ,
                                            DENSE_RANK() OVER ( PARTITION BY AA.PB ORDER BY AA.PT DESC ) AS PRank
                                    FROM    ( SELECT    TTTMP.I_TimeTable_ID AS PT ,
                                                        TTTMP.Dt_Schedule_Date AS PSch ,
                                                        TTTMP.I_Batch_ID AS PB ,
                                                        TMM.I_Module_ID AS PMI ,
                                                        TMM.S_Module_Name AS PM ,
                                                        TTTMP.S_Session_Name AS PS
                                              FROM      dbo.T_TimeTable_Master_Planned TTTMP
                                                        INNER JOIN dbo.T_Module_Master TMM ON TTTMP.I_Module_ID = TMM.I_Module_ID
                                                        INNER JOIN dbo.[fnGetCentersForReports](@sHierarchyList,
                                                              @iBrandID) AS FCR ON [TTTMP].[I_Center_Id] = [FCR].centerID
                                              WHERE     TTTMP.I_Batch_ID IS NOT NULL
                                                        AND TTTMP.I_Status = 1
                                                        AND TTTMP.I_Session_ID IS NOT NULL
                                                        AND TTTMP.B_Is_Actual = 0
                                                        AND TTTMP.Dt_Schedule_Date BETWEEN @StartDate AND @EndDate
                                            ) AA
                                            INNER JOIN ( SELECT
                                                              TTTMP.I_TimeTable_ID AS AT ,
                                                              TMM.I_Module_ID AS ATI ,
                                                              TMM.S_Module_Name AS AM ,
                                                              TTTMP.S_Session_Name AS ASess
                                                         FROM dbo.T_TimeTable_Master TTTMP
                                                              INNER JOIN dbo.T_Module_Master TMM ON TTTMP.I_Module_ID = TMM.I_Module_ID
                                                              INNER JOIN dbo.[fnGetCentersForReports](@sHierarchyList,
                                                              @iBrandID) AS FCR ON [TTTMP].[I_Center_Id] = [FCR].centerID
                                                         WHERE
                                                              TTTMP.I_Batch_ID IS NOT NULL
                                                              AND TTTMP.I_Status = 1
                                                              AND TTTMP.I_Session_ID IS NOT NULL
--ORDER BY TTTMP.Dt_Schedule_Date DESC
                                                       ) BB ON AA.PT = BB.AT
                                  ) ActualModSess ON TSBM.I_Batch_ID = ActualModSess.PB AND ActualModSess.PRank=1
                        LEFT OUTER JOIN dbo.T_Employee_Dtls ED ON TCBD.I_Employee_ID = ED.I_Employee_ID
                WHERE   TSBM.Dt_BatchStartDate BETWEEN @StartDate
                                               AND     @EndDate
                ORDER BY [TBCD].[I_Brand_ID] ,
                        [TBCD].[I_Centre_Id]    
            END    
        ELSE 
            BEGIN    
                SELECT  [TBCD].[I_Brand_ID] ,
                        TBM.S_Brand_Code ,
                        [TCM].centerName AS S_Center_Name ,
                        [TSBM].[S_Batch_Code] ,
                        [TSBM].S_Batch_Name ,
                        CM.S_Course_Name ,
                        CFM.S_CourseFamily_Name ,
                        [TSBM].[Dt_BatchStartDate] ,
                        [TSBM].[Dt_Course_Expected_End_Date] ,
                        [TSBM].[Dt_Course_Actual_End_Date] ,
                        TSBM.Dt_BatchIntroductionDate ,
                        TDPM.S_Pattern_Name ,
                        TSBM.I_TimeSlot_ID ,
                        TCBD.Max_Strength ,
                        StudentCount.NoOfStudents ,
                        HistStudentCount.HistNoOfStudents ,
                        [TSBM].[b_IsHOBatch] ,
                        ISNULL([TCBD].[I_Status], [TSBM].[I_Status]) AS [Status] ,
                        ( SELECT    SUM(A.I_Total_Session_Count) TotSeasonCount
                          FROM      T_Term_Master A
                                    INNER JOIN T_Term_Course_Map B ON A.I_Term_ID = B.I_Term_ID
                                    INNER JOIN T_Course_Master C ON B.I_Course_ID = C.I_Course_ID
                          WHERE     C.I_Course_ID = @iCourseID
                                    AND C.I_Brand_ID = @iBrandID
                        ) AS PlannedSessionCount ,
                        ( SELECT    COUNT(*)
                          FROM      dbo.T_TimeTable_Master TM
                          WHERE     TM.Dt_Schedule_Date BETWEEN @StartDate
                                                        AND   @EndDate
                                    AND TM.I_Batch_ID = TCBD.I_Batch_ID
                                    AND ( TM.I_Center_ID = TCBD.I_Centre_Id
                                          OR TM.I_Center_ID IS NULL
                                        )
                        ) AS PlannedSessionCountBeforeEndDate ,
                        ( SELECT    MIN(Dt_Actual_Date)
                          FROM      dbo.T_TimeTable_Master TM
                          WHERE     TM.I_Batch_ID = [TSBM].[I_Batch_ID]
                                    AND TM.I_Center_ID = TCBD.I_Centre_Id
                        ) AS FirstAttendanceDate ,
                        ( SELECT    COUNT(I_Student_ID)
                          FROM      dbo.T_Student_Batch_Details SBD
                                    INNER JOIN dbo.T_Student_Detail SD ON SBD.I_Student_ID = SD.I_Student_Detail_ID
                                    INNER JOIN T_Enquiry_Regn_Detail ERD ON SD.I_Enquiry_Regn_ID = ERD.I_Enquiry_Regn_ID
                          WHERE     SBD.I_Batch_ID = TCBD.I_Batch_ID
                                    AND SBD.I_Status = 1
                                    AND ERD.I_Centre_Id = TCBD.I_Centre_Id
                        ) StudentEnrolled ,
                        ( SELECT    COUNT(SRD.I_Enquiry_Regn_ID)
                          FROM      T_Student_Registration_Details SRD
                                    INNER JOIN T_Enquiry_Regn_Detail ERD ON SRD.I_Enquiry_Regn_ID = ERD.I_Enquiry_Regn_ID
                          WHERE     SRD.I_Batch_ID = TCBD.I_Batch_ID
                                    AND I_Status = 1
                                    AND ERD.I_Centre_Id = TCBD.I_Centre_Id
                        ) StudentRegistered ,
                        ISNULL(ED.S_First_Name, '') + ' '
                        + ISNULL(ED.S_Middle_Name, '') + ' '
                        + ISNULL(ED.S_Last_Name, '') AS Faculty ,
                        ( SELECT    COUNT(*)
                          FROM      dbo.T_TimeTable_Master TM
                          WHERE     TM.Dt_Actual_Date IS NOT NULL
                                    AND TM.Dt_Schedule_Date <= GETDATE()
                                    AND TM.I_Batch_ID = TCBD.I_Batch_ID
                                    AND ( TM.I_Center_ID = TCBD.I_Centre_Id
                                          OR TM.I_Center_ID IS NULL
                                        )
                        ) AS ActualSessionCount ,
                        ( SELECT    SUM(A.I_Total_Session_Count) TotSeasonCount
                          FROM      T_Term_Master A
                                    INNER JOIN T_Term_Course_Map B ON A.I_Term_ID = B.I_Term_ID
                                    INNER JOIN T_Course_Master C ON B.I_Course_ID = C.I_Course_ID
                          WHERE     C.I_Course_ID = @iCourseID
                                    AND C.I_Brand_ID = @iBrandID
                        ) AS TotalSessionCount ,
                        ( SELECT    CAST(CAST(LEFT(MIN(CONVERT(TIME, TCTM.Dt_Start_Time)),
                                                   5) AS VARCHAR) + '  to '
                                    + CAST(LEFT(MAX(CONVERT(TIME, TCTM.Dt_End_Time)),
                                                5) AS VARCHAR) AS VARCHAR) AS TimeSlot
                          FROM      dbo.T_Center_Timeslot_Master TCTM
                                    INNER JOIN dbo.fnGetCentersForReports(@sHierarchyList,
                                                              @iBrandID) AS FCR ON TCTM.I_Center_ID = FCR.centerID
                        ) AS TimeSlot
                FROM    [dbo].[T_Center_Batch_Details] AS TCBD
                        INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList,
                                                              @iBrandID) AS TCM ON [TCBD].[I_Centre_Id] = [TCM].centerID
                        INNER JOIN [dbo].[T_Student_Batch_Master] AS TSBM ON [TCBD].[I_Batch_ID] = [TSBM].[I_Batch_ID]
                        INNER JOIN [dbo].[T_Brand_Center_Details] AS TBCD ON [TCBD].[I_Centre_Id] = [TBCD].[I_Centre_Id]
                        INNER JOIN dbo.T_Brand_Master TBM ON TBCD.I_Brand_ID = TBM.I_Brand_ID
                        INNER JOIN dbo.T_Course_Master CM ON TSBM.I_Course_ID = CM.I_Course_ID
                        INNER JOIN dbo.T_CourseFamily_Master CFM ON CM.I_CourseFamily_ID = CFM.I_CourseFamily_ID
                        INNER JOIN dbo.T_Delivery_Pattern_Master TDPM ON TSBM.I_Delivery_Pattern_ID = TDPM.I_Delivery_Pattern_ID
                        INNER JOIN ( SELECT YY.HistoricalBatch ,
                                            COUNT(DISTINCT YY.I_Student_ID) AS HistNoOfStudents
                                     FROM   ( SELECT    TSBD.I_Student_ID ,
                                                        dbo.fnGetHistoricalBatchID(TSBD.I_Student_ID,
                                                              TSBM2.Dt_BatchStartDate) AS HistoricalBatch
                                              FROM      dbo.T_Student_Batch_Details TSBD
                                              INNER JOIN dbo.T_Student_Batch_Master TSBM2 ON TSBD.I_Batch_ID = TSBM2.I_Batch_ID
                                                        INNER JOIN dbo.T_Center_Batch_Details TCBD2 ON TSBD.I_Batch_ID = TCBD2.I_Batch_ID
                                                        INNER JOIN dbo.[fnGetCentersForReports](@sHierarchyList,
                                                              @iBrandID) AS FCR ON [TCBD2].[I_Centre_Id] = [FCR].centerID
                                              WHERE     TSBD.I_Status IN ( 0,
                                                              1, 2 )
                                            ) YY
                                     GROUP BY YY.HistoricalBatch
                                   ) HistStudentCount ON TSBM.I_Batch_ID = HistStudentCount.HistoricalBatch
                        LEFT JOIN ( SELECT  TSBD1.I_Batch_ID ,
                                            COUNT(DISTINCT TSBD1.I_Student_ID) AS NoOfStudents
                                    FROM    dbo.T_Student_Batch_Details TSBD1
                                    WHERE   TSBD1.I_Status = 1
                                    GROUP BY TSBD1.I_Batch_ID
                                  ) StudentCount ON TCBD.I_Batch_ID = StudentCount.I_Batch_ID
                        LEFT JOIN ( SELECT  AA.PT ,
                                            AA.PB ,
                                            AA.PSch ,
                                            AA.PM ,
                                            AA.PS ,
                                            BB.AM ,
                                            BB.ASess ,
                                            DENSE_RANK() OVER ( PARTITION BY AA.PB ORDER BY AA.PT DESC ) AS PRank
                                    FROM    ( SELECT    TTTMP.I_TimeTable_ID AS PT ,
                                                        TTTMP.Dt_Schedule_Date AS PSch ,
                                                        TTTMP.I_Batch_ID AS PB ,
                                                        TMM.I_Module_ID AS PMI ,
                                                        TMM.S_Module_Name AS PM ,
                                                        TTTMP.S_Session_Name AS PS
                                              FROM      dbo.T_TimeTable_Master_Planned TTTMP
                                                        INNER JOIN dbo.T_Module_Master TMM ON TTTMP.I_Module_ID = TMM.I_Module_ID
                                                        INNER JOIN dbo.[fnGetCentersForReports](@sHierarchyList,
                                                              @iBrandID) AS FCR ON [TTTMP].[I_Center_Id] = [FCR].centerID
                                              WHERE     TTTMP.I_Batch_ID IS NOT NULL
                                                        AND TTTMP.I_Status = 1
                                                        AND TTTMP.I_Session_ID IS NOT NULL
                                                        AND TTTMP.B_Is_Actual = 0
                                                        AND TTTMP.Dt_Schedule_Date BETWEEN @StartDate AND @EndDate
                                            ) AA
                                            INNER JOIN ( SELECT
                                                              TTTMP.I_TimeTable_ID AS AT ,
                                                              TMM.I_Module_ID AS ATI ,
                                                              TMM.S_Module_Name AS AM ,
                                                              TTTMP.S_Session_Name AS ASess
                                                         FROM dbo.T_TimeTable_Master TTTMP
                                                              INNER JOIN dbo.T_Module_Master TMM ON TTTMP.I_Module_ID = TMM.I_Module_ID
                                                              INNER JOIN dbo.[fnGetCentersForReports](@sHierarchyList,
                                                              @iBrandID) AS FCR ON [TTTMP].[I_Center_Id] = [FCR].centerID
                                                         WHERE
                                                              TTTMP.I_Batch_ID IS NOT NULL
                                                              AND TTTMP.I_Status = 1
                                                              AND TTTMP.I_Session_ID IS NOT NULL
--ORDER BY TTTMP.Dt_Schedule_Date DESC
                                                         
                                                       ) BB ON AA.PT = BB.AT
                                  ) ActualModSess ON TSBM.I_Batch_ID = ActualModSess.PB AND ActualModSess.PRank=1
                        LEFT OUTER JOIN dbo.T_Employee_Dtls ED ON TCBD.I_Employee_ID = ED.I_Employee_ID
                WHERE   TSBM.I_Course_ID IN (
                        SELECT  Val
                        FROM    fnString2Rows(@iCourseID, ',') )
                        AND TSBM.Dt_BatchStartDate BETWEEN @StartDate
                                                   AND     @EndDate
                ORDER BY [TBCD].[I_Brand_ID] ,
                        [TBCD].[I_Centre_Id] ,
                        TSBM.Dt_BatchStartDate   
            END    
    
    END TRY    
    
    BEGIN CATCH    
     
        DECLARE @ErrMsg NVARCHAR(4000) ,
            @ErrSeverity INT    
    
        SELECT  @ErrMsg = ERROR_MESSAGE() ,
                @ErrSeverity = ERROR_SEVERITY()    
    
        RAISERROR(@ErrMsg, @ErrSeverity, 1)    
    END CATCH
