-- =============================================  
-- Author:  <Author,,Name>  
-- Create date: <Create Date,,>  
-- Description: <Description,,>  
-- =============================================  
CREATE PROCEDURE [dbo].[uspGetCaste]  
 -- Add the parameters for the stored procedure here  
   
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON;  
  SELECT  c.I_Caste_ID,C.S_Caste_Name,C.I_Status   
  FROM dbo.T_Caste_Master C  
  WHERE   C.I_Status <> 0    
  ORDER BY c.S_Caste_Name  
END
