CREATE FUNCTION [dbo].[GenerateInvoiceNumber](@InvDate Date,@brandID Int,    
@SessionID Int,@S_Type varchar(10))      
RETURNS VARCHAR(20)      
AS      
BEGIN      
    DECLARE @InvoiceNumber VARCHAR(20)      
    --DECLARE @YearPart VARCHAR(4)      
    DECLARE @IncrementPart INT      
 DECLARE @sessionstDt DATE     
    DECLARE @sessionEndDt DATE     
 --Declare @SessionID int =1,@brandID int=110,@InvDate Date =Convert(Date,Getdate())    
 select @sessionstDt=Convert(Date,Dt_Session_Start_Date) ,@sessionEndDt=Convert(Date,Dt_Session_End_Date)    
from T_School_Academic_Session_Master where I_School_Session_ID=@SessionID    
--Select @sessionstDt,@sessionEndDt    
    -- Get the maximum increment value for the current year      
    --SET @IncrementPart = ISNULL(MAX(CAST(SUBSTRING(InvoiceNumber, 5, LEN(InvoiceNumber) - 4) AS INT)), 0) + 1      
 SET @IncrementPart =(select top 1 I_IncrementID+1 from T_ERP_InvGenerateRepository     
 where  I_Brand_ID=@brandID and I_School_Session_ID=@SessionID  And Type=@S_Type  
 and @InvDate >= @sessionstDt AND    
    @InvDate <= @sessionEndDt)      
 --Select @IncrementPart    
    -- Format the increment part with leading zeros      
    DECLARE @IncrementPartFormatted VARCHAR(10)      
    SET @IncrementPartFormatted = RIGHT('000000' + CAST(@IncrementPart AS VARCHAR(10)), 6)      
  --Select @IncrementPartFormatted    
    -- Concatenate the year and increment parts to form the invoice number      
    SET @InvoiceNumber = Concat(Right((YEAR(@sessionstDt)),2) , @IncrementPartFormatted  )    
  --Select @InvoiceNumber    
    RETURN @InvoiceNumber      
END;