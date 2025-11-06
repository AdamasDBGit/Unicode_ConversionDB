CREATE TABLE [dbo].[T_ERP_Menu_Permission] (
    [I_Menu_Permission_ID] INT            IDENTITY (1, 1) NOT NULL,
    [S_Permission_Name]    NVARCHAR (100) NOT NULL,
    [I_Menu_ID]            INT            NOT NULL,
    [I_CreatedBy]          INT            NULL,
    [Dt_CreatedAt]         DATETIME       NULL,
    [I_Status]             INT            NOT NULL,
    [Dt_ModifiedAt]        DATETIME       NULL,
    [I_ModifiedBy]         INT            NULL
);

