CREATE TABLE [EXAMINATION].[T_SubQuestion] (
    [I_SubQuestion_ID]    INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [I_Question_ID]       INT           NOT NULL,
    [I_SubQuestion_Type]  TINYINT       NULL,
    [S_SubQuestion_Desc]  VARCHAR (500) NOT NULL,
    [I_Document_ID]       INT           NULL,
    [S_SubQuestion_Value] VARCHAR (50)  NOT NULL,
    [S_Crtd_By]           VARCHAR (20)  NULL,
    [S_Upd_By]            VARCHAR (20)  NULL,
    [Dt_Crtd_On]          DATETIME      NULL,
    [Dt_Upd_On]           DATETIME      NULL,
    CONSTRAINT [PK__T_SubQuestion__053A8D97] PRIMARY KEY CLUSTERED ([I_SubQuestion_ID] ASC)
);

