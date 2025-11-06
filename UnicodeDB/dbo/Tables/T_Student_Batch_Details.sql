CREATE TABLE [dbo].[T_Student_Batch_Details] (
    [I_Student_Batch_ID]       INT      IDENTITY (1, 1) NOT NULL,
    [I_Student_ID]             INT      NULL,
    [I_Batch_ID]               INT      NULL,
    [I_Status]                 INT      NULL,
    [I_Student_Certificate_ID] INT      NULL,
    [I_Total_Attendance_Count] INT      NULL,
    [Dt_Valid_From]            DATETIME NULL,
    [Dt_Valid_To]              DATETIME NULL,
    [C_Is_LumpSum]             CHAR (1) NULL,
    [I_ToBatch_ID]             INT      NULL,
    [I_FromBatch_ID]           INT      NULL,
    [I_RollNo]                 INT      NULL,
    [I_School_Group_ID]        INT      NULL,
    [I_Class_ID]               INT      NULL,
    [I_Stream_ID]              INT      NULL,
    [I_Section_ID]             INT      NULL,
    [StudentClassStartDate]    DATETIME NULL,
    CONSTRAINT [PK_T_Student_Batch_Details] PRIMARY KEY CLUSTERED ([I_Student_Batch_ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [dailyacademicreport]
    ON [dbo].[T_Student_Batch_Details]([I_Status] ASC)
    INCLUDE([I_Student_ID], [I_Batch_ID]);


GO
CREATE NONCLUSTERED INDEX [Idx_I_Student_ID_I_Status]
    ON [dbo].[T_Student_Batch_Details]([I_Student_ID] ASC, [I_Status] ASC)
    INCLUDE([I_Batch_ID]);

