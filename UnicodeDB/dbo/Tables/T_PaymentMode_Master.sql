CREATE TABLE [dbo].[T_PaymentMode_Master] (
    [I_PaymentMode_ID]        INT            NOT NULL,
    [S_PaymentMode_Name]      NVARCHAR (MAX) NULL,
    [I_Status]                INT            NULL,
    [S_Crtd_By]               NVARCHAR (MAX) NULL,
    [S_Uptd_By]               NVARCHAR (MAX) NULL,
    [Dt_Crtd_On]              DATETIME       NULL,
    [Dt_Uptd_By]              DATETIME       NULL,
    [I_Brand_ID]              INT            NULL,
    [ISAllowedForSattlement]  BIT            NULL,
    [IsAllowedForDebitCredit] BIT            NULL,
    [IsAllowedForCheque]      BIT            NULL,
    [IsOffline]               BIT            NULL,
    [IsCheque_Draft]          BIT            DEFAULT ((0)) NOT NULL,
    [S_Cheque_DraftName]      NVARCHAR (50)  NULL,
    [Is_DebitCredit]          AS             (case when [I_Status]=(1) then CONVERT([bit],(1)) else CONVERT([bit],(0)) end) PERSISTED,
    CONSTRAINT [PK__T_PaymentMode_Ma__62906FD8] PRIMARY KEY CLUSTERED ([I_PaymentMode_ID] ASC)
);

