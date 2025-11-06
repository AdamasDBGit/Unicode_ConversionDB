CREATE PROCEDURE [dbo].[USP_ERP_SaveNotificationDetails]  
    @inNotificationScheduleID INT = NULL,  
    @inTypeId INT,  
    @stTypeName Nnvarchar(max),  
    @inCategoryId INT,  
    @stCategoryName Nnvarchar(max),  
    @inPriorityId INT,  
    @stPriorityName Nnvarchar(max),  
    @stDeliveryChannelId Nnvarchar(max),  
    @stDeliveryChannelName Nnvarchar(max),  
    @inRecipientId INT,  
    @stRecipientName Nnvarchar(max),  
    @stForAllOrIndividual Nnvarchar(max),  
    @stSchoolProgramId Nnvarchar(max) = NULL,  
    @stSchoolProgramName Nnvarchar(max) = NULL,  
    @stClassId Nnvarchar(max) = NULL,  
    @stClassName Nnvarchar(max) = NULL,      
    @stClassStreamSectionId Nnvarchar(max) = NULL,  
    @stClassStreamSectionName Nnvarchar(max) = NULL,  
    @inTemplateId INT,  
    @stTemplateTitle Nnvarchar(max),  
    @stSMSTemplateMessage Nnvarchar(max) = NULL,  
    @stPushTemplateMessage Nnvarchar(max) = NULL,  
 @stPushTitle Nnvarchar(max) = NULL,  
    @stEmailSubject Nnvarchar(max) = NULL,  
    @stEmailTemplateMessage Nnvarchar(max) = NULL,  
    @dtNotificationDate DATETIME = NULL,  
    @tmNotificationTime TIME(7) = NULL,  
    @stEmailAttachment Nnvarchar(max) = NULL,  
 @stPushAttachment Nnvarchar(max) = NULL,  
    @inCreatedBy INT,  
    @inBrandId INT,  
    @stNotificationType Nnvarchar(max),  
    @dtStartDate DATETIME  = NULL,  
    @dtEndDate DATETIME  = NULL,  
    @stFrequency Nnvarchar(max) = NULL,  
    @stFrequencyWord Nnvarchar(max) = NULL,  
    @tempNotificationClassStreamSectionInfo dbo.UT_Notification_ClassStreamSectionInfo READONLY  
AS  
BEGIN  
    SET NOCOUNT ON;  
  
    BEGIN TRY  
        BEGIN TRANSACTION;  
    
        DECLARE @NotificationId INT;  
  
        IF @inNotificationScheduleID IS NULL  
        BEGIN  
            -- Insert operation  
            INSERT INTO [dbo].[T_ERP_Notification_Schedule]  
            (  
                inTypeId,  
                stTypeName,  
                inCategoryId,  
                stCategoryName,  
                inPriorityId,  
                stPriorityName,  
                stDeliveryChannelId,  
                stDeliveryChannelName,  
                inRecipientId,  
                stRecipientName,  
                stForAllOrIndividual,  
                stSchoolProgramId,  
                stSchoolProgramName,  
                stClassId,  
                stClassName,  
                stClassStreamSectionId,  
                stClassStreamSectionName,  
                inTemplateId,  
                stTemplateTitle,  
                stSMSTemplateMessage,  
                stPushTemplateMessage,  
                stEmailSubject,  
                stEmailTemplateMessage,  
                dtNotificationDate,  
                tmNotificationTime,  
                stEmailAttachment,  
    stPushAttachment,  
                dtCreatedDate,  
                inCreatedBy,  
                inBrandId,  
                stNotificationType,  
                dtStartDate,  
                dtEndDate,  
                stFrequency,  
                stFrequencyWord,  
                inStatus,  
    stPushTitle  
            )  
            VALUES  
            (  
                @inTypeId,  
                @stTypeName,  
                @inCategoryId,  
                @stCategoryName,  
                @inPriorityId,  
                @stPriorityName,  
                @stDeliveryChannelId,  
                @stDeliveryChannelName,  
                @inRecipientId,  
                @stRecipientName,  
                @stForAllOrIndividual,  
                @stSchoolProgramId,  
                @stSchoolProgramName,  
                @stClassId,  
                @stClassName,  
                @stClassStreamSectionId,  
                @stClassStreamSectionName,  
                @inTemplateId,  
                @stTemplateTitle,  
                @stSMSTemplateMessage,  
                @stPushTemplateMessage,  
                @stEmailSubject,  
                @stEmailTemplateMessage,  
                @dtNotificationDate,  
                @tmNotificationTime,  
                @stEmailAttachment,  
    @stPushAttachment,  
                GETDATE(),  
                @inCreatedBy,  
                @inBrandId,  
                @stNotificationType,  
                @dtStartDate,  
                @dtEndDate,  
                @stFrequency,  
                @stFrequencyWord,  
                1,  
    @stPushTitle  
            );  
  
            SET @NotificationId = SCOPE_IDENTITY();   
  
        END  
        ELSE  
        BEGIN  
            -- Update operation  
            UPDATE [dbo].[T_ERP_Notification_Schedule]  
            SET  
                inTypeId = @inTypeId,  
                stTypeName = @stTypeName,  
                inCategoryId = @inCategoryId,  
                stCategoryName = @stCategoryName,  
                inPriorityId = @inPriorityId,  
                stPriorityName = @stPriorityName,  
                stDeliveryChannelId = @stDeliveryChannelId,  
                stDeliveryChannelName = @stDeliveryChannelName,  
                inRecipientId = @inRecipientId,  
                stRecipientName = @stRecipientName,  
                stForAllOrIndividual = @stForAllOrIndividual,  
                stSchoolProgramId = @stSchoolProgramId,  
                stSchoolProgramName = @stSchoolProgramName,  
                stClassId = @stClassId,  
                stClassName = @stClassName,  
                stClassStreamSectionId = @stClassStreamSectionId,  
                stClassStreamSectionName = @stClassStreamSectionName,  
                inTemplateId = @inTemplateId,  
                stTemplateTitle = @stTemplateTitle,  
                stSMSTemplateMessage = @stSMSTemplateMessage,  
                stPushTemplateMessage = @stPushTemplateMessage,  
                stEmailSubject = @stEmailSubject,  
                stEmailTemplateMessage = @stEmailTemplateMessage,  
                dtNotificationDate = @dtNotificationDate,  
                tmNotificationTime = @tmNotificationTime,  
                stEmailAttachment = @stEmailAttachment,  
    stPushAttachment = @stPushAttachment,  
                dtModifiedDate = GETDATE(),   
                inModifiedBy = @inCreatedBy,  
                inBrandId = @inBrandId,  
                stNotificationType = @stNotificationType,  
                dtStartDate = @dtStartDate,  
                dtEndDate = @dtEndDate,  
                stFrequency = @stFrequency,  
                stFrequencyWord = @stFrequencyWord,  
    stPushTitle = @stPushTitle  
            WHERE  
                inNotificationScheduleID = @inNotificationScheduleID;  
  
            SET @NotificationId = @inNotificationScheduleID;  
        END  
  
        -- Delete existing records for this notification schedule  
        DELETE FROM T_ERP_Notification_Class_Stream_Section   
        WHERE inNotificationScheduleID = @NotificationId;  
  
        -- Insert only if the table-valued parameter has data  
        IF EXISTS (SELECT 1 FROM @tempNotificationClassStreamSectionInfo)  
        BEGIN  
            INSERT INTO T_ERP_Notification_Class_Stream_Section   
            (inNotificationScheduleID, inSchoolProgramId, inClassId, inStreamId, inSectionId)  
            SELECT @NotificationId, TM.inSchoolProgramId, TM.inClassId, TM.inStreamId, TM.inSectionId   
            FROM @tempNotificationClassStreamSectionInfo TM;  
        END  
  
        COMMIT TRANSACTION;  
  
        -- Return success response  
        SELECT   
            1 AS StatusFlag,   
            'Notification saved successfully' AS Message,  
            @NotificationId AS NotificationId;    
  
    END TRY  
    BEGIN CATCH  
        -- Rollback the transaction on error  
        ROLLBACK TRANSACTION;  
  
        DECLARE @ErrMsg Nnvarchar(max), @ErrSeverity INT;  
  
        SELECT @ErrMsg = ERROR_MESSAGE(),  
               @ErrSeverity = ERROR_SEVERITY();  
  
        -- Return error response  
        SELECT 0 AS StatusFlag, @ErrMsg AS Message, 0 AS NotificationId;  
    END CATCH  
END;  
  
  
  
  