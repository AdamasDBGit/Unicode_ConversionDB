CREATE PROCEDURE [MBP].[uspGetEnroll]  
(   
 @iYear INT,  
 @iMonth INT,  
 @iCenterIDParam INT,  
 @MaxDateInMBPPerformance DATETIME   
)  
AS  
BEGIN TRY  
  
DECLARE @tempEnroll TABLE  
(  
ID INT IDENTITY(1,1),  
iCenterID INT,  
iStudentID INT  
)  
  
DECLARE @tempEnrollNew TABLE  
(  
ID INT IDENTITY(1,1),  
iCenterID INT,  
iProduct INT,  
iStudentID INT  
)  
  
INSERT INTO @tempEnroll (iStudentID,iCenterID)  
SELECT SD.I_Student_Detail_ID,SCD.I_Centre_Id FROM dbo.T_Student_Detail SD  
INNER JOIN dbo.T_Student_Center_Detail SCD  
ON SD.I_Student_Detail_ID =SCD.I_Student_Detail_ID  
WHERE (DATEPART(mm,SD.Dt_Crtd_On))  = @iMonth  
AND (DATEPART(yy,SD.Dt_Crtd_On))  = @iYear  
AND SD.Dt_Crtd_On > @MaxDateInMBPPerformance  
AND SCD.I_Centre_ID=@iCenterIDParam  
--GROUP BY I_Centre_Id,I_Student_Detail_ID  
  
  
DECLARE @iRow INT  
DECLARE @iCount INT  
DECLARE @iStudent INT  
--DECLARE @iBilling INT  
DECLARE @iCenterID INT  
DECLARE @iProduct INT  
  
  
SET @iCount = 1  
SET @iRow = (SELECT COUNT(*) FROM @tempEnroll)  
  
WHILE(@iCount <= @iRow)  
  
 BEGIN  
  SELECT @iStudent=iStudentID , @iCenterID = 
iCenterID FROM @tempEnroll WHERE ID = @iCount  
    
  IF @iStudent IS NOT NULL  
   BEGIN  
    INSERT INTO @tempEnrollNew (iCenterID,iProduct,iStudentID)  
    SELECT @iCenterID,iProductID,@iStudent FROM 
[MBP].[fnGetProductIDFromStudentID](@iStudent)  
   END   
  SET @iCount= @iCount+1  
  
 END  
  
--SELECT * FROM @tempEnrollNew  
  
DECLARE @tempEnrollNew1 TABLE  
(  
ID INT IDENTITY(1,1),  
iCenterID INT,  
iProduct INT,
iEnrollCount int   
)
insert into  @tempEnrollNew1
select iCenterID,iProduct,count( iStudentID )
from @tempEnrollNew
group by iCenterID,iProduct

--select * From @tempEnrollNew1
 

  
DECLARE @iCount2 INT  
DECLARE @iRow2 INT  
DECLARE @iProductID INT  
DECLARE @iEnroll INT  
DECLARE @iEnr INT  
SET @iCount2 = 1  
SET @iEnroll= 1       
SET @iRow2 = (SELECT COUNT(*) FROM @tempEnrollNew1)  
  
WHILE (@iCount2 <= @iRow2)  
 BEGIN  
  
  SELECT @iEnroll=iEnrollCount ,   
  --@iBill = iBilling,  
  @iCenterID = iCenterID ,   
  @iProductID =iProduct   
  FROM @tempEnrollNew1 WHERE ID = @iCount2  
  
  IF NOT EXISTS(SELECT * FROM MBP.T_MBPerformance WHERE I_Product_ID = @iProductID  
        AND I_Center_ID = @iCenterID  
        AND I_Year = @iYear  
        AND I_Month = @iMonth)  
   BEGIN   
      
  
    INSERT INTO MBP.T_MBPerformance 
(I_Product_ID,I_Center_ID,I_Month,I_Year,I_Actual_Enrollment,S_Crtd_By,Dt_Crtd_On)  
    VALUES (@iProductID,@iCenterID,@iMonth,@iYear,@iEnroll,'dba',GETDATE())  
   END  
  ELSE  
   BEGIN  
      SET @iEnr = (SELECT ISNULL(I_Actual_Enrollment,0) FROM MBP.T_MBPerformance  
      WHERE   
      I_Product_ID = @iProductID  
      AND I_Center_ID = @iCenterID  
      AND I_Year = @iYear  
      AND I_Month = @iMonth)  
  
    SET @iEnroll = @iEnroll + @iEnr  
      
    UPDATE MBP.T_MBPerformance  
    SET I_Actual_Enrollment = @iEnroll,  
     S_Upd_By ='dba',  
     Dt_Upd_On = GETDATE()  
    WHERE I_Product_ID = @iProductID  
        AND I_Center_ID = @iCenterID  
        AND I_Year = @iYear  
        AND I_Month = @iMonth    
   END  
  
 SET @iCount2 = @iCount2 +1  
END  
  
END TRY  
   BEGIN CATCH  
   --Error occurred:    
    DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int  
    SELECT @ErrMsg = ERROR_MESSAGE(),  
      @ErrSeverity = ERROR_SEVERITY()  
    RAISERROR(@ErrMsg, @ErrSeverity, 1)  
   END CATCH
