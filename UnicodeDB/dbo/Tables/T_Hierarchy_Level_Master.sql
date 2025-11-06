CREATE TABLE [dbo].[T_Hierarchy_Level_Master] (
    [I_Hierarchy_Level_Id]   INT            IDENTITY (1, 1) NOT NULL,
    [I_Hierarchy_Master_ID]  INT            NOT NULL,
    [S_Hierarchy_Level_Code] NVARCHAR (MAX) NULL,
    [S_Hierarchy_Level_Name] NVARCHAR (MAX) NULL,
    [I_Sequence]             INT            NULL,
    [I_Status]               INT            NULL,
    [I_Is_Last_Node]         INT            NULL,
    [S_Crtd_By]              NVARCHAR (MAX) NULL,
    [S_Upd_By]               NVARCHAR (MAX) NULL,
    [Dt_Crtd_On]             DATETIME       NULL,
    [Dt_Upd_On]              DATETIME       NULL,
    CONSTRAINT [PK__T_Hierarchy_Leve__03317E3D] PRIMARY KEY CLUSTERED ([I_Hierarchy_Level_Id] ASC)
);

