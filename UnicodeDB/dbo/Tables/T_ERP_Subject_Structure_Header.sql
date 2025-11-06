CREATE TABLE [dbo].[T_ERP_Subject_Structure_Header] (
    [I_Subject_Structure_Header_ID] INT      IDENTITY (1, 1) NOT NULL,
    [I_Subject_Template_Header_ID]  INT      NULL,
    [I_Subject_ID]                  INT      NULL,
    [I_CreatedBy]                   INT      NULL,
    [Dt_CreatedAt]                  DATETIME NULL
);

