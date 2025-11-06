CREATE TABLE [dbo].[T_SAP_Batch_Log] (
    [ID]          INT            IDENTITY (1, 1) NOT NULL,
    [I_Brand_ID]  INT            NULL,
    [I_Centre_ID] INT            NULL,
    [S_Comments]  NVARCHAR (MAX) NULL,
    [Dt_Run_Date] DATETIME       NULL
);

