CREATE TABLE [NETWORK].[T_Agreement_Center] (
    [I_Agreement_Center_ID] INT IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [I_Agreement_ID]        INT NULL,
    [I_Centre_Id]           INT NOT NULL,
    CONSTRAINT [PK__T_Agreement_Cent__29ACF837] PRIMARY KEY CLUSTERED ([I_Agreement_Center_ID] ASC)
);

