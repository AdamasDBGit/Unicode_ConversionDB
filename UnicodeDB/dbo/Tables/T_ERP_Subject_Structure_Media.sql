CREATE TABLE [dbo].[T_ERP_Subject_Structure_Media] (
    [I_Subject_Structure_Media_ID]  INT            IDENTITY (1, 1) NOT NULL,
    [I_Subject_Structure_Header_ID] INT            NOT NULL,
    [S_Media_Type]                  NVARCHAR (50)  NOT NULL,
    [S_Media_Name]                  NVARCHAR (250) NOT NULL,
    [S_Document_Link]               NVARCHAR (MAX) NULL,
    [I_CreatedBy]                   INT            NOT NULL,
    [Dt_CreatedAt]                  DATETIME       NOT NULL,
    [I_Status]                      INT            NOT NULL
);

