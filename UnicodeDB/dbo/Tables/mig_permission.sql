CREATE TABLE [dbo].[mig_permission] (
    [I_Permission_ID]                 INT            NOT NULL,
    [Permission_Type]                 NVARCHAR (MAX) NULL,
    [RequestType]                     NVARCHAR (MAX) NULL,
    [S_Name]                          NVARCHAR (MAX) NULL,
    [I_Parent_Menu_ID]                INT            NULL,
    [I_Is_Leaf_Node]                  INT            NULL,
    [i_pageseq]                       INT            NULL,
    [S_Icon]                          NVARCHAR (MAX) NULL,
    [I_CreatedBy]                     INT            NULL,
    [Dt_CreatedAt]                    DATETIME       NULL,
    [I_Status]                        INT            NULL,
    [S_PageUrl]                       NVARCHAR (MAX) NULL,
    [S_Display_Component_Permissions] NVARCHAR (MAX) NULL,
    [S_Enable_Component_Permissions]  NVARCHAR (MAX) NULL,
    [Description]                     NVARCHAR (MAX) NULL,
    [Is_Active]                       INT            NULL,
    [UniqueIdentifierColumn]          NVARCHAR (MAX) NULL,
    [S_Active_Icon]                   NVARCHAR (MAX) NULL,
    PRIMARY KEY CLUSTERED ([I_Permission_ID] ASC)
);

