CREATE PROCEDURE [MBP].[uspGetBooking]  
(   
 @iYear INT,  
 @iMonth INT,  
 @iCenterIDParam INT,  
 @MaxDateInMBPPerformance DATETIME   
)  
AS  
BEGIN TRY  
  
DECLARE @tempBook TABLE  
(  
ID INT IDENTITY(1,1),  
iCenterID INT,  
iStudentID INT,  
iBooking NUMERIC(18,2)  
)  
  
DECLARE @tempBookNew TABLE  
(  
ID INT IDENTITY(1,1),  
iCenterID INT,  
iProduct INT,  
iStudentID INT,  
iBooking NUMERIC(18,2)  
)  
  
INSERT INTO @tempBook (iStudentID,iBooking,iCenterID)  
SELECT I_Student_Detail_ID ,SUM(N_Invoice_Amount), I_Centre_Id FROM dbo.T_Invoice_Parent  
WHERE (DATEPART(mm,Dt_Crtd_On))  = @iMonth  
AND (DATEPART(yy,Dt_Crtd_On))  = @iYear  
AND Dt_Crtd_On > @MaxDateInMBPPerformance  
AND I_Centre_ID=@iCenterIDParam  
GROUP BY I_Centre_Id,I_Student_Detail_ID  
  
  
DECLARE @iRow INT  
DECLARE @iCount INT  
DECLARE @iStudent INT  
DECLARE @iBooking NUMERIC(18,2)  
DECLARE @iCenterID INT  
DECLARE @iProduct INT  
  
  
SET @iCount = 1  
SET @iRow = (SELECT COUNT(*) FROM @tempBook)  
  
WHILE(@iCount <= @iRow)  
  
 BEGIN  
  SELECT @iStudent=iStudentID ,@iBooking=iBooking, @iCenterID = iCenterID FROM @tempBook WHERE ID = @iCount  
    
  IF @iStudent IS NOT NULL  
   BEGIN  
    INSERT INTO @tempBookNew (iCenterID,iProduct,iBooking,iStudentID)  
    SELECT @iCenterID,iProductID,@iBooking,@iStudent FROM [MBP].[fnGetProductIDFromStudentID](@iStudent)  
   END   
  SET @iCount= @iCount+1  
  
 END  
  
--SELECT * FROM @tempBookNew  
  
  
DECLARE @iCount2 INT  
DECLARE @iRow2 INT  
DECLARE @iProductID INT  
DECLARE @iBook INT  
DECLARE @iBk INT  
SET @iCount2 = 1  
SET @iRow2 = (SELECT COUNT(*) FROM @tempBookNew)  
  
WHILE (@iCount2 <= @iRow2)  
 BEGIN  
  
  SELECT @iStudent=iStudentID ,   
  @iBk = iBooking,  
  @iCenterID = iCenterID ,   
  @iProductID =iProduct   
  FROM @tempBookNew WHERE ID = @iCount2  
  
  
  IF NOT EXISTS(SELECT * FROM MBP.T_MBPerformance WHERE I_Product_ID = @iProductID  
        AND I_Center_ID = @iCenterID  
        AND I_Year = @iYear  
        AND I_Month = @iMonth)  
   BEGIN   
      
  
    INSERT INTO MBP.T_MBPerformance (I_Product_ID,I_Center_ID,I_Month,I_Year,I_Actual_Booking,S_Crtd_By,Dt_Crtd_On)  
    VALUES (@iProductID,@iCenterID,@iMonth,@iYear,@iBk,'dba',GETDATE())  
   END  
  ELSE  
   BEGIN  
      SET @iBook = (SELECT ISNULL(I_Actual_Booking,0) FROM MBP.T_MBPerformance  
      WHERE   
      I_Product_ID = @iProductID  
      AND I_Center_ID = @iCenterID  
      AND I_Year = @iYear  
      AND I_Month = @iMonth)  
  
    SET @iBook = @iBook + @iBk  
      
    UPDATE MBP.T_MBPerformance  
    SET I_Actual_Booking = @iBook,  
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
