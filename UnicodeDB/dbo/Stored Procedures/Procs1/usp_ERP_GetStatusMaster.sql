      
CREATE PROCEDURE [dbo].[usp_ERP_GetStatusMaster]        
 @BrandID int =null,        
 @StatusID int = null        
AS        
BEGIN        
 SET NOCOUNT ON;        
         
  select distinct        
  SM.I_Status_Id,SM.S_Status_Desc as StatusDesc,        
  SM.S_Status_Type as StatusType,        
  SM.S_Status_Desc_SMS as StatusSMSDesc,        
  SM.I_Status_Value as StatusValue,        
  SM.I_Status_Id as StatusID,        
  SM.N_Amount as Amount,        
  SM.I_ConFig_ID as ConfigID,        
  SM.Status_Type Type ,        
  SM.Is_GSTApplicable Is_GST_Applicable,
  SM.Is_AdmissionToken,
  EGIC.I_GST_FeeComponent_Catagory_ID GST_config,        
  EGCD.dt_ValidFrom_dt Valid_from,        
  EGCD.dt_ValidTo_dt Valid_to,        
  ISNULL(SM.Is_AllowAmountChange,0) AllowAmountChange   ,  
  -- Newly added columns  
        SM.BankID,    
        SM.BankEffectiveFrom,    
        SM.BankEffectiveTo     
        
  from [dbo].[T_Status_Master] as SM        
  --INNER JOIN T_ERP_GST_Item_Category EGIC ON EGIC.I_Fee_Component_ID = SM.I_Status_Value       
  Left JOIN T_ERP_GST_Component_Mapping EGIC ON EGIC.I_Fee_Component_ID = SM.I_Status_Value       
  and I_GST_Component_Type=2      
  Left JOIN T_ERP_GST_Configuration_Details EGCD      
  ON EGCD.I_GST_FeeComponent_Catagory_ID=EGIC.I_GST_FeeComponent_Catagory_ID        
  where SM.S_Status_Type ='ReceiptType'         
  and Sm.I_Brand_ID= @BrandID and SM.I_Status_Id= ISNULL(@StatusID,SM.I_Status_Id)        
  order by SM.I_Status_Id desc        
 END 