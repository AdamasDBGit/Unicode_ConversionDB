CREATE PROCEDURE [dbo].[usp_ERP_GetCongifMasterForStatus]              
 @StatusValue int = null       
 ,@brandID int=null      
AS              
BEGIN              
 SET NOCOUNT ON;              
  DECLARE @SGST_Tax_ID int,@CGST_Tax_ID int,@IGST_Tax_ID int            
set @SGST_Tax_ID = (select top 1 I_Tax_ID  from T_Tax_Master where S_Tax_Code='SGST')            
set @CGST_Tax_ID = (select top 1 I_Tax_ID  from T_Tax_Master where S_Tax_Code='CGST')            
set @IGST_Tax_ID = (select top 1 I_Tax_ID  from T_Tax_Master where S_Tax_Code='IGST')            
    -- Insert statements for procedure here              
  select               
  SM.I_Status_Value as StatusValue,              
  SM.N_Amount as Amount,    
  SM.S_Status_Desc_SMS Description,    
  ECM.S_config_code as ConfigCode,              
  ECM.S_config_Value as ConfigValue ,            
  Case When SM.N_Amount between  GICD.N_Start_Amount and GICD.N_End_Amount            
  Then Convert(Numeric(18,2),((SM.N_Amount * N_SGST / 100)))            
  end as SGST,       
  N_SGST as SGSTPercentage,    
  @SGST_Tax_ID SGST_Tax_ID,            
     Case When SM.N_Amount between  GICD.N_Start_Amount and GICD.N_End_Amount            
  Then Convert(Numeric(18,2),((SM.N_Amount * N_CGST / 100) ))          
  end as CGST,       
  N_CGST as CGSTPercentage,    
  @CGST_Tax_ID CGST_Tax_ID,            
  Case When SM.N_Amount between  GICD.N_Start_Amount and GICD.N_End_Amount            
  Then Convert(Numeric(18,2),((SM.N_Amount * N_IGST / 100)))            
  end as IGST,        
  N_IGST AS IGSTPercentage,    
  @IGST_Tax_ID IGST_Tax_ID ,    
  SM.Is_AllowAmountChange as AllowAmountChange    
  from [dbo].[T_Status_Master] as SM             
  left join [dbo].[T_ERP_Configuration_Master] as ECM             
   on SM.I_ConFig_ID=ECM.I_Config_ID             
  --left Join T_ERP_GST_Item_Category GIC on GIC.I_Fee_Component_ID=SM.I_Status_Value            
  --and  GIC.[type]=2   
    left Join T_ERP_GST_Component_Mapping GIC on GIC.I_Fee_Component_ID=SM.I_Status_Value            
  and  GIC.I_GST_Component_Type=2   
  Left Join T_ERP_GST_Item_Category GICM   
  ON GICM.I_GST_FeeComponent_Catagory_ID=GIC.I_GST_FeeComponent_Catagory_ID  
  and GICM.Is_Active=1  and GICM.I_Brand_Id=   @brandID
  Left Join T_ERP_GST_Configuration_Details GICD             
  on GICD.I_GST_FeeComponent_Catagory_ID=GIC.I_GST_FeeComponent_Catagory_ID            
   where SM.I_Status_Value=@StatusValue  and SM.I_Brand_ID=@brandID        
 END 