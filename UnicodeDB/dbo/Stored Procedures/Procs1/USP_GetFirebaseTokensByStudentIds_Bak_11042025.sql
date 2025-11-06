-- Author: Md Qutubuddin Haider    
-- Create date: 2024-12-24    
  
-- SELECT * FROM Temp_Student_Details where student_id ='24-0445'  
-- EXEC USP_GetFirebaseTokensByStudentIds @inBrandID = 107, @inRecipientId = 1, @StudentIds='F4', @inCategoryId = 4  
-- EXEC USP_GetFirebaseTokensByStudentIds @inBrandID = 107, @inRecipientId = 4, @StudentIds='25-0003,24-0312,24-0377,24-0379,24-0351,24-0410,24-0334', @inCategoryId = 31  
-- EXEC USP_GetFirebaseTokensByStudentIds @inBrandID = 107, @inRecipientId = 4, @StudentIds='25-0214,24-0045', @inCategoryId = 1  
-- EXEC USP_GetFirebaseTokensByStudentIds @inBrandID = 107, @NotificationId = 21  
-- EXEC USP_GetFirebaseTokensByStudentIds @inBrandID = 107, @inRecipientId = 4, @inCategoryId = 4  
-- EXEC USP_GetFirebaseTokensByStudentIds @inBrandID = 107, @inRecipientId = 4, @StudentIds='24-0378', @inCategoryId = 4  
-- EXEC USP_GetFirebaseTokensByStudentIds @inBrandID = 107, @inRecipientId = 1, @StudentIds='800335', @inCategoryId = 27  
-- EXEC USP_GetFirebaseTokensByStudentIds @inBrandID = 107, @inRecipientId = 4,  @inSchoolProgramId = 1   
-- EXEC USP_GetFirebaseTokensByStudentIds @inBrandID = 107, @inRecipientId = 4,  @inSchoolProgramId = 1, @inClassId = "1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,65,66"  
  
-- EXEC USP_GetFirebaseTokensByStudentIds @inBrandID = 107, @inRecipientId = 4,  @inSchoolProgramId = 1, @inClassId = "4"  
  
--SELECT * from T_ERP_Notification_Schedule_Logs order BY 1 DESC  
  
--SELECT * FROM Temp_Student_Details WHERE student_id='24-0482'  
  
-- SELECT * FROM Temp_Fees_Details  
  
CREATE PROCEDURE [dbo].[USP_GetFirebaseTokensByStudentIds_Bak_11042025]  
    @inRecipientId INT = NULL,    
    @inCategoryId INT = NULL,  
    @inSchoolProgramId NVARCHAR(MAX) = NULL,    
    @inClassId NVARCHAR(MAX) = NULL,    
    @inStreamId NVARCHAR(MAX) = NULL,    
    @inSectionId NVARCHAR(MAX) = NULL,    
    @StudentIds NVARCHAR(MAX) = NULL,    
    @inBrandID INT,  
 @NotificationId INT = NULL  
AS    
BEGIN    
    SET NOCOUNT ON;    
  
    -- Temporary Table Update    
    EXEC InsertAndUpdateAllTempTables @inBrandID = @inBrandID,  @inRecipientId = @inRecipientId, @StudentIds = @StudentIds, @inSchoolProgramId = @inSchoolProgramId, @inClassId = @inClassId, @inStreamId = @inStreamId, @inSectionId = @inSectionId  
  
 IF @NotificationId IS NOT NULL  
 BEGIN  
  SELECT DISTINCT     
            -- Firebase Token    
            SD.S_Firebase_Token AS firebase_token,    
  
            -- Temp_Student_Details Columns (Always included)  
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
   --SD.I_Class_ID,  
   --SD.I_Stream_ID,  
   --SD.I_Section_ID,  
  
   -- Temp_School_Details Columns (Always included)  
            SCD.school_id,  
            SCD.school_name,  
            SCD.school_logo,  
            SCD.school_address,  
            SCD.school_contact_number,  
            SCD.school_email,  
            SCD.academic_year,  
            SCD.principal_name,  
  
    -- Dynamically include category-specific columns  
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
   ISNULL(TFD.current_due_amount,0)AS current_installment_fees,  
   --ISNULL(TFD.current_installment_fees,0)AS current_installment_fees,  
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
   TUD.birthday_year,  
   TUD.work_experience_years,  
   TUD.is_Faculty,  
   TUD.join_date,  
  
   SD.stParentToken  
  
        FROM     
            T_Parent_Master TPM    
        INNER JOIN     
            T_Student_Parent_Maps TSPM     
            ON TPM.I_Parent_Master_ID = TSPM.I_Parent_Master_ID    
            AND TPM.I_Brand_ID = @inBrandID    
        INNER JOIN     
            Temp_Student_Details SD     
            ON TSPM.S_Student_ID = SD.student_id    
        LEFT JOIN     
            T_Student_Class_Section TSCS     
            ON TSCS.S_Student_ID = SD.student_id    
            AND TSCS.I_Brand_ID = @inBrandID    
        LEFT JOIN     
            T_School_Group_Class TSGC     
            ON TSGC.I_School_Group_Class_ID = TSCS.I_School_Group_Class_ID    
        LEFT JOIN T_School_Group SG   
   ON SG.I_School_Group_ID = TSGC.I_School_Group_ID AND SG.I_Brand_Id = @inBrandID  
        LEFT JOIN     
            Temp_School_Details SCD     
            ON SCD.school_id = TPM.I_Brand_ID    
  LEFT JOIN   
   T_ERP_Notification_Class_Stream_Section NCSS ON  NCSS.inClassId =TSGC.I_Class_ID   
   AND (TSCS.I_Stream_ID = NCSS.inStreamId OR TSCS.I_Stream_ID IS NULL)  
   AND TSCS.I_Section_ID = NCSS.inSectionId  
   AND SG.I_School_Group_ID = NCSS.inSchoolProgramId  
  LEFT JOIN  
   T_ERP_Notification_Schedule NS ON NS.inNotificationScheduleID = NCSS.inNotificationScheduleID  
  
   -- Category-specific joins  
        LEFT JOIN    
            Temp_Event_Details TED    
            ON TED.event_id = @inCategoryId AND @inCategoryId = 11  
        LEFT JOIN    
            Temp_Fees_Details TFD    
            ON TFD.student_id = SD.student_id AND @inCategoryId =31 -- Finance Category    
        LEFT JOIN    
            Temp_Admission_Details TAD    
            ON TAD.enquiry_no = SD.student_id AND @inCategoryId = 1 -- Academic Category    
        LEFT JOIN    
            Temp_GatePass TGP    
            ON TGP.parent_master_id = TPM.I_Parent_Master_ID AND @inCategoryId = 10 -- GatePass Category    
        LEFT JOIN    
            Temp_User_Details TUD    
            ON TUD.user_id = TPM.I_Parent_Master_ID AND @inCategoryId = 3 -- Meeting Category    
  
        WHERE     
            TPM.I_Brand_ID = @inBrandID    
   AND TPM.I_IsPrimary = 1  
   AND TSCS.I_Status = 1  
            AND NS.inNotificationScheduleID = @NotificationId  
    RETURN;  
    END  
    IF @inRecipientId = 4    
    BEGIN    
        -- Select common columns for School and Student  
        SELECT DISTINCT     
            -- Firebase Token    
             SD.S_Firebase_Token AS firebase_token,    
  
            -- Temp_Student_Details Columns (Always included)  
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
  
            -- Temp_School_Details Columns (Always included)  
            SCD.school_id,  
            SCD.school_name,  
            SCD.school_logo,  
            SCD.school_address,  
            SCD.school_contact_number,  
            SCD.school_email,  
            SCD.academic_year,  
            SCD.principal_name,  
  
            -- Dynamically include category-specific columns  
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
   ISNULL(TFD.current_due_amount,0)AS current_installment_fees,  
   --ISNULL(TFD.current_installment_fees,0) AS current_installment_fees,  
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
   TUD.birthday_year,  
   TUD.work_experience_years,  
   TUD.is_Faculty,  
   TUD.join_date,  
  
   SD.stParentToken  
  
        FROM     
            T_Parent_Master TPM    
        INNER JOIN     
            T_Student_Parent_Maps TSPM     
            ON TPM.I_Parent_Master_ID = TSPM.I_Parent_Master_ID    
            AND TPM.I_Brand_ID = @inBrandID -- and TPM.S_Guardian_Email IS not NULL  
        INNER JOIN     
            Temp_Student_Details SD     
            ON TSPM.S_Student_ID = SD.student_id            
        LEFT JOIN     
            Temp_School_Details SCD     
            ON SCD.school_id = TPM.I_Brand_ID    
       
  
        -- Category-specific joins  
        LEFT JOIN    
            Temp_Event_Details TED    
            ON TED.event_id = @inCategoryId AND @inCategoryId = 11  
        LEFT JOIN    
            Temp_Fees_Details TFD    
            ON TFD.student_id = SD.student_id AND @inCategoryId = 31 -- Finance Category    
        LEFT JOIN    
            Temp_Admission_Details TAD    
            ON TAD.enquiry_no = SD.student_id AND @inCategoryId = 1 -- Academic Category    
        LEFT JOIN    
            Temp_GatePass TGP    
            ON TGP.parent_master_id = TPM.I_Parent_Master_ID AND @inCategoryId = 10 -- GatePass Category    
        LEFT JOIN    
            Temp_User_Details TUD    
            ON TUD.user_id = TPM.I_Parent_Master_ID AND @inCategoryId = 3 -- Meeting Category    
  
        WHERE     
            TPM.I_Brand_ID = @inBrandID    
   AND TPM.I_IsPrimary = 1 and SD.student_email IS NOT NULL  
        -- If no rows are returned    
        IF @@ROWCOUNT = 0    
        BEGIN    
            SELECT 'No matching records found' AS Message;    
        END    
    END    
 ELSE IF @inRecipientId = 1  
   BEGIN    
        SELECT DISTINCT     
              
            -- Temp_School_Details Columns (Always included)  
            SCD.school_id,  
            SCD.school_name,  
            SCD.school_logo,  
            SCD.school_address,  
     SCD.school_contact_number,  
            SCD.school_email,  
            SCD.academic_year,  
        SCD.principal_name,  
  
            U.I_User_ID AS user_id,--class_teacher_user_id,  
   U.S_Email AS username_email,  
   U.S_First_Name+' '+S_Last_Name AS username, --class_teacher_name,  
   U.S_Mobile AS username_mobile,  
   U.S_FireBase_Token AS firebase_token,  
   UP.Dt_DOB AS birthday_year,  
   '' AS work_experience_years,  
   UP.Dt_DOJ AS join_date  
  
        FROM T_ERP_User U  
  LEFT JOIN  T_User_Profile UP ON U.I_User_ID = UP.I_User_ID  
  LEFT JOIN     
            Temp_School_Details SCD     
            ON 1= 1    
  WHERE U.I_Status = 1  
     AND UP.I_User_ID IS NOT NULL  
     AND U.S_First_Name IS NOT NULL AND U.Is_Teaching_Staff = 1  
     AND (  
                (@StudentIds IS NOT NULL AND UP.S_EMP_Code IN (SELECT Value FROM dbo.ERP_SplitString(@StudentIds, ',')))  
                OR @StudentIds IS NULL  
              )  
             
  
        -- If no rows are returned    
        IF @@ROWCOUNT = 0    
        BEGIN    
            SELECT 'No matching records found' AS Message;    
        END    
    END        
    ELSE IF @inRecipientId = 2  
   BEGIN    
        SELECT DISTINCT     
              
            -- Temp_School_Details Columns (Always included)  
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
   U.S_First_Name+' '+S_Last_Name AS username,  
   U.S_Mobile AS username_mobile,  
   U.S_FireBase_Token AS firebase_token,  
   UP.Dt_DOB AS birthday_year,  
   '' AS work_experience_years,  
   UP.Dt_DOJ AS join_date  
  
        FROM T_ERP_User U  
  LEFT JOIN  T_User_Profile UP ON U.I_User_ID = UP.I_User_ID  
  LEFT JOIN     
            Temp_School_Details SCD     
            ON 1= 1    
  WHERE U.I_Status = 1  
     AND UP.I_User_ID IS NOT NULL  
     AND U.S_First_Name IS NOT NULL AND U.Is_Teaching_Staff = 0  
     AND (  
                (@StudentIds IS NOT NULL AND UP.S_EMP_Code IN (SELECT Value FROM dbo.ERP_SplitString(@StudentIds, ',')))  
                OR @StudentIds IS NULL  
              )  
             
  
        -- If no rows are returned    
        IF @@ROWCOUNT = 0    
        BEGIN    
            SELECT 'No matching records found' AS Message;    
        END    
    END   
    ELSE  
    BEGIN    
        SELECT 'Invalid recipient ID' AS Message;    
    END    
END;