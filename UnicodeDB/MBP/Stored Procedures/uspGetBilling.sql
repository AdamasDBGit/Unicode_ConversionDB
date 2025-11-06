CREATE PROCEDURE [MBP].[uspGetBilling]  
(   
 @iYear INT,  
 @iMonth INT,  
 @iCenterIDParam INT,  
 @MaxDateInMBPPerformance DATETIME   
)  
AS  
BEGIN TRY  
  
DECLARE @tempBill TABLE  
(  
ID INT IDENTITY(1,1),  
iBilling NUMERIC(18,2),  
iCenterID INT,  
iStudentID INT  
)  
  
DECLARE @tempBillNew TABLE  
(  
ID INT IDENTITY(1,1),  
iBilling NUMERIC(18,2),  
iCenterID INT,  
iProduct INT,  
iStudentID INT  
)  
  
INSERT INTO @tempBill (iBilling,iCenterID,iStudentID)  
SELECT SUM(N_Receipt_Amount),I_Centre_Id, I_Student_Detail_ID FROM dbo.T_Receipt_Header  
WHERE (DATEPART(mm,Dt_Crtd_On))  = @iMonth  
AND (DATEPART(yy,Dt_Crtd_On))  = @iYear  
AND Dt_Crtd_On > @MaxDateInMBPPerformance  
AND I_Centre_ID=@iCenterIDParam  
GROUP BY I_Centre_Id,I_Student_Detail_ID  
  
  
DECLARE @iRow INT  
DECLARE @iCount INT  
DECLARE @iStudent INT  
DECLARE @iBilling INT  
DECLARE @iCenterID INT  
DECLARE @iProduct INT  
DECLARE @iBrandID INT
  
SET @iCount = 1  
SET @iRow = (SELECT COUNT(*) FROM @tempBill)  
  
WHILE(@iCount <= @iRow)  
  
 BEGIN  
  SELECT @iStudent=iStudentID , @iBilling = iBilling,@iCenterID = iCenterID FROM @tempBill WHERE ID = @iCount  
    
  SELECT @iBrandID = [TBCD].[I_Brand_ID] FROM [dbo].[T_Brand_Center_Details] AS TBCD 
   WHERE [TBCD].[I_Centre_Id] = @iCenterID
    
  IF @iStudent IS NOT NULL  
   BEGIN  
    INSERT INTO @tempBillNew (iBilling,iCenterID,iProduct,iStudentID)          
    --SELECT @iBilling,@iCenterID,iProductID,@iStudent FROM [MBP].[fnGetProductIDFromStudentID](@iStudent)  
    SELECT @iBilling,@iCenterID,iProductID,@iStudent FROM [MBP].[fnGetDefaultProductIDFromBrandID](@iBrandID)
   END   
  SET @iCount= @iCount+1  
  
 END  
  
--SELECT * FROM @tempBillNew  
  
  
  
DECLARE @iCount2 INT  
DECLARE @iRow2 INT  
DECLARE @iProductID INT  
DECLARE @iBill INT  
DECLARE @iBilling2 INT  
SET @iCount2 = 1  
SET @iRow2 = (SELECT COUNT(*) FROM @tempBillNew)  
  
WHILE (@iCount2 <= @iRow2)  
 BEGIN  
  
  SELECT @iStudent=iStudentID ,   
  @iBill = iBilling,  
  @iCenterID = iCenterID ,   
  @iProductID =iProduct   
  FROM @tempBillNew WHERE ID = @iCount2  
  
  IF NOT EXISTS(SELECT * FROM MBP.T_MBPerformance WHERE I_Product_ID = @iProductID  
        AND I_Center_ID = @iCenterID  
        AND I_Year = @iYear  
        AND I_Month = @iMonth)  
   BEGIN        
  
    INSERT INTO MBP.T_MBPerformance (I_Product_ID,I_Center_ID,I_Month,I_Year,I_Actual_Billing,S_Crtd_By,Dt_Crtd_On)  
    VALUES (@iProductID,@iCenterID,@iMonth,@iYear,@iBill,'dba',GETDATE())  
   END  
  ELSE  
   BEGIN  
      SET @iBilling2 = (SELECT ISNULL(I_Actual_Billing,0) FROM MBP.T_MBPerformance  
      WHERE   
      I_Product_ID = @iProductID  
      AND I_Center_ID = @iCenterID  
      AND I_Year = @iYear  
      AND I_Month = @iMonth)  
  
    SET @iBilling2 = @iBilling2 + @iBill  
      
    UPDATE MBP.T_MBPerformance  
    SET I_Actual_Billing = @iBilling2,  
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
