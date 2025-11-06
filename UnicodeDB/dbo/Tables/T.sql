CREATE TABLE [dbo].[T] (
    [S_Batch_Schedule_ID_List] NVARCHAR (MAX) NULL,
    [I_Term_ID]                INT            NULL,
    [S_Term_Name]              NVARCHAR (MAX) NULL,
    [I_Module_ID]              INT            NULL,
    [S_Module_Name]            NVARCHAR (MAX) NULL,
    [I_Session_ID]             INT            NULL,
    [S_Session_Name]           NVARCHAR (MAX) NULL,
    [S_Session_Topic]          NVARCHAR (MAX) NULL,
    [Dt_Schedule_Date]         DATETIME       NULL,
    [Dt_Actual_Date]           DATETIME       NULL,
    [S_Faculty_Name]           NVARCHAR (MAX) NULL,
    [I_Employee_ID]            INT            NULL,
    [I_Is_Complete]            INT            NULL,
    [I_Batch_ID]               INT            NULL
);

