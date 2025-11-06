CREATE TABLE [dbo].[T_Preferred_Career_Master] (
    [I_Pref_Career_ID]   INT            IDENTITY (1, 1) NOT NULL,
    [S_Pref_Career_Name] NVARCHAR (MAX) NULL,
    [I_Status]           INT            NULL,
    [S_Crtd_By]          NVARCHAR (MAX) NULL,
    [S_Upd_By]           NVARCHAR (MAX) NULL,
    [Dt_Crtd_On]         DATETIME       NULL,
    [Dt_Upd_On]          DATETIME       NULL,
    CONSTRAINT [PK__T_Preferred_Care__562A98F3] PRIMARY KEY CLUSTERED ([I_Pref_Career_ID] ASC)
);

