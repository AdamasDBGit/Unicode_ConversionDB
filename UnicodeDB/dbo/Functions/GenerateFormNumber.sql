CREATE FUNCTION [dbo].[GenerateFormNumber](@PatternHeaderID int)        
RETURNS VARCHAR(20)        
AS        
BEGIN        
    DECLARE @Pattern1 VARCHAR(255)    
    DECLARE @Pattern2 INT        
    DECLARE @Pattern3 VARCHAR(255)      
    DECLARE @incrementid INT      
    DECLARE @InvoiceNumber VARCHAR(255)      
    DECLARE @Pattern2_item VARCHAR(255)
    -- Retrieve Pattern1, Pattern2, Pattern3, and Increment ID
    SELECT 
        @Pattern1 = ISNULL(PCH.Pattern1, ''),
        @Pattern2 = ISNULL(PCH.Pattern2, ''),
        @Pattern3 = ISNULL(PCH.Pattern3, ''),
        @incrementid = ISNULL(PCH.I_Increment_ID, 0)
    FROM
        [T_ERP_Saas_Pattern_Header] AS SPH 
    LEFT JOIN 
        [T_ERP_Saas_Pattern_Child_Header] AS PCH ON SPH.I_Pattern_HeaderID = PCH.I_Pattern_HeaderID 
    WHERE 
        PCH.I_Pattern_HeaderID = @PatternHeaderID;
    
    -- Set Pattern2_item based on condition
    IF @Pattern2 = 1
    BEGIN
        SET @Pattern2_item = CONVERT(VARCHAR(4), YEAR(GETDATE()));
    END
    ELSE
    BEGIN
        SET @Pattern2_item = '';
    END
    
    -- Increment the Increment ID
    SET @incrementid = @incrementid + 1;
    
    -- Format the Increment ID
    DECLARE @IncrementPartFormatted VARCHAR(10);        
    SET @IncrementPartFormatted = RIGHT('000000' + CAST(@incrementid AS VARCHAR(10)), 7);             
    
    -- Concatenate the parts to form the Invoice Number
    SET @InvoiceNumber = CONCAT(
                            CASE WHEN @Pattern1 <> '' THEN @Pattern1 + '/' ELSE '' END,
                            CASE WHEN @Pattern2_item <> '' THEN @Pattern2_item + '/' ELSE '' END,
                            CASE WHEN @Pattern3 <> '' THEN @Pattern3 + '/' ELSE '' END,
                            @IncrementPartFormatted
                        ); 
    
    RETURN @InvoiceNumber;        
END;