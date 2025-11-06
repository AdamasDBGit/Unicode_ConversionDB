-- =============================================  
-- Author:  Shankha Roy  
-- Create date: 19/07/2007  
-- Description: This sp return the detail of upload document  
-- =============================================  
CREATE PROCEDURE [MBP].[uspGetMBPDetail]  
(      
 @iYear INT = NULL,  
 @iMonth INT = NULL,  
 --@iCenterID INT  = NULL,  
 @iCenterID VARCHAR(8000)  = NULL,  
 @sProduct VARCHAR(50)  = NULL,  
 @iProduct VARCHAR(2000)  = NULL,  
 @iStatusID INT = NULL,  
 @iMBPPlanType INT = NULL,  
 @iHierarchyDetailID INT = NULL,  
 @iBrandID INT = NULL  
)  
AS  
 BEGIN TRY    
 ---PRINT @iCenterID  
IF @iMBPPlanType = 4 -- For only MBP DATA    
BEGIN -- MBP DATA  
  
 -- DECLARE NEW table for get data for Audit table  
 DECLARE @TblABP TABLE  
 (  
 ID INT IDENTITY (1,1),  
 I_MBP_Detail_ID INT,  
 I_Product_ID INT,  
 I_Center_ID INT,  
 I_Year INT,  
 I_Month INT,  
 I_Target_Enquiry INT,  
 I_Target_Booking NUMERIC(18,2),  
 I_Target_Enrollment INT,  
 I_Target_Billing NUMERIC(18,2),  
 I_Target_RFF NUMERIC(18,2),  
 I_Status_ID INT,  
 I_Type_ID INT,  
 S_Remarks VARCHAR(500),  
 S_Center_Name VARCHAR(100),  
 S_Center_Code VARCHAR(50),  
 S_Product_Name VARCHAR(100),   
 S_Currency_Code VARCHAR(20),  
 I_Currency_ID INT  
 )  
  
  
-- Check the dummy product id for enquiry   
IF(@sProduct IS NOT NULL)  
BEGIN  
 SET @iProduct = (SELECT DISTINCT(PM.I_Product_ID) FROM MBP.T_Product_Master PM  
 INNER JOIN MBP.T_Product_Component PC  
 ON PM.I_Product_ID=PC.I_Product_ID   
 LEFT OUTER JOIN dbo.T_Course_Master CM  
 ON CM.I_Course_ID = PC.I_Course_ID  
 LEFT OUTER JOIN dbo.T_CourseFamily_Master CFM  
 ON CFM.I_CourseFamily_ID = PC.I_Course_Family_ID  
 WHERE PM.S_Product_Name = @sProduct  
 AND CM.I_Brand_ID  =@iBrandID)  
END  
  
  
-- Check for Type Is it ABP or MBP   
  INSERT INTO  @TblABP  
   (  
   I_MBP_Detail_ID ,  
   I_Product_ID ,  
   I_Center_ID ,  
   I_Year ,  
   I_Month,  
   I_Target_Enquiry ,  
   I_Target_Booking ,  
   I_Target_Enrollment ,  
   I_Target_Billing ,  
   I_Target_RFF,  
   I_Status_ID ,  
   I_Type_ID,  
   S_Remarks,  
   S_Center_Name,  
   S_Center_Code,  
   S_Product_Name,     
   S_Currency_Code ,  
   I_Currency_ID   
   )  
   SELECT   
   ISNULL(MBP.I_MBP_Detail_ID,0) AS I_MBP_Detail_ID,  
   MBP.I_Product_ID,  
   MBP.I_Center_ID,  
   MBP.I_Year,  
   MBP.I_Month,  
   ISNULL(MBP.I_Target_Enquiry,0)AS I_Target_Enquiry,  
   ISNULL(MBP.I_Target_Booking,0) AS I_Target_Booking,  
   ISNULL(MBP.I_Target_Enrollment,0) AS I_Target_Enrollment,  
   ISNULL(MBP.I_Target_Billing,0) AS I_Target_Billing,  
   ISNULL(MBP.I_Target_RFF,0) AS I_Target_RFF,  
   MBP.I_Status_ID,  
   MBP.I_Type_ID ,  
   ISNULL(MBP.S_Remarks,'') AS S_Remarks,  
   ISNULL(CEN.S_Center_Name,'') AS S_Center_Name,  
   ISNULL(CEN.S_Center_Code,'') AS S_Center_Code,  
   PROD.S_Product_Name  AS S_Product_Name,  
   CURM.S_Currency_Code AS S_Currency_Code,  
   TCM.I_Currency_ID  
   FROM MBP.T_MBP_Detail MBP     
   LEFT OUTER JOIN dbo.T_Centre_Master CEN  
   ON MBP.I_Center_ID = CEN.I_Centre_ID  
   LEFT OUTER JOIN MBP.T_Product_Master PROD  
   ON MBP.I_Product_ID = PROD.I_Product_ID  
   INNER JOIN dbo.T_Country_Master TCM  
   ON CEN.I_Country_ID = TCM.I_Country_ID  
   INNER JOIN dbo.T_Currency_Master CURM  
   ON CURM.I_Currency_ID = TCM.I_Currency_ID  
   WHERE   
   MBP.I_Year = COALESCE( @iYear,I_Year)  
   AND MBP.I_Month = COALESCE(@iMonth,I_Month)  
   AND MBP.I_Center_ID IN (SELECT ID FROM [dbo].[fnSplitter](@iCenterID))  
   AND MBP.I_Product_ID = COALESCE(@iProduct,MBP.I_Product_ID)  
   --AND MBP.I_Product_ID IN (SELECT ID FROM [dbo].[fnSplitter](@iProduct))  
   AND MBP.I_Status_ID = COALESCE(@iStatusID,MBP.I_Status_ID)  
   AND I_Type_ID = COALESCE(@iMBPPlanType,I_Type_ID)  
  
  
  -- for Aduit table data  
  INSERT INTO  @TblABP  
   (  
   I_MBP_Detail_ID ,  
   I_Product_ID ,  
   I_Center_ID ,  
   I_Year ,  
   I_Month,  
   I_Target_Enquiry ,  
   I_Target_Booking ,  
   I_Target_Enrollment ,  
   I_Target_Billing ,  
   I_Target_RFF ,  
   I_Status_ID ,  
   I_Type_ID,  
   S_Remarks,  
   S_Center_Name,  
   S_Center_Code,  
   S_Product_Name,     
   S_Currency_Code,  
   I_Currency_ID   
   )  
   SELECT   
   ISNULL(MBP.I_MBP_Detail_ID,0) AS I_MBP_Detail_ID,  
   MBP.I_Product_ID,  
   MBP.I_Center_ID,  
   MBP.I_Year,  
   MBP.I_Month,  
   ISNULL(MBP.I_Target_Enquiry,0)AS I_Target_Enquiry,  
   ISNULL(MBP.I_Target_Booking,0) AS I_Target_Booking,  
   ISNULL(MBP.I_Target_Enrollment,0) AS I_Target_Enrollment,  
   ISNULL(MBP.I_Target_Billing,0) AS I_Target_Billing,  
   ISNULL(MBP.I_Target_RFF,0) AS I_Target_RFF,  
   MBP.I_Status_ID,  
   MBP.I_Type_ID ,  
   ISNULL(MBP.S_Remarks,'') AS S_Remarks,  
   ISNULL(CEN.S_Center_Name,'') AS S_Center_Name,  
   ISNULL(CEN.S_Center_Code,'') AS S_Center_Code,     
   PROD.S_Product_Name  AS S_Product_Name,  
   CURM.S_Currency_Code AS S_Currency_Code,  
   TCM.I_Currency_ID  
   FROM MBP.T_MBP_Detail_Audit MBP     
   LEFT OUTER JOIN dbo.T_Centre_Master CEN  
   ON MBP.I_Center_ID = CEN.I_Centre_ID  
   LEFT OUTER JOIN MBP.T_Product_Master PROD  
   ON MBP.I_Product_ID = PROD.I_Product_ID  
   INNER JOIN dbo.T_Country_Master TCM  
   ON CEN.I_Country_ID = TCM.I_Country_ID  
   INNER JOIN dbo.T_Currency_Master CURM  
   ON CURM.I_Currency_ID = TCM.I_Currency_ID  
   WHERE   
   MBP.I_Year = COALESCE( @iYear,I_Year)  
   AND MBP.I_Month = COALESCE(@iMonth,I_Month)  
   AND MBP.I_Center_ID IN (SELECT ID FROM [dbo].[fnSplitter](@iCenterID))  
   --AND MBP.I_Product_ID IN (SELECT ID FROM [dbo].[fnSplitter](@iProduct))  
   AND MBP.I_Product_ID = COALESCE(@iProduct,MBP.I_Product_ID)  
   AND MBP.I_Status_ID = COALESCE(@iStatusID,MBP.I_Status_ID)  
   AND I_Type_ID = COALESCE(@iMBPPlanType,I_Type_ID)  
  
           SELECT * from @TblABP ORDER BY I_MBP_Detail_ID  
  
END   
ELSE  
BEGIN  
  SELECT DISTINCT  
  ISNULL(MBP.I_MBP_Detail_ID,0) AS I_MBP_Detail_ID,  
  MBP.I_Product_ID,  
  MBP.I_Center_ID,  
  MBP.I_Year,  
  MBP.I_Month,  
  ISNULL(MBP.I_Target_Enquiry, 0) AS I_Target_Enquiry ,  
  ISNULL(MBP.I_Target_Booking,0) AS I_Target_Booking,  
  ISNULL(MBP.I_Target_Enrollment,0) AS I_Target_Enrollment,  
  ISNULL(MBP.I_Target_Billing,0) AS I_Target_Billing,  
  ISNULL(MBP.I_Target_RFF,0) AS I_Target_RFF,  
  MBP.I_Status_ID,  
  ISNULL(MBP.S_Remarks,'') AS S_Remarks,  
  ISNULL(CEN.S_Center_Name,'') AS S_Center_Name,  
  ISNULL(CEN.S_Center_Code,'') AS S_Center_Code,  
  PROD.S_Product_Name  AS S_Product_Name,  
  CURM.S_Currency_Code AS S_Currency_Code,  
  TCM.I_Currency_ID  
  FROM MBP.T_MBP_Detail MBP  
    
  LEFT OUTER JOIN dbo.T_Centre_Master CEN  
  ON MBP.I_Center_ID = CEN.I_Centre_ID  
  LEFT OUTER JOIN MBP.T_Product_Master PROD  
  ON MBP.I_Product_ID = PROD.I_Product_ID  
  INNER JOIN dbo.T_Country_Master TCM  
  ON CEN.I_Country_ID = TCM.I_Country_ID  
  INNER JOIN dbo.T_Currency_Master CURM  
  ON CURM.I_Currency_ID = TCM.I_Currency_ID  
  
  WHERE   
  MBP.I_Year = COALESCE( @iYear,I_Year)  
  AND MBP.I_Month = COALESCE(@iMonth,I_Month)  
  --AND MBP.I_Center_ID = COALESCE(@iCenterID,MBP.I_Center_ID)  
  AND MBP.I_Center_ID IN (SELECT ID FROM [dbo].[fnSplitter](@iCenterID))  
  --AND MBP.I_Product_ID IN (SELECT ID FROM [dbo].[fnSplitter](@iProduct))  
  AND MBP.I_Product_ID = COALESCE(@iProduct,MBP.I_Product_ID)  
  AND MBP.I_Status_ID = COALESCE(@iStatusID,MBP.I_Status_ID)  
  AND I_Type_ID = COALESCE(@iMBPPlanType,I_Type_ID)  
  --AND I_Type_ID IS NULL  
  --AND MBP.I_Center_ID<>0  
 END   
  
  
 END TRY  
   BEGIN CATCH  
   --Error occurred:    
    DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int  
    SELECT @ErrMsg = ERROR_MESSAGE(),  
      @ErrSeverity = ERROR_SEVERITY()  
    RAISERROR(@ErrMsg, @ErrSeverity, 1)  
   END CATCH
