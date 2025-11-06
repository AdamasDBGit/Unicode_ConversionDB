CREATE TABLE [dbo].[T_ERP_Religion] (
    [I_Religion_ID]   INT            IDENTITY (1, 1) NOT NULL,
    [S_Religion_Name] NVARCHAR (MAX) NULL,
    [I_Status]        INT            NULL,
    [I_Crtd_By]       INT            NULL,
    [Dt_Crtd_On]      DATETIME       NULL,
    [I_Updt_By]       INT            NULL,
    [Dt_Updt_On]      DATETIME       NULL,
    CONSTRAINT [PK_T_ERP_Religion] PRIMARY KEY CLUSTERED ([I_Religion_ID] ASC)
);

