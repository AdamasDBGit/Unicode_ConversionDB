CREATE FUNCTION [dbo].[fnCalculateTaxAmount]      
(      
 @iInvoiceDetailID INT      
)      
RETURNS NUMERIC(18,2)      
AS      
BEGIN      
 DECLARE @nTotalTax NUMERIC(18,2)      
      
 SELECT @nTotalTax = SUM(ISNULL(RTD.[N_Tax_Paid],0))       
 FROM [dbo].[T_Receipt_Tax_Detail] RTD WITH(NOLOCK)   
 INNER JOIN  dbo.T_Receipt_Component_Detail RCD  
 ON RTD.I_Receipt_Comp_Detail_ID = RCD.I_Receipt_Comp_Detail_ID  
 INNER JOIN dbo.T_Receipt_Header RH  
 ON RCD.I_Receipt_Detail_ID = RH.I_Receipt_Header_ID  
 WHERE RTD.I_Invoice_Detail_ID = @iInvoiceDetailID    
 AND RH.I_Status = 1  
 --INNER JOIN [dbo].[T_Receipt_Component_Detail] AS trcd      
 --ON trcd.[I_Receipt_Comp_Detail_ID] = RTD.[I_Receipt_Comp_Detail_ID]      
 --INNER JOIN [dbo].[T_Receipt_Header] AS trh      
 --ON trcd.[I_Receipt_Detail_ID] = trh.[I_Receipt_Header_ID]       
 --WHERE trh.[I_Invoice_Header_ID] = @iInvoiceHeaderID      
       
 RETURN @nTotalTax      
END