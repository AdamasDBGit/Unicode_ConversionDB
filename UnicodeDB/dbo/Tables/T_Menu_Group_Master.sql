CREATE TABLE [dbo].[T_Menu_Group_Master] (
    [I_Menu_Group_ID]   INT            NOT NULL,
    [S_Menu_Group_Name] NVARCHAR (MAX) NULL,
    [I_Status]          INT            NULL,
    CONSTRAINT [PK__T_Menu_Group_Mas__7B5C1DA2] PRIMARY KEY CLUSTERED ([I_Menu_Group_ID] ASC)
);

