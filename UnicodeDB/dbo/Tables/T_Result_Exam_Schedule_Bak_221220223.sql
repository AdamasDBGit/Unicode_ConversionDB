CREATE TABLE [dbo].[T_Result_Exam_Schedule_Bak_221220223] (
    [I_Result_Exam_Schedule_ID] BIGINT         IDENTITY (1, 1) NOT NULL,
    [I_School_Session_ID]       INT            NOT NULL,
    [I_Course_ID]               INT            NOT NULL,
    [I_Term_ID]                 INT            NOT NULL,
    [Title]                     NVARCHAR (MAX) NULL,
    [I_School_Group_Class_ID]   INT            NULL,
    [I_Stream_ID]               INT            NULL,
    [Dt_Exam_Start_Date]        DATE           NULL,
    [Dt_Exam_End_Date]          DATE           NULL,
    [S_Class_Teacher_Name]      NVARCHAR (MAX) NULL,
    [S_Class_Teacher_Signature] NVARCHAR (MAX) NULL,
    [S_Principal_Name]          NVARCHAR (MAX) NULL,
    [S_Principal_Signature]     NVARCHAR (MAX) NULL,
    [I_Result_Process_Status]   INT            NULL,
    [I_Result_Publish_Status]   INT            NULL,
    [Dt_Result_Publish_Date]    DATETIME       NULL,
    [I_Grade_Marks_View]        INT            NULL,
    [I_Is_Freezed]              INT            NULL,
    [Dt_CreatedAt]              DATETIME       NOT NULL,
    [I_Created_By]              INT            NOT NULL,
    [I_IsActive]                INT            NULL
);

