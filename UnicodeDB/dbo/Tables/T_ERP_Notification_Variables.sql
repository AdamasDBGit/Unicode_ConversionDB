CREATE TABLE [dbo].[T_ERP_Notification_Variables] (
    [Id]           INT            NOT NULL,
    [Module]       NVARCHAR (100) NULL,
    [VariableName] NVARCHAR (200) NULL,
    [Definition]   NVARCHAR (500) NULL,
    CONSTRAINT [PK__T_ERP_No__3214EC07E5F25460] PRIMARY KEY CLUSTERED ([Id] ASC)
);

