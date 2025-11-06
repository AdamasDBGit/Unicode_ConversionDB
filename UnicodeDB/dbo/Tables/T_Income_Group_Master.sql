CREATE TABLE [dbo].[T_Income_Group_Master] (
    [I_Income_Group_ID]   INT            IDENTITY (1, 1) NOT NULL,
    [S_Income_Group_Name] NVARCHAR (MAX) NULL,
    [I_Status]            INT            NULL,
    [S_Crtd_By]           NVARCHAR (MAX) NULL,
    [S_Upd_By]            NVARCHAR (MAX) NULL,
    [Dt_Crtd_On]          DATETIME       NULL,
    [Dt_Upd_On]           DATETIME       NULL,
    CONSTRAINT [PK__T_Income_Group_M__0E04DDC2] PRIMARY KEY CLUSTERED ([I_Income_Group_ID] ASC)
);

