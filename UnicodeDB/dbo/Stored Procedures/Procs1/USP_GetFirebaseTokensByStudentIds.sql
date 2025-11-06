CREATE PROCEDURE [dbo].[USP_GetFirebaseTokensByStudentIds]          
    @inRecipientId INT = NULL,            
    @inCategoryId INT = NULL,          
    @stSchoolProgramId NVARCHAR(max) = NULL,            
    @stClassId NVARCHAR(max) = NULL,            
    @stStreamId NVARCHAR(max) = NULL,            
    @stSectionId NVARCHAR(max) = NULL,            
    @stStudentIds NVARCHAR(max) = NULL,            
    @inBrandId INT,          
    @inNotificationId INT = NULL          
AS            
BEGIN            
    SET NOCOUNT ON;            
    
    -- Temporary Table Update            
    EXEC InsertAndUpdateAllTempTables     
         @inBrandId = @inBrandId,      
         @inRecipientId = @inRecipientId,     
         @stStudentIds = @stStudentIds,     
         @stSchoolProgramId = @stSchoolProgramId,     
         @stClassId = @stClassId,     
         @stStreamId = @stStreamId,     
         @stSectionId = @stSectionId;          
    
    -- Case 1: Notification specific data      
    IF @inNotificationId IS NOT NULL          
    BEGIN          
        SELECT DISTINCT             
            CASE     
                WHEN TPM.I_IsTokenActive = 0 THEN NULL       
                WHEN TPM.I_IsTokenActive = 1 THEN SD.S_Firebase_Token     
            END AS firebase_token,            
    
            -- Student Details          
            SD.student_id,          
            SD.student_name,          
            SD.parent_name,          
            SD.student_dob,          
            SD.student_address,          
            SD.student_roll_no,          
            SD.class_teacher_name,          
            SD.current_grade_class,          
            SD.current_grade_class_section_stream,          
            SD.student_phone,          
            SD.student_email,          
    
            SCD.school_id,          
            SCD.school_name,          
            SCD.school_logo,          
            SCD.school_address,          
            SCD.school_contact_number,          
            SCD.school_email,          
            SCD.academic_year,          
            SCD.principal_name,          
    
            TED.event_description,          
            TED.event_start_date,          
            TED.event_end_date,          
            TED.event_category,          
            TED.event_start_time,          
            TED.event_end_time,          
            'N/A' AS event_location,          
            'N/A' AS event_type,          
            'N/A' AS rsvp_link,          
    
            ISNULL(TFD.current_due_amount,0) AS current_due_amount,          
            TFD.current_due_date,          
            TFD.last_payment_id,          
            TFD.last_payment_status,          
            ISNULL(TFD.current_due_amount,0) AS current_installment_fees,          
            TFD.last_payment_received_date,          
            ISNULL(TFD.current_balance_amount,0) AS current_balance_amount,          
            ISNULL(TFD.current_late_fee,0) AS current_late_fee,          
            TFD.current_due_payment_link,          
    
            TAD.enquiry_no,          
            TAD.provisional_student_name,          
            TAD.admission_date,          
            TAD.admission_stage,          
            TAD.previous_school_name,          
            TAD.previous_academic_record,          
            TAD.submitted_documents,          
            TAD.provisional_student_parent_name,          
            TAD.admission_fee,          
            TAD.admission_grade_class_section_stream,          
    
            TGP.gatepass_issue_date,          
            TGP.gatepass_expiry_date,          
            TGP.gatepass_reason,          
            TGP.parent_master_id,          
            TGP.gatepass_issuer_name,          
    
            TUD.user_id,          
            TUD.recipient_name,          
            YEAR(TUD.birthday_year) AS birthday_year,   -- FIXED    
            TUD.work_experience_years,          
            TUD.is_Faculty,          
       CAST(TUD.join_date AS DATETIME) AS join_date,   -- FIXED    
    
            SD.stParentToken,      
            SD.I_Parent_Master_ID AS inParentMasterID      
        FROM T_Parent_Master TPM        
        INNER JOIN T_Student_Parent_Maps TSPM     
            ON TPM.I_Parent_Master_ID = TSPM.I_Parent_Master_ID            
           AND TPM.I_Brand_ID = @inBrandId            
        INNER JOIN Temp_Student_Details SD             
            ON TSPM.S_Student_ID = SD.student_id            
        LEFT JOIN T_Student_Class_Section TSCS     
            ON TSCS.S_Student_ID = SD.student_id            
           AND TSCS.I_Brand_ID = @inBrandId            
        LEFT JOIN T_School_Group_Class TSGC     
            ON TSGC.I_School_Group_Class_ID = TSCS.I_School_Group_Class_ID            
        LEFT JOIN T_School_Group SG            
            ON SG.I_School_Group_ID = TSGC.I_School_Group_ID     
           AND SG.I_Brand_Id = @inBrandId          
        LEFT JOIN Temp_School_Details SCD             
            ON SCD.school_id = TPM.I_Brand_ID            
        LEFT JOIN T_ERP_Notification_Class_Stream_Section NCSS     
            ON NCSS.inClassId = TSGC.I_Class_ID           
           AND (TSCS.I_Stream_ID = NCSS.inStreamId OR TSCS.I_Stream_ID IS NULL)          
           AND TSCS.I_Section_ID = NCSS.inSectionId          
           AND SG.I_School_Group_ID = NCSS.inSchoolProgramId          
        LEFT JOIN T_ERP_Notification_Schedule NS     
            ON NS.inNotificationScheduleID = NCSS.inNotificationScheduleID          
        LEFT JOIN Temp_Event_Details TED            
            ON TED.event_id = @inCategoryId AND @inCategoryId = 11          
        LEFT JOIN Temp_Fees_Details TFD            
            ON TFD.student_id = SD.student_id AND @inCategoryId = 31          
        LEFT JOIN Temp_Admission_Details TAD            
            ON TAD.enquiry_no = SD.student_id AND @inCategoryId = 1          
        LEFT JOIN Temp_GatePass TGP            
            ON TGP.parent_master_id = TPM.I_Parent_Master_ID AND @inCategoryId = 10          
        LEFT JOIN Temp_User_Details TUD            
            ON TUD.user_id = TPM.I_Parent_Master_ID AND @inCategoryId = 3          
        WHERE TPM.I_Brand_ID = @inBrandId            
          AND TPM.I_IsPrimary = 1          
          AND TSCS.I_Status = 1          
          AND NS.inNotificationScheduleID = @inNotificationId;          
        RETURN;          
    END          
    
    -- Case 2: Recipient = 4 (Students & Parents)      
    IF @inRecipientId = 4            
    BEGIN            
        SELECT DISTINCT             
            CASE     
                WHEN TPM.I_IsTokenActive = 0 THEN NULL       
                WHEN TPM.I_IsTokenActive = 1 THEN TPM.S_Firebase_Token     
            END AS firebase_token,            
            SD.student_id,          
            SD.student_name,          
            SD.parent_name,          
            SD.student_dob,          
            SD.student_address,          
            SD.student_roll_no,          
            SD.class_teacher_name,          
            SD.current_grade_class,          
            SD.current_grade_class_section_stream,          
            SD.student_phone,          
            SD.student_email,          
            SD.I_Parent_Master_ID AS inParentMasterID,      
            SCD.school_id,          
            SCD.school_name,          
            SCD.school_logo,          
            SCD.school_address,          
            SCD.school_contact_number,          
            SCD.school_email,          
            SCD.academic_year,          
            SCD.principal_name,          
            TED.event_description,          
            TED.event_start_date,          
            TED.event_end_date,          
            TED.event_category,          
            TED.event_start_time,          
            TED.event_end_time,          
            'N/A' AS event_location,          
            'N/A' AS event_type,      
            'N/A' AS rsvp_link,          
            ISNULL(TFD.current_due_amount,0) AS current_due_amount,          
            TFD.current_due_date,          
            TFD.last_payment_id,          
            TFD.last_payment_status,          
            ISNULL(TFD.current_due_amount,0) AS current_installment_fees,          
            TFD.last_payment_received_date,          
            ISNULL(TFD.current_balance_amount,0) AS current_balance_amount,           
            ISNULL(TFD.current_late_fee,0) AS current_late_fee,          
            TFD.current_due_payment_link,          
            TAD.enquiry_no,          
            TAD.provisional_student_name,          
            TAD.admission_date,          
            TAD.admission_stage,          
            TAD.previous_school_name,          
            TAD.previous_academic_record,          
            TAD.submitted_documents,          
            TAD.provisional_student_parent_name,          
            TAD.admission_fee,          
            TAD.admission_grade_class_section_stream,          
            TGP.gatepass_issue_date,          
            TGP.gatepass_expiry_date,          
            TGP.gatepass_reason,          
            TGP.parent_master_id,          
            TGP.gatepass_issuer_name,          
            TUD.user_id,          
            TUD.recipient_name,          
            YEAR(TUD.birthday_year) AS birthday_year,   -- FIXED    
            TUD.work_experience_years,          
            TUD.is_Faculty,          
            CAST(TUD.join_date AS DATETIME) AS join_date,   -- FIXED    
            SD.stParentToken          
        FROM T_Parent_Master TPM            
        INNER JOIN T_Student_Parent_Maps TSPM     
            ON TPM.I_Parent_Master_ID = TSPM.I_Parent_Master_ID            
           AND TPM.I_Brand_ID = @inBrandId          
        INNER JOIN Temp_Student_Details SD             
            ON TSPM.S_Student_ID = SD.student_id     
           AND SD.Is_token_Active = TPM.I_IsTokenActive     
           AND SD.I_Parent_Master_ID = TPM.I_Parent_Master_ID      
        LEFT JOIN Temp_School_Details SCD             
            ON SCD.school_id = TPM.I_Brand_ID            
        LEFT JOIN Temp_Event_Details TED            
            ON TED.event_id = @inCategoryId AND @inCategoryId = 11          
        LEFT JOIN Temp_Fees_Details TFD            
            ON TFD.student_id = SD.student_id AND @inCategoryId = 31          
        LEFT JOIN Temp_Admission_Details TAD            
            ON TAD.enquiry_no = SD.student_id AND @inCategoryId = 1          
        LEFT JOIN Temp_GatePass TGP            
            ON TGP.parent_master_id = TPM.I_Parent_Master_ID AND @inCategoryId = 10          
        LEFT JOIN Temp_User_Details TUD            
            ON TUD.user_id = TPM.I_Parent_Master_ID AND @inCategoryId = 3          
        WHERE TPM.I_Brand_ID = @inBrandId            
          AND TPM.I_IsPrimary = 1;          
        IF @@ROWCOUNT = 0            
        BEGIN            
            SELECT 'No matching records found' AS Message;            
        END            
    END            
    
    -- Case 3: Recipient = 1 (Teachers)      
    ELSE IF @inRecipientId = 1          
    BEGIN            
        SELECT DISTINCT             
            SCD.school_id,          
            SCD.school_name,          
            SCD.school_logo,          
            SCD.school_address,          
            SCD.school_contact_number,          
            SCD.school_email,          
            SCD.academic_year,          
            SCD.principal_name,          
            U.I_User_ID AS user_id,          
            U.S_Email AS username_email,          
            U.S_First_Name + ' ' + U.S_Last_Name AS username,          
            U.S_Mobile AS username_mobile,          
            U.S_FireBase_Token AS firebase_token,          
            YEAR(UP.Dt_DOB) AS birthday_year,          
            '' AS work_experience_years,          
  UP.Dt_DOJ AS join_date          
        FROM T_ERP_User U          
        LEFT JOIN T_User_Profile UP ON U.I_User_ID = UP.I_User_ID          
        LEFT JOIN Temp_School_Details SCD ON 1 = 1            
        WHERE U.I_Status = 1          
          AND UP.I_User_ID IS NOT NULL          
          AND U.S_First_Name IS NOT NULL     
          AND U.Is_Teaching_Staff = 1          
          AND ( (@stStudentIds IS NOT NULL AND UP.S_EMP_Code IN (SELECT Value FROM dbo.ERP_SplitString(@stStudentIds, ',')))          
        OR @stStudentIds IS NULL );          
        IF @@ROWCOUNT = 0            
        BEGIN            
            SELECT 'No matching records found' AS Message;            
        END            
    END                
    
    -- Case 4: Recipient = 2 (Non-Teaching Staff)      
    ELSE IF @inRecipientId = 2          
    BEGIN            
        SELECT DISTINCT             
            SCD.school_id,          
            SCD.school_name,          
            SCD.school_logo,          
            SCD.school_address,          
            SCD.school_contact_number,          
            SCD.school_email,          
            SCD.academic_year,          
            SCD.principal_name,          
            U.I_User_ID AS user_id,          
            U.S_Email AS username_email,          
            U.S_First_Name + ' ' + U.S_Last_Name AS username,          
            U.S_Mobile AS username_mobile,          
            U.S_FireBase_Token AS firebase_token,          
            YEAR(UP.Dt_DOB) AS birthday_year,          
            '' AS work_experience_years,          
            UP.Dt_DOJ AS join_date          
        FROM T_ERP_User U          
        LEFT JOIN T_User_Profile UP ON U.I_User_ID = UP.I_User_ID          
        LEFT JOIN Temp_School_Details SCD ON 1 = 1            
        WHERE U.I_Status = 1          
          AND UP.I_User_ID IS NOT NULL          
          AND U.S_First_Name IS NOT NULL     
          AND U.Is_Teaching_Staff = 0          
          AND ( (@stStudentIds IS NOT NULL AND UP.S_EMP_Code IN (SELECT Value FROM dbo.ERP_SplitString(@stStudentIds, ',')))          
                OR @stStudentIds IS NULL );          
        IF @@ROWCOUNT = 0            
        BEGIN            
            SELECT 'No matching records found' AS Message;            
        END            
    END           
    
    -- Case 5: Invalid Recipient      
    ELSE          
    BEGIN            
        SELECT 'Invalid recipient ID' AS Message;            
    END            
END;    
  
  
