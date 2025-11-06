CREATE TABLE [dbo].[T_ERP_Menu] (
    [I_Menu_ID]        INT            IDENTITY (1, 1) NOT NULL,
    [S_Code]           NVARCHAR (20)  NOT NULL,
    [S_Name]           NVARCHAR (150) NOT NULL,
    [I_Parent_Menu_ID] INT            NULL,
    [I_Is_Leaf_Node]   INT            NULL,
    [S_Icon]           NVARCHAR (150) NULL,
    [S_Url]            NVARCHAR (255) NULL,
    [I_CreatedBy]      INT            NULL,
    [Dt_CreatedAt]     DATETIME       NULL,
    [I_Status]         INT            NULL,
    [S_PageUrl]        NVARCHAR (MAX) NULL
);

