CREATE TABLE [PLACEMENT].[T_Vacancy_Skills] (
    [I_Vacancy_Skill_ID] INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [I_Vacancy_ID]       INT          NOT NULL,
    [I_Skills_ID]        INT          NOT NULL,
    [B_Soft_Skill]       BIT          NOT NULL,
    [B_Mandatory]        BIT          NOT NULL,
    [B_Technical_Skill]  BIT          NOT NULL,
    [S_Crtd_By]          VARCHAR (20) NULL,
    [S_Upd_By]           VARCHAR (20) NULL,
    [Dt_Crtd_on]         DATETIME     NULL,
    [Dt_Upd_On]          DATETIME     NULL,
    [I_Status]           INT          NOT NULL,
    CONSTRAINT [PK__T_Vacancy_Skills__20AD9DE2] PRIMARY KEY CLUSTERED ([I_Vacancy_Skill_ID] ASC)
);

