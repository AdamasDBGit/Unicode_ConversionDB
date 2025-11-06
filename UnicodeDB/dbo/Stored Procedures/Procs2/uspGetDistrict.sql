CREATE PROCEDURE [dbo].[uspGetDistrict]    
 -- Add the parameters for the stored procedure here    
    
AS    
BEGIN    
 -- SET NOCOUNT ON added to prevent extra result sets from    
 -- interfering with SELECT statements.    
 SET NOCOUNT ON;    
    
    SELECT  A.I_District_ID,A.S_District_Name,A.S_District_Code,A.I_Status,A.I_Country_ID, A.I_State_ID,     
  B.S_Country_Code ,B.S_Country_Name       
  FROM dbo.T_District_Master A,dbo.T_Country_Master B      
  WHERE A.I_Country_ID = B.I_Country_ID       
  AND  A.I_Status <> 0      
  ORDER BY A.S_District_Name      
END
