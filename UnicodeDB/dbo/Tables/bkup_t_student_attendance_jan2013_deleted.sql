CREATE TABLE [dbo].[bkup_t_student_attendance_jan2013_deleted] (
    [I_Attendance_Detail_ID] INT            IDENTITY (1, 1) NOT NULL,
    [I_Student_Detail_ID]    INT            NULL,
    [S_Crtd_By]              NVARCHAR (MAX) NULL,
    [Dt_Crtd_On]             DATETIME       NULL,
    [I_TimeTable_ID]         INT            NULL
);

