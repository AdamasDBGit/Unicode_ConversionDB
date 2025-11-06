CREATE PROCEDURE [MBP].[uspGetEnquiry]    
(     
 @iYear INT,    
 @iMonth INT,    
 @iCenterIDParam INT,    
 @MaxDateInMBPPerformance DATETIME     
)    
AS    
BEGIN TRY    
    
DECLARE @tempEnq TABLE    
(    
ID INT IDENTITY(1,1),    
iEnquiry INT,    
iCenterID INT,    
iCourseID INT    
    
)    
    
DECLARE @tempEnqNew TABLE    
(    
ID INT IDENTITY(1,1),    
iEnquiry INT,    
iCenterID INT,    
iCourseID INT,    
iProduct INT    
)    
    
INSERT INTO @tempEnq (iEnquiry,iCenterID,iCourseID)    
SELECT COUNT(ERD.I_Enquiry_Regn_ID),ERD.I_Centre_Id, I_Course_ID FROM     
dbo.T_Enquiry_Regn_Detail ERD    
INNER JOIN dbo.T_Enquiry_Course EC    
ON ERD.I_Enquiry_Regn_ID = EC.I_Enquiry_Regn_ID    
WHERE (DATEPART(mm,Dt_Crtd_On))  = @iMonth    
AND (DATEPART(yy,Dt_Crtd_On))  = @iYear    
AND Dt_Crtd_On > @MaxDateInMBPPerformance    
AND ERD.I_Centre_ID=@iCenterIDParam    
GROUP BY ERD.I_Centre_Id ,I_Course_ID    
    
DECLARE @iRow INT    
DECLARE @iCount INT    
DECLARE @iCourse INT    
DECLARE @iEnquiry INT    
DECLARE @iCenterID INT    
DECLARE @iProduct INT    
DECLARE @iBrandID INT
    
SET @iCount =1    
SET @iRow = (SELECT COUNT(*) FROM @tempEnq )    
    
WHILE(@iCount<= @iRow)    
 BEGIN    
  SELECT @iCourse=iCourseID , @iEnquiry = iEnquiry,@iCenterID = iCenterID FROM @tempEnq WHERE ID = @iCount    
      
  IF @iCenterID IS NOT NULL    
   BEGIN    
   
   SELECT @iBrandID = [TBCD].[I_Brand_ID] FROM [dbo].[T_Brand_Center_Details] AS TBCD 
   WHERE [TBCD].[I_Centre_Id] = @iCenterID
   
    INSERT INTO @tempEnqNew (iEnquiry,iCenterID,iCourseID,iProduct)    
    --SELECT @iEnquiry,@iCenterID,@iCourse,iProductID FROM [MBP].fnGetProductIDFromCourseID(@iCourse)    
    SELECT @iEnquiry,@iCenterID,@iCourse,iProductID FROM [MBP].[fnGetDefaultProductIDFromBrandID](@iBrandID)
   END     
  SET @iCount= @iCount+1    
 END    
    
--SELECT * FROM @tempEnqNew    

DECLARE @tempEnqNew1 TABLE    
(    
ID INT IDENTITY(1,1),    
iEnquiryCount INT,    
iCenterID INT,   
iProduct INT    
)

insert into @tempEnqNew1
select sum(iEnquiry),iCenterID,iProduct
from @tempEnqNew
group by iCenterId,iProduct
 
select * from @tempEnqNew1
    
-- Enquiry    
    
DECLARE @iCount2 INT    
DECLARE @iRow2 INT    
DECLARE @iProductID INT    
DECLARE @iEnqu INT    
DECLARE @iEnroll INT    
SET @iCount2 = 1    
SET @iRow2 = (SELECT COUNT(*) FROM @tempEnqNew1)    
  /*
WHILE (@iCount2 <= @iRow2)    
 BEGIN    
    
  SELECT     
  @iEnquiry = iEnquiryCount,    
  @iCenterID = iCenterID ,     
  @iProductID =iProduct     
  FROM @tempEnqNew1 WHERE ID = @iCount2    
    
  IF NOT EXISTS(SELECT * FROM MBP.T_MBPerformance WHERE I_Product_ID = @iProductID    
        AND I_Center_ID = @iCenterID    
        AND I_Year = @iYear    
        AND I_Month = @iMonth)    
   BEGIN          
    
    INSERT INTO MBP.T_MBPerformance (I_Product_ID,I_Center_ID,I_Month,I_Year,I_Actual_Enquiry,S_Crtd_By,Dt_Crtd_On)    
    VALUES (@iProductID,@iCenterID,@iMonth,@iYear,@iEnquiry,'dba',GETDATE())    
   END    
  ELSE    
   BEGIN    
      SET @iEnqu = (SELECT ISNULL(I_Actual_Enquiry,0) FROM MBP.T_MBPerformance    
      WHERE     
      I_Product_ID = @iProductID    
      AND I_Center_ID = @iCenterID    
      AND I_Year = @iYear    
      AND I_Month = @iMonth)
    
    SET @iEnqu = @iEnqu + @iEnquiry 
   
    UPDATE MBP.T_MBPerformance    
    SET I_Actual_Enquiry = @iEnqu,    
     S_Upd_By ='dba',    
     Dt_Upd_On = GETDATE()    
    WHERE I_Product_ID = @iProductID    
        AND I_Center_ID = @iCenterID    
        AND I_Year = @iYear    
        AND I_Month = @iMonth      
   END    
    
 SET @iCount2 = @iCount2 +1    
END   */   
END TRY    
   BEGIN CATCH    
   --Error occurred:      
    DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int    
    SELECT @ErrMsg = ERROR_MESSAGE(),    
      @ErrSeverity = ERROR_SEVERITY()    
    RAISERROR(@ErrMsg, @ErrSeverity, 1)    
   END CATCH
