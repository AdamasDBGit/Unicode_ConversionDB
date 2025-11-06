CREATE TABLE [dbo].[ERP_ErrorLogTable] (
    [ID]              INT            IDENTITY (1, 1) NOT NULL,
    [ErrorMessage]    NVARCHAR (MAX) NULL,
    [ErrorSeverity]   NVARCHAR (MAX) NULL,
    [ErrorState]      NVARCHAR (MAX) NULL,
    [ErrorProcedure]  NVARCHAR (MAX) NULL,
    [ErrorController] NVARCHAR (50)  NULL,
    [ErrorAction]     NVARCHAR (50)  NULL,
    [Date]            DATETIME       NULL,
    [ErrorID]         NVARCHAR (MAX) NULL,
    [UserID]          NVARCHAR (50)  NULL
);

