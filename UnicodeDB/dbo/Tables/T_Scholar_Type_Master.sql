CREATE TABLE [dbo].[T_Scholar_Type_Master] (
    [I_Scholar_Type_ID]   INT            IDENTITY (1, 1) NOT NULL,
    [S_Scholar_Type_Name] NVARCHAR (MAX) NULL,
    [I_Status]            INT            NULL,
    [S_Crtd_By]           NVARCHAR (MAX) NULL,
    [Dt_Crtd_On]          DATETIME       NULL,
    [S_Updt_By]           NVARCHAR (MAX) NULL,
    [Dt_Updt_On]          DATETIME       NULL,
    CONSTRAINT [PK_T_Scholar_Type_Master] PRIMARY KEY CLUSTERED ([I_Scholar_Type_ID] ASC)
);

