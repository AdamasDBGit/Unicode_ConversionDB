--exec [USP_GetNotificationLogsForProcessing] 1574      
      
CREATE PROCEDURE [dbo].[USP_GetNotificationLogsForProcessing]            
    @inNotificationScheduleID INT            
AS            
BEGIN            
    SET NOCOUNT ON;            
                
    SELECT             
        NL.inNotificationLogsID,            
        NL.inNotificationScheduleID,            
        NL.stStudentId,            
        NL.stStudentName,            
        NL.stTeacherId,            
        NL.stTeacherName,            
        NL.inUserId,            
        NL.stUserName,            
        NL.inTemplateId,            
        NL.stTemplateTitle,            
        NL.stSMSTemplateMessage,            
        NL.stPushTemplateMessage,            
        NL.stEmailSubject,            
        NL.stEmailTemplateMessage,            
        NL.stNotificationStatus,            
        NL.stErrorMessage,            
       -- NL.stRenderMessageBody,       
    COALESCE(  
        NL.stRenderMessageBody,  
        NL.stPushTemplateMessage,  
        NL.stEmailTemplateMessage,  
        NL.stSMSTemplateMessage  
                ) as stRenderMessageBody,  
        NL.dtCreatedDate,            
        NL.inCreatedBy,            
        NL.inDeliveryChannelId,            
        NL.stPushTitle,            
        NL.inSendStatus,            
        NL.stParentToken,            
            
        -- Get Firebase token based on recipient type            
        CASE             
            WHEN NS.inRecipientId = 4 THEN NL.st_firebasetoken         -- Parent            
            WHEN NS.inRecipientId IN (1, 2) THEN U.S_FireBase_Token     -- Teacher/Staff            
            ELSE NULL            
        END AS firebase_token,            
            
        -- Get email based on recipient type            
        CASE             
            WHEN NS.inRecipientId = 4 THEN SD.student_email             -- Parent            
            WHEN NS.inRecipientId IN (1, 2) THEN U.S_Email              -- Teacher/Staff            
            ELSE NULL            
        END AS student_email,            
            
        CASE             
            WHEN NS.inRecipientId IN (1, 2) THEN U.S_Email              -- Teacher/Staff            
            ELSE NULL            
        END AS username_email,            
            
        nl.stParentName  as parent_name,            
        NL.inParentMasterID            
    FROM             
        T_ERP_Notification_Schedule_Logs NL            
    INNER JOIN             
        T_ERP_Notification_Schedule NS             
            ON NL.inNotificationScheduleID = NS.inNotificationScheduleID            
    -- Corrected join path through Student_Parent_Maps            
    Inner JOIN             
        T_Student_Parent_Maps TSPM             
            ON NL.stStudentId = TSPM.S_Student_ID  and tspm.I_Brand_ID=NS.inBrandId          
    Inner JOIN             
        T_Parent_Master TPM             
            ON TSPM.I_Parent_Master_ID = TPM.I_Parent_Master_ID            
   AND NL.inParentMasterID=TPM.I_Parent_Master_ID --and nl.stParentToken=tpm.S_Token          
           AND TPM.I_Brand_ID = NS.inBrandId            
    Left JOIN             
        Temp_Student_Details SD             
            ON TSPM.S_Student_ID = SD.student_id  and sd.S_Firebase_Token=tpm.S_Firebase_Token          
   and sd.stParentToken=tpm.S_Token and sd.Is_token_Active=tpm.I_IsTokenActive          
   and sd.I_Parent_Master_ID=nl.inParentMasterID          
    LEFT JOIN             
        T_ERP_User U             
            ON NL.inUserId = U.I_User_ID            
    WHERE             
        NL.inNotificationScheduleID = @inNotificationScheduleID            
        AND NL.stNotificationStatus = 'Pending'            
    ORDER BY             
        NL.inNotificationLogsID;            
END; 