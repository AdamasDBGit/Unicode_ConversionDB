CREATE TABLE [NETWORK].[T_Payment_Charges_Master] (
    [I_Payment_Charges_ID] INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [S_Payment_Charges]    VARCHAR (20) NULL,
    CONSTRAINT [PK__T_Payment_Charge__65B7C09D] PRIMARY KEY CLUSTERED ([I_Payment_Charges_ID] ASC)
);

