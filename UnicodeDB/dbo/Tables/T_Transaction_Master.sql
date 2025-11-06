CREATE TABLE [dbo].[T_Transaction_Master] (
    [I_Transaction_ID]   INT            IDENTITY (1, 1) NOT NULL,
    [I_Menu_Group_ID]    INT            NULL,
    [S_Transaction_Code] NVARCHAR (MAX) NULL,
    [S_Transaction_Name] NVARCHAR (MAX) NULL,
    [I_Status]           INT            NULL,
    [I_Brand_ID]         INT            NULL,
    CONSTRAINT [PK__T_Transaction_Ma__4A4ED1F3] PRIMARY KEY CLUSTERED ([I_Transaction_ID] ASC)
);

