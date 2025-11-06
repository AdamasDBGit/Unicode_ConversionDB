CREATE TABLE [EXAMINATION].[T_Pool_Master] (
    [I_Pool_ID]   INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [I_Brand_ID]  INT           NOT NULL,
    [S_Pool_Desc] VARCHAR (200) NULL,
    [I_Status]    INT           NULL,
    [S_Crtd_By]   VARCHAR (20)  NULL,
    [S_Upd_By]    VARCHAR (20)  NULL,
    [Dt_Crtd_On]  DATETIME      NULL,
    [Dt_Upd_On]   DATETIME      NULL,
    CONSTRAINT [PK__T_Pool_Master__496FBC53] PRIMARY KEY CLUSTERED ([I_Pool_ID] ASC)
);

