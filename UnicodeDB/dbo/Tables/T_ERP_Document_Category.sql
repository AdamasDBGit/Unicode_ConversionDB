CREATE TABLE [dbo].[T_ERP_Document_Category] (
    [I_Document_Category_ID]   INT            IDENTITY (1, 1) NOT NULL,
    [S_Document_Category_Name] NVARCHAR (100) NOT NULL,
    [I_IsMandatory]            INT            NULL,
    [I_Status]                 INT            NOT NULL,
    CONSTRAINT [PK_T_ERP_Document_Category] PRIMARY KEY CLUSTERED ([I_Document_Category_ID] ASC)
);

