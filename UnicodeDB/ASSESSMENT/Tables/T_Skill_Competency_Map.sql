CREATE TABLE [ASSESSMENT].[T_Skill_Competency_Map] (
    [I_Competency_ID] INT          NOT NULL,
    [I_Skill_ID]      INT          NOT NULL,
    [S_Ctrd_by]       VARCHAR (20) NULL,
    [S_Updt_by]       VARCHAR (20) NULL,
    [Dt_Crtd_On]      DATETIME     NULL,
    [Dt_Updt_On]      DATETIME     NULL,
    CONSTRAINT [PK_T_Skill_Competency_Map] PRIMARY KEY CLUSTERED ([I_Competency_ID] ASC, [I_Skill_ID] ASC)
);

