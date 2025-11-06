CREATE PROCEDURE [dbo].[uspGetBloodGroup]  
   
AS  
BEGIN  
 
 SET NOCOUNT ON;  
  SELECT  B.I_Blood_Group_ID,B.S_Blood_Group,B.I_Status   
  FROM dbo.T_Blood_Group B  
  WHERE   B.I_Status <> 0    
  ORDER BY B.S_Blood_Group  
END
