CREATE TABLE [dbo].[T_PaymentMode_Master_BKP] (
    [I_PaymentMode_ID]   INT            NOT NULL,
    [S_PaymentMode_Name] NVARCHAR (MAX) NULL,
    [I_Status]           INT            NULL,
    [S_Crtd_By]          NVARCHAR (MAX) NULL,
    [S_Uptd_By]          NVARCHAR (MAX) NULL,
    [Dt_Crtd_On]         DATETIME       NULL,
    [Dt_Uptd_By]         DATETIME       NULL,
    [I_Brand_ID]         INT            NULL
);

