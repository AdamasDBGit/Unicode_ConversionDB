CREATE TABLE [dbo].[T_ERP_Attendance_Entry_Header] (
    [I_Attendance_Entry_Header_ID] INT      IDENTITY (1, 1) NOT NULL,
    [I_Student_Class_Routine_ID]   INT      NOT NULL,
    [I_Faculty_Master_ID]          INT      NOT NULL,
    [Dt_Date]                      DATETIME NOT NULL,
    [I_CreatedBy]                  INT      NOT NULL,
    [Dt_CreatedAt]                 DATETIME NULL
);

