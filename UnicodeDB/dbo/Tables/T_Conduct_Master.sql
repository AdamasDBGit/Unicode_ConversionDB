CREATE TABLE [dbo].[T_Conduct_Master] (
    [I_Conduct_Id]   INT            IDENTITY (1, 1) NOT NULL,
    [S_Conduct_Code] NVARCHAR (MAX) NULL,
    [S_Crtd_By]      NVARCHAR (MAX) NULL,
    [S_Upd_By]       NVARCHAR (MAX) NULL,
    [Dt_Crtd_On]     DATETIME       NULL,
    [Dt_Upd_On]      DATETIME       NULL,
    [I_Status]       INT            NULL,
    CONSTRAINT [PK_T_Conduct_Master] PRIMARY KEY CLUSTERED ([I_Conduct_Id] ASC)
);

