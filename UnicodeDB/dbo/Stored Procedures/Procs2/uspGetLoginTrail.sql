CREATE PROCEDURE [dbo].[uspGetLoginTrail]   
(  
 @dFromDate DATETIME =NULL,  
 @dToDate DATETIME =NULL  
)  
  
  
AS  
  
BEGIN   
 SET NOCOUNT ON;  
 set @dToDate = @dToDate + 1  
  
 SELECT DISTINCT   
UM.I_User_ID,  
UM.S_Login_ID,  
UM.S_Title,  
UM.S_First_Name,  
UM.S_Middle_Name,  
UM.S_Last_Name,  
UM.S_User_Type,  
UM.I_Reference_ID,  
LT.Dt_Login_Time,  
LT.Dt_Logout_Time,  
     --UHD.I_Hierarchy_Detail_ID ,HD.S_Hierarchy_Name,  
CM.S_Center_Name,
LT.S_IP_Address,
DATEDIFF(n,LT.Dt_Login_Time,ISNULL(LT.Dt_Logout_Time,LT.Dt_Login_Time)) AS Duration 
 FROM dbo.T_User_Master UM  
 INNER JOIN dbo.T_Login_Trail LT WITH(NOLOCK)  
 ON UM.I_User_ID = LT.I_User_ID  
 INNER JOIN dbo.T_User_Hierarchy_Details UHD WITH(NOLOCK)  
 ON UM.I_User_ID = UHD.I_User_ID  
 INNER JOIN dbo.T_Hierarchy_Master HM WITH(NOLOCK)  
 ON UHD.I_Hierarchy_Master_ID = HM.I_Hierarchy_Master_ID   
 INNER JOIN dbo.T_Hierarchy_Details HD WITH(NOLOCK)  
 ON UHD.I_Hierarchy_Detail_ID = HD.I_Hierarchy_Detail_ID  
 LEFT OUTER JOIN dbo.T_Center_Hierarchy_Details CHD WITH(NOLOCK)  
 ON UHD.I_Hierarchy_Detail_ID = CHD.I_Hierarchy_Detail_ID  
 LEFT OUTER JOIN dbo.T_Centre_Master CM WITH(NOLOCK)  
 ON CHD.I_Center_Id = CM.I_Centre_Id  
 WHERE LT.Dt_Login_Time >= ISNULL(@dFromDate,LT.Dt_Login_Time)  
 AND LT.Dt_Login_Time <= ISNULL(@dToDate,LT.Dt_Login_Time)  
 AND UHD.I_Status =1  
 AND HM.S_Hierarchy_Type='SO'  
 AND HM.I_Status =1  
 ORDER BY LT.Dt_Login_Time --desc  
END
