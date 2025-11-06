CREATE PROCEDURE [MBP].[uspUpdateMBPBatch]            
AS
BEGIN  
SET NOCOUNT ON;  
DECLARE @iBrandId INT  
DECLARE @iCenterId INT  
DECLARE @MaxDateInMBPPerformance DATETIME   
SELECT @MaxDateInMBPPerformance = Dt_Last_Run_Date  
FROM dbo.T_Batch_Master   
WHERE S_Batch_Process_Name= 'MBP_UPDATE'  
-----------------------------------------------------------  
DECLARE @sCenterName VARCHAR(200)  
DECLARE @Comments VARCHAR(2000)  
DECLARE @I_Process_ID_Max INT  
SELECT @I_Process_ID_Max=ISNULL(Max(I_Process_ID),0)+1 FROM dbo.T_Batch_Log   
WHERE S_Batch_Process_Name='MBP_UPDATE'  
--------------------------------------------------------------------------------  
DECLARE @iMonth INT, @iMonthEnd INT  
DECLARE @iYear INT, @iYearEnd INT  
  
SELECT @iYear = (DATEPART(yy,Dt_Last_Run_Date))  
   ,@iMonth = (DATEPART(mm,Dt_Last_Run_Date))  
FROM dbo.T_Batch_Master   
WHERE S_Batch_Process_Name= 'MBP_UPDATE'  
  
SELECT @iYearEnd = (DATEPART(yy,GETDATE())),@iMonthEnd =(DATEPART(mm,GETDATE()))  
CREATE TABLE #DateRANGE         
(              
 I_Month int,I_Year int        
)  
  
declare @i int set @i = 1  
while ( @iYear <= @iYearEnd )  
begin  
 while ( @i <= 12 )  
 begin  
  insert into #DateRANGE values(@i,@iYear)  
  set @i = @i + 1  
 end  
 set @i = 1  
 set @iYear= @iYear + 1  
end  
SELECT @iYear = (DATEPART(yy,Dt_Last_Run_Date))  
   ,@iMonth = (DATEPART(mm,Dt_Last_Run_Date))  
FROM dbo.T_Batch_Master   
WHERE S_Batch_Process_Name= 'MBP_UPDATE'  
  
SELECT @iYearEnd = (DATEPART(yy,GETDATE())),@iMonthEnd =(DATEPART(mm,GETDATE()))  

DELETE #DateRANGE WHERE I_Month < @iMonth AND I_Year = @iYear  
DELETE #DateRANGE WHERE I_Month >= @iMonthEnd+1 AND I_Year = @iYearEnd 

SELECT * FROM  #DateRANGE


--------------------------------------------------------------------------------    
CREATE TABLE #TempBRAND         
(              
 I_Brand_ID INT         
)        
        
INSERT INTO #TempBRAND(I_Brand_ID)        
SELECT DISTINCT I_Brand_ID FROM [dbo].T_Brand_Master WHERE I_Status = 1  
------------------------------------  
DECLARE BRAND_CURSOR CURSOR FOR   
  SELECT I_Brand_ID  
  FROM #TempBRAND  
  OPEN BRAND_CURSOR   
  FETCH NEXT FROM BRAND_CURSOR   
  INTO @iBrandId  
       
  WHILE @@FETCH_STATUS = 0      
  BEGIN  
  CREATE TABLE #TempCENTER         
  (              
   I_Center_ID INT         
  )  
  INSERT INTO #TempCENTER  
  SELECT DISTINCT CM.I_Centre_Id  
  FROM DBO.T_HIERARCHY_MASTER HM  
  INNER JOIN DBO.T_CENTER_HIERARCHY_DETAILS HD  
  ON HM.I_Hierarchy_Master_Id = HD.I_Hierarchy_Master_Id  
  INNER JOIN DBO.T_CENTRE_MASTER CM  
  ON CM.I_Centre_Id = HD.I_Center_Id  
  INNER JOIN DBO.T_HIERARCHY_BRAND_DETAILS HB  
  ON HB.I_Hierarchy_Master_Id = HM.I_Hierarchy_Master_Id  
  WHeRE HB.I_Brand_Id = @iBrandId  
  AND HM.I_Status =1  
  AND HD.I_Status =1  
  AND CM.I_Status =1  
  AND HB.I_Status =1  
  -----------------------------------------------  
  DECLARE CENTER_CURSOR CURSOR FOR   
    SELECT I_Center_ID  
    FROM #TempCENTER  
    OPEN CENTER_CURSOR   
    FETCH NEXT FROM CENTER_CURSOR   
    INTO @iCenterId  
         
    WHILE @@FETCH_STATUS = 0      
    BEGIN  
    -----------------------------------------------  
    DECLARE DATERANGE_CURSOR CURSOR FOR   
     SELECT I_Month, I_Year  
     FROM #DateRANGE  
     OPEN DATERANGE_CURSOR   
     FETCH NEXT FROM DATERANGE_CURSOR   
     INTO @iMonth, @iYear  
         
     WHILE @@FETCH_STATUS = 0      
     BEGIN  
     ---------------------------------------------------------------   
      EXEC MBP.uspGetBilling @iYear,@iMonth,@iCenterId, @MaxDateInMBPPerformance    
      EXEC MBP.uspGetRFF  @iYear,@iMonth,@iBrandId,  @MaxDateInMBPPerformance, @iCenterId    
      EXEC MBP.uspGetBooking @iYear,@iMonth,@iCenterId, @MaxDateInMBPPerformance    
      EXEC MBP.uspGetEnquiry @iYear,@iMonth,@iCenterId, @MaxDateInMBPPerformance    
      EXEC MBP.uspGetEnroll @iYear,@iMonth,@iCenterId, @MaxDateInMBPPerformance   
     ---------------------------------------------------------------  
     FETCH NEXT FROM DATERANGE_CURSOR   
         INTO @iMonth, @iYear  
     END  
     CLOSE DATERANGE_CURSOR   
    DEALLOCATE DATERANGE_CURSOR  
    -----------------------------------------------  
    SELECT @sCenterName = S_Center_Name FROM dbo.T_Centre_Master WHERE I_Centre_Id = @iCenterId  
    SET @Comments = 'MBP DATA UPDATED FOR '+ @sCenterName + '(ID: '+CAST(@iCenterId AS VARCHAR)+')'  
    EXEC uspWriteBatchProcessLog @I_Process_ID_Max,'MBP_UPDATE',@Comments,'Success'   
  
    FETCH NEXT FROM CENTER_CURSOR   
        INTO @iCenterId  
    END  
    CLOSE CENTER_CURSOR   
  DEALLOCATE CENTER_CURSOR  
  DROP TABLE #TempCENTER  
  -----------------------------------------------  
  FETCH NEXT FROM BRAND_CURSOR   
      INTO @iBrandId  
  END  
  CLOSE BRAND_CURSOR   
DEALLOCATE BRAND_CURSOR  
--------------------------------------    
DROP TABLE #TempBRAND  
  
END
