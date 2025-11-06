CREATE PROCEDURE [dbo].[usp_ERP_Exam_GetTypeList]   
(  
    @ExamTypeName NVARCHAR(max) = NULL,    
    @inTYPE INT = NULL,    
    @unTypeId UNIQUEIDENTIFIER = NULL,    
    @inBrandID INT = NULL  
)  
AS  
BEGIN  
    SET NOCOUNT ON;  

    -- Build the SQL query
    DECLARE @stSQL AS NVARCHAR(max);
    
    SET @stSQL = 'SELECT 
                      inExamTypeID, 
                      stExamTypeName, 
                      inTYPE, 
					  IsMainExam,
                      unTypeId, 
                      inBrandID  
                  FROM T_ERP_Exam_Type_Master ET  
                  WHERE 1=1';  

    -- Add filters  
    IF @ExamTypeName IS NOT NULL  
        SET @stSQL = @stSQL + ' AND ET.stExamTypeName LIKE @ExamTypeName';  

    IF @inTYPE IS NOT NULL  
        SET @stSQL = @stSQL + ' AND ET.inTYPE = @inTYPE';  

    IF @unTypeId IS NOT NULL  
        SET @stSQL = @stSQL + ' AND ET.unTypeId = @unTypeId';  

    IF @inBrandID IS NOT NULL  
        SET @stSQL = @stSQL + ' AND ET.inBrandID = @inBrandID';  

    -- Add ORDER BY clause  
    SET @stSQL = @stSQL + ' ORDER BY inExamTypeID DESC';  

    -- Execute the SQL query with the parameters
    EXEC sp_executesql @stSQL,  
        N'@ExamTypeName NVARCHAR(max), @inTYPE INT, @unTypeId UNIQUEIDENTIFIER, @inBrandID INT',  
        @ExamTypeName, @inTYPE, @unTypeId, @inBrandID;  
END  

