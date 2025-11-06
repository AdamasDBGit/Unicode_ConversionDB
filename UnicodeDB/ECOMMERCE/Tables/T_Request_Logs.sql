CREATE TABLE [ECOMMERCE].[T_Request_Logs] (
    [RequestID]            INT           IDENTITY (1, 1) NOT NULL,
    [InvokedRoute]         VARCHAR (MAX) NULL,
    [InvokedMethod]        VARCHAR (MAX) NULL,
    [UniqueAttributeName]  VARCHAR (MAX) NULL,
    [UniqueAttributeValue] VARCHAR (MAX) NULL,
    [RequestParameters]    VARCHAR (MAX) NULL,
    [RequestResult]        VARCHAR (MAX) NULL,
    [ErrorMessage]         VARCHAR (MAX) NULL,
    [LogDate]              DATETIME      NULL
);

