CREATE TABLE [dbo].[T_ERP_Request_Log] (
    [I_ERP_RequestID]        INT            IDENTITY (1, 1) NOT NULL,
    [S_Mobile_No]            NVARCHAR (MAX) NULL,
    [S_Token]                NVARCHAR (MAX) NULL,
    [S_Source]               NVARCHAR (MAX) NULL,
    [S_InvokedRoute]         NVARCHAR (MAX) NULL,
    [S_InvokedMethod]        NVARCHAR (MAX) NULL,
    [S_UniqueAttributeName]  NVARCHAR (MAX) NULL,
    [S_UniqueAttributeValue] NVARCHAR (MAX) NULL,
    [S_RequestParameters]    NVARCHAR (MAX) NULL,
    [RequestResult]          NVARCHAR (MAX) NULL,
    [ErrorMessage]           NVARCHAR (MAX) NULL,
    [LogDate]                DATETIME       NULL
);

