CREATE TABLE [EOS].[T_Role_Skill_Map] (
    [I_Role_Skill_ID] INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [I_Centre_ID]     INT          NULL,
    [I_Role_ID]       INT          NULL,
    [I_Skill_ID]      INT          NULL,
    [I_Status]        INT          NULL,
    [S_Crtd_By]       VARCHAR (20) NULL,
    [S_Upd_By]        VARCHAR (20) NULL,
    [Dt_Crtd_On]      DATETIME     NULL,
    [Dt_Upd_On]       DATETIME     NULL,
    [I_Brand_ID]      INT          NULL,
    CONSTRAINT [PK__T_Role_Skill_Map__5B795DF5] PRIMARY KEY CLUSTERED ([I_Role_Skill_ID] ASC)
);

