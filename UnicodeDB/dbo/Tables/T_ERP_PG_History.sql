CREATE TABLE [dbo].[T_ERP_PG_History] (
    [PG_History_ID]           INT            IDENTITY (1, 1) NOT NULL,
    [SourceofRequestType]     NVARCHAR (MAX) NULL,
    [RequestUserId]           NVARCHAR (MAX) NULL,
    [PGCancelledBy]           NVARCHAR (MAX) NULL,
    [PGCancelledDate]         DATETIME       NULL,
    [ExternalReceiptNo]       NVARCHAR (MAX) NULL,
    [PaymentStatus]           NVARCHAR (MAX) NULL,
    [PGMessage]               NVARCHAR (MAX) NULL,
    [PGResponseType]          NVARCHAR (MAX) NULL,
    [PGExecutionDate]         DATETIME       NULL,
    [PGResponseJson]          NVARCHAR (MAX) NULL,
    [S_Transaction_No]        NVARCHAR (MAX) NULL,
    [I_Transaction_Master_ID] INT            NULL,
    [Dt_CreatedAt]            DATETIME       NULL
);

