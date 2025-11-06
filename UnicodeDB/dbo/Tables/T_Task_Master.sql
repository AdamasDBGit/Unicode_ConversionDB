CREATE TABLE [dbo].[T_Task_Master] (
    [I_Task_Master_Id] INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [S_Name]           NVARCHAR (MAX) NOT NULL,
    [S_Description]    NVARCHAR (MAX) NULL,
    [I_Type]           TINYINT        NULL,
    [S_URL]            NVARCHAR (MAX) NULL,
    [I_IsActive]       INT            NULL,
    CONSTRAINT [PK_T_Task_Master] PRIMARY KEY CLUSTERED ([I_Task_Master_Id] ASC)
);

