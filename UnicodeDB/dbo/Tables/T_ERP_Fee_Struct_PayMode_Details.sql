CREATE TABLE [dbo].[T_ERP_Fee_Struct_PayMode_Details] (
    [I_Inv_PaymentModeD_ID]     BIGINT         IDENTITY (1, 1) NOT NULL,
    [R_I_Fee_Struct_Payment_ID] BIGINT         NULL,
    [R_I_PaymentMode_ID]        INT            NULL,
    [S_Tran_Ref_Number]         NVARCHAR (MAX) NULL,
    [S_Bank_Name]               NVARCHAR (MAX) NULL,
    [S_IFSC_Code]               NVARCHAR (MAX) NULL,
    [S_Branch_Name]             NVARCHAR (MAX) NULL,
    [S_MICR_Code]               NVARCHAR (MAX) NULL,
    [Is_Settlement]             BIT            CONSTRAINT [DF__T_ERP_Fee__Is_Se__0C32A10A] DEFAULT ((0)) NULL,
    [Dt_Settlement_Dt]          DATE           NULL,
    [S_Settlement_Bank]         NVARCHAR (MAX) NULL,
    [S_Settlement_Branch]       NVARCHAR (MAX) NULL,
    [Dtt_Created_At]            DATETIME       CONSTRAINT [DF__T_ERP_Fee__Dtt_C__0D26C543] DEFAULT (getdate()) NULL,
    [Dtt_Modified_At]           DATETIME       NULL,
    [I_Created_By]              INT            NULL,
    [I_Modified_By]             INT            NULL,
    [Is_Active]                 BIT            CONSTRAINT [DF__T_ERP_Fee__Is_Ac__0E1AE97C] DEFAULT ((1)) NULL,
    CONSTRAINT [PK__T_ERP_Fe__EFD56A392018B6C9] PRIMARY KEY CLUSTERED ([I_Inv_PaymentModeD_ID] ASC)
);

