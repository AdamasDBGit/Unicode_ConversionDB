CREATE TABLE [EXAMINATION].[T_Complexity_Master] (
    [I_Complexity_ID]   INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [S_Complexity_Desc] VARCHAR (100)  NOT NULL,
    [N_Marks]           NUMERIC (8, 2) NULL,
    [S_Crtd_By]         VARCHAR (20)   NULL,
    [S_Upd_By]          VARCHAR (20)   NULL,
    [Dt_Crtd_On]        DATETIME       NULL,
    [Dt_Upd_On]         DATETIME       NULL,
    CONSTRAINT [PK__T_Complexity_Mas__4D404D37] PRIMARY KEY CLUSTERED ([I_Complexity_ID] ASC)
);

