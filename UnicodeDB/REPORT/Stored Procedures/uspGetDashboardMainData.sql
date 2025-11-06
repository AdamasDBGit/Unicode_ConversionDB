CREATE PROCEDURE [REPORT].[uspGetDashboardMainData]
    (
      @sHierarchyListID VARCHAR(MAX) ,
      @iBrandID INT ,
      @dtStartDate DATE ,
      @dtEndDate DATE
    )
AS 
    BEGIN
    
        CREATE TABLE #temp1
            (
              CenterID INT ,
              Duration VARCHAR(MAX) ,
              BranchResource INT ,
              BranchSlot INT ,
              BranchCapacity INT ,
              BatchOccupancy INT ,
              CenterName VARCHAR(MAX)
            )
    
        CREATE TABLE #temp2
            (
              CenterID INT ,
              Duration VARCHAR(MAX) ,
              BranchResource INT ,
              BranchSlot INT ,
              BranchCapacity INT ,
              BatchOccupancy INT ,
              CenterName VARCHAR(MAX) ,
              Due DECIMAL(14, 2) ,
              BranchCollection DECIMAL(14, 2) ,
              AdmissionCount INT ,
              EnquiryCount INT ,
              DiscontinuedStudentCount INT ,
              DiscontinuedAmount DECIMAL(14, 2) ,
              MonthlyExamAttendanceCount INT ,
              MonthlyExamAttendanceShouldBe INT ,
              MonthlyExamAbsentCount INT ,
              StudentOnRoll INT ,
              StudentOnLeave INT ,
              TransferOutCount INT ,
              DefaulterCount INT ,
              DropOutCount INT ,
              CompletedCount INT ,
              ActiveStudentCount INT ,
              LeakagePercentage INT ,
              NoOfBatchesRunning INT ,
              CenterSlippage REAL,
              BatchwithSlippage INT
            )
    
    
        INSERT  INTO #temp1
                ( CenterID ,
                  Duration ,
                  BranchResource ,
                  BranchSlot ,
                  BranchCapacity ,
                  BatchOccupancy ,
                  CenterName
                )
                SELECT  TT.* ,
                        BranchBatchOccupancy.BatchOccupancy ,
                        TCHND.S_Center_Name
                FROM    ( SELECT    BranchResource.I_Centre_Id AS BranchID ,
                                    CAST(@dtStartDate AS VARCHAR) + ' to '
                                    + CAST(@dtEndDate AS VARCHAR) AS Duration ,
                                    BranchResource.ResourceCapacity AS BranchResource ,
                                    BranchSlot.Slot AS BranchSlot ,
                                    BranchResource.ResourceCapacity
                                    * BranchSlot.Slot AS CentreCapacity
                          FROM      ( SELECT    TRM.I_Centre_Id ,
                                                SUM(ISNULL(I_Room_Capacity,0)) AS ResourceCapacity
                                      FROM      dbo.T_Room_Master TRM
                                                INNER JOIN dbo.fnGetCentersForReports(@sHierarchyListID,
                                                              @iBrandID) FGCFR ON TRM.I_Centre_Id = FGCFR.centerID
                                      WHERE     TRM.I_Status = 1
                                      GROUP BY  TRM.I_Centre_Id
                                    ) BranchResource
                                    INNER JOIN ( SELECT TCTM.I_Center_ID ,
                                                        COUNT(DISTINCT I_TimeSlot_ID) AS Slot
                                                 FROM   dbo.T_Center_Timeslot_Master TCTM
                                                        INNER JOIN dbo.fnGetCentersForReports(@sHierarchyListID,
                                                              @iBrandID) FGCFR ON TCTM.I_Center_ID = FGCFR.centerID
                                                 WHERE  TCTM.I_Status = 1
                                                 GROUP BY TCTM.I_Center_ID
                                               ) BranchSlot ON BranchResource.I_Centre_Id = BranchSlot.I_Center_ID
                        ) TT
                        INNER JOIN ( SELECT TCBD.I_Centre_Id ,
                                            CAST(( ( CAST(COUNT(DISTINCT TSBD.I_Student_ID) AS DECIMAL)
                                                     / CAST(SUM(ISNULL(TCBD.Max_Strength,
                                                              1)) AS DECIMAL) )
                                                   * 100 ) AS DECIMAL) AS BatchOccupancy
                                     FROM   dbo.T_Student_Batch_Details TSBD
                                            INNER JOIN dbo.T_Student_Batch_Master TSBM ON TSBD.I_Batch_ID = TSBM.I_Batch_ID
                                            INNER JOIN dbo.T_Center_Batch_Details TCBD ON TSBM.I_Batch_ID = TCBD.I_Batch_ID
                                            INNER JOIN dbo.fnGetCentersForReports(@sHierarchyListID,
                                                              @iBrandID) FGCFR ON TCBD.I_Centre_Id = FGCFR.centerID
                                     WHERE  CONVERT(DATE, TSBM.Dt_Course_Expected_End_Date) >= CONVERT(DATE, @dtStartDate)
                                            AND TSBM.I_Status <> 0
                                            AND TSBD.I_Status = 1
                                     GROUP BY TCBD.I_Centre_Id
                                   ) BranchBatchOccupancy ON TT.BranchID = BranchBatchOccupancy.I_Centre_Id
                        INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TT.BranchID = TCHND.I_Center_ID
                           
                           
        INSERT  INTO #temp2
                ( CenterID ,
                  Duration ,
                  BranchResource ,
                  BranchSlot ,
                  BranchCapacity ,
                  BatchOccupancy ,
                  CenterName
                                     
                )
                SELECT  *
                FROM    #temp1 TT
                                     
                                     
        CREATE TABLE #temp
            (
              I_Student_Detail_ID INT ,
              S_Mobile_No VARCHAR(50) ,
              S_Student_ID VARCHAR(100) ,
              I_Roll_No INT ,
              S_Student_Name VARCHAR(200) ,
              S_Invoice_No VARCHAR(100) ,
              S_Receipt_No VARCHAR(100) ,
              Dt_Invoice_Date DATETIME ,
              S_Component_Name VARCHAR(100) ,
              S_Batch_Name VARCHAR(100) ,
              S_Course_Name VARCHAR(100) ,
              I_Center_ID INT ,
              S_Center_Name VARCHAR(100) ,
              S_Brand_Name VARCHAR(100) ,
              S_Cost_Center VARCHAR(100) ,
              Due_Value REAL ,
              Dt_Installment_Date DATETIME ,
              I_Installment_No INT ,
              I_Parent_Invoice_ID INT ,
              I_Invoice_Detail_ID INT ,
              Revised_Invoice_Date DATETIME ,
              Tax_Value DECIMAL(14, 2) ,
              Total_Value DECIMAL(14, 2) ,
              Amount_Paid DECIMAL(14, 2) ,
              Tax_Paid DECIMAL(14, 2) ,
              Total_Paid DECIMAL(14, 2) ,
              Total_Due DECIMAL(14, 2) ,
              sInstance VARCHAR(MAX)
            )

        INSERT  INTO #temp
                EXEC REPORT.uspGetDueReport_History @sHierarchyList = @sHierarchyListID, -- varchar(max)
                    @iBrandID = @iBrandID, -- int
                    @dtUptoDate = @dtEndDate, -- datetime
                    @sStatus = 'ALL' -- varchar(100)
                    
                    
        UPDATE  TT
        SET     TT.Due = TTT.Due
        FROM    #temp2 TT
                INNER JOIN ( SELECT T1.I_Center_ID ,
                                    ISNULL(SUM(T1.Total_Due), 0.0) AS Due
                             FROM   #temp T1
                             GROUP BY T1.I_Center_ID
                           ) TTT ON TT.CenterID = TTT.I_Center_ID
                           
                           
        UPDATE  TTT
        SET     TTT.DefaulterCount = T2.DefaulterCount
        FROM    #temp2 TTT
                INNER JOIN ( SELECT T1.I_Center_ID ,
                                    COUNT(DISTINCT T1.S_Student_ID) AS DefaulterCount
                             FROM   ( SELECT    TT.I_Center_ID ,
                                                TT.S_Student_ID ,
                                                SUM(TT.Total_Due) AS TotalDue
                                      FROM      #temp TT
                                      GROUP BY  TT.I_Center_ID ,
                                                TT.S_Student_ID
                                    ) T1
                             WHERE  T1.TotalDue > 10
                             GROUP BY T1.I_Center_ID
                           ) T2 ON TTT.CenterID = T2.I_Center_ID
                           
        DROP TABLE #temp
        
        CREATE TABLE #temp3
            (
              Student_ID VARCHAR(MAX) ,
              Student_Name VARCHAR(MAX) ,
              S_Invoice_No VARCHAR(MAX) ,
              Dt_Invoice_Date DATE ,
              Invoice_Amount DECIMAL(14, 2) ,
              Tax_Amount DECIMAL(14, 2) ,
              N_Discount_Amount DECIMAL(14, 2) ,
              Counselor_Name VARCHAR(MAX) ,
              CenterCode VARCHAR(MAX) ,
              CenterName VARCHAR(MAX) ,
              InstanceChain VARCHAR(MAX) ,
              S_Currency_Code VARCHAR(6) ,
              Receipt_No VARCHAR(MAX) ,
              Receipt_Date DATE ,
              I_Student_Detail_ID INT ,
              I_Enquiry_Regn_ID INT ,
              I_Invoice_Header_ID INT ,
              I_Receipt_Header_ID INT ,
              I_Status INT ,
              Receipt_Amount DECIMAL(14, 2) ,
              Receipt_Tax DECIMAL(14, 2) ,
              S_Receipt_Type_Desc VARCHAR(MAX) ,
              S_Form_No VARCHAR(MAX) ,
              Payment_Mode VARCHAR(MAX) ,
              S_Bank_Name VARCHAR(MAX) ,
              Instrument_No VARCHAR(MAX) ,
              Dt_ChequeDD_Date DATE ,
              Course_Fee DECIMAL(14, 2) ,
              Exam_Fee DECIMAL(14, 2) ,
              Others_Fee DECIMAL(14, 2) ,
              Tax_Component DECIMAL(14, 2) ,
              UudatedBy VARCHAR(MAX) ,
              Dt_Upd_On DATE ,
              S_Batch_Name VARCHAR(MAX) ,
              S_Course_Name VARCHAR(MAX) ,
              ConvenienceCharge DECIMAL(18, 2) ,
              ConvenienceChargeTax DECIMAL(18, 2)
            )
                
        INSERT  INTO #temp3
                EXEC REPORT.uspGetCollectionRegisterReport @sHierarchyList = @sHierarchyListID, -- varchar(max)
                    @iBrandID = @iBrandID, -- int
                    @dtStartDate = @dtStartDate, -- datetime
                    @dtEndDate = @dtEndDate, -- datetime
                    @sCounselorCond = 'ALL' -- varchar(20)                                                     
                                     
        
        UPDATE  TT
        SET     TT.BranchCollection = TTT.BranchCollection
        FROM    #temp2 TT
                INNER JOIN ( SELECT T1.CenterName ,
                                    ISNULL(SUM(T1.Receipt_Amount
                                               + T1.Receipt_Tax), 0.0) AS BranchCollection
                             FROM   #temp3 T1
                             GROUP BY T1.CenterName
                           ) TTT ON TT.CenterName = TTT.CenterName
                           
                           
        DROP TABLE #temp3 
        
        UPDATE  TT
        SET     TT.AdmissionCount = TTT.AdmissionCount
        FROM    #temp2 TT
                INNER JOIN ( SELECT TIP.I_Centre_Id ,
                                    COUNT(DISTINCT TSD.I_Student_Detail_ID) AS AdmissionCount
                             FROM   dbo.T_Student_Detail TSD
                                    INNER JOIN dbo.T_Invoice_Parent TIP ON TSD.I_Student_Detail_ID = TIP.I_Student_Detail_ID
                             WHERE  TSD.I_Status = 1
                                    AND ( TSD.Dt_Crtd_On >= @dtStartDate
                                          AND TSD.Dt_Crtd_On < DATEADD(dd, 1,
                                                              @dtEndDate)
                                        )
                                    AND TIP.I_Status IN ( 1, 3 )
                             GROUP BY TIP.I_Centre_Id
                           ) TTT ON TT.CenterID = TTT.I_Centre_Id
                           
                           
        UPDATE  TT
        SET     TT.EnquiryCount = TTT.EnquiryCount
        FROM    #temp2 TT
                INNER JOIN ( SELECT TERD.I_Centre_Id ,
                                    COUNT(DISTINCT TERD.I_Enquiry_Regn_ID) AS EnquiryCount
                             FROM   dbo.T_Enquiry_Regn_Detail TERD
                             WHERE  TERD.Dt_Crtd_On >= @dtStartDate
                                    AND TERD.Dt_Crtd_On < DATEADD(dd, 1,
                                                              @dtEndDate)
                             GROUP BY TERD.I_Centre_Id
                           ) TTT ON TT.CenterID = TTT.I_Centre_Id
                           
        UPDATE  TT
        SET     TT.DiscontinuedStudentCount = TTT.DiscontinuedStudentCount
        FROM    #temp2 TT
                INNER JOIN ( SELECT TDD.I_Center_Id ,
                                    ISNULL(COUNT(DISTINCT TDD.I_Student_Detail_ID),
                                           0) AS DiscontinuedStudentCount
                             FROM   ACADEMICS.T_Dropout_Details TDD
                             WHERE  --I_Dropout_Status<>0
                           --AND
                                    TDD.Dt_Crtd_On >= @dtStartDate
                                    AND TDD.Dt_Crtd_On < DATEADD(dd, 1,
                                                              @dtEndDate)
                             GROUP BY TDD.I_Center_Id
                           ) TTT ON TT.CenterID = TTT.I_Center_Id
                           
                           --SELECT * FROM dbo.T_Invoice_Parent TIP
                           
                           
        CREATE TABLE #temp4
            (
              StudentDetailID INT ,
              StudentID VARCHAR(MAX) ,
              BatchID INT ,
              BatchName VARCHAR(MAX) ,
              RollNo INT ,
              StudentName VARCHAR(MAX) ,
              SContactNo VARCHAR(MAX) ,
              GContactNo VARCHAR(MAX) ,
              CourseName VARCHAR(MAX) ,
              CenterID INT ,
              CenterName VARCHAR(MAX) ,
              StudyMaterialID INT ,
              StudyMaterialName VARCHAR(MAX) ,
              BatchStrength INT ,
              IsPresent INT ,
              ExamAttnCount INT ,
              ClassScheduled INT ,
              ClassAttended INT ,
              ClassAttnPercentage DECIMAL(18, 2)
            )
                           
                           
        DECLARE @date DATETIME
        SET @date = @dtStartDate  --mm/dd/yyyy
        WHILE ( DATEDIFF(dd, @date, @dtEndDate) >= 0 ) 
            BEGIN
                INSERT  INTO #temp4
                        EXEC REPORT.uspGetMonthlyExamAttendanceReport @dtPrevExamDate = @dtStartDate, -- date
                            @dtExamDate = @date, -- date
                            @sHierarchyList = @sHierarchyListID, -- varchar(max)
                            @sBatchIDs = NULL, -- varchar(max)
                            @iBrandID = @iBrandID -- int
        
	--SELECT @date
	--EXEC ERP.uspPrepareStudentFinancialData @date	
                SET @date = DATEADD(dd, 1, @date)
            END
            
            
        UPDATE  TT
        SET     TT.MonthlyExamAttendanceCount = TTT.MonthlyExamAttendanceCount
        FROM    #temp2 TT
                INNER JOIN ( SELECT CenterID ,
                                    COUNT(DISTINCT StudentDetailID) AS MonthlyExamAttendanceCount
                             FROM   #temp4 T
                             WHERE  IsPresent = 1
                             GROUP BY CenterID
                           ) TTT ON TT.CenterID = TTT.CenterID
            
        UPDATE  TT
        SET     TT.MonthlyExamAttendanceShouldBe = TTT.MonthlyExamAttendanceShouldBe
        FROM    #temp2 TT
                INNER JOIN ( SELECT CenterID ,
                                    COUNT(DISTINCT StudentDetailID) AS MonthlyExamAttendanceShouldBe
                             FROM   #temp4 T
            --WHERE IsPresent=1
                             GROUP BY CenterID
                           ) TTT ON TT.CenterID = TTT.CenterID
            
            
        UPDATE  #temp2
        SET     MonthlyExamAbsentCount = ISNULL(MonthlyExamAttendanceShouldBe,
                                                0)
                - ISNULL(MonthlyExamAttendanceCount, 0)
            
            
        DROP TABLE #temp4
            
            
        UPDATE  TT
        SET     TT.StudentOnRoll = TTT.StudentOnRoll
        FROM    #temp2 TT
                INNER JOIN ( SELECT T.CenterID AS I_CenterID ,
                                    COUNT(DISTINCT TSD.I_Student_Detail_ID) AS StudentOnRoll
                             FROM   dbo.T_Student_Detail TSD
                                    INNER JOIN dbo.T_Student_Batch_Details TSBD ON TSD.I_Student_Detail_ID = TSBD.I_Student_ID
                                    INNER JOIN dbo.T_Student_Batch_Master TSBM ON TSBD.I_Batch_ID = TSBM.I_Batch_ID
                                    INNER JOIN dbo.T_Center_Batch_Details TCBD ON TSBM.I_Batch_ID = TCBD.I_Batch_ID
                                    INNER JOIN #temp1 T ON TCBD.I_Centre_Id = T.CenterID
                             WHERE  TSBD.I_Status = 1
                                    --AND TSBM.Dt_Course_Expected_End_Date >= @dtEndDate
                                    AND TSD.I_Status <> 0
                             GROUP BY T.CenterID
                           ) TTT ON TT.CenterID = TTT.I_CenterID
            
        UPDATE  TT
        SET     TT.StudentOnLeave = TTT.StudentOnLeave
        FROM    #temp2 TT
                INNER JOIN ( SELECT T.CenterID AS I_CenterID ,
                                    COUNT(DISTINCT TSLR.I_Student_Detail_ID) AS StudentOnLeave
                             FROM   dbo.T_Student_Leave_Request TSLR
                                    INNER JOIN dbo.T_Student_Detail TSD ON TSLR.I_Student_Detail_ID = TSD.I_Student_Detail_ID
                                    INNER JOIN dbo.T_Student_Batch_Details TSBD ON TSLR.I_Student_Detail_ID = TSBD.I_Student_ID
                                    INNER JOIN dbo.T_Student_Batch_Master TSBM ON TSBD.I_Batch_ID = TSBM.I_Batch_ID
                                    INNER JOIN dbo.T_Center_Batch_Details TCBD ON TSBM.I_Batch_ID = TCBD.I_Batch_ID
                                    INNER JOIN #temp1 T ON TCBD.I_Centre_Id = T.CenterID
                             WHERE  TSBD.I_Status = 1
                                    --AND TSBM.Dt_Course_Expected_End_Date >= @dtEndDate
                                    AND TSD.I_Status <> 0
                                    AND ( ( TSLR.Dt_From_Date BETWEEN @dtStartDate
                                                              AND
                                                              @dtEndDate )
                                          OR ( TSLR.Dt_To_Date BETWEEN @dtStartDate
                                                              AND
                                                              @dtEndDate )
                                          OR ( TSLR.Dt_To_Date > @dtEndDate )
                                        )
                             GROUP BY T.CenterID
                           ) TTT ON TT.CenterID = TTT.I_CenterID
            
        CREATE TABLE #temp5
            (
              DestStud VARCHAR(MAX) ,
              DestStdName VARCHAR(MAX) ,
              SrcCenterID INT ,
              SrcCenterName VARCHAR(MAX) ,
              SrcBatch VARCHAR(MAX) ,
              DestCenterID INT ,
              DestCenter VARCHAR(MAX) ,
              DestBatch VARCHAR(MAX) ,
              DestCrtdOn DATE ,
              DestInvNo VARCHAR(MAX) ,
              DestCrtdBy VARCHAR(MAX) ,
              TransferType VARCHAR(MAX)
            )
            
        INSERT  INTO #temp5
                EXEC REPORT.uspGetReviseInvoiceAuditTrailReport @dtStartDate = @dtStartDate, -- date
                    @dtEndDate = @dtEndDate, -- date
                    @TransferType = 'BranchTransfer', -- varchar(max)
                    @iBrandID = @iBrandID, -- int
                    @SHierarchyList = @sHierarchyListID -- varchar(max)
                    
                    
        UPDATE  TT
        SET     TT.TransferOutCount = TTT.TransferOutCount
        FROM    #temp2 TT
                INNER JOIN ( SELECT T.SrcCenterID AS I_CenterID ,
                                    COUNT(DISTINCT T.DestStdName) AS TransferOutCount
                             FROM   #temp5 T
                                    INNER JOIN #temp1 T1 ON T.SrcCenterID = T1.CenterID
                             GROUP BY T.SrcCenterID
                           ) TTT ON TT.CenterID = TTT.I_CenterID
                    
                    
        
        DROP TABLE #temp5
        
        UPDATE  TT
        SET     TT.DropOutCount = TTT.DropOutCount
        FROM    #temp2 TT
                INNER JOIN ( SELECT T3.I_CenterID ,
                                    ISNULL(T3.AttendanceShouldBe, 0)
                                    - ISNULL(T4.AttendanceIs, 0) AS DropOutCount
                             FROM   ( SELECT    T2.I_CenterID ,
                                                COUNT(DISTINCT TSBD.I_Student_ID) AS AttendanceShouldBe
                                      FROM      ( SELECT    T1.I_Center_ID AS I_CenterID ,
                                                            T1.I_Batch_ID AS I_BatchID ,
                                                            T1.I_TimeTable_ID AS I_TimetableID
                                                  FROM      ( SELECT
                                                              TTTM.I_Center_ID ,
                                                              TTTM.I_Batch_ID ,
                                                              Dt_Schedule_Date ,
                                                              I_TimeTable_ID ,
                                                              DENSE_RANK() OVER ( PARTITION BY I_Batch_ID ORDER BY TTTM.Dt_Schedule_Date DESC ) AS RankID
                                                              FROM
                                                              dbo.T_TimeTable_Master TTTM
                                                              WHERE
                                                              TTTM.I_Center_ID IN (
                                                              SELECT
                                                              T.CenterID
                                                              FROM
                                                              #temp1 T )
                                                              AND TTTM.I_Status = 1
                                                              AND TTTM.I_Batch_ID IS NOT NULL
                                                              AND TTTM.Dt_Schedule_Date BETWEEN @dtStartDate
                                                              AND
                                                              @dtEndDate
                                                            ) T1
                                                  WHERE     RankID <= 4
                                                ) T2
                                                INNER JOIN dbo.T_Student_Batch_Details TSBD ON T2.I_BatchID = TSBD.I_Batch_ID
                                      WHERE     TSBD.I_Status = 1
                                      GROUP BY  T2.I_CenterID
                                    ) T3
                                    LEFT JOIN ( SELECT  T2.I_CenterID ,
                                                        COUNT(DISTINCT TSA.I_Student_Detail_ID) AS AttendanceIs
                                                FROM    ( SELECT
                                                              T1.I_Center_ID AS I_CenterID ,
                                                              T1.I_Batch_ID AS I_BatchID ,
                                                              T1.I_TimeTable_ID AS I_TimetableID
                                                          FROM
                                                              ( SELECT
                                                              TTTM.I_Center_ID ,
                                                              TTTM.I_Batch_ID ,
                                                              Dt_Schedule_Date ,
                                                              I_TimeTable_ID ,
                                                              DENSE_RANK() OVER ( PARTITION BY I_Batch_ID ORDER BY TTTM.Dt_Schedule_Date DESC ) AS RankID
                                                              FROM
                                                              dbo.T_TimeTable_Master TTTM
                                                              WHERE
                                                              TTTM.I_Center_ID IN (
                                                              SELECT
                                                              T.CenterID
                                                              FROM
                                                              #temp1 T )
                                                              AND TTTM.I_Status = 1
                                                              AND TTTM.I_Batch_ID IS NOT NULL
                                                              AND TTTM.Dt_Schedule_Date BETWEEN @dtStartDate
                                                              AND
                                                              @dtEndDate
                                                              ) T1
                                                          WHERE
                                                              RankID <= 4
                                                        ) T2
                                                        INNER JOIN dbo.T_Student_Attendance TSA ON T2.I_TimetableID = TSA.I_Attendance_Detail_ID
                                                GROUP BY T2.I_CenterID
                                              ) T4 ON T3.I_CenterID = T4.I_CenterID
                           ) TTT ON TT.CenterID = TTT.I_CenterID
                           
                           
        UPDATE  TT
        SET     TT.CompletedCount = TTT.CompletedCount
        FROM    #temp2 TT
                INNER JOIN ( SELECT TCBD.I_Centre_Id AS I_CenterID ,
                                    COUNT(DISTINCT TSD.I_Student_Detail_ID) AS CompletedCount
                             FROM   dbo.T_Student_Detail TSD
                                    INNER JOIN dbo.T_Student_Batch_Details TSBD ON TSD.I_Student_Detail_ID = TSBD.I_Student_ID
                                    INNER JOIN dbo.T_Student_Batch_Master TSBM ON TSBD.I_Batch_ID = TSBM.I_Batch_ID
                                    INNER JOIN dbo.T_Center_Batch_Details TCBD ON TSBM.I_Batch_ID = TCBD.I_Batch_ID
                                    INNER JOIN #temp1 T ON TCBD.I_Centre_Id = T.CenterID
                             WHERE  TSBD.I_Status = 1
                                    --AND TSBM.Dt_Course_Expected_End_Date >= @dtEndDate
                                    AND TSD.I_Status <> 0
                                    AND DATEDIFF(YEAR, TSD.Dt_Crtd_On,
                                                 @dtEndDate) >= 4
                             GROUP BY TCBD.I_Centre_Id
                           ) TTT ON TT.CenterID = TTT.I_CenterID
                             
        UPDATE  #temp2
        SET     ActiveStudentCount = ISNULL(StudentOnRoll, 0)
                - ( ISNULL(StudentOnLeave, 0) + ISNULL(DefaulterCount, 0)
                    + ISNULL(DropOutCount, 0) ) ,
                LeakagePercentage = ( ( ( CAST(ISNULL(StudentOnLeave, 0) AS REAL)
                                          + CAST(ISNULL(DefaulterCount, 0) AS REAL)
                                          + CAST(ISNULL(DropOutCount, 0) AS REAL) )
                                        / CAST(ISNULL(StudentOnRoll, 0) AS REAL) )
                                      * 100 )
                    
        UPDATE  TT
        SET     TT.NoOfBatchesRunning = TTT.NoOfBatchesRunning
        FROM    #temp2 TT
                INNER JOIN ( SELECT TCBD.I_Centre_Id ,
                                    COUNT(DISTINCT TSBM.I_Batch_ID) AS NoOfBatchesRunning
                             FROM   dbo.T_Student_Batch_Master TSBM
                                    INNER JOIN dbo.T_Center_Batch_Details TCBD ON TSBM.I_Batch_ID = TCBD.I_Batch_ID
                                    INNER JOIN #temp1 T1 ON TCBD.I_Centre_Id = T1.CenterID
                             WHERE  TSBM.Dt_Course_Expected_End_Date >= @dtEndDate
                                    AND TSBM.Dt_BatchStartDate <= @dtEndDate
                             GROUP BY TCBD.I_Centre_Id
                           ) TTT ON TT.CenterID = TTT.I_Centre_Id
                           
                           
                           
        UPDATE  TT
        SET     TT.CenterSlippage = TTT.CenterSlippage
        FROM    #temp2 TT
                INNER JOIN ( SELECT T1.I_Center_ID ,
                                    ( CAST(ISNULL(T1.SessionsPlanned, 0) AS REAL)
                                      - CAST(ISNULL(T2.SessionsConducted, 0) AS REAL) )
                                    / CAST(ISNULL(T1.SessionsPlanned, 0) AS REAL) AS CenterSlippage
                             FROM   ( SELECT    TTTM.I_Center_ID ,
                                                COUNT(TTTM.I_TimeTable_ID) AS SessionsPlanned
                                      FROM      dbo.T_TimeTable_Master TTTM
                                      WHERE     TTTM.I_Status = 1
                                                AND TTTM.I_Session_ID IS NOT NULL
                                                AND TTTM.I_Batch_ID IS NOT NULL
                                      GROUP BY  TTTM.I_Center_ID
                                    ) T1
                                    LEFT JOIN ( SELECT  TTTM.I_Center_ID ,
                                                        COUNT(TTTM.I_TimeTable_ID) AS SessionsConducted
                                                FROM    dbo.T_TimeTable_Master TTTM
                                                WHERE   TTTM.I_Status = 1
                                                        AND TTTM.I_Session_ID IS NOT NULL
                                                        AND TTTM.I_Batch_ID IS NOT NULL
                                                        AND I_Is_Complete = 1
                                                GROUP BY TTTM.I_Center_ID
                                              ) T2 ON T1.I_Center_ID = T2.I_Center_ID
                           ) TTT ON TT.CenterID = TTT.I_Center_ID 
                           
                           
                           UPDATE TT
                           SET
                           TT.BatchwithSlippage=TTT.BatchwithSlippage
                           FROM
                           #temp2 TT
                           INNER JOIN
                           (
                           SELECT T3.I_Center_ID,COUNT(DISTINCT T3.I_Batch_ID) AS BatchwithSlippage FROM
                           (
                           SELECT T1.I_Center_ID ,T1.I_Batch_ID,
                                    ( CAST(ISNULL(T1.SessionsPlanned, 0) AS REAL)
                                      - CAST(ISNULL(T2.SessionsConducted, 0) AS REAL) )
                                    / CAST(ISNULL(T1.SessionsPlanned, 0) AS REAL) AS CenterSlippage
                             FROM   ( SELECT    TTTM.I_Center_ID ,TTTM.I_Batch_ID,
                                                COUNT(TTTM.I_TimeTable_ID) AS SessionsPlanned
                                      FROM      dbo.T_TimeTable_Master TTTM
                                      WHERE     TTTM.I_Status = 1
                                                AND TTTM.I_Session_ID IS NOT NULL
                                                AND TTTM.I_Batch_ID IS NOT NULL
                                      GROUP BY  TTTM.I_Center_ID,TTTM.I_Batch_ID
                                    ) T1
                                    LEFT JOIN ( SELECT  TTTM.I_Center_ID ,TTTM.I_Batch_ID,
                                                        COUNT(TTTM.I_TimeTable_ID) AS SessionsConducted
                                                FROM    dbo.T_TimeTable_Master TTTM
                                                WHERE   TTTM.I_Status = 1
                                                        AND TTTM.I_Session_ID IS NOT NULL
                                                        AND TTTM.I_Batch_ID IS NOT NULL
                                                        AND I_Is_Complete = 1
                                                GROUP BY TTTM.I_Center_ID,TTTM.I_Batch_ID
                                              ) T2 ON T1.I_Center_ID = T2.I_Center_ID
                           
                           ) T3
                           WHERE T3.CenterSlippage>0
                           GROUP BY T3.I_Center_ID
                           ) TTT ON TT.CenterID=TTT.I_Center_ID
        
                                                        
        SELECT  *
        FROM    #temp2 TT ;
	
    END
