CREATE TABLE [dbo].[T_Error_Log_XML] (
    [ErrorID]           INT            IDENTITY (1, 1) NOT NULL,
    [ProcedureName]     NVARCHAR (255) NULL,
    [ErrorMessage]      NVARCHAR (MAX) NULL,
    [ErrorSeverity]     INT            NULL,
    [ErrorState]        INT            NULL,
    [ErrorLine]         INT            NULL,
    [ErrorNumber]       INT            NULL,
    [InputInvoiceXml]   XML            NULL,
    [InputOnAccountXml] XML            NULL,
    [TransactionNo]     NVARCHAR (MAX) NULL,
    [StudentID]         NVARCHAR (MAX) NULL,
    [LogTime]           DATETIME       DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([ErrorID] ASC)
);

