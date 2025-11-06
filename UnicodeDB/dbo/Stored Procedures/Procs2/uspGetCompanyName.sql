CREATE PROCEDURE [dbo].[uspGetCompanyName] ---738  
  
 @iCentreID INT  
  
AS  
BEGIN  
  
 SET NOCOUNT OFF;  
  
 SELECT TCM.I_Centre_Id,TCM.S_Center_Name,TAC.I_Agreement_Center_ID,TBM.S_Brand_Name AS S_Company_Name FROM dbo.T_Centre_Master AS TCM  
 INNER JOIN NETWORK.T_Agreement_Center AS TAC  
 ON TCM.I_Centre_Id = TAC.I_Centre_Id  
 INNER JOIN NETWORK.T_Agreement_Details AS TAD  
 ON TAC.I_Agreement_ID = TAD.I_Agreement_ID  
 INNER JOIN dbo.T_Brand_Master TBM ON  TAD.I_Brand_ID = TBM.I_Brand_ID
 WHERE TCM.I_Centre_Id = @iCentreID  
   
END
