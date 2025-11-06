CREATE TABLE [dbo].[T_Student_Batch_TimeSlot_Details] (
    [ID]             INT            IDENTITY (1, 1) NOT NULL,
    [BatchID]        INT            NOT NULL,
    [ClassDay]       NVARCHAR (MAX) NULL,
    [PeriodSequence] INT            NULL,
    [TimeSlot]       NVARCHAR (MAX) NULL,
    [CreatedBy]      NVARCHAR (MAX) NULL,
    [CreatedOn]      DATETIME       NULL
);

