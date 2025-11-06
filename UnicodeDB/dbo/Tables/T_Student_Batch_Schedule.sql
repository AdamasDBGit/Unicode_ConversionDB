CREATE TABLE [dbo].[T_Student_Batch_Schedule] (
    [I_Batch_Schedule_ID] INT            IDENTITY (1, 1) NOT NULL,
    [I_Batch_ID]          INT            NULL,
    [I_Centre_ID]         INT            NULL,
    [I_Term_ID]           INT            NULL,
    [I_Module_ID]         INT            NULL,
    [I_Session_ID]        INT            NULL,
    [S_Session_Name]      NVARCHAR (MAX) NULL,
    [S_Session_Topic]     NVARCHAR (MAX) NULL,
    [Dt_Schedule_Date]    DATETIME       NULL,
    [Dt_Actual_Date]      DATETIME       NULL,
    [I_Employee_ID]       INT            NULL,
    [I_Is_Complete]       INT            NULL,
    CONSTRAINT [PK_T_Student_Batch_Schedule] PRIMARY KEY CLUSTERED ([I_Batch_Schedule_ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [Ix_BatchID_TSBS]
    ON [dbo].[T_Student_Batch_Schedule]([I_Batch_ID] ASC);


GO
CREATE NONCLUSTERED INDEX [Ix_CenterID_TSBS]
    ON [dbo].[T_Student_Batch_Schedule]([I_Centre_ID] ASC);

