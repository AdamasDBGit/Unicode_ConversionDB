CREATE PROCEDURE [MBP].[uspGetMonthlyPerformanceReport]                      
(                      
 @iBrandID INT,                      
 --@iHierarchyDetailID INT,                      
 @sProductMonthInfo VARCHAR(8000),                      
 @iYear INT,                              
 @iCenterID INT,                      
 @sDefaultProduct VARCHAR(2000) = NULL ,            
 @sCurrency VARCHAR(100),          
 @sType VARCHAR(100),        
 @sReportType VARCHAR(100)                     
)                      
AS                      
                      
BEGIN                      
 SET NOCOUNT ON;                             
          
-------------------          
declare @tblSum  table          
  (                
   I_Hierarchy_Detail_ID int,                      
   S_Hierarchy_Name VARCHAR(200),                      
   I_Product_ID INT,                      
   I_Year INT,                      
   I_Month INT,                      
   N_Budget_Jan numeric(18,2),                      
   N_Actual_Jan numeric(18,2),           
   N_Budget_Feb numeric(18,2),                      
   N_Actual_Feb numeric(18,2),                   
   N_Budget_Mar numeric(18,2),                      
   N_Actual_Mar numeric(18,2),          
   N_Budget_Apr numeric(18,2),                      
   N_Actual_Apr numeric(18,2),           
   N_Budget_May numeric(18,2),                      
   N_Actual_May numeric(18,2),                  
   N_Budget_Jun numeric(18,2),                      
   N_Actual_Jun numeric(18,2),          
   N_Budget_Jul numeric(18,2),                      
   N_Actual_Jul numeric(18,2),          
   N_Budget_Aug numeric(18,2),                      
   N_Actual_Aug numeric(18,2),           
   N_Budget_Sep numeric(18,2),                      
   N_Actual_Sep numeric(18,2),                  
   N_Budget_Oct numeric(18,2),                      
   N_Actual_Oct numeric(18,2),          
   N_Budget_Nov numeric(18,2),                      
   N_Actual_Nov numeric(18,2),                  
   N_Budget_Dec numeric(18,2),                      
   N_Actual_Dec numeric(18,2)          
  )          
-------------------                
           
 CREATE TABLE #ProductTable (I_Product_Id INT)              
 CREATE TABLE #MonthTable (I_Month_Id INT)              
 CREATE TABLE #HierarchyTable (ROWID INT IDENTITY(1,1),I_Hierarchy_Detail_Id INT)      
             
 DECLARE @hDoc INT              
 EXEC sp_xml_preparedocument @hDoc OUTPUT,@sProductMonthInfo              
                    
 INSERT INTO #MonthTable              
 SELECT MonthTable.I_Month_Id FROM              
 OPENXML (@hDoc,'/INFO/MonthTable',2)              
 WITH( I_Month_Id INT) AS MonthTable           
          
 INSERT INTO #ProductTable              
 SELECT ProductTable.I_Product_Id FROM              
 OPENXML (@hDoc,'/INFO/ProductTable',2)              
 WITH( I_Product_Id INT) AS ProductTable     
    
 INSERT INTO  #HierarchyTable    
 SELECT HierarchyTable.I_Hierarchy_Detail_Id FROM    
 OPENXML(@hDoc,'/INFO/HierarchyTable',2)    
 WITH(I_Hierarchy_Detail_Id INT) AS HierarchyTable                             
       
DECLARE @iHierarchyDetailID INT    
DECLARE @min INT    
DECLARE @max INT    
SELECT @min = MIN(ROWID), @max = MAX(ROWID) FROM #HierarchyTable    
WHILE @min <= @max    
BEGIN    
 SELECT @iHierarchyDetailID =   I_Hierarchy_Detail_Id FROM   #HierarchyTable WHERE ROWID = @min    
------------------------------------------------------------------------------------------------------------------    
              
DECLARE @iMonthId INT              
DECLARE @iProductId INT              
              
DECLARE MONTH_CURSOR CURSOR FOR               
 SELECT I_Month_Id              
 FROM #MonthTable              
              
 OPEN MONTH_CURSOR               
 FETCH NEXT FROM MONTH_CURSOR               
 INTO @iMonthId              
                  
 WHILE @@FETCH_STATUS = 0                  
 BEGIN              
  --------------------------------              
  DECLARE PRODUCT_CURSOR CURSOR FOR               
  SELECT I_Product_Id              
  FROM #ProductTable              
  OPEN PRODUCT_CURSOR               
  FETCH NEXT FROM PRODUCT_CURSOR               
  INTO @iProductId              
                   
  WHILE @@FETCH_STATUS = 0                  
  BEGIN          
          
 IF  ( @iMonthId =  1 )          
  BEGIN          
   insert into @tblSum           
   (  I_Hierarchy_Detail_ID          
    ,S_Hierarchy_Name          
    ,I_Product_ID          
    ,I_Year          
    ,I_Month          
    ,N_Budget_Jan          
    ,N_Actual_Jan          
   )             
   SELECT           
     I_Hierarchy_Detail_ID                      
    ,S_Hierarchy_Name                     
    ,I_Product_ID                       
    ,I_Year                       
    ,I_Month                       
    ,N_Budget = case when @sType = 'ENQUIRY' then I_Target_Enquiry          
         when @sType = 'Admission' then I_Target_Enrollment          
         when @sType = 'BOOKING' then I_Target_Booking          
         when @sType = 'BILLING' then I_Target_Billing          
         when @sType = 'COMPANYSHARE' then I_Target_RFF end          
          
    ,N_Acutal = case when @sType = 'ENQUIRY' then I_Actual_Enquiry          
         when @sType = 'Admission' then I_Actual_Enrollment          
         when @sType = 'BOOKING' then I_Actual_Booking          
         when @sType = 'BILLING' then I_Actual_Billing          
         when @sType = 'COMPANYSHARE' then I_Actual_RFF end          
           
   FROM [dbo].[fnGetTargetSummary]              
   (@iBrandID,@iHierarchyDetailID,@iProductId,@iYear,@iMonthId,@iCenterID,@sDefaultProduct,@sCurrency)          
  END          
 ELSE IF ( @iMonthId =  2 )          
  BEGIN          
   insert into @tblSum           
   (  I_Hierarchy_Detail_ID          
    ,S_Hierarchy_Name          
    ,I_Product_ID          
    ,I_Year          
    ,I_Month          
    ,N_Budget_Feb          
    ,N_Actual_Feb          
   )             
   SELECT           
     I_Hierarchy_Detail_ID                      
    ,S_Hierarchy_Name                     
    ,I_Product_ID                       
    ,I_Year                       
    ,I_Month                       
    ,N_Budget = case when @sType = 'ENQUIRY' then I_Target_Enquiry          
         when @sType = 'Admission' then I_Target_Enrollment          
         when @sType = 'BOOKING' then I_Target_Booking          
         when @sType = 'BILLING' then I_Target_Billing          
         when @sType = 'COMPANYSHARE' then I_Target_RFF end          
          
    ,N_Acutal = case when @sType = 'ENQUIRY' then I_Actual_Enquiry          
         when @sType = 'Admission' then I_Actual_Enrollment          
         when @sType = 'BOOKING' then I_Actual_Booking          
         when @sType = 'BILLING' then I_Actual_Billing          
         when @sType = 'COMPANYSHARE' then I_Actual_RFF end          
   FROM [dbo].[fnGetTargetSummary]              
   (@iBrandID,@iHierarchyDetailID,@iProductId,@iYear,@iMonthId,@iCenterID,@sDefaultProduct,@sCurrency)          
  END          
 ELSE IF ( @iMonthId =  3 )          
  BEGIN          
   insert into @tblSum           
   (  I_Hierarchy_Detail_ID          
    ,S_Hierarchy_Name          
    ,I_Product_ID          
    ,I_Year          
    ,I_Month          
    ,N_Budget_Mar          
    ,N_Actual_Mar          
   )             
   SELECT           
     I_Hierarchy_Detail_ID                      
    ,S_Hierarchy_Name                     
    ,I_Product_ID                       
    ,I_Year                       
    ,I_Month                       
    ,N_Budget = case when @sType = 'ENQUIRY' then I_Target_Enquiry          
         when @sType = 'Admission' then I_Target_Enrollment          
         when @sType = 'BOOKING' then I_Target_Booking          
         when @sType = 'BILLING' then I_Target_Billing          
         when @sType = 'COMPANYSHARE' then I_Target_RFF end          
          
    ,N_Acutal = case when @sType = 'ENQUIRY' then I_Actual_Enquiry          
         when @sType = 'Admission' then I_Actual_Enrollment          
         when @sType = 'BOOKING' then I_Actual_Booking          
         when @sType = 'BILLING' then I_Actual_Billing          
         when @sType = 'COMPANYSHARE' then I_Actual_RFF end          
   FROM [dbo].[fnGetTargetSummary]              
   (@iBrandID,@iHierarchyDetailID,@iProductId,@iYear,@iMonthId,@iCenterID,@sDefaultProduct,@sCurrency)         
  END          
ELSE IF ( @iMonthId =  4 )          
  BEGIN          
   insert into @tblSum           
   (  I_Hierarchy_Detail_ID          
    ,S_Hierarchy_Name          
    ,I_Product_ID          
    ,I_Year          
    ,I_Month          
    ,N_Budget_Apr          
    ,N_Actual_Apr          
   )          
   SELECT           
     I_Hierarchy_Detail_ID                      
    ,S_Hierarchy_Name                     
    ,I_Product_ID                       
    ,I_Year                       
    ,I_Month                       
    ,N_Budget = case when @sType = 'ENQUIRY' then I_Target_Enquiry          
         when @sType = 'Admission' then I_Target_Enrollment          
         when @sType = 'BOOKING' then I_Target_Booking          
         when @sType = 'BILLING' then I_Target_Billing          
         when @sType = 'COMPANYSHARE' then I_Target_RFF end          
          
    ,N_Acutal = case when @sType = 'ENQUIRY' then I_Actual_Enquiry          
         when @sType = 'Admission' then I_Actual_Enrollment          
         when @sType = 'BOOKING' then I_Actual_Booking          
         when @sType = 'BILLING' then I_Actual_Billing          
         when @sType = 'COMPANYSHARE' then I_Actual_RFF end          
   FROM [dbo].[fnGetTargetSummary]              
   (@iBrandID,@iHierarchyDetailID,@iProductId,@iYear,@iMonthId,@iCenterID,@sDefaultProduct,@sCurrency)          
  END          
ELSE IF ( @iMonthId =  5 )          
  BEGIN          
   insert into @tblSum           
   (  I_Hierarchy_Detail_ID          
    ,S_Hierarchy_Name          
    ,I_Product_ID          
    ,I_Year          
    ,I_Month          
    ,N_Budget_May          
    ,N_Actual_May          
   )             
   SELECT           
     I_Hierarchy_Detail_ID                      
    ,S_Hierarchy_Name                     
    ,I_Product_ID                       
    ,I_Year                       
    ,I_Month                       
    ,N_Budget = case when @sType = 'ENQUIRY' then I_Target_Enquiry          
         when @sType = 'Admission' then I_Target_Enrollment          
         when @sType = 'BOOKING' then I_Target_Booking          
         when @sType = 'BILLING' then I_Target_Billing          
         when @sType = 'COMPANYSHARE' then I_Target_RFF end          
          
    ,N_Acutal = case when @sType = 'ENQUIRY' then I_Actual_Enquiry          
         when @sType = 'Admission' then I_Actual_Enrollment          
         when @sType = 'BOOKING' then I_Actual_Booking          
         when @sType = 'BILLING' then I_Actual_Billing          
         when @sType = 'COMPANYSHARE' then I_Actual_RFF end           
   FROM [dbo].[fnGetTargetSummary]              
   (@iBrandID,@iHierarchyDetailID,@iProductId,@iYear,@iMonthId,@iCenterID,@sDefaultProduct,@sCurrency)          
  END          
ELSE IF ( @iMonthId =  6 )          
  BEGIN          
   insert into @tblSum           
   (  I_Hierarchy_Detail_ID          
    ,S_Hierarchy_Name          
    ,I_Product_ID          
    ,I_Year          
    ,I_Month          
    ,N_Budget_Jun          
    ,N_Actual_Jun          
   )             
   SELECT           
     I_Hierarchy_Detail_ID                      
    ,S_Hierarchy_Name                     
    ,I_Product_ID                       
    ,I_Year                       
    ,I_Month                       
    ,N_Budget = case when @sType = 'ENQUIRY' then I_Target_Enquiry          
         when @sType = 'Admission' then I_Target_Enrollment          
         when @sType = 'BOOKING' then I_Target_Booking          
         when @sType = 'BILLING' then I_Target_Billing          
         when @sType = 'COMPANYSHARE' then I_Target_RFF end          
          
    ,N_Acutal = case when @sType = 'ENQUIRY' then I_Actual_Enquiry          
         when @sType = 'Admission' then I_Actual_Enrollment          
         when @sType = 'BOOKING' then I_Actual_Booking          
         when @sType = 'BILLING' then I_Actual_Billing          
         when @sType = 'COMPANYSHARE' then I_Actual_RFF end          
   FROM [dbo].[fnGetTargetSummary]              
   (@iBrandID,@iHierarchyDetailID,@iProductId,@iYear,@iMonthId,@iCenterID,@sDefaultProduct,@sCurrency)          
  END          
ELSE IF ( @iMonthId = 7 )          
  BEGIN          
   insert into @tblSum           
   (  I_Hierarchy_Detail_ID          
    ,S_Hierarchy_Name          
    ,I_Product_ID          
    ,I_Year          
    ,I_Month          
    ,N_Budget_Jul          
    ,N_Actual_Jul          
   )             
   SELECT           
     I_Hierarchy_Detail_ID                      
    ,S_Hierarchy_Name                     
    ,I_Product_ID                       
    ,I_Year                       
    ,I_Month                       
    ,N_Budget = case when @sType = 'ENQUIRY' then I_Target_Enquiry          
         when @sType = 'Admission' then I_Target_Enrollment          
         when @sType = 'BOOKING' then I_Target_Booking          
         when @sType = 'BILLING' then I_Target_Billing          
         when @sType = 'COMPANYSHARE' then I_Target_RFF end          
          
    ,N_Acutal = case when @sType = 'ENQUIRY' then I_Actual_Enquiry          
         when @sType = 'Admission' then I_Actual_Enrollment          
         when @sType = 'BOOKING' then I_Actual_Booking          
         when @sType = 'BILLING' then I_Actual_Billing          
         when @sType = 'COMPANYSHARE' then I_Actual_RFF end           
   FROM [dbo].[fnGetTargetSummary]              
   (@iBrandID,@iHierarchyDetailID,@iProductId,@iYear,@iMonthId,@iCenterID,@sDefaultProduct,@sCurrency)          
  END          
ELSE IF ( @iMonthId =  8 )          
  BEGIN          
   insert into @tblSum           
   (  I_Hierarchy_Detail_ID          
    ,S_Hierarchy_Name          
    ,I_Product_ID          
    ,I_Year          
    ,I_Month          
    ,N_Budget_Aug          
    ,N_Actual_Aug          
   )             
   SELECT           
     I_Hierarchy_Detail_ID                      
    ,S_Hierarchy_Name                     
    ,I_Product_ID                       
    ,I_Year                       
    ,I_Month                       
    ,N_Budget = case when @sType = 'ENQUIRY' then I_Target_Enquiry          
         when @sType = 'Admission' then I_Target_Enrollment          
         when @sType = 'BOOKING' then I_Target_Booking          
         when @sType = 'BILLING' then I_Target_Billing          
         when @sType = 'COMPANYSHARE' then I_Target_RFF end          
          
    ,N_Acutal = case when @sType = 'ENQUIRY' then I_Actual_Enquiry          
         when @sType = 'Admission' then I_Actual_Enrollment          
         when @sType = 'BOOKING' then I_Actual_Booking          
         when @sType = 'BILLING' then I_Actual_Billing          
         when @sType = 'COMPANYSHARE' then I_Actual_RFF end           
   FROM [dbo].[fnGetTargetSummary]              
   (@iBrandID,@iHierarchyDetailID,@iProductId,@iYear,@iMonthId,@iCenterID,@sDefaultProduct,@sCurrency)          
  END          
ELSE IF ( @iMonthId =  9 )          
  BEGIN          
   insert into @tblSum           
   (  I_Hierarchy_Detail_ID          
    ,S_Hierarchy_Name          
    ,I_Product_ID          
    ,I_Year          
    ,I_Month          
    ,N_Budget_Sep          
    ,N_Actual_Sep          
   )             
   SELECT           
     I_Hierarchy_Detail_ID                      
    ,S_Hierarchy_Name                     
    ,I_Product_ID                       
    ,I_Year                       
    ,I_Month                       
    ,N_Budget = case when @sType = 'ENQUIRY' then I_Target_Enquiry          
         when @sType = 'Admission' then I_Target_Enrollment          
     when @sType = 'BOOKING' then I_Target_Booking          
         when @sType = 'BILLING' then I_Target_Billing          
         when @sType = 'COMPANYSHARE' then I_Target_RFF end          
          
    ,N_Acutal = case when @sType = 'ENQUIRY' then I_Actual_Enquiry          
         when @sType = 'Admission' then I_Actual_Enrollment          
         when @sType = 'BOOKING' then I_Actual_Booking          
         when @sType = 'BILLING' then I_Actual_Billing          
         when @sType = 'COMPANYSHARE' then I_Actual_RFF end          
   FROM [dbo].[fnGetTargetSummary]              
   (@iBrandID,@iHierarchyDetailID,@iProductId,@iYear,@iMonthId,@iCenterID,@sDefaultProduct,@sCurrency)          
  END          
ELSE IF ( @iMonthId =  10 )          
  BEGIN          
   insert into @tblSum           
   (  I_Hierarchy_Detail_ID          
    ,S_Hierarchy_Name          
    ,I_Product_ID          
    ,I_Year          
    ,I_Month          
    ,N_Budget_Oct          
    ,N_Actual_Oct          
   )             
   SELECT           
     I_Hierarchy_Detail_ID                      
    ,S_Hierarchy_Name                     
    ,I_Product_ID                       
    ,I_Year                       
    ,I_Month                       
    ,N_Budget = case when @sType = 'ENQUIRY' then I_Target_Enquiry          
         when @sType = 'Admission' then I_Target_Enrollment          
         when @sType = 'BOOKING' then I_Target_Booking          
         when @sType = 'BILLING' then I_Target_Billing          
         when @sType = 'COMPANYSHARE' then I_Target_RFF end          
          
    ,N_Acutal = case when @sType = 'ENQUIRY' then I_Actual_Enquiry          
         when @sType = 'Admission' then I_Actual_Enrollment          
         when @sType = 'BOOKING' then I_Actual_Booking          
         when @sType = 'BILLING' then I_Actual_Billing          
         when @sType = 'COMPANYSHARE' then I_Actual_RFF end        FROM [dbo].[fnGetTargetSummary]              
   (@iBrandID,@iHierarchyDetailID,@iProductId,@iYear,@iMonthId,@iCenterID,@sDefaultProduct,@sCurrency)          
  END          
ELSE IF ( @iMonthId =  11 )          
  BEGIN          
   insert into @tblSum           
   (  I_Hierarchy_Detail_ID          
    ,S_Hierarchy_Name          
    ,I_Product_ID          
    ,I_Year          
    ,I_Month          
    ,N_Budget_Nov          
    ,N_Actual_Nov          
   )             
   SELECT           
     I_Hierarchy_Detail_ID                      
    ,S_Hierarchy_Name                     
    ,I_Product_ID                       
    ,I_Year                       
    ,I_Month                       
    ,N_Budget = case when @sType = 'ENQUIRY' then I_Target_Enquiry          
         when @sType = 'Admission' then I_Target_Enrollment          
         when @sType = 'BOOKING' then I_Target_Booking          
         when @sType = 'BILLING' then I_Target_Billing          
         when @sType = 'COMPANYSHARE' then I_Target_RFF end          
          
    ,N_Acutal = case when @sType = 'ENQUIRY' then I_Actual_Enquiry          
         when @sType = 'Admission' then I_Actual_Enrollment          
         when @sType = 'BOOKING' then I_Actual_Booking          
         when @sType = 'BILLING' then I_Actual_Billing          
         when @sType = 'COMPANYSHARE' then I_Actual_RFF end          
   FROM [dbo].[fnGetTargetSummary]              
   (@iBrandID,@iHierarchyDetailID,@iProductId,@iYear,@iMonthId,@iCenterID,@sDefaultProduct,@sCurrency)          
  END          
ELSE IF ( @iMonthId =  12 )          
  BEGIN          
   insert into @tblSum           
   (  I_Hierarchy_Detail_ID          
    ,S_Hierarchy_Name          
    ,I_Product_ID          
    ,I_Year          
    ,I_Month          
    ,N_Budget_Dec          
    ,N_Actual_Dec          
   )             
   SELECT           
     I_Hierarchy_Detail_ID                      
    ,S_Hierarchy_Name                     
    ,I_Product_ID                       
    ,I_Year                       
    ,I_Month                       
 ,N_Budget = case when @sType = 'ENQUIRY' then I_Target_Enquiry          
         when @sType = 'Admission' then I_Target_Enrollment          
         when @sType = 'BOOKING' then I_Target_Booking          
         when @sType = 'BILLING' then I_Target_Billing          
         when @sType = 'COMPANYSHARE' then I_Target_RFF end          
          
    ,N_Acutal = case when @sType = 'ENQUIRY' then I_Actual_Enquiry          
         when @sType = 'Admission' then I_Actual_Enrollment          
         when @sType = 'BOOKING' then I_Actual_Booking          
         when @sType = 'BILLING' then I_Actual_Billing          
         when @sType = 'COMPANYSHARE' then I_Actual_RFF end          
   FROM [dbo].[fnGetTargetSummary]              
   (@iBrandID,@iHierarchyDetailID,@iProductId,@iYear,@iMonthId,@iCenterID,@sDefaultProduct,@sCurrency)          
  END          
           
  -----------------------------------------------              
  FETCH NEXT FROM PRODUCT_CURSOR               
      INTO @iProductId              
  END              
  CLOSE PRODUCT_CURSOR               
  DEALLOCATE PRODUCT_CURSOR               
  --------------------------------              
 FETCH NEXT FROM MONTH_CURSOR               
     INTO @iMonthId              
 END              
CLOSE MONTH_CURSOR               
DEALLOCATE MONTH_CURSOR      
------------------------------------------------------------------------------------------------------------------    
 SET @min = @min + 1    
END        
         
          
-------------------------------------------------------------------------------------------              
IF @sReportType = 'NODEWISE'        
BEGIN        
select                      
   S_Hierarchy_Name                  
--   ,ISNULL(SUM(I_Product_ID),0)          
--   ,ISNULL(SUM(I_Year),0)                   
--   ,ISNULL(SUM(I_Month),0)          
   ,ISNULL(SUM(N_Budget_Jan),0) AS N_Budget_Jan          
   ,ISNULL(SUM(N_Actual_Jan),0) AS N_Actual_Jan          
   ,ISNULL(SUM(N_Budget_Feb),0) AS N_Budget_Feb                    
   ,ISNULL(SUM(N_Actual_Feb),0) AS N_Actual_Feb                 
   ,ISNULL(SUM(N_Budget_Mar),0) AS N_Budget_Mar                    
   ,ISNULL(SUM(N_Actual_Mar),0) AS N_Actual_Mar          
   ,ISNULL(SUM(N_Budget_Apr),0) AS N_Budget_Apr                     
   ,ISNULL(SUM(N_Actual_Apr),0) AS N_Actual_Apr            
   ,ISNULL(SUM(N_Budget_May),0) AS N_Budget_May                    
   ,ISNULL(SUM(N_Actual_May),0) AS N_Actual_May                
   ,ISNULL(SUM(N_Budget_Jun),0) AS N_Budget_Jun                    
   ,ISNULL(SUM(N_Actual_Jun),0) AS N_Actual_Jun           
   ,ISNULL(SUM(N_Budget_Jul),0) AS N_Budget_Jul                     
   ,ISNULL(SUM(N_Actual_Jul),0) AS N_Actual_Jul           
   ,ISNULL(SUM(N_Budget_Aug),0) AS N_Budget_Aug                    
   ,ISNULL(SUM(N_Actual_Aug),0) AS N_Actual_Aug           
   ,ISNULL(SUM(N_Budget_Sep),0) AS N_Budget_Sep                      
   ,ISNULL(SUM(N_Actual_Sep),0) AS N_Actual_Sep                  
   ,ISNULL(SUM(N_Budget_Oct),0) AS N_Budget_Oct                      
   ,ISNULL(SUM(N_Actual_Oct),0) AS N_Actual_Oct            
   ,ISNULL(SUM(N_Budget_Nov),0) AS N_Budget_Nov                      
   ,ISNULL(SUM(N_Actual_Nov),0) AS N_Actual_Nov                  
   ,ISNULL(SUM(N_Budget_Dec),0) AS N_Budget_Dec                      
   ,ISNULL(SUM(N_Actual_Dec),0) AS N_Actual_Dec          
   ,0 AS N_Upto_Budget          
   ,0 AS N_Upto_Actual          
   ,0 AS N_Upto_Percentage          
   ,ISNULL(SUM( ISNULL(N_Budget_Jan,0)+ISNULL(N_Budget_Feb,0)+ISNULL(N_Budget_Mar,0)+ISNULL(N_Budget_Apr,0)          
      +ISNULL(N_Budget_May,0)+ISNULL(N_Budget_Jun,0)+ISNULL(N_Budget_Jul,0)+ISNULL(N_Budget_Aug,0)          
      +ISNULL(N_Budget_Sep,0)+ISNULL(N_Budget_Oct,0)+ISNULL(N_Budget_Nov,0)+ISNULL(N_Budget_Dec,0)),0) AS N_Annual_Budget           
   ,0 AS N_Annual_Actual          
   ,0 AS N_Annual_Percentage          
From @tblSum              
group by I_Hierarchy_Detail_ID,  S_Hierarchy_Name           
--ORDER BY S_Hierarchy_Name          
UNION ALL          
select                      
   'Total' AS S_Hierarchy_Name                  
--   ,ISNULL(SUM(I_Product_ID),0)          
--   ,ISNULL(SUM(I_Year),0)                   
--   ,ISNULL(SUM(I_Month),0)          
   ,ISNULL(SUM(N_Budget_Jan),0) AS N_Budget_Jan          
   ,ISNULL(SUM(N_Actual_Jan),0) AS N_Actual_Jan          
   ,ISNULL(SUM(N_Budget_Feb),0) AS N_Budget_Feb                    
   ,ISNULL(SUM(N_Actual_Feb),0) AS N_Actual_Feb                 
   ,ISNULL(SUM(N_Budget_Mar),0) AS N_Budget_Mar                    
   ,ISNULL(SUM(N_Actual_Mar),0) AS N_Actual_Mar          
   ,ISNULL(SUM(N_Budget_Apr),0) AS N_Budget_Apr                     
   ,ISNULL(SUM(N_Actual_Apr),0) AS N_Actual_Apr            
   ,ISNULL(SUM(N_Budget_May),0) AS N_Budget_May                    
   ,ISNULL(SUM(N_Actual_May),0) AS N_Actual_May                
   ,ISNULL(SUM(N_Budget_Jun),0) AS N_Budget_Jun                    
   ,ISNULL(SUM(N_Actual_Jun),0) AS N_Actual_Jun           
   ,ISNULL(SUM(N_Budget_Jul),0) AS N_Budget_Jul                     
   ,ISNULL(SUM(N_Actual_Jul),0) AS N_Actual_Jul           
 ,ISNULL(SUM(N_Budget_Aug),0) AS N_Budget_Aug                    
   ,ISNULL(SUM(N_Actual_Aug),0) AS N_Actual_Aug           
   ,ISNULL(SUM(N_Budget_Sep),0) AS N_Budget_Sep                      
   ,ISNULL(SUM(N_Actual_Sep),0) AS N_Actual_Sep                  
   ,ISNULL(SUM(N_Budget_Oct),0) AS N_Budget_Oct                      
   ,ISNULL(SUM(N_Actual_Oct),0) AS N_Actual_Oct            
   ,ISNULL(SUM(N_Budget_Nov),0) AS N_Budget_Nov                      
   ,ISNULL(SUM(N_Actual_Nov),0) AS N_Actual_Nov                  
   ,ISNULL(SUM(N_Budget_Dec),0) AS N_Budget_Dec                      
   ,ISNULL(SUM(N_Actual_Dec),0) AS N_Actual_Dec          
   ,0 AS N_Upto_Budget          
   ,0 AS N_Upto_Actual          
   ,0 AS N_Upto_Percentage          
   ,ISNULL(SUM( ISNULL(N_Budget_Jan,0)+ISNULL(N_Budget_Feb,0)+ISNULL(N_Budget_Mar,0)+ISNULL(N_Budget_Apr,0)          
      +ISNULL(N_Budget_May,0)+ISNULL(N_Budget_Jun,0)+ISNULL(N_Budget_Jul,0)+ISNULL(N_Budget_Aug,0)          
      +ISNULL(N_Budget_Sep,0)+ISNULL(N_Budget_Oct,0)+ISNULL(N_Budget_Nov,0)+ISNULL(N_Budget_Dec,0)),0) AS N_Annual_Budget           
   ,0 AS N_Annual_Actual          
   ,0 AS N_Annual_Percentage          
From @tblSum         
END         
-------------------------------------------------------------------------------------------------------------------------------        
ELSE IF @sReportType = 'PRODUCTWISE'        
BEGIN        
select                      
   --S_Hierarchy_Name                  
 PM.S_Product_Name as  S_Hierarchy_Name         
--   ,ISNULL(SUM(I_Year),0)                   
--   ,ISNULL(SUM(I_Month),0)          
   ,ISNULL(SUM(TS.N_Budget_Jan),0) AS N_Budget_Jan          
   ,ISNULL(SUM(TS.N_Actual_Jan),0) AS N_Actual_Jan          
   ,ISNULL(SUM(TS.N_Budget_Feb),0) AS N_Budget_Feb                    
   ,ISNULL(SUM(TS.N_Actual_Feb),0) AS N_Actual_Feb                 
   ,ISNULL(SUM(TS.N_Budget_Mar),0) AS N_Budget_Mar                    
   ,ISNULL(SUM(TS.N_Actual_Mar),0) AS N_Actual_Mar          
   ,ISNULL(SUM(TS.N_Budget_Apr),0) AS N_Budget_Apr                     
   ,ISNULL(SUM(TS.N_Actual_Apr),0) AS N_Actual_Apr            
   ,ISNULL(SUM(TS.N_Budget_May),0) AS N_Budget_May                    
   ,ISNULL(SUM(TS.N_Actual_May),0) AS N_Actual_May                
   ,ISNULL(SUM(TS.N_Budget_Jun),0) AS N_Budget_Jun                    
   ,ISNULL(SUM(TS.N_Actual_Jun),0) AS N_Actual_Jun           
   ,ISNULL(SUM(TS.N_Budget_Jul),0) AS N_Budget_Jul                     
   ,ISNULL(SUM(TS.N_Actual_Jul),0) AS N_Actual_Jul           
   ,ISNULL(SUM(TS.N_Budget_Aug),0) AS N_Budget_Aug                    
   ,ISNULL(SUM(TS.N_Actual_Aug),0) AS N_Actual_Aug           
   ,ISNULL(SUM(TS.N_Budget_Sep),0) AS N_Budget_Sep                      
   ,ISNULL(SUM(TS.N_Actual_Sep),0) AS N_Actual_Sep                  
   ,ISNULL(SUM(TS.N_Budget_Oct),0) AS N_Budget_Oct                      
   ,ISNULL(SUM(TS.N_Actual_Oct),0) AS N_Actual_Oct            
   ,ISNULL(SUM(TS.N_Budget_Nov),0) AS N_Budget_Nov                      
   ,ISNULL(SUM(TS.N_Actual_Nov),0) AS N_Actual_Nov                  
   ,ISNULL(SUM(TS.N_Budget_Dec),0) AS N_Budget_Dec                      
   ,ISNULL(SUM(TS.N_Actual_Dec),0) AS N_Actual_Dec          
   ,0 AS N_Upto_Budget          
   ,0 AS N_Upto_Actual          
   ,0 AS N_Upto_Percentage          
   ,ISNULL(SUM( ISNULL(TS.N_Budget_Jan,0)+ISNULL(TS.N_Budget_Feb,0)+ISNULL(TS.N_Budget_Mar,0)+ISNULL(TS.N_Budget_Apr,0)          
      +ISNULL(TS.N_Budget_May,0)+ISNULL(TS.N_Budget_Jun,0)+ISNULL(TS.N_Budget_Jul,0)+ISNULL(TS.N_Budget_Aug,0)          
      +ISNULL(TS.N_Budget_Sep,0)+ISNULL(TS.N_Budget_Oct,0)+ISNULL(TS.N_Budget_Nov,0)+ISNULL(TS.N_Budget_Dec,0)),0) AS N_Annual_Budget           
   ,0 AS N_Annual_Actual          
   ,0 AS N_Annual_Percentage          
From @tblSum TS        
INNER JOIN MBP.T_PRODUCT_MASTER PM ON TS.I_PRODUCT_ID = PM.I_PRODUCT_ID             
group by TS.I_Product_ID,PM.S_Product_Name          
--ORDER BY S_Hierarchy_Name          
UNION ALL          
select                      
   'Total' AS S_Hierarchy_Name                  
--   ,ISNULL(SUM(I_Product_ID),0)          
--   ,ISNULL(SUM(I_Year),0)                 --   ,ISNULL(SUM(I_Month),0)          
   ,ISNULL(SUM(TS.N_Budget_Jan),0) AS N_Budget_Jan          
   ,ISNULL(SUM(TS.N_Actual_Jan),0) AS N_Actual_Jan          
   ,ISNULL(SUM(TS.N_Budget_Feb),0) AS N_Budget_Feb                    
   ,ISNULL(SUM(TS.N_Actual_Feb),0) AS N_Actual_Feb                 
   ,ISNULL(SUM(TS.N_Budget_Mar),0) AS N_Budget_Mar                    
   ,ISNULL(SUM(TS.N_Actual_Mar),0) AS N_Actual_Mar          
   ,ISNULL(SUM(TS.N_Budget_Apr),0) AS N_Budget_Apr                     
   ,ISNULL(SUM(TS.N_Actual_Apr),0) AS N_Actual_Apr            
   ,ISNULL(SUM(TS.N_Budget_May),0) AS N_Budget_May                    
   ,ISNULL(SUM(TS.N_Actual_May),0) AS N_Actual_May                
   ,ISNULL(SUM(TS.N_Budget_Jun),0) AS N_Budget_Jun                    
   ,ISNULL(SUM(TS.N_Actual_Jun),0) AS N_Actual_Jun           
   ,ISNULL(SUM(TS.N_Budget_Jul),0) AS N_Budget_Jul                     
   ,ISNULL(SUM(TS.N_Actual_Jul),0) AS N_Actual_Jul           
   ,ISNULL(SUM(TS.N_Budget_Aug),0) AS N_Budget_Aug                    
   ,ISNULL(SUM(TS.N_Actual_Aug),0) AS N_Actual_Aug           
   ,ISNULL(SUM(TS.N_Budget_Sep),0) AS N_Budget_Sep                      
   ,ISNULL(SUM(TS.N_Actual_Sep),0) AS N_Actual_Sep                  
   ,ISNULL(SUM(TS.N_Budget_Oct),0) AS N_Budget_Oct                      
   ,ISNULL(SUM(TS.N_Actual_Oct),0) AS N_Actual_Oct            
   ,ISNULL(SUM(TS.N_Budget_Nov),0) AS N_Budget_Nov                      
   ,ISNULL(SUM(TS.N_Actual_Nov),0) AS N_Actual_Nov                  
   ,ISNULL(SUM(TS.N_Budget_Dec),0) AS N_Budget_Dec                      
   ,ISNULL(SUM(TS.N_Actual_Dec),0) AS N_Actual_Dec          
   ,0 AS N_Upto_Budget          
   ,0 AS N_Upto_Actual          
   ,0 AS N_Upto_Percentage          
   ,ISNULL(SUM( ISNULL(N_Budget_Jan,0)+ISNULL(N_Budget_Feb,0)+ISNULL(N_Budget_Mar,0)+ISNULL(N_Budget_Apr,0)          
      +ISNULL(N_Budget_May,0)+ISNULL(N_Budget_Jun,0)+ISNULL(N_Budget_Jul,0)+ISNULL(N_Budget_Aug,0)          
      +ISNULL(N_Budget_Sep,0)+ISNULL(N_Budget_Oct,0)+ISNULL(N_Budget_Nov,0)+ISNULL(N_Budget_Dec,0)),0) AS N_Annual_Budget           
   ,0 AS N_Annual_Actual          
   ,0 AS N_Annual_Percentage          
From @tblSum TS        
INNER JOIN MBP.T_PRODUCT_MASTER PM ON TS.I_PRODUCT_ID = PM.I_PRODUCT_ID         
END         
-------------------------------------------------------------------------------------------------------------------------------              
DROP TABLE #ProductTable               
DROP TABLE #MonthTable              
              
END
