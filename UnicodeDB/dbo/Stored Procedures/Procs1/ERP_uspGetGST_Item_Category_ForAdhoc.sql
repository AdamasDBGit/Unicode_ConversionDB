--exec [ERP_uspGetGST_Item_Category_ForAdhoc] 107,334
CREATE PROCEDURE [dbo].[ERP_uspGetGST_Item_Category_ForAdhoc]  
(  
  @I_Brand_Id int,
  @StatusId int=NULL
)  
AS  
BEGIN  
    -- SET NOCOUNT ON added to prevent extra result sets from  
    -- interfering with SELECT statements.  
    SET NOCOUNT ON;  
  DECLARE @statusvalue int=null
  set @statusvalue = (select top 1 I_Status_Value from T_Status_Master where I_Status_Id=@StatusId)
    -- Insert statements for procedure here  
    SELECT 
        I_GST_FeeComponent_Catagory_ID,  
        S_GST_FeeComponent_Category_Type  
    FROM 
        T_ERP_GST_Item_Category  
   WHERE 
        I_Brand_Id = @I_Brand_Id  
       AND (
            (I_Fee_Component_ID IS NULL) 
            OR (I_Fee_Component_ID = @statusvalue AND @statusvalue IS NOT NULL)
        );
END;
