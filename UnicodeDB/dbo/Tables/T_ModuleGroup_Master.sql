CREATE TABLE [dbo].[T_ModuleGroup_Master] (
    [I_ModuleGroup_ID]   INT            IDENTITY (1, 1) NOT NULL,
    [S_ModuleGroup_Code] NVARCHAR (MAX) NULL,
    [S_ModuleGroup_Name] NVARCHAR (MAX) NULL,
    [I_Brand_ID]         INT            NULL,
    [I_Status]           INT            NULL,
    [I_Sequence]         INT            NULL,
    [S_Crtd_By]          NVARCHAR (MAX) NULL,
    [Dt_Crtd_On]         DATETIME       NULL,
    [S_Upd_By]           NVARCHAR (MAX) NULL,
    [Dt_Upd_On]          DATETIME       NULL,
    CONSTRAINT [PK_T_ModuleGroup_Master] PRIMARY KEY CLUSTERED ([I_ModuleGroup_ID] ASC)
);

