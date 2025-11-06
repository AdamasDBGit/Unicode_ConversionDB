CREATE  PROCEDURE [dbo].[uspGetCity]   
  
AS  
BEGIN  
  
 SELECT A.I_City_ID,A.S_City_Code,A.S_City_Name,A.I_Country_ID,A.I_Status,A.I_State_ID,  
 B.S_Country_Code ,B.S_Country_Name ,C.S_State_Name  
 FROM dbo.T_City_Master A ,dbo.T_Country_Master B ,dbo.T_State_Master C  
 WHERE A.I_Country_ID = B.I_Country_ID  
 AND A.I_State_ID = C.I_State_ID  
 AND A.I_Status <> 0 ORDER BY S_City_Name  
  
END
