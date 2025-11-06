-- =============================================  
-- Author:  <Author,,Name>  
-- Create date: <Create Date,,>  
-- Description: <Description,,>  
-- =============================================  
CREATE PROCEDURE [dbo].[uspGetGrade]  
 -- Add the parameters for the stored procedure here  
   
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON;  
  SELECT  G.I_Grade_Code,G.S_Grade_Name,G.I_Status   
  FROM dbo.T_Grade_Master G  
  WHERE   G.I_Status <> 0    
  ORDER BY G.I_Grade_Code DESC  
END
