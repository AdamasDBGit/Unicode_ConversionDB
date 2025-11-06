CREATE TABLE [dbo].[T_Student_Attendance_deleted_28May2013] (
    [I_Attendance_Detail_ID] INT            IDENTITY (1, 1) NOT NULL,
    [I_Student_Detail_ID]    INT            NULL,
    [S_Crtd_By]              NVARCHAR (MAX) NULL,
    [Dt_Crtd_On]             DATETIME       NULL,
    [I_TimeTable_ID]         INT            NULL
);

