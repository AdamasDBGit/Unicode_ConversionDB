CREATE TABLE [dbo].[T_Book_Master] (
    [I_Book_ID]   INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [S_Book_Name] NVARCHAR (MAX) NULL,
    [I_Brand_ID]  INT            NULL,
    [I_Status]    INT            NULL,
    [S_Book_Code] NVARCHAR (MAX) NULL,
    [S_Crtd_By]   NVARCHAR (MAX) NULL,
    [S_Book_Desc] NVARCHAR (MAX) NULL,
    [S_Upd_By]    NVARCHAR (MAX) NULL,
    [Dt_Crtd_On]  DATETIME       NULL,
    [Dt_Upd_On]   DATETIME       NULL,
    CONSTRAINT [PK__T_Book_Master__1F6473EE] PRIMARY KEY CLUSTERED ([I_Book_ID] ASC)
);

