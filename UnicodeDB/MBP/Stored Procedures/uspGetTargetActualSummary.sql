CREATE PROCEDURE [MBP].[uspGetTargetActualSummary]          
(          
 @iBrandID INT,          
 @iHierarchyDetailID INT,          
 @sProductMonthInfo VARCHAR(8000),          
 @iYear INT,                  
 @iCenterID INT,          
 @sDefaultProduct VARCHAR(2000) = NULL ,
 @sCurrency VARCHAR(100)         
)          
AS          
          
BEGIN          
 SET NOCOUNT ON;           
           
 DECLARE @tblHD TABLE          
  (          
   ID INT IDENTITY(1,1),          
   I_Hierarchy_Detail_ID int,          
   S_Hierarchy_Name VARCHAR(200)          
  )    
 DECLARE @tblSum TABLE    
  (    
   I_Hierarchy_Detail_ID int,          
   S_Hierarchy_Name VARCHAR(200),          
   I_Product_ID INT,          
   I_Year INT,          
   I_Month INT,          
   I_Target_Enquiry numeric(18,2),          
   I_Actual_Enquiry int,          
   I_Target_Booking numeric(18,2),          
   I_Actual_Booking numeric(18,2),          
   I_Target_Enrollment int,          
   I_Actual_Enrollment int,          
   I_Target_Billing numeric(18,2),          
   I_Actual_Billing numeric(18,2),      
   I_Target_RFF numeric(18,2),      
   I_Actual_RFF numeric(18,2)    
  )         
  
 CREATE TABLE #ProductTable (I_Product_Id INT)  
 CREATE TABLE #MonthTable (I_Month_Id INT)  
   
 DECLARE @hDoc INT  
 EXEC sp_xml_preparedocument @hDoc OUTPUT,@sProductMonthInfo  
  
 INSERT INTO #ProductTable  
 SELECT ProductTable.I_Product_Id FROM  
 OPENXML (@hDoc,'/INFO/ProductTable',2)  
 WITH( I_Product_Id INT) AS ProductTable  
  
   
 INSERT INTO #MonthTable  
 SELECT MonthTable.I_Month_Id FROM  
 OPENXML (@hDoc,'/INFO/MonthTable',2)  
 WITH( I_Month_Id INT) AS MonthTable  
  
  
 IF(@iCenterID = 0)          
  BEGIN          
   INSERT INTO @tblHD          
   SELECT HMD.I_Hierarchy_Detail_ID, HD.S_Hierarchy_Name           
   FROM dbo.T_Hierarchy_Mapping_Details HMD          
   INNER JOIN dbo.T_Hierarchy_Details HD           
   ON HMD.I_Hierarchy_Detail_ID = HD.I_Hierarchy_Detail_ID          
   WHERE HMD.I_Parent_ID = @iHierarchyDetailID AND HMD.I_Status = 1          
  END          
  ELSE          
  BEGIN          
   INSERT INTO @tblHD          
   SELECT HMD.I_Hierarchy_Detail_ID, HD.S_Hierarchy_Name           
   FROM dbo.T_Hierarchy_Mapping_Details HMD          
   INNER JOIN dbo.T_Hierarchy_Details HD           
   ON HMD.I_Hierarchy_Detail_ID = HD.I_Hierarchy_Detail_ID          
   WHERE HMD.I_Hierarchy_Detail_ID = @iHierarchyDetailID AND HMD.I_Status = 1          
  END          
          
  
DECLARE @iMonthId INT  
DECLARE @iProductId INT  
  
DECLARE PRODUCT_CURSOR CURSOR FOR   
 SELECT I_Product_Id  
 FROM #ProductTable  
  
 OPEN PRODUCT_CURSOR   
 FETCH NEXT FROM PRODUCT_CURSOR   
 INTO @iProductId  
      
 WHILE @@FETCH_STATUS = 0      
 BEGIN  
  --------------------------------  
  DECLARE MONTH_CURSOR CURSOR FOR   
  SELECT I_Month_Id  
  FROM #MonthTable  
  OPEN MONTH_CURSOR   
  FETCH NEXT FROM MONTH_CURSOR   
  INTO @iMonthId  
       
  WHILE @@FETCH_STATUS = 0      
  BEGIN  
  -----------------------------------------------  
  insert into @tblSum  
  SELECT * FROM [dbo].[fnGetTargetSummary]  
   (@iBrandID,@iHierarchyDetailID,@iProductId,@iYear,@iMonthId,@iCenterID,@sDefaultProduct,@sCurrency)  
  -----------------------------------------------  
  FETCH NEXT FROM MONTH_CURSOR   
      INTO @iMonthId  
  END  
  CLOSE MONTH_CURSOR   
  DEALLOCATE MONTH_CURSOR   
  --------------------------------  
 FETCH NEXT FROM PRODUCT_CURSOR   
     INTO @iProductId  
 END  
CLOSE PRODUCT_CURSOR   
DEALLOCATE PRODUCT_CURSOR   
  
SELECT * FROM @tblHD  
ORDER BY I_Hierarchy_Detail_ID  

DECLARE @iProdCount INT
SELECT  @iProdCount = COUNT(DISTINCT I_Product_Id) FROM #ProductTable

SELECT * FROM @tblSum AS TS
 
SELECT   
  I_Hierarchy_Detail_ID							AS  I_Hierarchy_Detail_ID        
  ,S_Hierarchy_Name								AS  S_Hierarchy_Name  
  ,null											AS  I_Product_ID      
  ,@iYear										AS  I_Year          
  ,SUM(I_Month)									AS  I_Month          
  ,SUM(I_Target_Enquiry)/@iProdCount			AS  I_Target_Enquiry 
  ,SUM(I_Actual_Enquiry)/@iProdCount			AS  I_Actual_Enquiry 
  ,SUM(I_Target_Booking)						AS  I_Target_Booking  
  ,SUM(I_Actual_Booking)						AS  I_Actual_Booking  
  ,SUM(I_Target_Enrollment)						AS  I_Target_Enrollment  
  ,SUM(I_Actual_Enrollment)						AS  I_Actual_Enrollment  
  ,SUM(I_Target_Billing)/@iProdCount			AS  I_Target_Billing  
  ,SUM(I_Actual_Billing)/@iProdCount			AS  I_Actual_Billing  
  ,SUM(I_Target_RFF)/@iProdCount				AS  I_Target_RFF      
  ,SUM(I_Actual_RFF)/@iProdCount				AS  I_Actual_RFF   
FROM @tblSum  
GROUP BY I_Hierarchy_Detail_ID  
,S_Hierarchy_Name  
ORDER BY I_Hierarchy_Detail_ID  
   
DROP TABLE #ProductTable   
DROP TABLE #MonthTable  
  
END
