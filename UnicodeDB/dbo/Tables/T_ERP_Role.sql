CREATE TABLE [dbo].[T_ERP_Role] (
    [I_Role_ID]     INT            IDENTITY (1, 1) NOT NULL,
    [S_Role_Name]   NVARCHAR (100) NOT NULL,
    [S_Description] NVARCHAR (MAX) NULL,
    [Dt_CreatedBy]  INT            NULL,
    [Dt_CreatedAt]  DATETIME       NULL,
    [I_Status]      INT            NOT NULL
);

