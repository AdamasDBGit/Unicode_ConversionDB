CREATE PROCEDURE [dbo].[USP_ERP_GetExamCategoryList]  
(  
    @ExamCategoryName NVARCHAR(max) = NULL,    
    @ExamTypeID INT = NULL,    
    @BrandID INT = NULL,    
    @SchoolGroupID INT = NULL,   
    @SchoolSessionID INT = NULL,    
    @IsActive BIT = NULL,   
    @SortColumn INT = NULL,    
    @SortOrder NVARCHAR(max) = 'ASC',
	@inPageNo INT = 1,   
	@inPageSize INT = 10,
	@inUserId INT = NULL
)  
AS  
BEGIN  
    SET NOCOUNT ON;  
    
    DECLARE @SQL AS NVARCHAR(max);
    DECLARE @stSort NVARCHAR(max) = 'inExamCategoryId';   
    DECLARE @inStart INT, @inEnd INT;   

    SET @SortOrder = UPPER(ISNULL(@SortOrder, 'ASC'));
    SET @inStart = (@inPageNo - 1) * @inPageSize + 1;   
    SET @inEnd = @inPageNo * @inPageSize;   

    -- Determine sorting column  
    IF @SortColumn = 1   
        SET @stSort = 'inExamCategoryId';   
    ELSE IF @SortColumn = 2  
        SET @stSort = 'stExamCategoryName';   
  
    -- Dynamic SQL construction
    SET @SQL = '
    WITH PAGED AS (
        SELECT  
            ROW_NUMBER() OVER(ORDER BY ' + QUOTENAME(@stSort) + ' ' + @SortOrder + ') AS inRownumber,
            inExamCategoryId,  
            inExamTypeID,  
            stExamCategoryName,  
            inBrandID,  
            IsActive,  
            dtCreatedDate,  
            inCreatedBy,  
            unCategoryId,  
            inSchoolGroupID,  
            inSchoolSessionID  
        FROM T_ERP_EXAM_CATEGORY  
        WHERE 1=1';  
  
    -- Add filters safely
    IF @ExamCategoryName IS NOT NULL  
        SET @SQL += ' AND stExamCategoryName LIKE ''%' + REPLACE(@ExamCategoryName, '''', '''''') + '%''';
  
    IF @ExamTypeID IS NOT NULL  
        SET @SQL += ' AND inExamTypeID = ' + CAST(@ExamTypeID AS NVARCHAR(10));
  
    IF @BrandID IS NOT NULL  
        SET @SQL += ' AND inBrandID = ' + CAST(@BrandID AS NVARCHAR(10));
  
    IF @SchoolGroupID IS NOT NULL  
        SET @SQL += ' AND inSchoolGroupID = ' + CAST(@SchoolGroupID AS NVARCHAR(10));
  
    IF @SchoolSessionID IS NOT NULL  
        SET @SQL += ' AND inSchoolSessionID = ' + CAST(@SchoolSessionID AS NVARCHAR(10));
  
    IF @IsActive IS NOT NULL  
        SET @SQL += ' AND IsActive = ' + CAST(@IsActive AS NVARCHAR(1));

    -- Finalize pagination and execute
    SET @SQL += '  
        )
        SELECT  
            (SELECT COUNT(*) FROM PAGED) AS inRecordCount,  
            *  
        FROM PAGED  
        WHERE inRownumber BETWEEN ' + CAST(@inStart AS NVARCHAR(10)) + ' AND ' + CAST(@inEnd AS NVARCHAR(10)) + ';';

    -- Debugging output and execution
    PRINT(@SQL);  
    EXEC sp_executesql @SQL;
END;

