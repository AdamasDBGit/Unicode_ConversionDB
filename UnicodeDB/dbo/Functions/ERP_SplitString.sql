CREATE FUNCTION dbo.ERP_SplitString  
(  
    @String NVARCHAR(MAX),  
    @Delimiter NVARCHAR(10)  
)  
RETURNS @Result TABLE (Value NVARCHAR(MAX))  
AS  
BEGIN  
    DECLARE @Value NVARCHAR(MAX)  
    WHILE CHARINDEX(@Delimiter, @String) > 0  
    BEGIN  
        SET @Value = LEFT(@String, CHARINDEX(@Delimiter, @String) - 1)  
        INSERT INTO @Result (Value) VALUES (@Value)  
        SET @String = RIGHT(@String, LEN(@String) - CHARINDEX(@Delimiter, @String))  
    END  
    INSERT INTO @Result (Value) VALUES (@String)  
    RETURN  
END  