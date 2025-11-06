CREATE PROCEDURE [dbo].[USP_ERP_SaveNotificationDetailsWithLogs]      
(    
    @inNotificationScheduleID INT = NULL,      
    @inTypeId INT,      
    @stTypeName NVARCHAR(max),      
    @inCategoryId INT,      
    @stCategoryName NVARCHAR(max),      
    @inPriorityId INT,      
    @stPriorityName NVARCHAR(max),      
    @stDeliveryChannelId NVARCHAR(max),      
    @stDeliveryChannelName NVARCHAR(max),      
    @inRecipientId INT,      
    @stRecipientName NVARCHAR(max),      
    @stForAllOrIndividual NVARCHAR(max),      
    @stSchoolProgramId NVARCHAR(max) = NULL,      
    @stSchoolProgramName NVARCHAR(max) = NULL,      
    @stClassId NVARCHAR(max) = NULL,      
    @stClassName NVARCHAR(max) = NULL,      
    @stClassStreamSectionId NVARCHAR(max) = NULL,      
    @stClassStreamSectionName NVARCHAR(max) = NULL,      
    @inTemplateId INT,      
    @stTemplateTitle NVARCHAR(max),      
    @stSMSTemplateMessage NVARCHAR(max) = NULL,      
    @stPushTemplateMessage NVARCHAR(max) = NULL,      
    @stPushTitle NVARCHAR(max) = NULL,      
    @stEmailSubject NVARCHAR(max) = NULL,      
    @stEmailTemplateMessage NVARCHAR(max) = NULL,      
    @dtNotificationDate DATETIME = NULL,      
    @tmNotificationTime TIME(7) = NULL,      
    @stEmailAttachment NVARCHAR(max) = NULL,      
    @stPushAttachment NVARCHAR(max) = NULL,      
    @inCreatedBy INT,      
    @inBrandId INT,      
    @stNotificationType NVARCHAR(max),      
    @dtStartDate DATETIME = NULL,      
    @dtEndDate DATETIME = NULL,      
    @stFrequency NVARCHAR(max) = NULL,      
    @stFrequencyWord NVARCHAR(max) = NULL,      
    @tempNotificationClassStreamSectionInfo dbo.UT_Notification_ClassStreamSectionInfo READONLY,      
    @StudentIds NVARCHAR(max) = NULL ,
	@inNotificationDefinedTypeId int=null,
	@inEventTypeId int=null,
    @stVariableTypeId nvarchar=null
)      
AS      
Begin      
    SET NOCOUNT ON;      
    
    DECLARE @NotificationId INT;   
	
    BEGIN TRY  
	        BEGIN TRANSACTION;      

	IF OBJECT_ID('tempdb..#FirebaseTokens') IS NOT NULL
    DROP TABLE #FirebaseTokens;
     CREATE TABLE #FirebaseTokens      
        (      
            firebase_token NVARCHAR(max) NULL,      
            student_id NVARCHAR(max) NULL,      
            student_name NVARCHAR(max) NULL,      
            parent_name NVARCHAR(max) NULL,      
            student_dob DATE NULL,      
            student_address NVARCHAR(max) NULL,      
            student_roll_no NVARCHAR(max) NULL,      
            class_teacher_name NVARCHAR(max) NULL,      
            current_grade_class NVARCHAR(max) NULL,      
            current_grade_class_section_stream NVARCHAR(max) NULL,      
            student_phone NVARCHAR(max) NULL,      
            student_email NVARCHAR(max) NULL,      
            inParentMasterID INT NULL,      
            school_id INT NULL, school_name NVARCHAR(max) NULL,      
            school_logo NVARCHAR(max) NULL, school_address NVARCHAR(max) NULL,      
            school_contact_number NVARCHAR(max) NULL, school_email NVARCHAR(max) NULL,      
            academic_year NVARCHAR(max) NULL, principal_name NVARCHAR(max) NULL,      
            event_description NVARCHAR(max) NULL, event_start_date DATETIME NULL, event_end_date DATETIME NULL,      
            event_category NVARCHAR(max) NULL, event_start_time NVARCHAR(max) NULL, event_end_time NVARCHAR(max) NULL,      
            event_location NVARCHAR(max) NULL, event_type NVARCHAR(max) NULL, rsvp_link NVARCHAR(max) NULL,      
            current_due_amount DECIMAL(18,2) NULL, current_due_date DATETIME NULL,      
            last_payment_id INT NULL, last_payment_status NVARCHAR(max) NULL,      
            current_installment_fees DECIMAL(18,2) NULL, last_payment_received_date DATETIME NULL,      
            current_balance_amount DECIMAL(18,2) NULL, current_late_fee DECIMAL(18,2) NULL,      
            current_due_payment_link NVARCHAR(max) NULL,      
            enquiry_no NVARCHAR(max) NULL, provisional_student_name NVARCHAR(max) NULL,      
            admission_date DATETIME NULL, admission_stage NVARCHAR(max) NULL,      
            previous_school_name NVARCHAR(max) NULL, previous_academic_record NVARCHAR(max) NULL,      
            submitted_documents NVARCHAR(max) NULL, provisional_student_parent_name NVARCHAR(max) NULL,      
            admission_fee DECIMAL(18,2) NULL, admission_grade_class_section_stream NVARCHAR(max) NULL,      
            gatepass_issue_date DATETIME NULL, gatepass_expiry_date DATETIME NULL,      
            gatepass_reason NVARCHAR(max) NULL, parent_master_id INT NULL, gatepass_issuer_name NVARCHAR(max) NULL,      
            user_id INT NULL, recipient_name NVARCHAR(max) NULL, birthday_year INT NULL,      
            work_experience_years NVARCHAR(max) NULL, is_Faculty BIT NULL, join_date DATETIME NULL,      
            stParentToken NVARCHAR(max) NULL      
        )
		 INSERT INTO #FirebaseTokens      
        EXEC dbo.USP_GetFirebaseTokensByStudentIds      
            @inRecipientId, @inCategoryId, @stSchoolProgramId, @stClassId, NULL, NULL, @StudentIds, @inBrandId, NULL;      
    Print 'Execution of USP_GetFirebaseTokensByStudentIds for 1 '
    If (@inNotificationDefinedTypeId=1 OR @inNotificationDefinedTypeId is null)
	Begin
	Print 'For @inNotificationDefinedTypeId=1 '
        -----------------------------------------------------------------    
        -- STEP 1: Insert/Update Notification Schedule      
        -----------------------------------------------------------------    
        --INSERT INTO dbo.USP_ERP_SaveNotificationDetailsWithLogs_Debug (StepName, StepMessage)      
        --VALUES ('STEP 1', 'Insert/Update Notification Schedule starting');      
        
        --BEGIN TRANSACTION;      
    
        IF @inNotificationScheduleID IS NULL      
        BEGIN      
            INSERT INTO [dbo].[T_ERP_Notification_Schedule]      
            (      
                inTypeId, stTypeName,      
                inCategoryId, stCategoryName,      
                inPriorityId, stPriorityName,      
                stDeliveryChannelId, stDeliveryChannelName,      
                inRecipientId, stRecipientName, stForAllOrIndividual,      
                stSchoolProgramId, stSchoolProgramName,      
                stClassId, stClassName,      
                stClassStreamSectionId, stClassStreamSectionName,      
                inTemplateId, stTemplateTitle,      
                stSMSTemplateMessage, stPushTemplateMessage,      
                stEmailSubject, stEmailTemplateMessage,      
                dtNotificationDate, tmNotificationTime,      
                stEmailAttachment, stPushAttachment,      
                dtCreatedDate, inCreatedBy, inBrandId,      
                stNotificationType, dtStartDate, dtEndDate,      
                stFrequency, stFrequencyWord, inStatus, stPushTitle      
            )      
            VALUES      
            (      
                @inTypeId, @stTypeName,      
                @inCategoryId, @stCategoryName,      
                @inPriorityId, @stPriorityName,      
                @stDeliveryChannelId, @stDeliveryChannelName,      
                @inRecipientId, @stRecipientName, @stForAllOrIndividual,      
                @stSchoolProgramId, @stSchoolProgramName,      
                @stClassId, @stClassName,      
                @stClassStreamSectionId, @stClassStreamSectionName,      
                @inTemplateId, @stTemplateTitle,      
                @stSMSTemplateMessage, @stPushTemplateMessage,      
                @stEmailSubject, @stEmailTemplateMessage,      
                @dtNotificationDate, @tmNotificationTime,      
                @stEmailAttachment, @stPushAttachment,      
                GETDATE(), @inCreatedBy, @inBrandId,      
                @stNotificationType, @dtStartDate, @dtEndDate,      
                @stFrequency, @stFrequencyWord, 1, @stPushTitle      
            );      
    
            SET @NotificationId = SCOPE_IDENTITY();      
        END      
        ELSE      
        BEGIN      
            UPDATE [dbo].[T_ERP_Notification_Schedule]      
            SET      
                inTypeId = @inTypeId, stTypeName = @stTypeName,      
                inCategoryId = @inCategoryId, stCategoryName = @stCategoryName,      
                inPriorityId = @inPriorityId, stPriorityName = @stPriorityName,      
                stDeliveryChannelId = @stDeliveryChannelId, stDeliveryChannelName = @stDeliveryChannelName,      
                inRecipientId = @inRecipientId, stRecipientName = @stRecipientName,      
                stForAllOrIndividual = @stForAllOrIndividual,      
                stSchoolProgramId = @stSchoolProgramId, stSchoolProgramName = @stSchoolProgramName,      
                stClassId = @stClassId, stClassName = @stClassName,      
                stClassStreamSectionId = @stClassStreamSectionId, stClassStreamSectionName = @stClassStreamSectionName,      
                inTemplateId = @inTemplateId, stTemplateTitle = @stTemplateTitle,      
                stSMSTemplateMessage = @stSMSTemplateMessage, stPushTemplateMessage = @stPushTemplateMessage,      
                stEmailSubject = @stEmailSubject, stEmailTemplateMessage = @stEmailTemplateMessage,      
                dtNotificationDate = @dtNotificationDate, tmNotificationTime = @tmNotificationTime,      
                stEmailAttachment = @stEmailAttachment, stPushAttachment = @stPushAttachment,      
                dtModifiedDate = GETDATE(), inModifiedBy = @inCreatedBy,      
                inBrandId = @inBrandId, stNotificationType = @stNotificationType,      
                dtStartDate = @dtStartDate, dtEndDate = @dtEndDate,      
                stFrequency = @stFrequency, stFrequencyWord = @stFrequencyWord,      
                stPushTitle = @stPushTitle      
            WHERE inNotificationScheduleID = @inNotificationScheduleID;      
            
            SET @NotificationId = @inNotificationScheduleID;      
        END      
    
        --COMMIT TRANSACTION;      
    
        --INSERT INTO dbo.USP_ERP_SaveNotificationDetailsWithLogs_Debug (StepName, StepMessage)      
        --VALUES ('STEP 1', 'Insert/Update Notification Schedule completed');      
    
        -----------------------------------------------------------------    
        -- STEP 2: Refresh Class/Stream Section      
        -----------------------------------------------------------------    
        DELETE FROM T_ERP_Notification_Class_Stream_Section WHERE inNotificationScheduleID = @NotificationId;      
        
        --INSERT INTO dbo.USP_ERP_SaveNotificationDetailsWithLogs_Debug (StepName, StepMessage)      
        --VALUES ('STEP 2', 'Class/Stream Section cleared');      
    
        IF EXISTS (SELECT 1 FROM @tempNotificationClassStreamSectionInfo)      
        BEGIN      
            INSERT INTO T_ERP_Notification_Class_Stream_Section      
            (inNotificationScheduleID, inSchoolProgramId, inClassId, inStreamId, inSectionId)      
            SELECT @NotificationId, TM.inSchoolProgramId, TM.inClassId, TM.inStreamId, TM.inSectionId      
            FROM @tempNotificationClassStreamSectionInfo TM;      
        END      
    
        --INSERT INTO dbo.USP_ERP_SaveNotificationDetailsWithLogs_Debug (StepName, StepMessage)      
        --VALUES ('STEP 2', 'Class/Stream Section inserted');      
    
        -----------------------------------------------------------------    
        -- STEP 3: Clear Old Logs      
        -----------------------------------------------------------------    
        DELETE FROM T_ERP_Notification_Schedule_Logs WHERE inNotificationScheduleID = @NotificationId;      
    
        --INSERT INTO dbo.USP_ERP_SaveNotificationDetailsWithLogs_Debug (StepName, StepMessage)      
        --VALUES ('STEP 3', 'Old logs cleared');      
    
        -----------------------------------------------------------------    
        -- STEP 4: Capture Firebase Tokens using existing SP      
        -----------------------------------------------------------------    
        --CREATE TABLE #FirebaseTokens      
        --(      
        --    firebase_token NVARCHAR(MAX) NULL,      
        --    student_id NVARCHAR(50) NULL,      
        --    student_name NVARCHAR(200) NULL,      
        --    parent_name NVARCHAR(200) NULL,      
        --    student_dob DATE NULL,      
        --    student_address NVARCHAR(MAX) NULL,      
        --    student_roll_no NVARCHAR(50) NULL,      
        --    class_teacher_name NVARCHAR(200) NULL,      
        --    current_grade_class NVARCHAR(200) NULL,      
        --    current_grade_class_section_stream NVARCHAR(200) NULL,      
        --    student_phone NVARCHAR(50) NULL,      
        --    student_email NVARCHAR(200) NULL,      
        --    inParentMasterID INT NULL,      
        --    school_id INT NULL, school_name NVARCHAR(200) NULL,      
        --    school_logo NVARCHAR(MAX) NULL, school_address NVARCHAR(MAX) NULL,      
        --    school_contact_number NVARCHAR(50) NULL, school_email NVARCHAR(200) NULL,      
        --    academic_year NVARCHAR(50) NULL, principal_name NVARCHAR(200) NULL,      
        --    event_description NVARCHAR(MAX) NULL, event_start_date DATETIME NULL, event_end_date DATETIME NULL,      
        --    event_category NVARCHAR(100) NULL, event_start_time NVARCHAR(50) NULL, event_end_time NVARCHAR(50) NULL,      
        --    event_location NVARCHAR(200) NULL, event_type NVARCHAR(100) NULL, rsvp_link NVARCHAR(200) NULL,      
        --    current_due_amount DECIMAL(18,2) NULL, current_due_date DATETIME NULL,      
        --    last_payment_id INT NULL, last_payment_status NVARCHAR(100) NULL,      
        --    current_installment_fees DECIMAL(18,2) NULL, last_payment_received_date DATETIME NULL,      
        --    current_balance_amount DECIMAL(18,2) NULL, current_late_fee DECIMAL(18,2) NULL,      
        --    current_due_payment_link NVARCHAR(MAX) NULL,      
        --    enquiry_no NVARCHAR(50) NULL, provisional_student_name NVARCHAR(200) NULL,      
        --    admission_date DATETIME NULL, admission_stage NVARCHAR(100) NULL,      
        --    previous_school_name NVARCHAR(200) NULL, previous_academic_record NVARCHAR(MAX) NULL,      
        --    submitted_documents NVARCHAR(MAX) NULL, provisional_student_parent_name NVARCHAR(200) NULL,      
        --    admission_fee DECIMAL(18,2) NULL, admission_grade_class_section_stream NVARCHAR(200) NULL,      
        --    gatepass_issue_date DATETIME NULL, gatepass_expiry_date DATETIME NULL,      
        --    gatepass_reason NVARCHAR(200) NULL, parent_master_id INT NULL, gatepass_issuer_name NVARCHAR(200) NULL,      
        --    user_id INT NULL, recipient_name NVARCHAR(200) NULL, birthday_year INT NULL,      
        --    work_experience_years NVARCHAR(50) NULL, is_Faculty BIT NULL, join_date DATETIME NULL,      
        --    stParentToken NVARCHAR(MAX) NULL      
        --);      
    
        --INSERT INTO dbo.USP_ERP_SaveNotificationDetailsWithLogs_Debug (StepName, StepMessage)      
        --VALUES ('STEP 4', 'Fetching firebase tokens started');      
    
    --    INSERT INTO #FirebaseTokens      
    --    EXEC dbo.USP_GetFirebaseTokensByStudentIds      
    --        @inRecipientId, @inCategoryId, @stSchoolProgramId, @stClassId, NULL, NULL, @StudentIds, @inBrandId, NULL;      
    --Print 'Execution of USP_GetFirebaseTokensByStudentIds for 1 '
        --INSERT INTO dbo.USP_ERP_SaveNotificationDetailsWithLogs_Debug (StepName, StepMessage)      
        --VALUES ('STEP 4', 'Firebase tokens fetched');      
    
        -----------------------------------------------------------------    
        -- STEP 5: Insert Notification Logs      
        -----------------------------------------------------------------    
        INSERT INTO T_ERP_Notification_Schedule_Logs      
        (      
            inNotificationScheduleID, stStudentId, stStudentName,      
            stTeacherId, stTeacherName, inUserId, stUserName,      
            inTemplateId, stTemplateTitle, stSMSTemplateMessage,      
            stPushTemplateMessage, stEmailSubject, stEmailTemplateMessage,      
            stNotificationStatus, stErrorMessage, stRenderMessageBody,      
            dtCreatedDate, inCreatedBy, inDeliveryChannelId,      
            stPushTitle, inSendStatus, stParentToken, inParentMasterID ,stParentName,st_firebasetoken  
        )      
        SELECT      
            @NotificationId,      
            ft.student_id, ft.student_name,      
            ft.user_id, ft.class_teacher_name,      
            ft.user_id, ft.recipient_name,      
            @inTemplateId, @stTemplateTitle,      
            @stSMSTemplateMessage, @stPushTemplateMessage,      
            @stEmailSubject, @stEmailTemplateMessage,      
            'Pending', NULL, NULL,      
            GETDATE(), @inCreatedBy, CAST(channel.Value AS INT),      
            @stPushTitle, 0, ft.stParentToken, ft.inParentMasterID,ft. parent_name,ft.firebase_token    
        FROM #FirebaseTokens ft      
        CROSS JOIN (SELECT Value FROM dbo.ERP_SplitString(@stDeliveryChannelId, ',')) channel;      
    
        --INSERT INTO dbo.USP_ERP_SaveNotificationDetailsWithLogs_Debug (StepName, StepMessage)      
        --VALUES ('STEP 5', 'Notification logs inserted');      
    
       -- DROP TABLE #FirebaseTokens;      
    
        -----------------------------------------------------------------    
        -- SUCCESS      
        -----------------------------------------------------------------    
        SELECT 1 AS StatusFlag, 'Notification saved successfully with logs populated' AS Message, @NotificationId AS NotificationId;      
    End  -----End of @inNotificationDefinedTypeId=1
	Else 
	  IF @inNotificationDefinedTypeId=2
	BEGIN------Start For @inNotificationDefinedTypeId=2-----
	IF @inNotificationScheduleID IS NULL      
        BEGIN      
            INSERT INTO [dbo].[T_ERP_Notification_Schedule]      
            (      
                inTypeId, stTypeName,      
                inCategoryId, stCategoryName,      
                inPriorityId, stPriorityName,      
                stDeliveryChannelId, stDeliveryChannelName,      
                inRecipientId, stRecipientName, stForAllOrIndividual,      
                stSchoolProgramId, stSchoolProgramName,      
                stClassId, stClassName,      
                stClassStreamSectionId, stClassStreamSectionName,      
                inTemplateId, stTemplateTitle,      
                stSMSTemplateMessage, stPushTemplateMessage,      
                stEmailSubject, stEmailTemplateMessage,      
                dtNotificationDate, tmNotificationTime,      
                stEmailAttachment, stPushAttachment,      
                dtCreatedDate, inCreatedBy, inBrandId,      
                stNotificationType, dtStartDate, dtEndDate,      
                stFrequency, stFrequencyWord, inStatus, stPushTitle      
            )      
            VALUES      
            (      
                @inTypeId, @stTypeName,      
                @inCategoryId, @stCategoryName,      
                @inPriorityId, @stPriorityName,      
                @stDeliveryChannelId, @stDeliveryChannelName,      
                @inRecipientId, @stRecipientName, @stForAllOrIndividual,      
                @stSchoolProgramId, @stSchoolProgramName,      
                @stClassId, @stClassName,      
                @stClassStreamSectionId, @stClassStreamSectionName,      
                @inTemplateId, @stTemplateTitle,      
                @stSMSTemplateMessage, @stPushTemplateMessage,      
                @stEmailSubject, @stEmailTemplateMessage,      
                @dtNotificationDate, @tmNotificationTime,      
                @stEmailAttachment, @stPushAttachment,      
                GETDATE(), @inCreatedBy, @inBrandId,      
                @stNotificationType, @dtStartDate, @dtEndDate,      
                @stFrequency, @stFrequencyWord, 1, @stPushTitle      
            );      
    
            SET @NotificationId = SCOPE_IDENTITY();      
        END      
        ELSE      
        BEGIN      
            UPDATE [dbo].[T_ERP_Notification_Schedule]      
            SET      
                inTypeId = @inTypeId, stTypeName = @stTypeName,      
                inCategoryId = @inCategoryId, stCategoryName = @stCategoryName,      
                inPriorityId = @inPriorityId, stPriorityName = @stPriorityName,      
                stDeliveryChannelId = @stDeliveryChannelId, stDeliveryChannelName = @stDeliveryChannelName,      
                inRecipientId = @inRecipientId, stRecipientName = @stRecipientName,      
                stForAllOrIndividual = @stForAllOrIndividual,      
                stSchoolProgramId = @stSchoolProgramId, stSchoolProgramName = @stSchoolProgramName,      
                stClassId = @stClassId, stClassName = @stClassName,      
                stClassStreamSectionId = @stClassStreamSectionId, stClassStreamSectionName = @stClassStreamSectionName,      
                inTemplateId = @inTemplateId, stTemplateTitle = @stTemplateTitle,      
                stSMSTemplateMessage = @stSMSTemplateMessage, stPushTemplateMessage = @stPushTemplateMessage,      
                stEmailSubject = @stEmailSubject, stEmailTemplateMessage = @stEmailTemplateMessage,      
                dtNotificationDate = @dtNotificationDate, tmNotificationTime = @tmNotificationTime,      
                stEmailAttachment = @stEmailAttachment, stPushAttachment = @stPushAttachment,      
                dtModifiedDate = GETDATE(), inModifiedBy = @inCreatedBy,      
                inBrandId = @inBrandId, stNotificationType = @stNotificationType,      
                dtStartDate = @dtStartDate, dtEndDate = @dtEndDate,      
                stFrequency = @stFrequency, stFrequencyWord = @stFrequencyWord,      
                stPushTitle = @stPushTitle      
            WHERE inNotificationScheduleID = @inNotificationScheduleID;      
    
            SET @NotificationId = @inNotificationScheduleID;  
			DELETE FROM T_ERP_Notification_Class_Stream_Section WHERE inNotificationScheduleID = @NotificationId;      
    
        --INSERT INTO dbo.USP_ERP_SaveNotificationDetailsWithLogs_Debug (StepName, StepMessage)      
        --VALUES ('STEP 2', 'Class/Stream Section cleared');      
    
        IF EXISTS (SELECT 1 FROM @tempNotificationClassStreamSectionInfo)      
        BEGIN      
            INSERT INTO T_ERP_Notification_Class_Stream_Section      
            (inNotificationScheduleID, inSchoolProgramId, inClassId, inStreamId, inSectionId)      
            SELECT @NotificationId, TM.inSchoolProgramId, TM.inClassId, TM.inStreamId, TM.inSectionId      
            FROM @tempNotificationClassStreamSectionInfo TM;      
        END      
    
        --INSERT INTO dbo.USP_ERP_SaveNotificationDetailsWithLogs_Debug (StepName, StepMessage)      
        --VALUES ('STEP 2', 'Class/Stream Section inserted');      
    
        -----------------------------------------------------------------    
        -- STEP 3: Clear Old Logs      
        -----------------------------------------------------------------    
        DELETE FROM T_ERP_Notification_Schedule_Logs WHERE inNotificationScheduleID = @NotificationId;      
    
        --INSERT INTO dbo.USP_ERP_SaveNotificationDetailsWithLogs_Debug (StepName, StepMessage)      
        --VALUES ('STEP 3', 'Old logs cleared');      
    
        -----------------------------------------------------------------    
        -- STEP 4: Capture Firebase Tokens using existing SP      
        -----------------------------------------------------------------    
        --CREATE TABLE #FirebaseTokens      
        --(      
        --    firebase_token NVARCHAR(MAX) NULL,      
        --    student_id NVARCHAR(50) NULL,      
        --    student_name NVARCHAR(200) NULL,      
        --    parent_name NVARCHAR(200) NULL,      
        --    student_dob DATE NULL,      
        --    student_address NVARCHAR(MAX) NULL,      
        --    student_roll_no NVARCHAR(50) NULL,      
        --    class_teacher_name NVARCHAR(200) NULL,      
        --    current_grade_class NVARCHAR(200) NULL,      
        --    current_grade_class_section_stream NVARCHAR(200) NULL,      
        --    student_phone NVARCHAR(50) NULL,      
        --    student_email NVARCHAR(200) NULL,      
        --    inParentMasterID INT NULL,      
        --    school_id INT NULL, school_name NVARCHAR(200) NULL,      
        --    school_logo NVARCHAR(MAX) NULL, school_address NVARCHAR(MAX) NULL,      
        --    school_contact_number NVARCHAR(50) NULL, school_email NVARCHAR(200) NULL,      
        --    academic_year NVARCHAR(50) NULL, principal_name NVARCHAR(200) NULL,      
        --    event_description NVARCHAR(MAX) NULL, event_start_date DATETIME NULL, event_end_date DATETIME NULL,      
        --    event_category NVARCHAR(100) NULL, event_start_time NVARCHAR(50) NULL, event_end_time NVARCHAR(50) NULL,      
        --    event_location NVARCHAR(200) NULL, event_type NVARCHAR(100) NULL, rsvp_link NVARCHAR(200) NULL,      
        --    current_due_amount DECIMAL(18,2) NULL, current_due_date DATETIME NULL,      
        --    last_payment_id INT NULL, last_payment_status NVARCHAR(100) NULL,      
        --    current_installment_fees DECIMAL(18,2) NULL, last_payment_received_date DATETIME NULL,      
        --    current_balance_amount DECIMAL(18,2) NULL, current_late_fee DECIMAL(18,2) NULL,      
        --    current_due_payment_link NVARCHAR(MAX) NULL,      
        --    enquiry_no NVARCHAR(50) NULL, provisional_student_name NVARCHAR(200) NULL,      
        --    admission_date DATETIME NULL, admission_stage NVARCHAR(100) NULL,      
        --    previous_school_name NVARCHAR(200) NULL, previous_academic_record NVARCHAR(MAX) NULL,      
        --    submitted_documents NVARCHAR(MAX) NULL, provisional_student_parent_name NVARCHAR(200) NULL,      
        --    admission_fee DECIMAL(18,2) NULL, admission_grade_class_section_stream NVARCHAR(200) NULL,      
        --    gatepass_issue_date DATETIME NULL, gatepass_expiry_date DATETIME NULL,      
        --    gatepass_reason NVARCHAR(200) NULL, parent_master_id INT NULL, gatepass_issuer_name NVARCHAR(200) NULL,      
        --    user_id INT NULL, recipient_name NVARCHAR(200) NULL, birthday_year INT NULL,      
        --    work_experience_years NVARCHAR(50) NULL, is_Faculty BIT NULL, join_date DATETIME NULL,      
        --    stParentToken NVARCHAR(MAX) NULL      
        --);      
    
        --INSERT INTO dbo.USP_ERP_SaveNotificationDetailsWithLogs_Debug (StepName, StepMessage)      
        --VALUES ('STEP 4', 'Fetching firebase tokens started');      
    
        --INSERT INTO #FirebaseTokens      
        --EXEC dbo.USP_GetFirebaseTokensByStudentIds      
        --    @inRecipientId, @inCategoryId, @stSchoolProgramId, @stClassId, NULL, NULL, @StudentIds, @inBrandId, NULL;     
    --Select * from #FirebaseTokens
	   End   
	  -- Select * from #FirebaseTokens
	   ------Start to Fetch Real Data for Adhoc schdule------
	   IF @inEventTypeId=1-----for Adhoc Schedule---
	   BEGIN 
	   Print 'For  @inEventTypeId=1 '
	   Declare @AdHocFeeID  nvarchar(max),@AdHocFeeName nvarchar(max),@Amount nvarchar(max),@Currency nvarchar(max)
	   ,@StartDate nvarchar(max),@EndDate nvarchar(max)

      Select top 1 @AdHocFeeID=AdHocFeeID,@AdHocFeeName=AdHocFeeName,@Amount=Amount
	 ,@Currency=Currency,@StartDate=StartDate,@EndDate=EndDate
	 from (
	 Select distinct aps.inAdHocFeeComponentID as AdHocFeeID,
	 tsm.S_Status_Desc_SMS as AdHocFeeName,aps.nAmount as Amount,'INR' as Currency
	 ,Convert(Date,aps.dtStartDate) as StartDate,Convert(Date,aps.dtEndDate) as EndDate       
	 from T_ERP_AdhocPaymentScheduleHeader aps
	inner Join T_ERP_AdhocPaymentScheduleHeaderDetail apsd 
	on aps.inAdhocPaymentScheduleHeaderID=apsd.inAdhocPaymentScheduleHeaderID
	Inner Join T_ERP_AdhocPaymentScheduleStudentDetail apssd 
	on apssd.inAdhocPaymentScheduleHeaderDetailID=apsd.inAdhocPaymentScheduleHeaderDetailID
	Left Join T_Status_Master tsm on tsm.I_Status_Value=aps.inAdHocFeeComponentID
	where aps.inAdhocPaymentScheduleHeaderID=@stVariableTypeId
	) as AdhocSchedule
	------Replacing Variable with template-------
set @stPushTemplateMessage =
    replace(
    replace(
    replace(
    replace(
    replace(
    replace(@stPushTemplateMessage,
        '{{AdHocFeeName}}', isnull(@AdHocFeeName, '')
    ),
        '{{AdHocFeeID}}', isnull(cast(@AdHocFeeID as varchar(20)), '')
    ),
        '{{Amount}}', isnull(cast(@Amount as varchar(20)), '')
    ),
        '{{Currency}}', isnull(@Currency, '')
    ),
        '{{StartDate}}', isnull(convert(varchar(10), @StartDate, 120), '')
    ),
        '{{EndDate}}', isnull(convert(varchar(10), @EndDate, 120), ''))
		-----------------
		set @stSMSTemplateMessage =
    replace(
    replace(
    replace(
    replace(
    replace(
    replace(@stSMSTemplateMessage,
        '{{AdHocFeeName}}', isnull(@AdHocFeeName, '')
    ),
        '{{AdHocFeeID}}', isnull(cast(@AdHocFeeID as varchar(20)), '')
    ),
        '{{Amount}}', isnull(cast(@Amount as varchar(20)), '')
    ),
        '{{Currency}}', isnull(@Currency, '')
    ),
        '{{StartDate}}', isnull(convert(varchar(10), @StartDate, 120), '')
    ),
        '{{EndDate}}', isnull(convert(varchar(10), @EndDate, 120), ''))
		-----------------------------
set @stEmailTemplateMessage =
    replace(
    replace(
    replace(
    replace(
    replace(
    replace(@stEmailTemplateMessage,
        '{{AdHocFeeName}}', isnull(@AdHocFeeName, '')
    ),
        '{{AdHocFeeID}}', isnull(cast(@AdHocFeeID as varchar(20)), '')
    ),
        '{{Amount}}', isnull(cast(@Amount as varchar(20)), '')
    ),
        '{{Currency}}', isnull(@Currency, '')
    ),
        '{{StartDate}}', isnull(convert(varchar(10), @StartDate, 120), '')
    ),
        '{{EndDate}}', isnull(convert(varchar(10), @EndDate, 120), ''))

	   Print'Adhioc Schedule Fetch'
	   End
	    -- STEP 5: Insert Notification Logs      
        -----------------------------------------------------------------    
        INSERT INTO T_ERP_Notification_Schedule_Logs      
        (      
            inNotificationScheduleID, stStudentId, stStudentName,      
            stTeacherId, stTeacherName, inUserId, stUserName,      
            inTemplateId, stTemplateTitle, stSMSTemplateMessage,      
            stPushTemplateMessage, stEmailSubject, stEmailTemplateMessage,      
            stNotificationStatus, stErrorMessage, stRenderMessageBody,      
            dtCreatedDate, inCreatedBy, inDeliveryChannelId,      
            stPushTitle, inSendStatus, stParentToken, inParentMasterID ,stParentName,st_firebasetoken  
        )      
        SELECT      
            @NotificationId,      
            ft.student_id, ft.student_name,      
            ft.user_id, ft.class_teacher_name,      
            ft.user_id, ft.recipient_name,      
            @inTemplateId, @stTemplateTitle,      
            @stSMSTemplateMessage, @stPushTemplateMessage,      
            @stEmailSubject, @stEmailTemplateMessage,      
            'Pending', NULL, NULL,      
            GETDATE(), @inCreatedBy, CAST(channel.Value AS INT),      
            @stPushTitle, 0, ft.stParentToken, ft.inParentMasterID,ft. parent_name,ft.firebase_token    
        FROM #FirebaseTokens ft      
        CROSS JOIN (SELECT Value FROM dbo.ERP_SplitString(@stDeliveryChannelId, ',')) channel;      
        
        --INSERT INTO dbo.USP_ERP_SaveNotificationDetailsWithLogs_Debug (StepName, StepMessage)      
        --VALUES ('STEP 5', 'Notification logs inserted');      
    
        --DROP TABLE #FirebaseTokens; 
	SELECT 1 AS StatusFlag, ' System Notification saved successfully with logs populated' AS Message, @NotificationId AS NotificationId;      

	Print 'For @inNotificationDefinedTypeId=2'
	End     ------ End of @inNotificationDefinedTypeId=2
	   COMMIT TRANSACTION;      
    END TRY      
    BEGIN CATCH      
        IF @@TRANCOUNT > 0      
            ROLLBACK TRANSACTION;      
    
        --INSERT INTO dbo.USP_ERP_SaveNotificationDetailsWithLogs_Debug (StepName, StepMessage)      
        --VALUES ('ERROR', ERROR_MESSAGE());      
    
        SELECT 0 AS StatusFlag, ERROR_MESSAGE() AS Message, 0 AS NotificationId;      
    END CATCH      
END;    
    
