CREATE TABLE [dbo].[FinancialSyncLogs] (
    [I_FinancialSyncLog_ID] INT      NULL,
    [I_Brand_ID]            INT      NULL,
    [Dt_FromDate]           DATETIME NULL,
    [Dt_ToDate]             DATETIME NULL,
    [IsPush]                BIT      NULL,
    [IsGLPushed]            BIT      NULL,
    [Dt_ExecutionDate]      DATETIME NULL,
    [I_Executed_By]         INT      NULL,
    [TransactionMonth]      INT      NULL,
    [TransactionYear]       INT      NULL
);

