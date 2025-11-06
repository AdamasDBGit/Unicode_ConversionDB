CREATE PROCEDURE [dbo].[GetTableNamesFromProcedure]
    @ProcedureName NVARCHAR(255)
AS
BEGIN
    -- Create a temporary table to store the results
    CREATE TABLE #TempTable (TableName NVARCHAR(255));

    -- Declare variables
    DECLARE @SqlStatement NVARCHAR(MAX);

    -- Build the dynamic SQL statement
    SET @SqlStatement = '
        INSERT INTO #TempTable (TableName)
        SELECT DISTINCT t.name
        FROM sysobjects o
        JOIN syscomments c ON o.id = c.id
        JOIN sys.tables t ON t.name LIKE ''%'' + o.name + ''%''
        WHERE o.xtype = ''P'' AND o.name = ''' + @ProcedureName + '''';
		Print @SqlStatement
    -- Execute the dynamic SQL
    EXEC sp_executesql @SqlStatement;

    -- Select the results
    SELECT * FROM #TempTable;

    -- Drop the temporary table
    DROP TABLE #TempTable;
END;
