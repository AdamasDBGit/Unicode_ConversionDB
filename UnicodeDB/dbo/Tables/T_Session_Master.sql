CREATE TABLE [dbo].[T_Session_Master] (
    [I_Session_ID]       INT            IDENTITY (1, 1) NOT NULL,
    [I_Session_Type_ID]  INT            NULL,
    [I_Brand_ID]         INT            NULL,
    [S_Session_Code]     NVARCHAR (MAX) NOT NULL,
    [S_Session_Name]     NVARCHAR (MAX) NULL,
    [N_Session_Duration] NUMERIC (18)   NULL,
    [S_Crtd_By]          NVARCHAR (MAX) NULL,
    [S_Upd_By]           NVARCHAR (MAX) NULL,
    [S_Session_Topic]    NVARCHAR (MAX) NULL,
    [Dt_Crtd_On]         DATETIME       NULL,
    [Dt_Upd_On]          DATETIME       NULL,
    [I_Is_Editable]      INT            NULL,
    [I_Status]           INT            NULL,
    [I_Skill_ID]         INT            NULL,
    CONSTRAINT [PK__T_Session_Master__407B4EF6] PRIMARY KEY CLUSTERED ([I_Session_ID] ASC)
);

