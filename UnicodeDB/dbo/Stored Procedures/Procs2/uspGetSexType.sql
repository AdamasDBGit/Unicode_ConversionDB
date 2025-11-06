CREATE PROCEDURE [dbo].[uspGetSexType]  
   
AS  
BEGIN  
 
 SET NOCOUNT ON;  
  SELECT  S.I_Sex_ID,S.S_Sex_Name,S.I_Status   
  FROM dbo.T_User_Sex S 
  WHERE   S.I_Status <> 0    
  ORDER BY S.S_Sex_Name    
END
