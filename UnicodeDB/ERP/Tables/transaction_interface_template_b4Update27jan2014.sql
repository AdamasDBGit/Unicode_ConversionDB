CREATE TABLE [ERP].[transaction_interface_template_b4Update27jan2014] (
    [Transaction Number] INT             IDENTITY (1, 1) NOT NULL,
    [Entity]             VARCHAR (250)   NOT NULL,
    [Cost Centre]        INT             NOT NULL,
    [Transaction Type]   VARCHAR (250)   NOT NULL,
    [Amount]             NUMERIC (24, 2) NULL,
    [Date]               DATE            NULL,
    [Instrument Number]  VARCHAR (25)    NULL,
    [Bank Account Name]  VARCHAR (250)   NULL,
    [Interfaced Flag]    VARCHAR (10)    NULL,
    [Error Message]      VARCHAR (2000)  NULL
);

