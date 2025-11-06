--[NETWORK].[uspGetCenterCreationHistory]  688  
  
CREATE PROCEDURE [NETWORK].[uspGetCenterCreationHistory]             
 @iCenterID INT              
AS              
BEGIN              
          
 CREATE TABLE #TempTable              
 (  
  SequenceID INT,                         
  Activity varchar(1000),              
  CreatedBy Varchar(50),                     
  DtCrtdOn Datetime,                         
  Reason varchar(1000)       
 )    
   
 DECLARE @sCurrency VARCHAR(10)          
 SET @sCurrency =   
(  
 SELECT DISTINCT S_Currency_Code FROM dbo.T_Currency_Master tcm  
INNER JOIN NETWORK.T_Agreement_Details t  
ON tcm.I_Currency_ID = t.I_Currency_ID  
WHERE I_Agreement_ID IN (SELECT I_Agreement_ID FROM NETWORK.T_Agreement_Center tac WHERE I_Centre_Id=@iCenterID)  
)  
 PRINT(@sCurrency)  
--query to fetch Agreement Create Activity  
INSERT INTO #TempTable  
SELECT 1,'Agreement Created' AS Activity, S_Crtd_By, Dt_Crtd_On,'--' AS Remarks FROM NETWORK.T_agreement_audit   
WHERE I_Agreement_ID IN (SELECT I_Agreement_ID FROM NETWORK.T_Agreement_Center tac WHERE I_Centre_Id = @iCenterID)  
AND I_Status=1  
  
--query to fetch BP Notifiaction Activity  
INSERT INTO #TempTable  
SELECT DISTINCT 2,'Notification Sent To BP' AS Activity, S_Crtd_By, Dt_Upd_On,'--' AS Remarks FROM NETWORK.T_agreement_audit   
WHERE I_Agreement_ID IN (SELECT I_Agreement_ID FROM NETWORK.T_Agreement_Center tac WHERE I_Centre_Id = @iCenterID)  
AND I_Status=2  
  
--query to fetch Agreement Reject Activity  
INSERT INTO #TempTable  
SELECT 3,'Agreement Rejected' AS Activity, S_Crtd_By, Dt_Upd_On, S_Reason AS Remarks FROM NETWORK.T_agreement_audit   
WHERE I_Agreement_ID IN (SELECT I_Agreement_ID FROM NETWORK.T_Agreement_Center tac WHERE I_Centre_Id = @iCenterID)  
AND I_Status=3  
  
--query to fetch Agreement Regeneration Activity  
INSERT INTO #TempTable  
SELECT 4,'Agreement Regenerated' AS Activity, S_Crtd_By, Dt_Upd_On, '--' AS Remarks FROM NETWORK.T_agreement_audit   
WHERE I_Agreement_ID IN (SELECT I_Agreement_ID FROM NETWORK.T_Agreement_Center tac WHERE I_Centre_Id = @iCenterID)  
AND I_Status=4  
  
--query to fetch Agreement Approve Activity  
IF EXISTS(SELECT 'TRUE' FROM NETWORK.T_agreement_audit   
WHERE I_Agreement_ID IN (SELECT I_Agreement_ID FROM NETWORK.T_Agreement_Center tac WHERE I_Centre_Id = @iCenterID)  
AND I_Status=5)  
BEGIN  
INSERT INTO #TempTable  
 SELECT TOP 1 5,'Agreement Approved' AS Activity, S_Upd_By, Dt_Upd_On, S_Reason AS Remarks FROM NETWORK.T_agreement_audit   
 WHERE I_Agreement_ID IN (SELECT I_Agreement_ID FROM NETWORK.T_Agreement_Center tac WHERE I_Centre_Id = @iCenterID)  
 AND I_Status=5  
 ORDER BY Dt_Upd_On  
END  
ELSE  
BEGIN  
INSERT INTO #TempTable  
 SELECT 5,'Agreement Approved' AS Activity, S_Upd_By, Dt_Upd_On, S_Reason AS Remarks FROM NETWORK.T_Agreement_Details t  
 WHERE I_Agreement_ID IN (SELECT I_Agreement_ID FROM NETWORK.T_Agreement_Center tac WHERE I_Centre_Id = @iCenterID)  
 AND I_Status=5  
END  
  
--query to fetch Center Creation Activity  
INSERT INTO #TempTable  
SELECT 6,'Center Created' AS Activity, S_Crtd_By, Dt_Crtd_On,'--' AS Remarks FROM dbo.T_Centre_Master tcm WHERE I_Centre_Id = @iCenterID  
  
  
--query to fetch Instance Create Activity  
INSERT INTO #TempTable  
SELECT 7,'Center Instance Created' AS Activity,S_Crtd_By,Dt_Crtd_On,'--' AS Remarks FROM dbo.T_Hierarchy_Details thd WHERE I_Hierarchy_Detail_ID  
IN   
(  
select I_Hierarchy_Detail_ID FROM dbo.T_Center_Hierarchy_Details WHERE I_Center_Id = @iCenterID  
)  
  
--query to fetch Add To Hierarchy Activity  
INSERT INTO #TempTable  
SELECT 8,'Center Added To Hierarchy' AS Activity,S_Crtd_By,Dt_Crtd_On,'--' AS Remarks FROM dbo.T_Hierarchy_Mapping_Details thmd  
WHERE I_Hierarchy_Detail_ID IN   
(  
select I_Hierarchy_Detail_ID FROM dbo.T_Center_Hierarchy_Details WHERE I_Center_Id = @iCenterID  
)  
  
--query to fetch Startup Payment Entry Activity  
INSERT INTO #TempTable  
SELECT 9,'Startup Payment of '+ CAST(D_Total_Amount AS varchar) + ' (' + @sCurrency + ') Entered' AS Activity,S_Crtd_By,Dt_Crtd_On,S_Remarks AS Remarks FROM NETWORK.T_Center_Payment_Details tcpd   
WHERE I_Centre_Id = @iCenterID AND I_Payment_Type= 8 AND I_Status IN (1,2,3) ORDER BY Dt_Crtd_On  
  
--query to fetch Startup Payment Approval Activity  
INSERT INTO #TempTable  
SELECT 10,'Startup Payment of '+ CAST(D_Total_Amount AS varchar) + ' (' + @sCurrency + ') Approved' AS Activity,S_Upd_By,Dt_Upd_On,S_Reason AS Remarks FROM NETWORK.T_Center_Payment_Details tcpd   
WHERE I_Centre_Id = @iCenterID AND I_Payment_Type= 8 AND S_Upd_By IS NOT NULL AND I_Status = 2 ORDER BY Dt_Upd_On  
  
--query to fetch Startup Payment Rejection Activity  
INSERT INTO #TempTable  
SELECT 11,'Startup Payment of '+ CAST(D_Total_Amount AS varchar) + ' (' + @sCurrency + ') Rejected' AS Activity,S_Upd_By,Dt_Upd_On,S_Reason AS Remarks FROM NETWORK.T_Center_Payment_Details tcpd   
WHERE I_Centre_Id = @iCenterID AND I_Payment_Type= 8 AND S_Upd_By IS NOT NULL AND I_Status = 3 ORDER BY Dt_Upd_On  
  
--query to fetch SAP update Activity  
INSERT INTO #TempTable  
SELECT 12,'Center Updated in SAP' AS Activity,S_Upd_By,Dt_Upd_On, '--' AS Remarks FROM NETWORK.T_Center_Master_Audit tcma   
WHERE I_Centre_Id=@iCenterID AND I_Status=5  
  
--query to fetch Infrastructure Detail Entry Activity  
INSERT INTO #TempTable  
SELECT TOP 1 13,'Center Infrastructure Entered' AS Activity, S_Crtd_By, Dt_Crtd_On, '--' as Remarks FROM NETWORK.T_Startup_Kit_Detail WHERE I_Centre_Id = @iCenterID ORDER BY Dt_Crtd_On desc  
  
----query to fetch Infrastructure Detail Notify Activity  
INSERT INTO #TempTable  
SELECT 14,'Center Infrastructure Details Sent For Approval' AS Activity, S_Crtd_By, Dt_Crtd_On, S_Reason AS Remarks FROM NETWORK.T_Center_InfrastructureRequest  
WHERE I_Centre_Id=@iCenterID  
  
--query to fetch Infrastructure Detail Approval Activity  
INSERT INTO #TempTable  
SELECT 15,'Center Infrastructure Details Approved' AS Activity, S_Upd_By, Dt_Upd_On, S_Reason AS Remarks FROM NETWORK.T_Center_InfrastructureRequest  
WHERE I_Centre_Id=@iCenterID AND I_Status =2  
  
--query to fetch Infrastructure Detail Rejection Activity  
INSERT INTO #TempTable  
SELECT 16,'Center Infrastructure Details Rejected' AS Activity, S_Upd_By, Dt_Upd_On, S_Reason AS Remarks FROM NETWORK.T_Center_InfrastructureRequest  
WHERE I_Centre_Id=@iCenterID AND I_Status =3  
  
  
--query to fetch Center Readiness Approval Activity  
IF EXISTS(SELECT 'TRUE' FROM NETWORK.T_Center_Master_Audit tcma   
WHERE I_Centre_Id=@iCenterID AND I_Status=8)  
BEGIN  
INSERT INTO #TempTable  
 SELECT 17,'Center Readiness Approved' AS Activity,S_Upd_By,Dt_Upd_On, '--' AS Remarks FROM NETWORK.T_Center_Master_Audit tcma   
WHERE I_Centre_Id=@iCenterID AND I_Status=8  
  
END  
ELSE  
BEGIN  
INSERT INTO #TempTable  
 SELECT 17,'Center Readiness Approved' AS Activity,S_Upd_By,Dt_Upd_On, '--' AS Remarks FROM t_centre_master   
 WHERE I_Centre_Id=@iCenterID AND I_Status =8  
  
END  
  
--query to fetch Feeplan Assignment Activity  
INSERT INTO #TempTable  
SELECT TOP 1 18,'Feeplan Assigned To Center' AS Activity, S_Crtd_By,dt_Crtd_On, '--' as Remarks from T_Course_Center_Detail  
WHERE I_Centre_Id=@iCenterID ORDER BY dt_Crtd_On  
  
--query to fetch Center Activation Activity  
INSERT INTO #TempTable  
SELECT Top 1 19,'Center Activated' AS Activity,S_Upd_By,Dt_Upd_On, '--' AS Remarks FROM NETWORK.T_Center_Master_Audit tcma   
WHERE I_Centre_Id=@iCenterID AND I_Status=1 ORDER BY Dt_Upd_On  
  
  
SELECT Activity,  
    CreatedBy,  
    DtCrtdOn,  
    Reason FROM #TempTable tt ORDER BY SequenceID,DtCrtdOn  
  
END
