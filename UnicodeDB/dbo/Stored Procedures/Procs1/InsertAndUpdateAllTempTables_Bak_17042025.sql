--EXEC InsertAndUpdateAllTempTables 107, 4      
      
CREATE PROCEDURE InsertAndUpdateAllTempTables_Bak_17042025         
    @inBrandID INT,      
 @inRecipientId INT,      
 @StudentIds NVARCHAR(MAX) = NULL,      
 @inSchoolProgramId NVARCHAR(MAX) = NULL,      
 @inClassId NVARCHAR(MAX) = NULL,      
 @inStreamId NVARCHAR(MAX) = NULL,      
 @inSectionId NVARCHAR(MAX) = NULL      
AS      
BEGIN      
         
    BEGIN      
      
  TRUNCATE TABLE Temp_School_Details;      
        TRUNCATE TABLE Temp_Event_Details;             
  TRUNCATE TABLE Temp_User_Details;          
      
        -- Insert data into Temp_School_Details        
      
        INSERT INTO Temp_School_Details (      
            school_id, school_name, school_logo, school_address,       
            school_contact_number, school_email, academic_year, principal_name      
        )      
        SELECT       
            BM.I_Brand_ID AS school_id,      
            BM.S_Brand_Name AS school_name,      
            SC.S_Logo AS school_logo,      
            '' AS school_address,      
            SC.S_Mobile AS school_contact_number,      
            SC.S_Email AS school_email,      
            SASM.S_Label AS academic_year,        
            '' AS principal_name      
        FROM       
            T_Brand_Master BM      
        INNER JOIN       
            T_School_Contact SC ON SC.I_Brand_ID = BM.I_Brand_ID      
  INNER JOIN       
   T_School_Academic_Session_Master SASM ON SASM.I_Brand_ID =  BM.I_Brand_ID      
        WHERE       
            BM.I_Brand_ID = @inBrandID      
   AND SASM.I_Current_Session = 1      
      
        -- Insert data into Temp_Event_Details      
        INSERT INTO Temp_Event_Details (      
            event_id, event_description, event_start_date, event_end_date,       
            event_category, event_start_time, event_end_time, event_location,       
            event_type, rsvp_link      
        )      
        SELECT       
            EV.I_Event_ID AS event_id,      
            EV.S_Event_Desc AS event_description,      
            EV.Dt_StartDate AS event_start_date,      
            EV.Dt_EndDate AS event_end_date,      
            EC.S_Event_Category AS event_category,      
            EV.Dt_StartTime AS event_start_time,      
            EV.Dt_EndTime AS event_end_time,      
            '' AS event_location,      
            '' AS event_type,      
            '' AS rsvp_link      
        FROM       
            T_Event EV      
        INNER JOIN       
            T_Event_Category EC ON EC.I_Event_Category_ID = EV.I_Event_Category_ID      
        WHERE       
            EV.I_Brand_ID = @inBrandID      
            AND EV.Dt_StartDate BETWEEN GETDATE() AND DATEADD(DAY, 3, GETDATE());      
      
   IF @inRecipientId = 4        
   BEGIN      
      TRUNCATE TABLE Temp_Student_Details;      
      TRUNCATE TABLE Temp_Admission_Details;      
      TRUNCATE TABLE Temp_GatePass;      
      TRUNCATE TABLE Temp_Fees_Details;      
      
     -- Insert data into Temp_Student_Details      
     INSERT INTO Temp_Student_Details (      
      student_id, student_detail_id, student_name, parent_name, student_dob,       
      student_address, student_roll_no, class_teacher_name, current_grade_class,       
      current_grade_class_section_stream, student_phone, student_email, I_School_Session_ID,      
      I_School_Group_Class_ID, I_Class_ID, I_Stream_ID, I_Section_ID, S_Firebase_Token,stParentToken      
     )      
           
     SELECT       
      TSD.S_Student_ID AS student_id,      
      TSD.I_Student_Detail_ID AS student_detail_id,      
      CONCAT(TSD.S_First_Name, ' ', COALESCE(TSD.S_Middle_Name, ''), ' ', COALESCE(TSD.S_Last_Name, '')) AS student_name,      
      CONCAT(TPM.S_First_Name, ' ', COALESCE(TPM.S_Last_Name, '')) AS parent_name,      
      TSD.Dt_Birth_Date AS student_dob,      
      TSD.S_Curr_Address1 AS student_address,      
      TSD.I_RollNo AS student_roll_no,      
      U.S_First_Name +' '+U.S_Middle_Name+''+U.S_Last_Name AS class_teacher_name,      
     C.S_Class_Name AS current_grade_class,      
      SC.S_Section_Name+' '+ST.S_Stream AS current_grade_class_section_stream,      
      TSD.S_Phone_No AS student_phone,      
      TPM.S_Guardian_Email AS student_email,      
      RSH.I_School_Session_ID,      
      SCS.I_School_Group_Class_ID,      
      C.I_Class_ID,      
      RSH.I_Stream_ID,      
      RSH.I_Section_ID,      
      TPM.S_Firebase_Token,      
      TPM.S_Token      
     FROM       
      T_Student_Detail TSD      
     INNER JOIN       
      T_Student_Parent_Maps TSPM ON TSD.S_Student_ID = TSPM.S_Student_ID      
     JOIN       
      T_Parent_Master TPM ON TPM.I_Parent_Master_ID = TSPM.I_Parent_Master_ID AND TPM.I_IsPrimary = 1 --AND TPM.S_Guardian_Email IS NOT NULL      
     LEFT JOIN      
      T_Student_Class_Section SCS ON SCS.I_Student_Detail_ID = TSD.I_Student_Detail_ID AND SCS.I_Status = 1      
     LEFT JOIN       
      T_School_Group_Class SGC ON SGC.I_School_Group_Class_ID = SCS.I_School_Group_Class_ID      
     LEFT JOIN       
      T_Class C ON C.I_Class_ID = SGC.I_Class_ID AND C.I_Brand_ID = SCS.I_Brand_ID      
     LEFT JOIN      
      T_School_Group SG ON SG.I_School_Group_ID = SGC.I_School_Group_ID AND SG.I_Brand_ID = SCS.I_Brand_ID      
     LEFT JOIN       
      T_Stream ST ON ST.I_Stream_ID = SCS.I_Stream_ID      
     LEFT JOIN      
      T_Section SC ON SC.I_Section_ID = SCS.I_Section_ID      
     LEFT JOIN      
        T_ERP_Routine_Structure_Header RSH       
       ON RSH.I_Class_ID = C.I_Class_ID       
        AND RSH.I_School_Session_ID = SCS.I_School_Session_ID      
        AND RSH.I_Section_ID = SCS.I_Section_ID       
        AND (RSH.I_Stream_ID = SCS.I_Stream_ID OR SCS.I_Stream_ID IS NULL)      
     LEFT JOIN      
      T_ERP_user U ON U.I_User_ID = RSH.I_FacultyClassTeacher      
     WHERE       
         -- Handle @StudentIds properly        
      (@StudentIds IS NOT NULL AND TSPM.S_Student_ID IN (SELECT Value FROM dbo.ERP_SplitString(@StudentIds, ',')))      
      OR @StudentIds IS NULL      
      AND (      
       (@inSchoolProgramId IS NOT NULL AND SGC.I_School_Group_ID IN (SELECT Value FROM dbo.ERP_SplitString(@inSchoolProgramId, ',')))      
       OR @inSchoolProgramId IS NULL      
      )      
      AND (      
       (@inClassId IS NOT NULL AND SGC.I_Class_ID IN (SELECT Value FROM dbo.ERP_SplitString(@inClassId, ',')))      
       OR @inClassId IS NULL      
      )      
      AND (      
       (@inStreamId IS NOT NULL AND SCS.I_Stream_ID IN (SELECT Value FROM dbo.ERP_SplitString(@inStreamId, ',')))      
       OR @inStreamId IS NULL      
      )      
      AND (      
       (@inSectionId IS NOT NULL AND SCS.I_Section_ID IN (SELECT Value FROM dbo.ERP_SplitString(@inSectionId, ',')))      
       OR @inSectionId IS NULL      
      );      
      
  --Insert Fees Details      
  -- EXEC InsertFeeDataset @StudentIds= @StudentIds      
  --INSERT INTO Temp_Fees_Details(student_id, current_due_amount, current_due_date, last_payment_id, last_payment_status,       
  --  current_installment_fees, last_payment_received_date, current_balance_amount, current_late_fee, current_due_payment_link)      
  -- SELECT DISTINCT       
  --   TSD.S_Student_ID AS student_id,      
  --   COALESCE(IC.N_Invoice_Amount, 0) - COALESCE(SUM(RH.N_Receipt_Amount), 0) AS current_due_amount,      
  --   subqt.Dt_Installment_Date AS current_due_date,      
  --   RH.I_Receipt_Header_ID AS last_payment_id,          
  --   CASE WHEN      
  --    RH.Dt_Receipt_Date is not Null      
  --   THEN 1       
  --   ELSE 0       
  --   END      
  --   AS last_payment_status,      
  --   NULL AS current_installment_fees,      
  --   RH.Dt_Receipt_Date AS last_payment_received_date,      
  --   IC.N_Invoice_Amount AS current_balance_amount,      
  --   NULL AS current_late_fee,      
  --   NULL AS current_due_payment_link      
  --  FROM       
  --   T_Student_Detail TSD           
  --  LEFT JOIN      
  --   T_Invoice_Parent IC ON  IC.I_Student_Detail_ID = TSD.I_Student_Detail_ID              
  --  LEFT JOIN       
  --   T_Receipt_Header RH ON       
  --   RH.I_Student_Detail_ID = IC.I_Student_Detail_ID AND RH.I_Invoice_Header_ID = IC.I_Invoice_Header_ID       
  --  JOIN T_Student_Class_Section SCS ON SCS.I_Student_Detail_ID = TSD.I_Student_Detail_ID AND SCS.I_Status = 1 AND SCS.I_Brand_ID = @inBrandID      
  --   AND SCS.I_School_Session_ID = IC.I_School_Session_ID       
  --  Left Join (      
  --   SELECT TOP 1 cd.Dt_Installment_Date,iv.I_Invoice_Header_ID        
  --   FROM T_Invoice_Child_Detail  cd      
  --    inner Join T_Invoice_Child_Header  ch ON ch.I_Invoice_Child_Header_ID=cd.I_Invoice_Child_Header_ID      
  --    inner join T_Invoice_Parent iv ON iv.I_Invoice_Header_ID=ch.I_Invoice_Header_ID      
  --    WHERE convert(DATE,cd.Dt_Installment_Date) >convert(DATE,GETDATE())      
       
  --  ) AS subqt ON subqt.I_Invoice_Header_ID = IC.I_Invoice_Header_ID      
  --  WHERE      
  --   IC.N_Invoice_Amount > 0      
  --  GROUP BY       
  --   TSD.S_Student_ID,      
  --   IC.N_Invoice_Amount,      
  --   TSD.I_Student_Detail_ID,      
  --   RH.I_Receipt_Header_ID,      
  --   RH.Dt_Receipt_Date,      
  --   subqt.Dt_Installment_Date      
      
      
    -- Insert Adminssion details      
     INSERT INTO Temp_Admission_Details (      
         enquiry_no,      
         provisional_student_name,       
         admission_date,       
         admission_stage,       
         previous_school_name,       
         previous_academic_record,       
         submitted_documents,       
         provisional_student_parent_name,      
         admission_fee,       
         admission_grade_class_section_stream)         
   SELECT       
    ER.S_Enquiry_No AS enquiry_no,      
    CONCAT(ER.S_First_Name, ' ', COALESCE(ER.S_Middle_Name, ''), ' ', COALESCE(ER.S_Last_Name, '')) AS provisional_student_name,      
    ER.Dt_PaymentDate AS admission_date,      
    ASM.S_Admission_Current_Stage AS admission_stage,      
    ERP.S_School_Name AS previous_school_name,      
    ERP.N_TotalMarks AS previous_academic_record,      
    '' AS submitted_documents,      
    ER.S_Father_Name AS provisional_student_parent_name,      
    0 AS admission_fee,      
    '' AS admission_grade_class_section_stream      
   FROM T_Enquiry_Regn_Detail ER      
   JOIN T_ERP_EnquiryReg_Prev_Details ERP ON ERP.R_I_Enquiry_Regn_ID  = ER.I_Enquiry_Regn_ID      
   JOIN T_ERP_Admission_Stage_Master ASM ON ASM.I_Admission_Stage_ID = ER.R_I_AdmStgTypeID      
           
   -- Insert Gatepass details      
      
   INSERT INTO Temp_GatePass(active_gatepass_id, gatepass_issue_date, gatepass_expiry_date, gatepass_reason, parent_master_id, gatepass_issuer_name)      
   SELECT       
    GP.I_Gate_Pass_Request_ID AS active_gatepass_id,      
    GP.Dt_Request_Date AS gatepass_issue_date,      
    NULL AS gatepass_expiry_date,      
    GP.S_Request_Reason AS gatepass_reason,      
    GP.I_Parent_Master_ID AS parent_master_id,      
    CONCAT(PM.S_First_Name, ' ', COALESCE(PM.S_Last_Name, '')) AS gatepass_issuer_name      
   FROM T_Gate_Pass_Request GP      
   JOIN T_Parent_Master PM ON PM.I_Parent_Master_ID = GP.I_Parent_Master_ID      
   END      
      
  -- Insert User & Faculty Details      
      
  INSERT INTO Temp_User_Details(user_id, recipient_name, birthday_year, work_experience_years, is_Faculty, join_date)      
  SELECT       
   U.I_User_ID AS user_id,      
   CONCAT(U.S_First_Name, ' ', COALESCE(U.S_Middle_Name, ''), ' ', COALESCE(U.S_Last_Name, '')) AS recipient_name,      
   UP.Dt_DOB AS birthday_year,      
   '' AS work_experience_years,      
   U.Is_Teaching_Staff AS is_Faculty,      
   UP.Dt_DOJ AS join_date      
  FROM T_ERP_user U      
  LEFT JOIN  T_User_Profile UP ON U.I_User_ID = UP.I_User_ID      
  WHERE U.I_Status = 1      
   AND UP.I_User_ID IS NOT NULL      
   AND U.S_First_Name IS NOT NULL          
      
    END      
          
END 