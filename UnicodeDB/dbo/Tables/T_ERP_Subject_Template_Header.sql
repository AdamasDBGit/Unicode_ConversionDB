CREATE TABLE [dbo].[T_ERP_Subject_Template_Header] (
    [I_Subject_Template_Header_ID] INT           IDENTITY (1, 1) NOT NULL,
    [S_Title]                      NVARCHAR (50) NULL,
    [I_Brand_ID]                   INT           NOT NULL,
    [I_IsDefault]                  INT           CONSTRAINT [DF_T_ERP_Subject_Structure_Header_I_IsDefault] DEFAULT ((0)) NOT NULL,
    [I_CreatedBy]                  INT           NULL,
    [Dt_CreatedAt]                 DATETIME      NULL
);

