  
CREATE FUNCTION [dbo].[GeneratetempInvoiceNumber](@brandID Int,        
@SessionID Int)          
RETURNS VARCHAR(20)          
AS          
BEGIN          
    DECLARE @InvoiceNumber VARCHAR(20)          
    --DECLARE @YearPart VARCHAR(4)          
    DECLARE @IncrementPart INT          
 DECLARE @sessionstDt DATE         
    DECLARE @sessionEndDt DATE         
        
 SET @IncrementPart =(select top 1 Temp_Inv+1 from T_ERP_InvGenerateRepository         
 where  I_Brand_ID=@brandID and I_School_Session_ID=@SessionID and Type='INV' )          
 --Select @IncrementPart        
    -- Format the increment part with leading zeros          
    DECLARE @IncrementPartFormatted VARCHAR(10)          
    SET @IncrementPartFormatted = RIGHT('0000000' + CAST(@IncrementPart AS VARCHAR(10)), 7)          
     
    -- Concatenate the year and increment parts to form the invoice number          
    SET @InvoiceNumber = Concat('Temp/' , @IncrementPartFormatted  )        
  --Select @InvoiceNumber        
    RETURN @InvoiceNumber          
END;