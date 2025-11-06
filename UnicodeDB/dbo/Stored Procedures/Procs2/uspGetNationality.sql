CREATE PROCEDURE [dbo].[uspGetNationality]  
   
AS  
BEGIN  
 
 SET NOCOUNT ON;  
  SELECT  N.I_Nationality_ID,N.S_Nationality,N.I_Status   
  FROM dbo.T_User_Nationality N  
  WHERE   N.I_Status <> 0    
  ORDER BY N.S_Nationality  
END
