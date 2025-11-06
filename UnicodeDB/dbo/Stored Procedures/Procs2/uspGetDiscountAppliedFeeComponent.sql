CREATE PROCEDURE [dbo].[uspGetDiscountAppliedFeeComponent]           
       
AS      
BEGIN     
    
 SELECT I_Fee_Component_Id    
     ,S_Component_Code    
 FROM dbo.T_Fee_Component_Master    
 WHERE I_Status = 1 AND Is_Discount_Applicable = 1 AND Is_Invoice_Receipt = 1    
    
END
