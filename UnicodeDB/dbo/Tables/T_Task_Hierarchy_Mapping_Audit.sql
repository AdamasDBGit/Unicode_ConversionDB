CREATE TABLE [dbo].[T_Task_Hierarchy_Mapping_Audit] (
    [I_Task_Hierarchy_Audit_ID] INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [I_Task_Master_Id]          INT            NOT NULL,
    [I_Hierarchy_Detail_ID]     INT            NOT NULL,
    [S_Crtd_By]                 NVARCHAR (MAX) NULL,
    [Dt_Crtd_On]                DATETIME       NULL,
    [S_Upd_By]                  NVARCHAR (MAX) NULL,
    [Dt_Upd_On]                 DATETIME       NULL,
    CONSTRAINT [PK__T_Task_Hierarchy__2B5614DE] PRIMARY KEY CLUSTERED ([I_Task_Hierarchy_Audit_ID] ASC)
);

