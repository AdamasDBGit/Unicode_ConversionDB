CREATE PROCEDURE [dbo].[uspGetReligion]  
   
AS  
BEGIN  
 
 SET NOCOUNT ON;  
  SELECT  R.I_Religion_ID,R.S_Religion_Name,R.I_Status   
  FROM dbo.T_User_Religion R 
  WHERE   R.I_Status <> 0    
  ORDER BY R.S_Religion_Name  
END
