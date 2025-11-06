CREATE PROCEDURE [REPORT].[uspGetDetailFinancialFlowTemp]        
(
@iBrandID INT,
@sHierarchyListID VARCHAR(MAX),
@dtStartDate DATE,
@dtEndDate DATE
)

AS
BEGIN


CREATE TABLE #temp
(
CenterID INT,
CenterName VARCHAR(MAX),
CourseID INT,
CourseName VARCHAR(MAX),
StudentDetailID INT,
StudentID VARCHAR(MAX),
StudentName VARCHAR(MAX),
ClosingDue DECIMAL(14,2),
TotalAccrual DECIMAL(14,2),
TotalCollectable DECIMAL(14,2),
CollectionAgainstClosingDue DECIMAL(14,2),
CollectionAgainstAccrualinCurrMonth DECIMAL(14,2),
ReceivedinAdvanceinCurrMonth DECIMAL(14,2),
TotalCollectioninCurrMonth DECIMAL(14,2),
CarriedForwardDueFromPrevMonth DECIMAL(14,2),
ReceivedinAdvinEarlierMonths DECIMAL(14,2),
PendingDueForCurrMonth DECIMAL(14,2),
CumulativeDue DECIMAL(14,2)
)

CREATE TABLE #temp1
(
CenterID INT,
CenterName VARCHAR(MAX),
CourseID INT,
CourseName VARCHAR(MAX),
StudentDetailID INT,
StudentID VARCHAR(MAX),
StudentName VARCHAR(MAX),
TotalAccrual DECIMAL(14,2)
)

        
        
        CREATE TABLE #temp2
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
EXEC REPORT.uspGetDueReport_History @sHierarchyList = '54', -- varchar(max)
    @iBrandID = 109, -- int
    @dtUptoDate = '2016-05-31', -- datetime
    @sStatus = 'ALL'
  --varchar(100)
  
  
    
--------Accrual for Given Month------

INSERT INTO #temp1
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
        TSD.S_First_Name + ' ' + ISNULL(TSD.S_Middle_Name, '') + ' '
        + TSD.S_Last_Name AS StudentName ,
        SUM(TICD.N_Amount_Due) AS AccrualAmount
FROM    dbo.T_Invoice_Parent TIP
        INNER JOIN dbo.T_Invoice_Child_Header TICH ON TIP.I_Invoice_Header_ID = TICH.I_Invoice_Header_ID
        INNER JOIN dbo.T_Invoice_Child_Detail TICD ON TICH.I_Invoice_Child_Header_ID = TICD.I_Invoice_Child_Header_ID
        INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TIP.I_Centre_Id = TCHND.I_Center_ID
        INNER JOIN dbo.T_Course_Master TCM ON TICH.I_Course_ID = TCM.I_Course_ID
        INNER JOIN dbo.T_Student_Detail TSD ON TIP.I_Student_Detail_ID = TSD.I_Student_Detail_ID
WHERE   TIP.I_Status IN ( 1, 3 )
        AND TCHND.I_Brand_ID = 109
        AND TICD.Dt_Installment_Date BETWEEN '2016-06-01'
                                     AND     '2016-06-30'
GROUP BY TCHND.I_Center_ID ,
        TCHND.S_Center_Name ,
        TCM.I_Course_ID ,
        TCM.S_Course_Name ,
        TSD.I_Student_Detail_ID ,
        TSD.S_Student_ID ,
        TSD.S_First_Name + ' ' + ISNULL(TSD.S_Middle_Name, '') + ' '
        + TSD.S_Last_Name
ORDER BY TCHND.I_Center_ID ,
        TCHND.S_Center_Name ,
        TCM.I_Course_ID ,
        TCM.S_Course_Name ,
        TSD.I_Student_Detail_ID ,
        TSD.S_Student_ID ,
        TSD.S_First_Name + ' ' + ISNULL(TSD.S_Middle_Name, '') + ' '
        + TSD.S_Last_Name
        
INSERT INTO #temp
        ( CenterID ,
          CenterName  ,
          StudentID ,
          StudentName
          )
          SELECT DISTINCT T3.I_Center_ID,T3.S_Center_Name,T3.S_Student_ID,T3.S_Student_Name FROM
          (
          SELECT DISTINCT I_Center_ID,S_Center_Name,S_Student_ID,S_Student_Name FROM #temp2 T1
          UNION ALL
          SELECT DISTINCT T2.CenterID AS I_Center_ID,T2.CenterName AS S_Center_Name,T2.StudentID AS S_Student_ID,T2.StudentName AS S_Student_Name FROM #temp1 T2
          ) T3 
        
        

-----Collection against Prev Month Closing Due------

SELECT TCHND.I_Center_ID ,
        TCHND.S_Center_Name ,
        TCM.I_Course_ID ,
        TCM.S_Course_Name ,
        TSD.I_Student_Detail_ID ,
        TSD.S_Student_ID ,
        TSD.S_First_Name + ' ' + ISNULL(TSD.S_Middle_Name, '') + ' '
        + TSD.S_Last_Name AS StudentName ,
        SUM(TRCD.N_Amount_Paid) AS AmtCollectedAgnstDueUptoPrevMonth FROM dbo.T_Receipt_Header TRH
INNER JOIN dbo.T_Receipt_Component_Detail TRCD ON TRH.I_Receipt_Header_ID = TRCD.I_Receipt_Detail_ID
INNER JOIN dbo.T_Invoice_Child_Detail TICD ON TRCD.I_Invoice_Detail_ID = TICD.I_Invoice_Detail_ID
INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TRH.I_Centre_Id=TCHND.I_Center_ID
INNER JOIN dbo.T_Student_Detail TSD ON TRH.I_Student_Detail_ID=TSD.I_Student_Detail_ID
INNER JOIN dbo.T_Student_Batch_Details TSBD ON TSD.I_Student_Detail_ID=TSBD.I_Student_ID AND TRH.I_Student_Detail_ID=TSBD.I_Student_ID
INNER JOIN dbo.T_Student_Batch_Master TSBM ON TSBD.I_Batch_ID = TSBM.I_Batch_ID
INNER JOIN T_Course_Master TCM ON TSBM.I_Course_ID = TCM.I_Course_ID
WHERE
TRH.I_Status=1 AND TRH.I_Invoice_Header_ID IS NOT NULL AND TSBD.I_Status=1 AND TCHND.I_Brand_ID=109
AND TRH.Dt_Crtd_On BETWEEN '2016-06-01' AND DATEADD(d,1,'2016-06-30')
AND TICD.Dt_Installment_Date<'2016-06-01'
GROUP BY TCHND.I_Center_ID ,
        TCHND.S_Center_Name ,
        TCM.I_Course_ID ,
        TCM.S_Course_Name ,
        TSD.I_Student_Detail_ID ,
        TSD.S_Student_ID ,
        TSD.S_First_Name + ' ' + ISNULL(TSD.S_Middle_Name, '') + ' '
        + TSD.S_Last_Name
ORDER BY TCHND.I_Center_ID ,
        TCHND.S_Center_Name ,
        TCM.I_Course_ID ,
        TCM.S_Course_Name ,
        TSD.I_Student_Detail_ID ,
        TSD.S_Student_ID ,
        TSD.S_First_Name + ' ' + ISNULL(TSD.S_Middle_Name, '') + ' '
        + TSD.S_Last_Name
        
        
        
-----Collection against Given Month Due------

SELECT TCHND.I_Center_ID ,
        TCHND.S_Center_Name ,
        TCM.I_Course_ID ,
        TCM.S_Course_Name ,
        TSD.I_Student_Detail_ID ,
        TSD.S_Student_ID ,
        TSD.S_First_Name + ' ' + ISNULL(TSD.S_Middle_Name, '') + ' '
        + TSD.S_Last_Name AS StudentName ,
        SUM(TRCD.N_Amount_Paid) AS AmtCollectedAgnstGivenMonthDue FROM dbo.T_Receipt_Header TRH
INNER JOIN dbo.T_Receipt_Component_Detail TRCD ON TRH.I_Receipt_Header_ID = TRCD.I_Receipt_Detail_ID
INNER JOIN dbo.T_Invoice_Child_Detail TICD ON TRCD.I_Invoice_Detail_ID = TICD.I_Invoice_Detail_ID
INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TRH.I_Centre_Id=TCHND.I_Center_ID
INNER JOIN dbo.T_Student_Detail TSD ON TRH.I_Student_Detail_ID=TSD.I_Student_Detail_ID
INNER JOIN dbo.T_Student_Batch_Details TSBD ON TSD.I_Student_Detail_ID=TSBD.I_Student_ID AND TRH.I_Student_Detail_ID=TSBD.I_Student_ID
INNER JOIN dbo.T_Student_Batch_Master TSBM ON TSBD.I_Batch_ID = TSBM.I_Batch_ID
INNER JOIN T_Course_Master TCM ON TSBM.I_Course_ID = TCM.I_Course_ID
WHERE
TRH.I_Status=1 AND TRH.I_Invoice_Header_ID IS NOT NULL AND TSBD.I_Status=1 AND TCHND.I_Brand_ID=109
AND TRH.Dt_Crtd_On BETWEEN '2016-06-01' AND DATEADD(d,1,'2016-06-30')
AND TICD.Dt_Installment_Date BETWEEN '2016-06-01' AND '2016-06-30'
GROUP BY TCHND.I_Center_ID ,
        TCHND.S_Center_Name ,
        TCM.I_Course_ID ,
        TCM.S_Course_Name ,
        TSD.I_Student_Detail_ID ,
        TSD.S_Student_ID ,
        TSD.S_First_Name + ' ' + ISNULL(TSD.S_Middle_Name, '') + ' '
        + TSD.S_Last_Name
ORDER BY TCHND.I_Center_ID ,
        TCHND.S_Center_Name ,
        TCM.I_Course_ID ,
        TCM.S_Course_Name ,
        TSD.I_Student_Detail_ID ,
        TSD.S_Student_ID ,
        TSD.S_First_Name + ' ' + ISNULL(TSD.S_Middle_Name, '') + ' '
        + TSD.S_Last_Name        
        
        
        
-----Collection against Later Month Due------

SELECT TCHND.I_Center_ID ,
        TCHND.S_Center_Name ,
        TCM.I_Course_ID ,
        TCM.S_Course_Name ,
        TSD.I_Student_Detail_ID ,
        TSD.S_Student_ID ,
        TSD.S_First_Name + ' ' + ISNULL(TSD.S_Middle_Name, '') + ' '
        + TSD.S_Last_Name AS StudentName ,
        SUM(TRCD.N_Amount_Paid) AS AmtCollectedAgnstLaterMonthAccrual FROM dbo.T_Receipt_Header TRH
INNER JOIN dbo.T_Receipt_Component_Detail TRCD ON TRH.I_Receipt_Header_ID = TRCD.I_Receipt_Detail_ID
INNER JOIN dbo.T_Invoice_Child_Detail TICD ON TRCD.I_Invoice_Detail_ID = TICD.I_Invoice_Detail_ID
INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TRH.I_Centre_Id=TCHND.I_Center_ID
INNER JOIN dbo.T_Student_Detail TSD ON TRH.I_Student_Detail_ID=TSD.I_Student_Detail_ID
INNER JOIN dbo.T_Student_Batch_Details TSBD ON TSD.I_Student_Detail_ID=TSBD.I_Student_ID AND TRH.I_Student_Detail_ID=TSBD.I_Student_ID
INNER JOIN dbo.T_Student_Batch_Master TSBM ON TSBD.I_Batch_ID = TSBM.I_Batch_ID
INNER JOIN T_Course_Master TCM ON TSBM.I_Course_ID = TCM.I_Course_ID
WHERE
TRH.I_Status=1 AND TRH.I_Invoice_Header_ID IS NOT NULL AND TSBD.I_Status=1 AND TCHND.I_Brand_ID=109
AND TRH.Dt_Crtd_On BETWEEN '2016-06-01' AND DATEADD(d,1,'2016-06-30')
AND TICD.Dt_Installment_Date>'2016-06-30'
GROUP BY TCHND.I_Center_ID ,
        TCHND.S_Center_Name ,
        TCM.I_Course_ID ,
        TCM.S_Course_Name ,
        TSD.I_Student_Detail_ID ,
        TSD.S_Student_ID ,
        TSD.S_First_Name + ' ' + ISNULL(TSD.S_Middle_Name, '') + ' '
        + TSD.S_Last_Name
ORDER BY TCHND.I_Center_ID ,
        TCHND.S_Center_Name ,
        TCM.I_Course_ID ,
        TCM.S_Course_Name ,
        TSD.I_Student_Detail_ID ,
        TSD.S_Student_ID ,
        TSD.S_First_Name + ' ' + ISNULL(TSD.S_Middle_Name, '') + ' '
        + TSD.S_Last_Name
        
        
-----Collection against Given Month Due Paid in Advance------

SELECT TCHND.I_Center_ID ,
        TCHND.S_Center_Name ,
        TCM.I_Course_ID ,
        TCM.S_Course_Name ,
        TSD.I_Student_Detail_ID ,
        TSD.S_Student_ID ,
        TSD.S_First_Name + ' ' + ISNULL(TSD.S_Middle_Name, '') + ' '
        + TSD.S_Last_Name AS StudentName ,
        SUM(TRCD.N_Amount_Paid) AS AmtCollectedAgnstGivenMonthDuePaidinAdv FROM dbo.T_Receipt_Header TRH
INNER JOIN dbo.T_Receipt_Component_Detail TRCD ON TRH.I_Receipt_Header_ID = TRCD.I_Receipt_Detail_ID
INNER JOIN dbo.T_Invoice_Child_Detail TICD ON TRCD.I_Invoice_Detail_ID = TICD.I_Invoice_Detail_ID
INNER JOIN dbo.T_Center_Hierarchy_Name_Details TCHND ON TRH.I_Centre_Id=TCHND.I_Center_ID
INNER JOIN dbo.T_Student_Detail TSD ON TRH.I_Student_Detail_ID=TSD.I_Student_Detail_ID
INNER JOIN dbo.T_Student_Batch_Details TSBD ON TSD.I_Student_Detail_ID=TSBD.I_Student_ID AND TRH.I_Student_Detail_ID=TSBD.I_Student_ID
INNER JOIN dbo.T_Student_Batch_Master TSBM ON TSBD.I_Batch_ID = TSBM.I_Batch_ID
INNER JOIN T_Course_Master TCM ON TSBM.I_Course_ID = TCM.I_Course_ID
WHERE
TRH.I_Status=1 AND TRH.I_Invoice_Header_ID IS NOT NULL AND TSBD.I_Status=1 AND TCHND.I_Brand_ID=109
AND TRH.Dt_Crtd_On<'2016-06-01'
AND TICD.Dt_Installment_Date BETWEEN '2016-06-01' AND '2016-06-30'
GROUP BY TCHND.I_Center_ID ,
        TCHND.S_Center_Name ,
        TCM.I_Course_ID ,
        TCM.S_Course_Name ,
        TSD.I_Student_Detail_ID ,
        TSD.S_Student_ID ,
        TSD.S_First_Name + ' ' + ISNULL(TSD.S_Middle_Name, '') + ' '
        + TSD.S_Last_Name
ORDER BY TCHND.I_Center_ID ,
        TCHND.S_Center_Name ,
        TCM.I_Course_ID ,
        TCM.S_Course_Name ,
        TSD.I_Student_Detail_ID ,
        TSD.S_Student_ID ,
        TSD.S_First_Name + ' ' + ISNULL(TSD.S_Middle_Name, '') + ' '
        + TSD.S_Last_Name 
        
 END
