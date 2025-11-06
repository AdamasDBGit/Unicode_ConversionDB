--USE [IndiaCanProd]          
--GO          
--/****** Object:  StoredProcedure [REPORT].[uspGetAccruedAmount]    Script Date: 09/01/2011 11:05:10 ******/          
--SET ANSI_NULLS ON          
--GO          
--SET QUOTED_IDENTIFIER ON          
--GO          
          
 -- =============================================          
-- Author:  <Author,,Name>          
-- Create date: <Create Date,,>          
-- Description: <Description,,>          
          
          
CREATE PROCEDURE [REPORT].[uspGetAccruedAmount]          
(          
 @sHierarchyList varchar(MAX),          
 @iBrandID int,          
 @dtStartDate datetime,          
 @dtEndDate datetime          
)          
AS          
 BEGIN          
           
  DECLARE @BATCH TABLE(ID INT IDENTITY(1,1),BATCHID INT,CENTERID INT)          
            
  INSERT INTO @BATCH          
  SELECT DISTINCT [TSBS].[I_Batch_ID],[TCBD].[I_Centre_ID]          
  FROM [dbo].[T_Student_Batch_Schedule] AS TSBS          
  LEFT OUTER join T_Center_Batch_Details TCBD        
  on TSBS.I_Batch_ID = TCBD.I_Batch_ID        
  LEFT OUTER JOIN dbo.T_Brand_Center_Details AS TBCD      
  ON TCBD.I_Centre_Id = TBCD.I_Centre_Id      
  INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID) FN1          
  ON TCBD.I_Centre_Id=FN1.CenterID           
  WHERE ((DATEDIFF(DD,ISNULL(@dtStartDate,[TSBS].[Dt_Schedule_Date]),[TSBS].[Dt_Schedule_Date]) >= 0           
  AND DATEDIFF(DD,ISNULL(@dtEndDate,[TSBS].[Dt_Schedule_Date]),[TSBS].[Dt_Schedule_Date])<= 0))          
  AND (TSBS.I_Centre_Id=FN1.CenterID OR TSBS.I_Centre_ID IS NULL)        
  AND TBCD.I_Brand_ID = @iBrandID      
  UNION 
  SELECT DISTINCT TCBD.I_Batch_ID,TCBD.I_Centre_Id 
  FROM dbo.T_Invoice_Parent AS TIP
  INNER JOIN dbo.T_Invoice_Child_Header AS TICH
  ON TIP.I_Invoice_Header_ID = TICH.I_Invoice_Header_ID
  INNER JOIN dbo.T_Invoice_Batch_Map AS TIBM
  ON TICH.I_Invoice_Child_Header_ID = TIBM.I_Invoice_Child_Header_ID
  INNER JOIN dbo.T_Center_Batch_Details AS TCBD
  ON TIBM.I_Batch_ID = TCBD.I_Batch_ID
  INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID) FN1          
  ON TCBD.I_Centre_Id=FN1.CenterID  
  WHERE TIP.Dt_Invoice_Date BETWEEN @dtStartDate AND @dtEndDate

           
  DECLARE @BatchSchedule TABLE          
  (          
   CenterID INT,          
   BatchID INT,          
   BatchCode VARCHAR(50),          
   BatchName VARCHAR(100),             
   CourseID INT,          
   CourseName VARCHAR(100),          
   FeePlanAmount NUMERIC(18,2),          
   PaymentType Char(1),          
   BatchStartDate DATETIME,          
   BatchEndDate DATETIME,          
   TotalSessionCount INT,          
   PlannedSessionCount INT,             
   ActualSessionCount INT,          
   AmountPerSession Numeric(18,2),          
   AccrualAmount Numeric(18,2)          
  )          
              
  INSERT INTO @BatchSchedule          
  (          
   [CenterID],          
   [BatchID],          
   [BatchCode],          
   [BatchName],          
   [CourseID],          
   [CourseName],          
   [BatchStartDate],          
   [BatchEndDate],          
   TotalSessionCount,          
   PlannedSessionCount,          
   ActualSessionCount          
  )            
  SELECT tcbd.I_Centre_Id,tcbd.I_Batch_ID,S_Batch_Code,S_Batch_Name,tcm.I_Course_ID,          
  S_Course_Name,tsbm.Dt_BatchStartDate,ISNULL(Dt_Course_Actual_End_Date,Dt_Course_Expected_End_Date),           
  (SELECT COUNT(*) TotSeasonCount FROM [dbo].[T_Student_Batch_Schedule] AS TSBS           
    WHERE TSBS.I_Batch_ID= b.BATCHID AND  (b.CENTERID = TSBS.I_Centre_ID OR TSBS.I_Centre_ID IS NULL)) as TotalSeasonCount,          
  [dbo].[fnGetTotalSessionCount](b.BATCHID,b.CENTERID,@dtStartDate,@dtEndDate) AS PlannedSessionCount,          
  (SELECT COUNT(*) FROM [dbo].[T_Student_Batch_Schedule] SC             
   WHERE SC.Dt_Actual_Date IS NOT NULL AND SC.I_Batch_ID= b.BATCHID           
   AND SC.I_Centre_ID = b.CENTERID AND DATEDIFF(dd,Dt_Schedule_Date,GETDATE()) <= 0) as ActualSeasonCount          
  FROM @BATCH b          
  INNER JOIN dbo.T_Center_Batch_Details AS tcbd          
  ON b.BATCHID = tcbd.I_Batch_ID          
  AND (tcbd.I_Centre_Id = b.CENTERID OR b.CENTERID IS NULL)
  INNER JOIN dbo.T_Student_Batch_Master AS tsbm          
  ON b.BATCHID = tsbm.I_Batch_ID          
  INNER JOIN dbo.T_Course_Master AS tcm          
  ON tsbm.I_Course_ID = tcm.I_Course_ID          
            
               
  SELECT tibm.I_Batch_ID,tip.I_Student_Detail_ID, tip.I_Centre_Id,          
  ISNULL(tSD.S_First_Name,'')+' '+ISNULL(tSD.S_Middle_Name,'')+' '+ISNULL(tSD.S_Last_Name,'') AS StudentName,          
  tsd.S_Student_ID,ticd.I_Invoice_Child_Header_ID,tip.S_Invoice_No,tip.Dt_Invoice_Date,tip.I_Status,          
  CASE WHEN tich.C_Is_LumpSum='Y' THEN tcfp.N_TotalLumpSum ELSE tcfp.N_TotalInstallment END as FeePlanAmount,          
  tich.C_Is_LumpSum,          
  ((CASE WHEN tich.C_Is_LumpSum='Y' THEN tcfp.N_TotalLumpSum ELSE tcfp.N_TotalInstallment END)- tich.N_Amount) as Discount,          
  tich.N_Amount as CourseAmount,          
  ISNULL(tich.N_Tax_Amount,0) as CourseTaxAmount,          
  TotalCollection AS TotalCollection,          
  ISNULL(TotalTax,0) AS TotalTax,
  ISNULL(PartialCollection,0) AS PartialCollection,
  ISNULL(PartialTax,0) AS PartialTax         
  INTO #BatchPayments          
  FROM dbo.T_Invoice_Parent AS tip          
  INNER JOIN T_Student_Detail tsd          
  on tip.I_Student_Detail_ID=tsd.I_Student_Detail_ID          
  INNER JOIN dbo.T_Invoice_Child_Header AS tich          
  ON tip.I_Invoice_Header_ID = tich.I_Invoice_Header_ID          
  INNER JOIN DBO.T_Invoice_Batch_Map tibm          
  ON tich.I_Invoice_Child_Header_ID = tibm.I_Invoice_Child_Header_ID          
  INNER JOIN dbo.T_Invoice_Child_Detail AS ticd          
  on tich.I_Invoice_Child_Header_ID = ticd.I_Invoice_Child_Header_ID          
  INNER JOIN dbo.T_Student_Batch_Master AS tsbm          
  ON tibm.I_Batch_ID = tsbm.I_Batch_ID          
  AND tich.I_Course_ID=tsbm.I_Course_ID          
  LEFT JOIN T_Receipt_Component_Detail C          
  ON ticd.I_Invoice_Detail_ID = C.I_Invoice_Detail_ID          
  LEFT JOIN dbo.T_Course_Fee_Plan AS tcfp          
  ON tcfp.I_Course_Fee_Plan_ID = tich.I_Course_FeePlan_ID          
  LEFT OUTER JOIN          
  (Select tip2.I_Student_Detail_ID,A.I_Invoice_Child_Header_ID,a.I_Course_ID,tibm.I_Batch_ID,SUM(C.N_Amount_Paid) TotalCollection          
   FROM dbo.T_Invoice_Parent AS tip2          
   INNER JOIN T_Invoice_Child_Header A           
   ON tip2.I_Invoice_Header_ID = A.I_Invoice_Header_ID          
   INNER JOIN DBO.T_Invoice_Batch_Map tibm          
   ON A.I_Invoice_Child_Header_ID = tibm.I_Invoice_Child_Header_ID          
   INNER JOIN T_Invoice_Child_Detail B          
   ON A.I_Invoice_Child_Header_ID = B.I_Invoice_Child_Header_ID          
   inner join T_Receipt_Component_Detail C          
   ON B.I_Invoice_Detail_ID = C.I_Invoice_Detail_ID          
   Group By tip2.I_Student_Detail_ID,A.I_Invoice_Child_Header_ID,a.I_Course_ID,tibm.I_Batch_ID          
  ) AS TotalCollection          
  On TotalCollection.I_Student_Detail_ID = tip.I_Student_Detail_ID          
  AND TotalCollection.I_Invoice_Child_Header_ID = tich.I_Invoice_Child_Header_ID          
  AND TotalCollection.I_Course_ID=tich.I_Course_ID          
  AND TotalCollection.I_Batch_ID=tibm.I_Batch_ID          
  LEFT OUTER JOIN          
  (Select tip2.I_Student_Detail_ID,A.I_Invoice_Child_Header_ID,a.I_Course_ID,tibm.I_Batch_ID,SUM(trtd.N_Tax_Paid) TotalTax          
   FROM dbo.T_Invoice_Parent AS tip2          
   INNER JOIN T_Invoice_Child_Header A           
   ON tip2.I_Invoice_Header_ID = A.I_Invoice_Header_ID          
   INNER JOIN DBO.T_Invoice_Batch_Map tibm          
   ON A.I_Invoice_Child_Header_ID = tibm.I_Invoice_Child_Header_ID          
   INNER JOIN T_Invoice_Child_Detail B          
   ON A.I_Invoice_Child_Header_ID = B.I_Invoice_Child_Header_ID          
   inner join dbo.T_Receipt_Tax_Detail AS trtd          
   ON B.I_Invoice_Detail_ID = trtd.I_Invoice_Detail_ID          
   Group By tip2.I_Student_Detail_ID,A.I_Invoice_Child_Header_ID,a.I_Course_ID,tibm.I_Batch_ID          
  ) AS TotalTax          
  On TotalTax.I_Student_Detail_ID = tip.I_Student_Detail_ID           
  AND TotalTax.I_Invoice_Child_Header_ID = tich.I_Invoice_Child_Header_ID          
  AND TotalTax.I_Course_ID=tich.I_Course_ID          
  AND TotalTax.I_Batch_ID=tibm.I_Batch_ID      
   LEFT OUTER JOIN          
  (Select tip2.I_Student_Detail_ID,A.I_Invoice_Child_Header_ID,a.I_Course_ID,tibm.I_Batch_ID,SUM(C.N_Amount_Paid) PartialCollection          
   FROM dbo.T_Invoice_Parent AS tip2          
   INNER JOIN T_Invoice_Child_Header A           
   ON tip2.I_Invoice_Header_ID = A.I_Invoice_Header_ID          
   INNER JOIN DBO.T_Invoice_Batch_Map tibm          
   ON A.I_Invoice_Child_Header_ID = tibm.I_Invoice_Child_Header_ID          
   INNER JOIN T_Invoice_Child_Detail B          
   ON A.I_Invoice_Child_Header_ID = B.I_Invoice_Child_Header_ID          
   inner join T_Receipt_Component_Detail C          
   ON B.I_Invoice_Detail_ID = C.I_Invoice_Detail_ID          
   INNER JOIN dbo.T_Receipt_Header AS TRH
   ON C.I_Receipt_Detail_ID = TRH.I_Receipt_Header_ID
   WHERE TRH.Dt_Receipt_Date BETWEEN @dtStartDate AND @dtEndDate
   Group By tip2.I_Student_Detail_ID,A.I_Invoice_Child_Header_ID,a.I_Course_ID,tibm.I_Batch_ID          
  ) AS PartialCollection          
  On PartialCollection.I_Student_Detail_ID = tip.I_Student_Detail_ID          
  AND PartialCollection.I_Invoice_Child_Header_ID = tich.I_Invoice_Child_Header_ID          
  AND PartialCollection.I_Course_ID=tich.I_Course_ID          
  AND PartialCollection.I_Batch_ID=tibm.I_Batch_ID          
  LEFT OUTER JOIN          
  (Select tip2.I_Student_Detail_ID,A.I_Invoice_Child_Header_ID,a.I_Course_ID,tibm.I_Batch_ID,SUM(trtd.N_Tax_Paid) PartialTax          
   FROM dbo.T_Invoice_Parent AS tip2          
   INNER JOIN T_Invoice_Child_Header A           
   ON tip2.I_Invoice_Header_ID = A.I_Invoice_Header_ID          
   INNER JOIN DBO.T_Invoice_Batch_Map tibm          
   ON A.I_Invoice_Child_Header_ID = tibm.I_Invoice_Child_Header_ID          
   INNER JOIN T_Invoice_Child_Detail B          
   ON A.I_Invoice_Child_Header_ID = B.I_Invoice_Child_Header_ID          
   inner join dbo.T_Receipt_Tax_Detail AS trtd          
   ON B.I_Invoice_Detail_ID = trtd.I_Invoice_Detail_ID  
   INNER JOIN dbo.T_Receipt_Component_Detail AS TRCD
   ON trtd.I_Receipt_Comp_Detail_ID = TRCD.I_Receipt_Comp_Detail_ID
   INNER JOIN dbo.T_Receipt_Header AS TRH
   ON TRCD.I_Receipt_Detail_ID = TRH.I_Receipt_Header_ID
   WHERE TRH.Dt_Receipt_Date BETWEEN @dtStartDate AND @dtEndDate
   Group By tip2.I_Student_Detail_ID,A.I_Invoice_Child_Header_ID,a.I_Course_ID,tibm.I_Batch_ID          
   ) AS PartialTax          
  On PartialTax.I_Student_Detail_ID = tip.I_Student_Detail_ID           
  AND PartialTax.I_Invoice_Child_Header_ID = tich.I_Invoice_Child_Header_ID          
  AND PartialTax.I_Course_ID=tich.I_Course_ID          
  AND PartialTax.I_Batch_ID=tibm.I_Batch_ID      
  WHERE tibm.I_Batch_ID IN (SELECT DISTINCT b.BatchID FROM @BATCH AS b)          
  AND tip.I_Centre_Id IN (SELECT DISTINCT b.CENTERID FROM @BATCH AS b)          
  
  
  SELECT DISTINCT          
  tchnd.S_Region_Name Region,          
  tchnd.S_Territiry_Name Territory,          
  tchnd.S_City_Name City,          
  tchnd.S_Center_Name Center,          
  bs.CenterID,          
  BS.BatchID,          
  bs.BatchCode,          
  bs.BatchName,          
  LTRIM(bp.StudentName) StudentName,          
  bp.S_Student_ID StudentID,          
  bp.I_Invoice_Child_Header_ID InvoiceChildHeaderID,          
  bp.S_Invoice_No InvoiceNO,          
  bp.Dt_Invoice_Date as InvoiceDate,          
  bp.I_Status InvoiceStatus,          
  bs.CourseID,          
  bs.CourseName,          
  bp.FeePlanAmount,          
  bp.C_Is_LumpSum PaymentType,          
  bp.Discount,          
  bp.CourseAmount,          
  bp.CourseTaxAmount TaxAmount,          
  bs.BatchStartDate,          
  bs.BatchEndDate,          
  bs.TotalSessionCount,          
  bs.PlannedSessionCount,          
  ISNULL(bp.TotalCollection,0.00) AmountCollectedTillDate,          
  bp.TotalTax TaxCollectedTillDate,   
  ISNULL(bp.PartialCollection,0.00) AmountCollectedWithinDateRange,
  ISNULL(bp.PartialTax,0.00) TaxCollectedWithinDateRange,       
  bs.ActualSessionCount,          
  Case When (CourseAmount IS Null OR CourseAmount=0) or (TotalSessionCount IS Null OR TotalSessionCount=0) then 0 else CourseAmount/TotalSessionCount end AmountPerSession,          
  Case When (CourseAmount IS Null OR CourseAmount=0) or (TotalSessionCount IS Null OR TotalSessionCount=0) then 0 ELSE ((CourseAmount/TotalSessionCount)*PlannedSessionCount)  end AccrualAmount          
  FROM #BatchPayments AS bp          
  INNER JOIN @BatchSchedule AS bs ON bs.BatchID = bp.I_Batch_ID          
  INNER JOIN T_Center_Hierarchy_Name_Details tchnd on bs.CenterID=tchnd.I_Center_ID          
  AND bs.CenterID = bp.I_Centre_Id           
  --ORDER BY LTRIM(bp.StudentName)          
  UNION  
  SELECT DISTINCT          
  tchnd.S_Region_Name Region,          
  tchnd.S_Territiry_Name Territory,          
  tchnd.S_City_Name City,          
  tchnd.S_Center_Name Center,          
  bs.CenterID,          
  BS.BatchID,          
  bs.BatchCode,          
  bs.BatchName,          
  LTRIM(bp.StudentName) StudentName,          
  bp.S_Student_ID StudentID,          
  bp.I_Invoice_Child_Header_ID InvoiceChildHeaderID,          
  bp.S_Invoice_No InvoiceNO,          
  bp.Dt_Invoice_Date as InvoiceDate,          
  bp.I_Status InvoiceStatus,          
  bs.CourseID,          
  bs.CourseName,          
  bp.FeePlanAmount*(-1),          
  bp.C_Is_LumpSum PaymentType,          
  bp.Discount*(-1),          
  bp.CourseAmount*(-1),          
  bp.CourseTaxAmount*(-1) TaxAmount,          
  bs.BatchStartDate,          
  bs.BatchEndDate,          
  bs.TotalSessionCount,          
  bs.PlannedSessionCount,          
  ISNULL(bp.TotalCollection,0.00) AmountCollectedTillDate,          
  bp.TotalTax TaxCollectedTillDate,   
  ISNULL(bp.PartialCollection,0.00) AmountCollectedWithinDateRange,
  ISNULL(bp.PartialTax,0.00) TaxCollectedWithinDateRange,       
  bs.ActualSessionCount,          
  Case When (CourseAmount IS Null OR CourseAmount=0) or (TotalSessionCount IS Null OR TotalSessionCount=0) then 0 else CourseAmount/TotalSessionCount*(-1) end AmountPerSession,          
  Case When (CourseAmount IS Null OR CourseAmount=0) or (TotalSessionCount IS Null OR TotalSessionCount=0) then 0 else ((CourseAmount/TotalSessionCount)*PlannedSessionCount)*(-1) end AccrualAmount          
  FROM #BatchPayments AS bp          
  INNER JOIN @BatchSchedule AS bs ON bs.BatchID = bp.I_Batch_ID          
  INNER JOIN T_Center_Hierarchy_Name_Details tchnd on bs.CenterID=tchnd.I_Center_ID          
  AND bs.CenterID = bp.I_Centre_Id      
  WHERE bp.I_Status = 0       
  ORDER BY LTRIM(bp.StudentName)       
          
          
 END           
          
          
--EXEC [REPORT].[uspGetAccruedAmount] 1,2,'2011-12-26','2011-12-31'          
          
--SELECT * FROM dbo.T_Invoice_Batch_Map          
--SELECT * FROM dbo.T_Invoice_Child_Header
