--exec POC_usp_GetStudentChartData 1,'T_POC_StudentChartData_Hindi'
CREATE PROCEDURE [dbo].[POC_usp_GetStudentChartData]
@Id INT,
@table NVARCHAR(200) = 'T_POC_StudentChartData' -- Default table name
AS
BEGIN
    DECLARE @SQL NVARCHAR(MAX);
    SET @SQL = N'SELECT *' + 
               N' FROM [dbo].' + QUOTENAME(@table) + 
               N' WHERE Id = @Id';

    -- Execute the dynamic SQL
    EXEC sp_executesql @SQL, N'@Id INT', @Id;
END
