CREATE PROCEDURE [REPORT].[uspGetDashboardFinancialDataNew]
(
@iCentreID INT,
@dtStartDate DATE,
@dtEndDate DATE,
@iBrandID INT,
@sHierarchyListID VARCHAR(MAX)
)

AS
SET NOCOUNT ON;
IF 1 = 2
 BEGIN
  SELECT
   CAST(NULL AS INT) AS CenterID,
   CAST(NULL AS VARCHAR(MAX)) AS CenterName,
   CAST(NULL AS VARCHAR(MAX)) AS Category,
   CAST(NULL AS DECIMAL(14,2)) AS CategoryValue
 END
BEGIN

	DECLARE @dtDate DATE=GETDATE()
	
	CREATE TABLE #temp1
	(
	CenterID INT,
	CenterName VARCHAR(MAX),
	Category VARCHAR(MAX),
	CategoryValue DECIMAL(14,2)
	)
	
	
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
                EXEC REPORT.uspGetDueReport_History @sHierarchyList = '54', -- varchar(max)
                    @iBrandID = 109, -- int
                    @dtUptoDate = @dtDate, -- datetime
                    @sStatus = 'ALL' -- varchar(100)
                    
                    
                    INSERT INTO #temp1
                            ( CenterID ,
                              CenterName ,
                              Category ,
                              CategoryValue
                            )
                    SELECT TT.I_Center_ID,TT.S_Center_Name,'Due',SUM(TT.Total_Due) AS TotalDue FROM #temp TT
                    GROUP BY TT.I_Center_ID,TT.S_Center_Name
                    
                    
                    SELECT * FROM #temp1 TTT
                    WHERE
                    CenterID=@iCentreID
END
