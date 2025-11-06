-- =============================================  
-- Author:  <Parichoy Nandi>  
-- Create date: <9th Nov>  
-- Description: <to get Fee components>  
-- =============================================  
CREATE PROCEDURE [dbo].[usp_ERP_Get_Fee_Catagory]  
 -- Add the parameters for the stored procedure here  
 @CatagoryId int null  
AS  
BEGIN  
   
 SET NOCOUNT ON;  
  Select FC.I_Fee_Structure_Catagory_ID as CatagoryID  
      ,FC.S_Fee_Structure_Catagory_Name as CatagoryName  
      ,FC.I_Status as CatagoryStatus  
  from [dbo].[T_ERP_Fee_Structure_Category] as FC  
  where FC.I_Fee_Structure_Catagory_ID= ISNULL(@CatagoryId,FC.I_Fee_Structure_Catagory_ID)  
END  