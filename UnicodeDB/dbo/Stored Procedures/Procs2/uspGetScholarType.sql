CREATE PROCEDURE [dbo].[uspGetScholarType] 
   
AS  
BEGIN  
 
 SET NOCOUNT ON;  
  SELECT  S.I_Scholar_Type_ID,S.S_Scholar_Type_Name,S.I_Status   
  FROM dbo.T_Scholar_Type_Master S 
  WHERE   S.I_Status <> 0    
  ORDER BY S.S_Scholar_Type_Name  
END
