CREATE TABLE [dbo].[T_Student_Attendance] (
    [I_Attendance_Detail_ID] INT            IDENTITY (1, 1) NOT NULL,
    [I_Student_Detail_ID]    INT            NULL,
    [S_Crtd_By]              NVARCHAR (MAX) NULL,
    [Dt_Crtd_On]             DATETIME       NULL,
    [I_TimeTable_ID]         INT            NULL,
    CONSTRAINT [PK__T_Student_Attend__7CDA51C0] PRIMARY KEY CLUSTERED ([I_Attendance_Detail_ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [index_Student_ID_Attendance]
    ON [dbo].[T_Student_Attendance]([I_Student_Detail_ID] ASC);


GO
CREATE NONCLUSTERED INDEX [TimeTableIDStudentID]
    ON [dbo].[T_Student_Attendance]([I_TimeTable_ID] ASC)
    INCLUDE([I_Student_Detail_ID]);

