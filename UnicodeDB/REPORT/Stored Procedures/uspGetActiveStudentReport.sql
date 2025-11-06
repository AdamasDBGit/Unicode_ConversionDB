-- =============================================  
-- Author:  Santanu Maity  
-- Create date: 06/15/2007  
-- Description: To get Active Student List  
-- =============================================  
--sp_helptext '[REPORT].[uspGetActiveStudentReport]'  
  
CREATE PROCEDURE [REPORT].[uspGetActiveStudentReport]   
(  
-- Add the parameters for the stored procedure here  
 @sHierarchyList varchar(MAX),  
 @iBrandID int,
 @iBatchID INT = NULL   
)  
AS  
  
BEGIN TRY  
 BEGIN   
  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON;  
  
  SELECT DISTINCT  
   SD.S_Student_ID,  
   LTRIM(ISNULL(SD.S_Title,'') + ' ') + SD.S_First_Name + ' ' + LTRIM(ISNULL(SD.S_Middle_Name,'') + ' ' + SD.S_Last_Name) as StudentName,  
   CM.S_Course_Code,  
   CM.S_Course_Name,  
   FN1.CenterCode,  
   FN1.CenterName,  
   FN2.InstanceChain,
   TSBM.S_Batch_Name,
   TSBM.I_Batch_ID  
  FROM   
   dbo.T_Student_Detail SD  
   INNER JOIN dbo.T_Student_Batch_Details AS TSBD  
    ON SD.I_Student_Detail_ID = TSBD.I_Student_ID  
    AND TSBD.I_Status = SD.I_Status  
    --AND SCD.I_Is_Completed = 'False'  
    AND TSBD.I_Status = 1  
    AND SD.I_Status = 1 
   INNER JOIN dbo.T_Student_Center_Detail SC  
    ON SC.I_Student_Detail_ID = TSBD.I_Student_ID  
    AND SC.I_Status = 1  
   INNER JOIN dbo.T_Center_Batch_Details AS TCBD
   ON TSBD.I_Batch_ID = TCBD.I_Batch_ID
   AND SC.I_Centre_Id = TCBD.I_Centre_Id
   AND ISNULL(TCBD.I_Status,2) <> 5
   INNER JOIN dbo.T_Student_Batch_Master AS TSBM
   ON TCBD.I_Batch_ID = TSBM.I_Batch_ID 
   INNER JOIN dbo.T_Course_Master CM  
    ON TSBM.I_Course_ID = CM.I_Course_ID  
   INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID) FN1  
    ON SC.I_Centre_Id=FN1.CenterID  
   INNER JOIN [dbo].[fnGetInstanceNameChainForReports](@sHierarchyList, @iBrandID) FN2  
    ON FN1.HierarchyDetailID=FN2.HierarchyDetailID  
	WHERE   TSBD.I_Batch_ID = ISNULL(@iBatchID, TSBD.I_Batch_ID)
   ORDER By FN2.InstanceChain,FN1.CenterName,SD.S_Student_ID,CM.S_Course_Name,TSBM.S_Batch_Name   
 END  
END TRY  
  
BEGIN CATCH  
   
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int  
  
 SELECT @ErrMsg = ERROR_MESSAGE(),  
   @ErrSeverity = ERROR_SEVERITY()  
  
 RAISERROR(@ErrMsg, @ErrSeverity, 1)  
END CATCH
