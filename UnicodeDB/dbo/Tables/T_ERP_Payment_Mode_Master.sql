CREATE TABLE [dbo].[T_ERP_Payment_Mode_Master] (
    [I_PaymentMode_ID]  INT            IDENTITY (1, 1) NOT NULL,
    [S_PaymentTypeName] NVARCHAR (MAX) NULL,
    [Dtt_Created_At]    DATETIME       CONSTRAINT [DF__T_ERP_Pay__Dtt_C__189877EF] DEFAULT (getdate()) NULL,
    [Dtt_Modified_At]   DATETIME       NULL,
    [I_Created_By]      INT            NULL,
    [I_Modified_By]     INT            NULL,
    [Is_Active]         BIT            CONSTRAINT [DF__T_ERP_Pay__Is_Ac__198C9C28] DEFAULT ((1)) NULL,
    CONSTRAINT [PK__T_ERP_Pa__F1DF11951255595C] PRIMARY KEY CLUSTERED ([I_PaymentMode_ID] ASC)
);

