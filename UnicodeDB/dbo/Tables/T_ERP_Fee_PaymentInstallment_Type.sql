CREATE TABLE [dbo].[T_ERP_Fee_PaymentInstallment_Type] (
    [I_Fee_Pay_Installment_ID] INT            IDENTITY (1, 1) NOT NULL,
    [I_Brand_ID]               INT            NULL,
    [I_Pay_InstallmentNo]      INT            NULL,
    [S_Installment_Frequency]  NVARCHAR (MAX) NULL,
    [Dtt_Created_At]           DATETIME       CONSTRAINT [DF__T_ERP_Fee__Dtt_C__14C7E70B] DEFAULT (getdate()) NULL,
    [Dtt_Modified_At]          DATETIME       NULL,
    [I_Created_By]             INT            NULL,
    [I_Modified_By]            INT            NULL,
    [Is_Active]                BIT            CONSTRAINT [DF__T_ERP_Fee__Is_Ac__15BC0B44] DEFAULT ((1)) NULL,
    [I_Interval]               INT            NULL,
    [RequiredforFine]          BIT            NULL,
    CONSTRAINT [PK__T_ERP_Fe__5B0A0340A5415E20] PRIMARY KEY CLUSTERED ([I_Fee_Pay_Installment_ID] ASC)
);

