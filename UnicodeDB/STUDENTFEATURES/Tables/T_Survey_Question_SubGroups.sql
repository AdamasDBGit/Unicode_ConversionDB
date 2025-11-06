CREATE TABLE [STUDENTFEATURES].[T_Survey_Question_SubGroups] (
    [I_SQ_SubGroups_ID] INT           IDENTITY (1, 1) NOT NULL,
    [S_SubGroupDesc]    VARCHAR (200) NOT NULL,
    [I_SQ_Groups_ID]    INT           NOT NULL,
    [I_Status]          INT           NULL,
    [S_Crtd_By]         VARCHAR (20)  NULL,
    [S_Upd_By]          VARCHAR (20)  NULL,
    [Dt_Crtd_On]        DATETIME      NULL,
    [Dt_Upd_On]         DATETIME      NULL,
    CONSTRAINT [PK__T_Survey__3FF9E4EC405857D3] PRIMARY KEY CLUSTERED ([I_SQ_SubGroups_ID] ASC),
    CONSTRAINT [UQ__T_Survey__CD4BF94F4334C47E] UNIQUE NONCLUSTERED ([S_SubGroupDesc] ASC)
);

