CREATE TABLE [dbo].[T_Hierarchy_Master] (
    [I_Hierarchy_Master_ID] INT            IDENTITY (1, 1) NOT NULL,
    [S_Hierarchy_Code]      NVARCHAR (MAX) NULL,
    [S_Hierarchy_Desc]      NVARCHAR (MAX) NULL,
    [S_Hierarchy_Type]      NVARCHAR (MAX) NULL,
    [I_Status]              INT            NULL,
    [DT_Crtd_On]            DATETIME       NULL,
    [Dt_Upd_On]             DATETIME       NULL,
    [S_Crtd_By]             NVARCHAR (MAX) NULL,
    [S_Upd_By]              NVARCHAR (MAX) NULL,
    CONSTRAINT [PK__T_Hierarchy_Mast__656CDC83] PRIMARY KEY CLUSTERED ([I_Hierarchy_Master_ID] ASC)
);

