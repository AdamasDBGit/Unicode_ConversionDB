CREATE TABLE [EXAMINATION].[T_STUDENT_MARKS_DELETED] (
    [I_Student_Marks_ID]  INT            IDENTITY (1, 1) NOT NULL,
    [I_Student_Detail_ID] INT            NULL,
    [I_Exam_Component_ID] INT            NULL,
    [I_Course_ID]         INT            NULL,
    [I_Term_ID]           INT            NULL,
    [I_Module_ID]         INT            NULL,
    [I_Exam_ID]           INT            NULL,
    [I_Exam_Total]        NUMERIC (8, 2) NULL,
    [S_Crtd_By]           VARCHAR (20)   NULL,
    [S_Upd_By]            VARCHAR (20)   NULL,
    [Dt_Crtd_On]          DATETIME       NULL,
    [Dt_Upd_On]           DATETIME       NULL,
    [Dt_Exam_Date]        DATETIME       NULL
);

