-- =============================================    
-- Author:  <Parichoy Nandi>    
-- Create date: <23-11-2023>    
-- Description: <get the listing for fee structure>    
--exec [usp_ERP_FeeStructureComponentDetails] 1, 234868 

-- =============================================    

-- =============================================      
-- Author:  <Parichoy Nandi>      
-- Create date: <23-11-2023>      
-- Description: <get the listing for fee structure>      
--exec [usp_ERP_FeeStructureComponentDetails] 1,null   
-- =============================================      
CREATE PROCEDURE [dbo].[usp_ERP_FeeStructureComponentDetails]      
(      
@feeStructureID int = null,      
@enquiryRegID int = null      
)      
 -- Add the parameters for the stored procedure here      
AS      
BEGIN      
 -- SET NOCOUNT ON added to prevent extra result sets from      
 -- interfering with SELECT statements.      
 SET NOCOUNT ON;      
      
    -- Insert statements for procedure here      
   If 
   Exists (Select 1 from T_ERP_Stud_Fee_Struct_Comp_Mapping     
   where R_I_Enquiry_Regn_ID=@enquiryRegID and R_I_Fee_Structure_ID=@feeStructureID )    
   Begin    
SELECT Distinct     
  TESFSCM.I_Stud_Fee_Struct_CompMap_ID StudFeeStructCompMapID      
  ,TESFSCMD.I_Stud_Fee_Struct_CompMap_Details_ID StudFeeStructCompMapDetailsID    
 , TEFC.S_Fee_Component_Name FeeComponentName      
 ,TEFSIC.N_Component_Actual_Total_Annual_Amount ComponentActualAmount      
 ,TEFPT.S_Installment_Frequency InstallmentFrequency      
 ,TEFPT.I_Fee_Pay_Installment_ID PayInstallmentNo      
 ,TEFS.N_Total_OneTime_Amount TotalAmount      
 ,TEFC.I_Fee_Component_ID FeeComponentID
 ,TEFSIC.I_Seq_No SeqNo
    
 --,TESFSCMD.I_Stud_Fee_Struct_CompMap_Details_ID StudFeeStructCompMapDetailsID      
 FROM T_ERP_Fee_Structure TEFS       
 Left JOIN      
 T_ERP_Fee_Structure_Installment_Component TEFSIC ON TEFS.I_Fee_Structure_ID = TEFSIC.R_I_Fee_Structure_ID      
 Left JOIN      
 T_ERP_Fee_Component TEFC ON TEFC.I_Fee_Component_ID = TEFSIC.R_I_Fee_Component_ID      
 Left Join    
 T_ERP_Fee_PaymentInstallment_Type TEFPT ON TEFPT.I_Fee_Pay_Installment_ID = TEFSIC.R_I_Fee_Pay_Installment_ID      
 LEFT JOIN       
 T_ERP_Stud_Fee_Struct_Comp_Mapping TESFSCM ON TESFSCM.R_I_Fee_Structure_ID = TEFS.I_Fee_Structure_ID      
 LEFT JOIN       
 T_ERP_Stud_Fee_Struct_Comp_Mapping_Details TESFSCMD ON   
 TESFSCMD.R_I_Stud_Fee_Struct_CompMap_ID =  TESFSCM.I_Stud_Fee_Struct_CompMap_ID     
 and TESFSCMD.R_I_Fee_Structure_ID=TESFSCM.R_I_Fee_Structure_ID    
 and TESFSCMD.R_I_Fee_Component_ID=TEFSIC.R_I_Fee_Component_ID    
 Left Join T_ERP_Stud_Fee_Struct_Comp_Mapping SELFJ on selfj.R_I_Enquiry_Regn_ID=@enquiryRegID  
          
 --where TEFS.I_Fee_Structure_ID= @feeStructureID and TESFSCM.R_I_Enquiry_Regn_ID=@enquiryRegID



END      
Else 
If
Exists (Select 1 from T_ERP_Stud_Fee_Struct_Comp_Mapping     
   where R_I_Enquiry_Regn_ID=@enquiryRegID and R_I_Fee_Structure_ID<>@feeStructureID )    
   Begin 
   SELECT  Distinct     
  TESFSCM.I_Stud_Fee_Struct_CompMap_ID StudFeeStructCompMapID      
  ,TESFSCMD.I_Stud_Fee_Struct_CompMap_Details_ID StudFeeStructCompMapDetailsID    
 , TEFC.S_Fee_Component_Name FeeComponentName      
 ,TEFSIC.N_Component_Actual_Total_Annual_Amount ComponentActualAmount      
 ,TEFPT.S_Installment_Frequency InstallmentFrequency      
 ,TEFPT.I_Fee_Pay_Installment_ID PayInstallmentNo      
 ,TEFS.N_Total_OneTime_Amount TotalAmount      
 ,TEFC.I_Fee_Component_ID FeeComponentID
 ,TEFSIC.I_Seq_No SeqNo
    
 --,TESFSCMD.I_Stud_Fee_Struct_CompMap_Details_ID StudFeeStructCompMapDetailsID      
 FROM T_ERP_Fee_Structure TEFS       
 Left JOIN      
 T_ERP_Fee_Structure_Installment_Component TEFSIC ON TEFS.I_Fee_Structure_ID = TEFSIC.R_I_Fee_Structure_ID      
 Left JOIN      
 T_ERP_Fee_Component TEFC ON TEFC.I_Fee_Component_ID = TEFSIC.R_I_Fee_Component_ID      
 Left Join    
 T_ERP_Fee_PaymentInstallment_Type TEFPT ON TEFPT.I_Fee_Pay_Installment_ID = TEFSIC.R_I_Fee_Pay_Installment_ID      
 LEFT JOIN       
 T_ERP_Stud_Fee_Struct_Comp_Mapping TESFSCM ON TESFSCM.R_I_Fee_Structure_ID = TEFS.I_Fee_Structure_ID      
 LEFT JOIN       
 T_ERP_Stud_Fee_Struct_Comp_Mapping_Details TESFSCMD ON   
 TESFSCMD.R_I_Stud_Fee_Struct_CompMap_ID =  TESFSCM.I_Stud_Fee_Struct_CompMap_ID     
 and TESFSCMD.R_I_Fee_Structure_ID=TESFSCM.R_I_Fee_Structure_ID    
 and TESFSCMD.R_I_Fee_Component_ID=TEFSIC.R_I_Fee_Component_ID    
 Left Join T_ERP_Stud_Fee_Struct_Comp_Mapping SELFJ on selfj.R_I_Enquiry_Regn_ID=@enquiryRegID    
          
 where TEFS.I_Fee_Structure_ID= @feeStructureID   
   End
   ELSE
Begin    
SELECT  Distinct     
  SELFJ.I_Stud_Fee_Struct_CompMap_ID StudFeeStructCompMapID      
  ,SELFJ1.I_Stud_Fee_Struct_CompMap_Details_ID StudFeeStructCompMapDetailsID    
 , TEFC.S_Fee_Component_Name FeeComponentName      
 ,TEFSIC.N_Component_Actual_Total_Annual_Amount ComponentActualAmount      
 ,TEFPT.S_Installment_Frequency InstallmentFrequency      
 ,TEFPT.I_Fee_Pay_Installment_ID PayInstallmentNo      
 ,TEFS.N_Total_OneTime_Amount TotalAmount      
 ,TEFC.I_Fee_Component_ID FeeComponentID
 ,TEFSIC.I_Seq_No SeqNo
    
 --,TESFSCMD.I_Stud_Fee_Struct_CompMap_Details_ID StudFeeStructCompMapDetailsID      
 FROM T_ERP_Fee_Structure TEFS       
 Left JOIN      
 T_ERP_Fee_Structure_Installment_Component TEFSIC ON TEFS.I_Fee_Structure_ID = TEFSIC.R_I_Fee_Structure_ID      
 Inner JOIN      
 T_ERP_Fee_Component TEFC ON TEFC.I_Fee_Component_ID = TEFSIC.R_I_Fee_Component_ID      
 Left Join    
 T_ERP_Fee_PaymentInstallment_Type TEFPT ON TEFPT.I_Fee_Pay_Installment_ID = TEFSIC.R_I_Fee_Pay_Installment_ID      
 LEFT JOIN       
 T_ERP_Stud_Fee_Struct_Comp_Mapping TESFSCM ON TESFSCM.R_I_Fee_Structure_ID = TEFS.I_Fee_Structure_ID      
 LEFT JOIN       
 T_ERP_Stud_Fee_Struct_Comp_Mapping_Details TESFSCMD ON TESFSCMD.R_I_Stud_Fee_Struct_CompMap_ID =  TESFSCM.I_Stud_Fee_Struct_CompMap_ID     
 and TESFSCMD.R_I_Fee_Structure_ID=TESFSCM.R_I_Fee_Structure_ID    
 and TESFSCMD.R_I_Fee_Component_ID=TEFSIC.R_I_Fee_Component_ID    
 Left Join T_ERP_Stud_Fee_Struct_Comp_Mapping SELFJ on selfj.R_I_Enquiry_Regn_ID=@enquiryRegID    
 Left Join T_ERP_Stud_Fee_Struct_Comp_Mapping_Details SELFJ1 
 on SELFJ1.R_I_Stud_Fee_Struct_CompMap_ID=SELFJ.I_Stud_Fee_Struct_CompMap_ID        
 where TEFS.I_Fee_Structure_ID= @feeStructureID  
 
End    
End
