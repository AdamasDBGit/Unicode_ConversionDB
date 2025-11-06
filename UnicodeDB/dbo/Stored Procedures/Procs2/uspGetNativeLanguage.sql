CREATE PROCEDURE [dbo].[uspGetNativeLanguage]  
   
AS  
BEGIN  
 
 SET NOCOUNT ON;  
  SELECT  N.I_Native_Language_ID,N.S_Native_Language_Name,N.I_Status   
  FROM dbo.T_Native_Language N  
  WHERE   N.I_Status <> 0    
  ORDER BY N.S_Native_Language_Name  
END
