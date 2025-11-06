CREATE FUNCTION [dbo].[SplitString](@String NVARCHAR(MAX), @Delimiter CHAR(1))
RETURNS @Result TABLE (Value NVARCHAR(MAX))
AS
BEGIN
    DECLARE @Value NVARCHAR(MAX)
    WHILE CHARINDEX(@Delimiter, @String) > 0
    BEGIN
        -- Extract the substring before the delimiter, trim spaces, and insert into the result table
        SELECT @Value = LTRIM(RTRIM(SUBSTRING(@String, 1, CHARINDEX(@Delimiter, @String) - 1)))
        IF @Value <> '' -- Ensure no empty values are inserted
            INSERT INTO @Result (Value) VALUES (@Value)
        
        -- Move the remaining string forward after the delimiter
        SELECT @String = SUBSTRING(@String, CHARINDEX(@Delimiter, @String) + 1, LEN(@String))
    END

    -- Insert the final value after the last delimiter, if it exists and is not empty
    IF LTRIM(RTRIM(@String)) <> ''
        INSERT INTO @Result (Value) VALUES (LTRIM(RTRIM(@String)))

    RETURN
END
