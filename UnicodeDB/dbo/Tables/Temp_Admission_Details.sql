CREATE TABLE [dbo].[Temp_Admission_Details] (
    [enquiry_no]                           NVARCHAR (50)   NULL,
    [provisional_student_name]             NVARCHAR (100)  NULL,
    [admission_date]                       DATE            NULL,
    [admission_stage]                      NVARCHAR (50)   NULL,
    [previous_school_name]                 NVARCHAR (100)  NULL,
    [previous_academic_record]             NVARCHAR (MAX)  NULL,
    [submitted_documents]                  NVARCHAR (MAX)  NULL,
    [provisional_student_parent_name]      NVARCHAR (100)  NULL,
    [admission_fee]                        DECIMAL (10, 2) NULL,
    [admission_grade_class_section_stream] NVARCHAR (100)  NULL
);

