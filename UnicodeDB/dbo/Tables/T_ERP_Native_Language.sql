CREATE TABLE [dbo].[T_ERP_Native_Language] (
    [I_Native_Language_ID]   INT            IDENTITY (1, 1) NOT NULL,
    [S_Native_Language_Name] NVARCHAR (MAX) NULL,
    [I_Status]               INT            NULL,
    [S_Crtd_By]              INT            NULL,
    [Dt_Crtd_On]             DATETIME       NULL,
    [S_Updt_By]              INT            NULL,
    [Dt_Updt_On]             DATETIME       NULL,
    CONSTRAINT [PK_T_ERP_Native_Language] PRIMARY KEY CLUSTERED ([I_Native_Language_ID] ASC)
);

