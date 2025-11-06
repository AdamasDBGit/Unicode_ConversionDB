CREATE TABLE [EOS].[T_KRA_Index_Master] (
    [I_KRA_Index_ID]   INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [S_KRA_Index_Desc] VARCHAR (200) NULL,
    [I_Status]         INT           NULL,
    [S_Crtd_By]        VARCHAR (20)  NULL,
    [S_Upd_By]         VARCHAR (20)  NULL,
    [Dt_Crtd_On]       DATETIME      NULL,
    [Dt_Upd_On]        DATETIME      NULL,
    CONSTRAINT [PK__T_KRA_Index_Mast__2C9F3ED2] PRIMARY KEY CLUSTERED ([I_KRA_Index_ID] ASC)
);

