/*  
-- =================================================================  
-- Author:Babin SAha  
-- Create date:07/28/2007   
-- Description: SP For Audit Track Report  
   
-- =================================================================  
*/  
--EXEC [REPORT].[uspAuditTrackReport] @iBrandID = 22, @sHierarchyList = N'2', @dtStartDate = N'01-01-2005', @dtEndDate = '01-01-2009'  
CREATE PROCEDURE [REPORT].[uspAuditTrackReport]  
(  
 @iBrandID INT = NULL,  
 @sHierarchyList VARCHAR(MAX) = NULL,  
 @dtStartDate DATETIME,  
 @dtEndDate DATETIME,  
 @sAuditorFName VARCHAR(100) = NULL,  
 @sAuditorMName VARCHAR(100) = NULL,  
 @sAuditorLName VARCHAR(100) = NULL  
)  
AS  
BEGIN TRY  
  
DECLARE @BrandName VARCHAR (1000)  
DECLARE @BrandCode VARCHAR (1000)  
DECLARE @AuditorID int  
DECLARE @AuditorCount int  
  
SELECT @BrandCode = S_Brand_Code,@BrandName=S_Brand_Name FROM dbo.T_Brand_Master WHERE I_Brand_ID = @iBrandID  
  
IF(@sAuditorFName = '')   
BEGIN  
SET @sAuditorFName = NULL  
END

IF(@sAuditorMName = '')   
BEGIN  
SET @sAuditorMName = NULL  
END

IF(@sAuditorLName = '')   
BEGIN  
SET @sAuditorLName = NULL  
END
  
SELECT   
  @BrandName AS BrandName   
  ,@BrandCode AS BrandCode   
  ,ADT.I_Audit_Schedule_ID  
  ,RES.I_Audit_Result_ID  
  ,FN1.CenterCode AS CenterCode   
  ,FN1.CenterName AS CenterName  
  ,FN2.InstanceChain AS InstanceChain  
  ,SUBSTRING(FN2.InstanceChain, LEN(FN2.InstanceChain) - CHARINDEX('-',REVERSE(FN2.InstanceChain)) + 2, LEN(FN2.InstanceChain) - CHARINDEX('-',REVERSE(FN2.InstanceChain))) AS RegionName  
  --,(SUBSTRING(REPLACE((REPLACE(FN2.InstanceChain,' ','')),' ',''),(CHARINDEX('n-',(REPLACE(FN2.InstanceChain,' ','')),0) + 2),(CHARINDEX(';C',(REPLACE(FN2.InstanceChain,' ','')),0) - (CHARINDEX('n-',(REPLACE(FN2.InstanceChain,' ','')),0)+2)))) AS RegionName  
  ,ISNULL(CONVERT(VARCHAR,ADT.Dt_Audit_On,101),'1/1/1') AS AuditDate  
  ,ISNULL(CONVERT(VARCHAR,RES.Dt_Report_Date,110),'1/1/1') AS ReportDate  
  ,ISNULL(CONVERT(VARCHAR,RES.Dt_Upd_On,101),'1/1/1') AS NCRDate  
  ,RES.F_Par_Score AS PARValue  
  ,COUNT(NCR.I_Audit_Report_NCR_ID) AS NoOfCriticalIssue  
   
  FROM AUDIT.T_Audit_Schedule ADT
  INNER JOIN [dbo].[T_User_Master] AS TUM ON [ADT].[I_User_ID] = [TUM].[I_User_ID]
  INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID) FN1  
  ON ADT.I_Center_Id=FN1.CenterID  
  LEFT OUTER JOIN  [dbo].[fnGetInstanceNameChainForReports](@sHierarchyList, @iBrandID) FN2  
  ON FN1.HierarchyDetailID=FN2.HierarchyDetailID  
  LEFT OUTER JOIN AUDIT.T_Audit_Result RES  
  ON ADT.I_Audit_Schedule_ID= RES.I_Audit_Schedule_ID  
  LEFT OUTER JOIN AUDIT.T_Audit_Result_NCR NCR  
  ON RES.I_Audit_Result_ID = NCR.I_Audit_Result_ID AND NCR.I_NCR_Type_ID=1    
  WHERE   
  ADT.Dt_Audit_On >= @dtStartDate AND ADT.Dt_Audit_On < @dtEndDate   
  AND [TUM].[S_First_Name] = ISNULL(@sAuditorFName,[TUM].[S_First_Name])
  AND [TUM].[S_Middle_Name] = ISNULL(@sAuditorMName,[TUM].[S_Middle_Name])
  AND [TUM].[S_Last_Name] = ISNULL(@sAuditorLName,[TUM].[S_Last_Name])
    
  GROUP BY   
  NCR.I_Audit_Result_ID  
  ,ADT.I_Audit_Schedule_ID  
  ,RES.I_Audit_Result_ID  
  ,FN1.CenterCode  
  ,FN1.CenterName  
  ,FN2.InstanceChain  
  ,ADT.Dt_Audit_On  
  ,RES.Dt_Report_Date  
  ,RES.Dt_Upd_On  
  ,RES.F_Par_Score  
  
  ORDER BY ADT.Dt_Audit_On ASC  
  
  
END TRY  
  
BEGIN CATCH  
 --Error occurred:    
  
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int  
 SELECT @ErrMsg = ERROR_MESSAGE(),  
   @ErrSeverity = ERROR_SEVERITY()  
   
 RAISERROR(@ErrMsg, @ErrSeverity, 1)  
END CATCH
