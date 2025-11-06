CREATE TABLE [dbo].[T_ERP_Attendance_Entry_Detail] (
    [I_Attendance_Entry_Detail_ID] INT      IDENTITY (1, 1) NOT NULL,
    [I_Attendance_Entry_Header_ID] INT      NOT NULL,
    [I_Student_Detail_ID]          INT      NOT NULL,
    [I_IsPresent]                  INT      CONSTRAINT [DF_T_ERP_I_Attendance_Entry_Detail_I_IsPresent] DEFAULT ((1)) NULL,
    [Dt_CreatedAt]                 DATETIME NULL,
    [Dt_UpdatedAt]                 DATETIME NULL,
    [I_CreatedBy]                  INT      NULL,
    [I_UpdatedBy]                  INT      NULL
);

