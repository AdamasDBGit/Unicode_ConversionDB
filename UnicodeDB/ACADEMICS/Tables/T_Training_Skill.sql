CREATE TABLE [ACADEMICS].[T_Training_Skill] (
    [I_Training_Skill_ID] INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [I_Skill_ID]          INT          NULL,
    [I_Training_ID]       INT          NULL,
    [S_Crtd_By]           VARCHAR (20) NULL,
    [S_Upd_By]            VARCHAR (20) NULL,
    [Dt_Crtd_On]          DATETIME     NULL,
    [Dt_Upd_On]           DATETIME     NULL,
    CONSTRAINT [PK__T_Training_Skill__6C6EDFCD] PRIMARY KEY CLUSTERED ([I_Training_Skill_ID] ASC)
);

