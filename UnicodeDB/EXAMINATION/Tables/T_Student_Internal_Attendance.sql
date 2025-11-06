CREATE TABLE [EXAMINATION].[T_Student_Internal_Attendance] (
    [I_Course_ID]         INT             NULL,
    [I_Term_ID]           INT             NULL,
    [I_Module_ID]         INT             NULL,
    [I_Exam_Component_ID] INT             NULL,
    [I_Student_Detail_ID] INT             NULL,
    [N_Attendance]        DECIMAL (14, 2) NULL,
    [S_Crtd_By]           VARCHAR (MAX)   NULL,
    [Dt_Crtd_On]          DATETIME        NULL,
    [S_Updt_By]           VARCHAR (MAX)   NULL,
    [Dt_Updt_On]          DATETIME        NULL,
    [N_AllottedClass]     INT             NULL,
    [I_Status]            INT             NULL
);

