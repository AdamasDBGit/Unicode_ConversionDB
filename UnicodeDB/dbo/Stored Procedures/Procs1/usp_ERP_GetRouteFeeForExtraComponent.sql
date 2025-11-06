-- =============================================      
-- Author:  <Author,,Name>      
-- Create date: <Create Date,,>      
-- Description: <Description,,>      
-- exec usp_ERP_GetRouteFeeForExtraComponent 107, null, 24     
--select * from T_ERP_GST_Item_Category  
--select * from T_ERP_GST_Configuration_Details  
-- =============================================   
--EXEC [usp_ERP_GetRouteFeeForExtraComponent] 107,null,136
CREATE PROCEDURE [dbo].[usp_ERP_GetRouteFeeForExtraComponent]      
 -- Add the parameters for the stored procedure here      
 (          
  @iBrandID INT NULL,      
  @I_pointID INT NULL,    
  @RouteID INT NULL    
 )      
AS      
BEGIN      
 -- SET NOCOUNT ON added to prevent extra result sets from      
 -- interfering with SELECT statements.      
 SET NOCOUNT ON;      
 --select * from T_Fee_Component_Master   
    -- Insert statements for procedure here   
 ----Create Temp Table----  
  Create Table #TempComponent_GST (    
  I_ID int Identity(1,1),    
  PickupPointID int,    
  RouteID int,    
  PickupPointName varchar(200),  
  Fees Numeric(18,2),  
  Component_ID int,  
  --CGST_Amt Numeric(18,2),    
  --SGST_Amt Numeric(18,2),    
  --IGST_Amt Numeric(18,2),    
  --CGST_Per Numeric(10,2),    
  --SGST_Per Numeric(10,2),    
  --IGST_per numeric(10,2)    
  )   
  
  Insert Into #TempComponent_GST(PickupPointID, RouteID, PickupPointName, Fees, Component_ID)  
  
  select DISTINCT    
  TRTM.I_PickupPoint_ID as PickupPointID,  TRTM.I_Route_ID as RouteID,  TTM.S_PickupPoint_Name 
  as PickupPointName,  TTM.N_Fees as Fees, 9     
  --TTM.I_PickupPoint_ID as PickupPointID,      
  --TTM.S_PickupPoint_Name as PickupPointName,      
  --TTM.N_Fees as Fees      
 from T_Route_Transport_Map as TRTM 
 right join T_Transport_Master as TTM on TRTM.I_PickupPoint_ID = TTM.I_PickupPoint_ID    
  --T_Transport_Master as TTM      
  where TTM.I_Brand_ID = ISNULL(@iBrandID, I_Brand_ID)      
  and TRTM.I_Route_ID = @RouteID    
  and (TTM.I_PickupPoint_ID = @I_pointID or @I_pointID IS NULL )
  and TTM.I_Status=1
    --select * from #TempComponent_GST

  select a.*  
  ,ISNULL(c.N_CGST,0) as CGST_Per  
  ,ISNULL(c.N_SGST,0) as SGST_Per  
  ,ISNULL(c.N_IGST ,0)as IGST_Per  
  ,ISNULL(Convert(numeric(18,2),(a.Fees * c.N_CGST / 100)),0) as CGST_Amt  
  ,ISNULL(Convert(numeric(18,2),(a.Fees * c.N_SGST / 100)),0) as SGST_Amt  
  ,ISNULL(Convert(numeric(18,2),(a.Fees * c.N_IGST / 100)),0) as IGST_Amt  
    
  from #TempComponent_GST a  
  Left Join T_ERP_GST_Component_Mapping b on a.Component_ID=b.I_Fee_Component_ID 
  and b.I_GST_Component_Type=1
  Left Join T_ERP_GST_Configuration_Details c   
  on c.I_GST_FeeComponent_Catagory_ID=b.I_GST_FeeComponent_Catagory_ID 
  and a.Component_ID=b.I_Fee_Component_ID  and a.Fees between c.N_Start_Amount and c.N_End_Amount  
    -- Where   
END  