CREATE PROCEDURE [MBP].[uspGetRFF]  
(   
 @iYear INT,  
 @iMonth INT,  
 @iBrandID INT,  
 @MaxDateInMBPPerformance DATETIME,
 @iCenter_Id int   
)  
AS  
BEGIN TRY  
  
DECLARE @tempRFF TABLE  
(  
ID INT IDENTITY(1,1),  
iRFF NUMERIC(18,2),  
iCenterID INT,  
iStudentID INT  
)  
  
DECLARE @tempRFFNew TABLE  
(  
ID INT IDENTITY(1,1),  
iRFF NUMERIC(18,2),  
iCenterID INT,  
iProduct INT,  
iStudentID INT  
)  
  
INSERT INTO @tempRFF (iRFF,iCenterID,iStudentID)  
SELECT SUM(N_Amount_Rff),I_Centre_Id, I_Student_Detail_ID FROM dbo.T_Receipt_Header  
WHERE I_Centre_Id = @iCenter_Id 
AND(DATEPART(mm,Dt_Crtd_On))  = @iMonth  
AND (DATEPART(yy,Dt_Crtd_On))  = @iYear  
AND Dt_Crtd_On > @MaxDateInMBPPerformance
GROUP BY I_Centre_Id,I_Student_Detail_ID  
  
  
DECLARE @iRow INT  
DECLARE @iCount INT  
DECLARE @iStudent INT  
DECLARE @iRFF NUMERIC(18,2)  
DECLARE @iCenterID INT  
DECLARE @iProduct INT  
  
  
SET @iCount = 1  
SET @iRow = (SELECT COUNT(*) FROM @tempRFF)  
  
WHILE(@iCount <= @iRow)  
  
 BEGIN  
  SELECT @iStudent=iStudentID , @iRFF = iRFF,@iCenterID = iCenterID FROM @tempRFF WHERE ID = @iCount  
    
  IF @iStudent IS NOT NULL  
   BEGIN  
    INSERT INTO @tempRFFNew (iRFF,iCenterID,iProduct,iStudentID)  
    --SELECT @iRFF,@iCenterID,iProductID,@iStudent FROM [MBP].[fnGetProductIDFromStudentID](@iStudent)--Modification for Default Product  
    SELECT @iRFF,@iCenterID,iProductID,@iStudent FROM [MBP].[fnGetDefaultProductIDFromBrandID](@iBrandID)  
   END   
  SET @iCount= @iCount+1  
  
 END  
  
--SELECT * FROM @tempBillNew  
  
  
  
DECLARE @iCount2 INT  
DECLARE @iRow2 INT  
DECLARE @iProductID INT  
DECLARE @iRFF1 INT  
DECLARE @iRFF2 INT  
SET @iCount2 = 1  
SET @iRow2 = (SELECT COUNT(*) FROM @tempRFFNew)  
  
WHILE (@iCount2 <= @iRow2)  
 BEGIN  
  
  SELECT @iStudent=iStudentID ,   
  @iRFF1 = iRFF,  
  @iCenterID = iCenterID ,   
  @iProductID =iProduct   
  FROM @tempRFFNew WHERE ID = @iCount2  and iCenterID = @iCenter_Id
  
  IF NOT EXISTS(SELECT * FROM MBP.T_MBPerformance WHERE I_Product_ID = @iProductID  
        AND I_Center_ID = @iCenterID  
        AND I_Year = @iYear  
        AND I_Month = @iMonth)  
   BEGIN        
  
    INSERT INTO MBP.T_MBPerformance (I_Product_ID,I_Center_ID,I_Month,I_Year,I_Actual_RFF,S_Crtd_By,Dt_Crtd_On)  
    VALUES (@iProductID,@iCenterID,@iMonth,@iYear,@iRFF1,'dba',GETDATE())  
   END  
  ELSE  
   BEGIN  
      SET @iRFF2 = (SELECT ISNULL(I_Actual_RFF,0) FROM MBP.T_MBPerformance  
      WHERE   
      I_Product_ID = @iProductID  
      AND I_Center_ID = @iCenterID  
      AND I_Year = @iYear  
      AND I_Month = @iMonth)  
  
    SET @iRFF2 = @iRFF2 + @iRFF1  
      
    UPDATE MBP.T_MBPerformance  
    SET I_Actual_RFF = @iRFF2,  
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
