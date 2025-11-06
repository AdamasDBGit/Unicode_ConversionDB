CREATE FUNCTION [dbo].[fn_Split_comma_String]
(
    @InputString NVARCHAR(MAX),
    @Delimiter CHAR(1)
)
RETURNS @OutputTable TABLE 
(
    ID INT IDENTITY(1,1) PRIMARY KEY,
    Value NVARCHAR(MAX)
)
AS
BEGIN
    DECLARE @StartIndex INT, @EndIndex INT;

    -- Initialize start position
    SET @StartIndex = 1;

    -- Find the first occurrence of the delimiter
    SET @EndIndex = CHARINDEX(@Delimiter, @InputString);

    -- Loop through the input string
    WHILE @StartIndex <= LEN(@InputString)
    BEGIN
        -- If no more delimiters are found, set the end to the end of the string
        IF @EndIndex = 0
            SET @EndIndex = LEN(@InputString) + 1;

        -- Insert the substring into the output table
        INSERT INTO @OutputTable (Value)
        VALUES (SUBSTRING(@InputString, @StartIndex, @EndIndex - @StartIndex));

        -- Move the start position to the next character after the delimiter
        SET @StartIndex = @EndIndex + 1;

        -- Find the next occurrence of the delimiter
        SET @EndIndex = CHARINDEX(@Delimiter, @InputString, @StartIndex);
    END;

    RETURN;
END;
