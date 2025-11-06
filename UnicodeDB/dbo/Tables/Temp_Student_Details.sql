CREATE TABLE [dbo].[Temp_Student_Details] (
    [student_id]                         NVARCHAR (50)  NULL,
    [student_detail_id]                  INT            NULL,
    [student_name]                       NVARCHAR (100) NULL,
    [parent_name]                        NVARCHAR (100) NULL,
    [student_dob]                        DATE           NULL,
    [student_address]                    NVARCHAR (255) NULL,
    [student_roll_no]                    NVARCHAR (50)  NULL,
    [class_teacher_name]                 NVARCHAR (100) NULL,
    [current_grade_class]                NVARCHAR (50)  NULL,
    [current_grade_class_section_stream] NVARCHAR (50)  NULL,
    [student_phone]                      NVARCHAR (15)  NULL,
    [student_email]                      NVARCHAR (100) NULL,
    [I_School_Session_ID]                INT            NULL,
    [I_School_Group_Class_ID]            INT            NULL,
    [I_Class_ID]                         INT            NULL,
    [I_Stream_ID]                        INT            NULL,
    [I_Section_ID]                       INT            NULL,
    [S_Firebase_Token]                   NVARCHAR (MAX) NULL,
    [stParentToken]                      NVARCHAR (200) NULL,
    [I_Parent_Master_ID]                 INT            NULL,
    [Is_token_Active]                    BIT            NULL
);

