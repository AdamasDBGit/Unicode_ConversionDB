
--EXEC ERP_get_FEE_Structure_GST_Generation 44,0  
  
CREATE Proc [dbo].[usp_ERP_Get_GSTConfigutationDetails_ComponentWise](  
@iFeeComponentID int,
@AnnualBaseAmount int
)  
As   
Begin  

Declare @GSTCategoryID int,@Fee_Component_Amount Numeric(18,2),  
@SGST_Per numeric(10,2), @SGST_Value numeric(18,2),  
@CGST_Per numeric(10,2), @CGST_Value numeric(18,2),  
@IGST_Per numeric(10,2), @IGST_Value numeric(18,2),  
@Fee_ComponentID int  
  
  
SET @IGST_Per =  
(  
Select Top 1 N_IGST from 
T_ERP_GST_Item_Category as GIC 
inner join
T_ERP_GST_Configuration_Details as GCD on GIC.I_GST_FeeComponent_Catagory_ID=GCD.I_GST_FeeComponent_Catagory_ID
where @AnnualBaseAmount between GCD.N_Start_Amount and GCD.N_End_Amount and GIC.I_Fee_Component_ID=@iFeeComponentID  
) 


--select @IGST_Per
  
SET @CGST_Per =(  
Select Top 1 N_CGST from 
T_ERP_GST_Item_Category as GIC 
inner join
T_ERP_GST_Configuration_Details as GCD on GIC.I_GST_FeeComponent_Catagory_ID=GCD.I_GST_FeeComponent_Catagory_ID
where @AnnualBaseAmount between GCD.N_Start_Amount and GCD.N_End_Amount and GIc.I_Fee_Component_ID=@iFeeComponentID   
)  

  
SET @SGST_Per =(  
Select Top 1 N_SGST from 
T_ERP_GST_Item_Category as GIC 
inner join
T_ERP_GST_Configuration_Details as GCD on GIC.I_GST_FeeComponent_Catagory_ID=GCD.I_GST_FeeComponent_Catagory_ID
where @AnnualBaseAmount between GCD.N_Start_Amount and GCD.N_End_Amount and GIc.I_Fee_Component_ID=@iFeeComponentID   
)  
  
SET @SGST_Value=(@AnnualBaseAmount * @SGST_Per / 100)   
SET @CGST_Value=(@AnnualBaseAmount * @CGST_Per / 100)   
SET @IGST_Value=(@AnnualBaseAmount * @IGST_Per / 100)   


select @IGST_Per as IGST_Per,@IGST_Value IGST_Value,@CGST_Per CGST_Per,
@CGST_Value CGST_Value,@SGST_Per SGST_Per,@SGST_Value SGST_Value
  
 
End  
