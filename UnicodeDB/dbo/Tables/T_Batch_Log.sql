CREATE TABLE [dbo].[T_Batch_Log] (
    [ID]                   INT            IDENTITY (1, 1) NOT NULL,
    [I_Process_ID]         INT            NOT NULL,
    [I_Batch_Process_ID]   INT            NULL,
    [S_Batch_Process_Name] NVARCHAR (MAX) NULL,
    [S_Comments]           NVARCHAR (MAX) NULL,
    [Dt_Run_Date_Time]     DATETIME       NULL,
    [S_Status]             NVARCHAR (MAX) NULL
);

