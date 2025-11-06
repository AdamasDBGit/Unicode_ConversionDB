CREATE PROCEDURE [dbo].[uspGetMaritalStatus]    
     
AS    
BEGIN    
   
 SET NOCOUNT ON;    
  SELECT  M.I_Marital_Status_ID,M.S_Marital_Status,M.I_Status     
  FROM dbo.T_Marital_Status M    
  WHERE   M.I_Status <> 0      
  ORDER BY M.I_Marital_Status_ID    
END
