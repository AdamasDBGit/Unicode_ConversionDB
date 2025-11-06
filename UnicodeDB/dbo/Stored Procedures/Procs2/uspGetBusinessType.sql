CREATE PROCEDURE [dbo].[uspGetBusinessType]  
   
AS  
BEGIN  
 
 SET NOCOUNT ON;  
  SELECT  B.I_Business_Type_ID,B.S_Business_Type,B.I_Status   
  FROM dbo.T_Business_Type B
  WHERE   B.I_Status <> 0    
  ORDER BY B.S_Business_Type    
END
