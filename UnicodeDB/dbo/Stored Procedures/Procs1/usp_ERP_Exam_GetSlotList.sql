-- =============================================  
-- Author:  Qutub Haider  
-- Create date: 8 Aug 2024  
-- EDIT DATE : 30 SEPT
-- Description: Get Exam Slot List  
-- =============================================  

CREATE PROCEDURE [dbo].[usp_ERP_Exam_GetSlotList]   
(  
    @SlotCode NVARCHAR(50) = NULL,  
    @StartTime TIME(0) = NULL,  
    @EndTime TIME(0) = NULL,  
    @IsActive BIT = NULL,  
    @inSortColumn INT = NULL,  
    @stSortOrder NVARCHAR(51) = NULL  
)  
AS  
BEGIN  
    SET NOCOUNT ON;  
    DECLARE @stSQL AS NVARCHAR(MAX);  
    DECLARE @stSort AS NVARCHAR(MAX) = 'inSlotID';  

    -- Default sort order  
    SET @stSortOrder = ISNULL(@stSortOrder, 'DESC');  

    -- Determine sort column  
    IF @inSortColumn = 1  
    BEGIN  
        SET @stSort = 'inSlotID';  
    END  
    ELSE IF @inSortColumn = 2  
    BEGIN  
        SET @stSort = 'stSlotCode';  
    END  
    ELSE IF @inSortColumn = 3  
    BEGIN  
        SET @stSort = 'tmSlotStartTime';  
    END  
    ELSE IF @inSortColumn = 4  
    BEGIN  
        SET @stSort = 'tmSlotEndTime';  
    END  
    ELSE IF @inSortColumn = 5  
    BEGIN  
        SET @stSort = 'dtCreatedDate';  
    END  
    ELSE IF @inSortColumn = 6  
    BEGIN  
        SET @stSort = 'dtModifiedDate';  
    END  

    -- Build dynamic SQL query  
    SET @stSQL = '  
        SELECT  
            inSlotID, 
            stSlotCode, 
            tmSlotStartTime, 
            tmSlotEndTime, 
            dtCreatedDate, 
            dtModifiedDate, 
            inCreatedBy, 
            inModifiedBy, 
            IsActive  
        FROM T_ERP_Exam_Slot_Master ES  
        ORDER BY 1 DESC'; 

    EXEC sp_executesql @stSQL;
END
