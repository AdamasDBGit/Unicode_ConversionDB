CREATE TABLE [dbo].[T_House_Master] (
    [I_House_ID]   INT            IDENTITY (1, 1) NOT NULL,
    [I_Brand_ID]   INT            NOT NULL,
    [S_House_Name] NVARCHAR (MAX) NOT NULL,
    [I_Status]     INT            NOT NULL,
    [S_Crtd_By]    NVARCHAR (MAX) NULL,
    [Dt_Crtd_On]   DATETIME       NULL,
    [S_Updt_By]    NVARCHAR (MAX) NULL,
    [Dt_Updt_On]   DATETIME       NULL,
    CONSTRAINT [PK_T_House_Master] PRIMARY KEY CLUSTERED ([I_House_ID] ASC)
);

