--exec usp_ERP_GetNotificationList 107,'Custom'  
  
CREATE PROCEDURE [dbo].[usp_ERP_GetNotificationList]    
(    
    @inBrandId INT = NULL,  
    @stNotificationType NVARCHAR(100) = NULL  
)   
AS   
BEGIN TRY    
    SET NOCOUNT ON;    
    --SET TRANSACTION ISOLATION LEVEL READ COMMITTED;    
  
--DECLARE @inBrandId INT = 107;  
--DECLARE @stNotificationType NVARCHAR(100) = NULL;  
  
    -- Fetch latest job state for each notification  
    WITH JobStatus AS (  
        SELECT   
            J.Id AS JobId,  
            S.Name AS JobState,  
            S.CreatedAt,  
            ROW_NUMBER() OVER (PARTITION BY J.Id ORDER BY S.CreatedAt DESC) AS rn  
        FROM HangFire.Job J  
        LEFT JOIN HangFire.State S ON J.Id = S.JobId  
    )  
      
    SELECT   
        N.inNotificationScheduleID,  
        N.stTemplateTitle,  
        N.stTypeName,  
        N.stEmailTemplateMessage,  
        N.stEmailSubject,  
        N.stSMSTemplateMessage,  
        N.stPushTemplateMessage,  
        N.stCategoryName,  
        N.stPriorityName,  
        N.stDeliveryChannelName,  
        N.stNotificationType,  
        N.stClassStreamSectionId,  
        N.dtCreatedDate,  
        N.dtStartDate,  
        N.dtEndDate,  
        N.stFrequency,  
        N.stFrequencyWord,  
        N.inStatus,  
        N.stForAllOrIndividual,  
        N.stRecipientName,  
        COALESCE(RecipientCounts.inRecipientCount, 0) AS inRecipientCount,  
        AggregatedData.stStudentIds,  
        AggregatedData.stStudentNames,  
        AggregatedData.inUserIds,  
        AggregatedData.stUserNames,  
        COALESCE(JS.JobState, 'Succeeded') AS JobStatus  -- Hangfire job status  
    FROM   
        T_ERP_Notification_Schedule N  
    LEFT JOIN   
        (SELECT   
            NSL.inNotificationScheduleID,  
            COUNT(DISTINCT COALESCE(NSL.stStudentId, NSL.stUserName)) AS inRecipientCount  
         FROM T_ERP_Notification_Schedule_Logs NSL  
         GROUP BY NSL.inNotificationScheduleID  
        ) AS RecipientCounts   
        ON N.inNotificationScheduleID = RecipientCounts.inNotificationScheduleID  
    LEFT JOIN   
        (SELECT   
            NSL.inNotificationScheduleID,  
  
            -- Aggregate Student IDs  
            STUFF((SELECT DISTINCT ', ' + NSL2.stStudentId   
                   FROM T_ERP_Notification_Schedule_Logs NSL2  
                   WHERE NSL2.inNotificationScheduleID = NSL.inNotificationScheduleID   
                   FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 2, '') AS stStudentIds,  
  
            -- Aggregate Student Names  
            STUFF((SELECT DISTINCT ', ' + NSL2.stStudentName   
                   FROM T_ERP_Notification_Schedule_Logs NSL2  
                   WHERE NSL2.inNotificationScheduleID = NSL.inNotificationScheduleID   
                   FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 2, '') AS stStudentNames,  
  
            -- Aggregate User IDs  
            STUFF((SELECT DISTINCT ', ' + CAST(NSL2.inUserId AS NVARCHAR(MAX))   
                   FROM T_ERP_Notification_Schedule_Logs NSL2  
                   WHERE NSL2.inNotificationScheduleID = NSL.inNotificationScheduleID   
                   FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 2, '') AS inUserIds,  
  
            -- Aggregate User Names  
            STUFF((SELECT DISTINCT ', ' + NSL2.stUserName   
                   FROM T_ERP_Notification_Schedule_Logs NSL2  
                   WHERE NSL2.inNotificationScheduleID = NSL.inNotificationScheduleID   
                   FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 2, '') AS stUserNames  
  
        FROM T_ERP_Notification_Schedule_Logs NSL  
        GROUP BY NSL.inNotificationScheduleID  
        ) AS AggregatedData  
        ON N.inNotificationScheduleID = AggregatedData.inNotificationScheduleID  
    LEFT JOIN JobStatus JS ON N.inJobId = JS.JobId AND JS.rn = 1    
    WHERE  
        (@inBrandId IS NULL OR N.inBrandId = @inBrandId)    
        AND (@stNotificationType IS NULL OR N.stNotificationType = @stNotificationType)    
    ORDER BY   
        N.inNotificationScheduleID DESC;  
  
END TRY    
BEGIN CATCH    
    THROW;  -- Throws actual error message for better debugging  
END CATCH;