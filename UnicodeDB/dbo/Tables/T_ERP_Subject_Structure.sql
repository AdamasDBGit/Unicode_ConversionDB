CREATE TABLE [dbo].[T_ERP_Subject_Structure] (
    [I_Subject_Structure_ID]        INT            IDENTITY (1, 1) NOT NULL,
    [I_Subject_Structure_Header_ID] INT            NOT NULL,
    [I_Subject_Template_ID]         INT            NOT NULL,
    [I_Parent_Subject_Structure_ID] INT            NULL,
    [S_Name]                        NVARCHAR (MAX) NOT NULL,
    [I_CreatedBy]                   INT            NOT NULL,
    [Dt_CreatedAt]                  DATETIME       NOT NULL,
    [I_Status]                      INT            NOT NULL,
    [Methodology]                   NVARCHAR (MAX) NULL,
    [Objective]                     NVARCHAR (MAX) NULL
);

