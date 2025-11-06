-- =============================================  
-- Author:      Mayur Lawankar  
-- Create date: 9 Sep 2024  
-- Description: Fetch Exam Category Details by ID  
-- =============================================  
  
  
CREATE PROCEDURE [dbo].[USP_ERP_GetExamCategoryByID]  
    @I_EXAM_CATEGORY_ID INT  
AS  
BEGIN  
    SET NOCOUNT ON;  
  
    -- Check if the provided ID is valid  
    IF @I_EXAM_CATEGORY_ID IS NULL  
    BEGIN  
        -- Return an error if the ID is not provided  
        SELECT 0 AS StatusFlag, 'Invalid Category ID' AS Message;  
        RETURN;  
    END  
  
    -- Fetch the category details based on the provided ID  
    SELECT  
        inExamCategoryId,  
        inExamTypeID AS ExamTypeID,  
        stExamCategoryName AS CategoryName,  
        inBrandID,  
        IsActive,  
        dtCreatedDate,  
        inCreatedBy,  
        unCategoryId,  
        inSchoolGroupID AS SchoolGroupID,  
        inSchoolSessionID AS Session  
    FROM T_ERP_EXAM_CATEGORY  
    WHERE inExamCategoryId = @I_EXAM_CATEGORY_ID;  
  
    -- Check if the category exists  
    IF @@ROWCOUNT = 0  
    BEGIN  
        -- Return an error if no category is found  
        SELECT 0 AS StatusFlag, 'Category not found' AS Message;  
    END  
    ELSE  
    BEGIN  
        -- Return success if category is found  
        SELECT 1 AS StatusFlag, 'Category fetched successfully!' AS Message;  
    END  
END  