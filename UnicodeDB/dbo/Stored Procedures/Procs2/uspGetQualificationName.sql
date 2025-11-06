-- =============================================  
-- Author:  Debarshi Basu  
-- Create date: 26/03/2006  
-- Description: Gets all rows from Qualification Name master table  
-- =============================================  
CREATE PROCEDURE [dbo].[uspGetQualificationName]   
  
AS  
BEGIN  
  
 SET NOCOUNT OFF  
  
 SELECT I_Qualification_Name_ID,I_Qualification_Type_ID,S_Qualification_Name,I_Status  
 FROM dbo.T_Qualification_Name_Master  
 ORDER BY S_Qualification_Name  
  
END
