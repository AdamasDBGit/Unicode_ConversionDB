CREATE TABLE [EXAMINATION].[T_Homework_Master] (
    [I_Homework_ID]      INT            IDENTITY (1, 1) NOT NULL,
    [S_Homework_Name]    VARCHAR (200)  NOT NULL,
    [S_Homework_Desc]    VARCHAR (2000) NULL,
    [Dt_Submission_Date] DATETIME       NULL,
    [I_Batch_ID]         INT            NOT NULL,
    [I_Center_ID]        INT            NOT NULL,
    [I_Status]           INT            NULL,
    [S_Crtd_By]          VARCHAR (20)   NULL,
    [Dt_Crtd_On]         DATETIME       NULL,
    [S_Updt_By]          VARCHAR (20)   NULL,
    [Dt_Updt_On]         DATETIME       NULL,
    [I_Term_ID]          INT            NULL,
    [I_session_ID]       INT            NULL,
    CONSTRAINT [PK_T_Homework_Master] PRIMARY KEY CLUSTERED ([I_Homework_ID] ASC)
);

