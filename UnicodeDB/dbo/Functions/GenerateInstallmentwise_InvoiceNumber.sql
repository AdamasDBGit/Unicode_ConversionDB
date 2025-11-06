  
Create FUNCTION [dbo].[GenerateInstallmentwise_InvoiceNumber](@brandID Int,        
@SessionID Int)          
RETURNS VARCHAR(20)          
AS          
BEGIN          
    DECLARE @InvoiceNumber VARCHAR(20)          
    --DECLARE @YearPart VARCHAR(4)          
    DECLARE @IncrementPart INT          
 DECLARE @sessionstDt DATE         
    DECLARE @sessionEndDt DATE         
        
 SET @IncrementPart =(select top 1 InstallmentwiseTempInv+1 from T_ERP_InvGenerateRepository         
 where  I_Brand_ID=@brandID and I_School_Session_ID=@SessionID and Type='INV' )          
 --Select @IncrementPart        
    -- Format the increment part with leading zeros          
    DECLARE @IncrementPartFormatted VARCHAR(10)          
    SET @IncrementPartFormatted = RIGHT('0000000' + CAST(@IncrementPart AS VARCHAR(10)), 7)          
  Declare @pattern1 Varchar(10)
  SEt @pattern1=(select top 1 pattern1 from T_ERP_InvGenerateRepository         
     where  I_Brand_ID=@brandID and I_School_Session_ID=@SessionID and Type='INV')
    -- Concatenate the year and increment parts to form the invoice number          
    SET @InvoiceNumber = Concat(@pattern1 , @IncrementPartFormatted)        
  --Select @InvoiceNumber        
    RETURN @InvoiceNumber          
END;