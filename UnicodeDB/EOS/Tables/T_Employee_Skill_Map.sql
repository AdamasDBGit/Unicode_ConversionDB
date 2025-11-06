CREATE TABLE [EOS].[T_Employee_Skill_Map] (
    [I_Emp_Skill_Dtl_ID] INT          IDENTITY (1, 1) NOT NULL,
    [I_Skill_ID]         INT          NULL,
    [I_Employee_ID]      INT          NULL,
    [I_Status]           INT          NULL,
    [S_Crtd_By]          VARCHAR (20) NULL,
    [S_Upd_By]           VARCHAR (20) NULL,
    [Dt_Crtd_On]         DATETIME     NULL,
    [Dt_Upd_On]          DATETIME     NULL,
    CONSTRAINT [PK__T_Employee_Skill__703F70B1] PRIMARY KEY CLUSTERED ([I_Emp_Skill_Dtl_ID] ASC)
);

