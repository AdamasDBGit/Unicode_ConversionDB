CREATE TABLE [dbo].[T_Company_Tax_Master] (
    [I_Company_Tax_Master_ID] INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [I_Brand_ID]              INT            NULL,
    [I_Country_ID]            INT            NULL,
    [S_Tax_Name]              NVARCHAR (MAX) NULL,
    [S_Tax_Desc]              NVARCHAR (MAX) NULL,
    [I_Status]                INT            NULL,
    [S_Crtd_By]               NVARCHAR (MAX) NULL,
    [Dt_Crtd_On]              DATETIME       NULL,
    [S_Upd_By]                NVARCHAR (MAX) NULL,
    [Dt_Upd_On]               DATETIME       NULL,
    CONSTRAINT [PK_T_Company_Tax_Master] PRIMARY KEY CLUSTERED ([I_Company_Tax_Master_ID] ASC)
);

