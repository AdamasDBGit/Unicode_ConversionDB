CREATE TABLE [ECOMMERCE].[T_Cofiguration_Property_Master] (
    [ConfigID]           INT           IDENTITY (1, 1) NOT NULL,
    [ConfigCode]         VARCHAR (10)  NOT NULL,
    [ConfigName]         VARCHAR (MAX) NULL,
    [ConfigDefaultValue] VARCHAR (MAX) NULL,
    [StatusID]           INT           NULL
);

