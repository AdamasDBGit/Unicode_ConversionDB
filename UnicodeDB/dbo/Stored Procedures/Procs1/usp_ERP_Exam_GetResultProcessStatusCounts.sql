--exec usp_ERP_Exam_GetResultProcessStatusCounts  
  
CREATE PROCEDURE [dbo].[usp_ERP_Exam_GetResultProcessStatusCounts]  
(  
@inBrandID int  
)  
AS  
  
BEGIN  
    -- Count pending results (where inResultProcessStatus is NULL or 1)  
    DECLARE @PendingCount INT;  
    SELECT @PendingCount = COUNT(*)  
    FROM T_ERP_Exam_SchedulesDetails  
    WHERE inResultProcessStatus IS NULL OR inResultProcessStatus = 1 and inBrandId=@inBrandID;  
  
    -- Count results ready for publish (where inResultProcessStatus is 2)  
    DECLARE @ReadyForPublishCount INT;  
    SELECT @ReadyForPublishCount = COUNT(*)  
    FROM T_ERP_Exam_SchedulesDetails  
    WHERE inResultProcessStatus = 2 and inBrandId=@inBrandID;  
  
    -- Count completed results (where inResultProcessStatus is 3)  
    DECLARE @CompletedCount INT;  
    SELECT @CompletedCount = COUNT(*)  
    FROM T_ERP_Exam_SchedulesDetails  
    WHERE inResultProcessStatus = 3 and inBrandId=@inBrandID;  
  
    -- Return the counts  
    SELECT   
        @PendingCount AS PendingCount,   
        @ReadyForPublishCount AS ReadyForPublishCount,   
        @CompletedCount AS CompletedCount;  
END;  