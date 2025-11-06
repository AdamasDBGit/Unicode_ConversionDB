CREATE TABLE [dbo].[BKP_T_Student_Term_Detail_SEP] (
    [I_Student_Term_Detail_ID] INT            IDENTITY (1, 1) NOT NULL,
    [I_Term_ID]                INT            NOT NULL,
    [I_Course_ID]              INT            NOT NULL,
    [I_Student_Detail_ID]      INT            NOT NULL,
    [I_Is_Completed]           BIT            NULL,
    [S_Crtd_By]                NVARCHAR (MAX) NULL,
    [S_Upd_By]                 NVARCHAR (MAX) NULL,
    [Dt_Crtd_On]               DATETIME       NULL,
    [Dt_Upd_On]                DATETIME       NULL,
    [I_Student_PS_ID]          INT            NULL,
    [I_Student_Certificate_ID] INT            NULL,
    [S_Term_Grade]             NVARCHAR (MAX) NULL,
    [S_Term_Status]            NVARCHAR (MAX) NULL,
    [S_Term_Final_Marks]       INT            NULL,
    [I_Batch_ID]               INT            NULL,
    [D_Attendance]             DECIMAL (18)   NULL,
    [I_Conduct_Id]             INT            NULL
);

