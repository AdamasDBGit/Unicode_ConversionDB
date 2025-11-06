CREATE TABLE [ERP].[T_SMS_Oracle_Recon_Result] (
    [ID]               INT             IDENTITY (1, 1) NOT NULL,
    [BrandName]        VARCHAR (MAX)   NULL,
    [MonthYear]        VARCHAR (MAX)   NULL,
    [Type]             VARCHAR (50)    NULL,
    [AccCode]          INT             NULL,
    [AccDesc]          VARCHAR (MAX)   NULL,
    [OracleAmount]     DECIMAL (14, 2) NULL,
    [SMSAmount]        DECIMAL (14, 2) NULL,
    [DifferenceAmount] DECIMAL (14, 2) NULL,
    [CreatedOn]        DATETIME        NULL,
    [Status]           INT             NULL
);

