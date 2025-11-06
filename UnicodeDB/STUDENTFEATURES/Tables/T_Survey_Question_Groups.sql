CREATE TABLE [STUDENTFEATURES].[T_Survey_Question_Groups] (
    [I_SQ_Groups_ID] INT           IDENTITY (1, 1) NOT NULL,
    [S_GroupDesc]    VARCHAR (200) NOT NULL,
    [I_Status]       INT           NULL,
    [S_Crtd_By]      VARCHAR (20)  NULL,
    [S_Upd_By]       VARCHAR (20)  NULL,
    [Dt_Crtd_On]     DATETIME      NULL,
    [Dt_Upd_On]      DATETIME      NULL,
    CONSTRAINT [PK__T_Survey__91DF301B39AB5A44] PRIMARY KEY CLUSTERED ([I_SQ_Groups_ID] ASC),
    CONSTRAINT [UQ__T_Survey__E412C1C53C87C6EF] UNIQUE NONCLUSTERED ([S_GroupDesc] ASC)
);

