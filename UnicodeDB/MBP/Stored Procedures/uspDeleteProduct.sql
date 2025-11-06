CREATE PROCEDURE [MBP].[uspDeleteProduct]    
(   
 @iProductID INT = NULL,
 @sUser varchar(100)   
)  
AS  
BEGIN

insert into [MBP].[T_Product_Master_Delete]
select 
I_Product_Id
,S_Product_Name
,S_Product_Description
,1
,@sUser
,null
,getdate()
,null
,I_Brand_ID 
from MBP.T_Product_Master  where I_Product_id = @iProductID
 
Delete From MBP.T_Product_Master  
Where I_Product_ID =@iProductID   
Delete From MBP.T_MBP_Detail  
Where I_Product_ID =@iProductID   
Delete From MBP.T_MBP_Detail_Audit  
Where I_Product_ID =@iProductID   
Delete From MBP.T_MBPerformance  
Where I_Product_ID =@iProductID   
Delete From MBP.T_Product_Component  
Where I_Product_ID =@iProductID 

  
  
END
