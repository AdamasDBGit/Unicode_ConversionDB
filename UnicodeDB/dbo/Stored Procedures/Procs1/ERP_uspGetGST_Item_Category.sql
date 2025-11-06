  
-- =============================================      
CREATE PROCEDURE [dbo].[ERP_uspGetGST_Item_Category]      
 -- Add the parameters for the stored procedure here      
 (      
  @I_Brand_Id int      
 )      
AS      
BEGIN      
 -- SET NOCOUNT ON added to prevent extra result sets from      
 -- interfering with SELECT statements.      
 SET NOCOUNT ON;      
      
    -- Insert statements for procedure here      
 select I_GST_FeeComponent_Catagory_ID,      
 S_GST_FeeComponent_Category_Type      
 from T_ERP_GST_Item_Category      
 where I_Brand_Id = @I_Brand_Id and Is_Active=1  --and I_Fee_Component_ID is null    
END 