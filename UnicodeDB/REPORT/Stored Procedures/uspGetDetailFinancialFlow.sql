CREATE PROCEDURE [REPORT].[uspGetDetailFinancialFlow]
    (
      @iBrandID INT ,
      @sHierarchyListID VARCHAR(MAX) ,
      @dtStartDate DATE ,
      @dtEndDate DATE
    )
AS 
    BEGIN
	
        DECLARE @lDate DATE= DATEADD(d, -1, @dtStartDate)

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
                    @dtUptoDate = @lDate, -- datetime
                    @sStatus = 'ALL'
    
        CREATE TABLE #temp1
            (
              CenterID INT ,
              CenterName VARCHAR(MAX) ,
              CourseID INT ,
              CourseName VARCHAR(MAX) ,
              StudentDetailID INT ,
              StudentID VARCHAR(MAX) ,
              StudentName VARCHAR(MAX) ,
              TotalAccrual DECIMAL(14, 2)
            )
            
        CREATE TABLE #temp3
            (
              CenterID INT ,
              CenterName VARCHAR(MAX) ,
              CourseID INT ,
              CourseName VARCHAR(MAX) ,
              StudentDetailID INT ,
              StudentID VARCHAR(MAX) ,
              StudentName VARCHAR(MAX) ,
              ColAgnstPrevDue DECIMAL(14, 2)
            )


        INSERT  INTO #temp1
                ( CenterID ,
                  CenterName ,
                  CourseID ,
                  CourseName ,
                  StudentDetailID ,
                  StudentID ,
                  StudentName ,
                  TotalAccrual
                )
                SELECT  TCHND.I_Center_ID ,
                        TCHND.S_Center_Name ,
                        TCM.I_Course_ID ,
                        TCM.S_Course_Name ,
                        TSD.I_Student_Detail_ID ,
                        TSD.S_Student_ID ,
                        TSD.S_First_Name + ' ' + ISNULL(TSD.S_Middle_Name, '')
                        + ' ' + TSD.S_Last_Name AS StudentName ,
                        SUM(TICD.N_Amount_Due) AS AccrualAmount
                FROM    dbo.T_Invoice_Parent TIP
                        INNER JOIN dbo.T_Invoice_Child_Header TICH ON TIP.I_Invoice_Header_ID = TICH.I_Invoice_Header_ID
                        INNER JOIN dbo.T_Invoice_Child_Detail TICD ON TICH.I_Invoice_Child_Header_ID = TICD.I_Invoice_Child_Header_ID
                        --INNER JOIN dbo.T_Invoice_Detail_Tax TIDT ON TICD.I_Invoice_Detail_ID = TIDT.I_Invoice_Detail_ID
                        INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TIP.I_Centre_Id = TCHND.I_Center_ID
                        INNER JOIN dbo.T_Course_Master TCM ON TICH.I_Course_ID = TCM.I_Course_ID
                        INNER JOIN dbo.T_Student_Detail TSD ON TIP.I_Student_Detail_ID = TSD.I_Student_Detail_ID
                WHERE   TIP.I_Status IN ( 1, 3 )
                        AND TCHND.I_Center_ID IN (
                        SELECT  FGCFR.centerID
                        FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
                                                           @iBrandID) FGCFR )
                        AND TICD.Dt_Installment_Date BETWEEN @dtStartDate
                                                     AND     @dtEndDate
                GROUP BY TCHND.I_Center_ID ,
                        TCHND.S_Center_Name ,
                        TCM.I_Course_ID ,
                        TCM.S_Course_Name ,
                        TSD.I_Student_Detail_ID ,
                        TSD.S_Student_ID ,
                        TSD.S_First_Name + ' ' + ISNULL(TSD.S_Middle_Name, '')
                        + ' ' + TSD.S_Last_Name
                ORDER BY TCHND.I_Center_ID ,
                        TCHND.S_Center_Name ,
                        TCM.I_Course_ID ,
                        TCM.S_Course_Name ,
                        TSD.I_Student_Detail_ID ,
                        TSD.S_Student_ID ,
                        TSD.S_First_Name + ' ' + ISNULL(TSD.S_Middle_Name, '')
                        + ' ' + TSD.S_Last_Name

        CREATE TABLE #temp2
            (
              CenterID INT ,
              CenterName VARCHAR(MAX) ,
              CourseID INT ,
              CourseName VARCHAR(MAX) ,
              StudentDetailID INT ,
              StudentID VARCHAR(MAX) ,
              StudentName VARCHAR(MAX) ,
              ClosingDue DECIMAL(14, 2) ,
              TotalAccrual DECIMAL(14, 2) ,
              TotalCollectable DECIMAL(14, 2) ,
              CollectionAgainstClosingDue DECIMAL(14, 2) ,
              CollectionAgainstAccrualinCurrMonth DECIMAL(14, 2) ,
              ReceivedinAdvanceinCurrMonth DECIMAL(14, 2) ,
              TotalCollectioninCurrMonth DECIMAL(14, 2) ,
              CarriedForwardDueFromPrevMonth DECIMAL(14, 2) ,
              ReceivedinAdvinEarlierMonths DECIMAL(14, 2) ,
              PendingDueForCurrMonth DECIMAL(14, 2) ,
              CumulativeDue DECIMAL(14, 2)
            )


        INSERT  INTO #temp2
                ( CenterID ,
                  CenterName ,
                  StudentID ,
                  StudentName
                )
                SELECT DISTINCT
                        T3.I_Center_ID ,
                        T3.S_Center_Name ,
                        T3.S_Student_ID ,
                        T3.S_Student_Name
                FROM    ( SELECT DISTINCT
                                    I_Center_ID ,
                                    S_Center_Name ,
                                    S_Student_ID ,
                                    S_Student_Name
                          FROM      #temp T1
                          UNION ALL
                          SELECT DISTINCT
                                    T2.CenterID AS I_Center_ID ,
                                    T2.CenterName AS S_Center_Name ,
                                    T2.StudentID AS S_Student_ID ,
                                    T2.StudentName AS S_Student_Name
                          FROM      #temp1 T2
                        ) T3 

        UPDATE  T1
        SET     T1.ClosingDue = T2.Total_Due
        FROM    #temp2 T1
                INNER JOIN ( SELECT TT.S_Student_ID ,
                                    SUM(Due_Value)-SUM(ISNULL(Amount_Paid,0)) AS Total_Due
                             FROM   #temp TT
                             GROUP BY TT.S_Student_ID
                           ) T2 ON T1.StudentID = T2.S_Student_ID


        UPDATE  T1
        SET     T1.TotalAccrual = T2.TotalAccrual
        FROM    #temp2 T1
                INNER JOIN ( SELECT TT.StudentID ,
                                    SUM(TotalAccrual) AS TotalAccrual
                             FROM   #temp1 TT
                             GROUP BY TT.StudentID
                           ) T2 ON T1.StudentID = T2.StudentID

        UPDATE  #temp2
        SET     TotalCollectable = ISNULL(ClosingDue, 0.0)
                + ISNULL(TotalAccrual, 0.0)
                
                
--        INSERT  INTO #temp3
--                ( CenterID ,
--                  CenterName ,
--                  CourseID ,
--                  CourseName ,
--                  StudentDetailID ,
--                  StudentID ,
--                  StudentName ,
--                  ColAgnstPrevDue
--                )
--                SELECT  TCHND.I_Center_ID ,
--                        TCHND.S_Center_Name ,
--                        TCM.I_Course_ID ,
--                        TCM.S_Course_Name ,
--                        TSD.I_Student_Detail_ID ,
--                        TSD.S_Student_ID ,
--                        TSD.S_First_Name + ' ' + ISNULL(TSD.S_Middle_Name, '')
--                        + ' ' + TSD.S_Last_Name AS StudentName ,
--                        SUM(TRCD.N_Amount_Paid) AS AmtCollectedAgnstDueUptoPrevMonth
--                FROM    dbo.T_Receipt_Header TRH
--                        INNER JOIN dbo.T_Receipt_Component_Detail TRCD ON TRH.I_Receipt_Header_ID = TRCD.I_Receipt_Detail_ID
--                        INNER JOIN dbo.T_Invoice_Child_Detail TICD ON TRCD.I_Invoice_Detail_ID = TICD.I_Invoice_Detail_ID
--                        INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TRH.I_Centre_Id = TCHND.I_Center_ID
--                        INNER JOIN dbo.T_Student_Detail TSD ON TRH.I_Student_Detail_ID = TSD.I_Student_Detail_ID
--                        INNER JOIN dbo.T_Student_Batch_Details TSBD ON TSD.I_Student_Detail_ID = TSBD.I_Student_ID
--                                                              AND TRH.I_Student_Detail_ID = TSBD.I_Student_ID
--                        INNER JOIN dbo.T_Student_Batch_Master TSBM ON TSBD.I_Batch_ID = TSBM.I_Batch_ID
--                        INNER JOIN T_Course_Master TCM ON TSBM.I_Course_ID = TCM.I_Course_ID
--                WHERE   TRH.I_Status = 1
--                        AND TRH.I_Invoice_Header_ID IS NOT NULL
--                        AND TSBD.I_Status = 1
--                        AND TCHND.I_Center_ID IN (
--                        SELECT  FGCFR.centerID
--                        FROM    dbo.fnGetCentersForReports(@sHierarchyListID,
--                                                           @iBrandID) FGCFR )
--                        AND TRH.Dt_Crtd_On BETWEEN @dtStartDate
--                                           AND     DATEADD(d, 1, @dtEndDate)
--                        AND TICD.Dt_Installment_Date < @dtStartDate
--                GROUP BY TCHND.I_Center_ID ,
--                        TCHND.S_Center_Name ,
--                        TCM.I_Course_ID ,
--                        TCM.S_Course_Name ,
--                        TSD.I_Student_Detail_ID ,
--                        TSD.S_Student_ID ,
--                        TSD.S_First_Name + ' ' + ISNULL(TSD.S_Middle_Name, '')
--                        + ' ' + TSD.S_Last_Name
--                ORDER BY TCHND.I_Center_ID ,
--                        TCHND.S_Center_Name ,
--                        TCM.I_Course_ID ,
--                        TCM.S_Course_Name ,
--                        TSD.I_Student_Detail_ID ,
--                        TSD.S_Student_ID ,
--                        TSD.S_First_Name + ' ' + ISNULL(TSD.S_Middle_Name, '')
--                        + ' ' + TSD.S_Last_Name         

--UPDATE T1
--SET
--T1.CollectionAgainstClosingDue=T2.ColAgnstPrevDue
--FROM
--#temp2 T1
--INNER JOIN
--(
--SELECT TT.StudentID,TT.ColAgnstPrevDue FROM #temp3 TT
--) T2 ON T1.StudentID=T2.StudentID
        
   
    
--SELECT * FROM #temp T1    
--SELECT * FROM #temp1 T2
        SELECT  *
        FROM    #temp2 T3
	
    END
