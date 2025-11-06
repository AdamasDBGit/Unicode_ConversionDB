CREATE TABLE [EXAMINATION].[T_Question_Bank_Master] (
    [I_Question_Bank_ID] INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [I_Brand_ID]         INT           NOT NULL,
    [S_Bank_Desc]        VARCHAR (200) NULL,
    [I_Status]           INT           NULL,
    [S_Crtd_By]          VARCHAR (20)  NULL,
    [S_Upd_By]           VARCHAR (20)  NULL,
    [Dt_Crtd_On]         DATETIME      NULL,
    [Dt_Upd_On]          DATETIME      NULL,
    CONSTRAINT [PK__T_Question_Bank___4B5804C5] PRIMARY KEY CLUSTERED ([I_Question_Bank_ID] ASC)
);

