CREATE TABLE [dbo].[T_ERP_Currency_Master] (
    [I_Currency_ID]   INT            IDENTITY (1, 1) NOT NULL,
    [S_Currency_Code] NVARCHAR (MAX) NULL,
    [S_Currency_Name] NVARCHAR (MAX) NULL,
    [I_Status]        INT            NULL,
    [S_Crtd_By]       INT            NULL,
    [S_Upd_By]        INT            NULL,
    [Dt_Crtd_On]      DATETIME       NULL,
    [Dt_Upd_On]       DATETIME       NULL,
    CONSTRAINT [PK_T_ERP_Currency_Master_08B618C0] PRIMARY KEY CLUSTERED ([I_Currency_ID] ASC)
);

