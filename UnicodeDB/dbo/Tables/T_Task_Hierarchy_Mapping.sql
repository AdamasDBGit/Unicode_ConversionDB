CREATE TABLE [dbo].[T_Task_Hierarchy_Mapping] (
    [I_Task_Master_Id]      INT            NOT NULL,
    [I_Hierarchy_Detail_ID] INT            NOT NULL,
    [S_Crtd_By]             NVARCHAR (MAX) NULL,
    [Dt_Crtd_On]            DATETIME       NULL,
    [S_Upd_By]              NVARCHAR (MAX) NULL,
    [Dt_Upd_On]             DATETIME       NULL,
    CONSTRAINT [PK_T_Task_Hierarchy_Mapping] PRIMARY KEY CLUSTERED ([I_Task_Master_Id] ASC, [I_Hierarchy_Detail_ID] ASC)
);

