CREATE TABLE [dbo].[T_Student_Activity_Performance] (
    [I_Student_Activity_Performance_ID] INT            IDENTITY (1, 1) NOT NULL,
    [I_Student_Activity_ID]             INT            NOT NULL,
    [I_Term_ID]                         INT            NOT NULL,
    [I_Evaluation_ID]                   INT            NOT NULL,
    [S_Student_Grade]                   NVARCHAR (MAX) NULL,
    [I_Status]                          INT            NOT NULL,
    [S_Crtd_By]                         NVARCHAR (MAX) NOT NULL,
    [Dt_Crtd_On]                        DATETIME       NOT NULL,
    [S_Updt_By]                         NVARCHAR (MAX) NULL,
    [Dt_Updt_On]                        DATETIME       NULL,
    CONSTRAINT [PK_T_Student_Activity_Performance] PRIMARY KEY CLUSTERED ([I_Student_Activity_Performance_ID] ASC)
);

