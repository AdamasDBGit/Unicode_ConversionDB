CREATE PROCEDURE [dbo].[uspGetHouse]     
       
AS      
BEGIN      
     
 SET NOCOUNT ON;      
  SELECT  H.I_House_ID,H.S_House_Name ,H.I_Status,H.I_Brand_ID      
  FROM dbo.T_House_Master H     
  WHERE   H.I_Status <> 0        
  ORDER BY H.S_House_Name      
END
