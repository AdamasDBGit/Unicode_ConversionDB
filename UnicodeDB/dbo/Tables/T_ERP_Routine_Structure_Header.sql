CREATE TABLE [dbo].[T_ERP_Routine_Structure_Header] (
    [I_Routine_Structure_Header_ID] INT      IDENTITY (1, 1) NOT NULL,
    [I_School_Session_ID]           INT      NOT NULL,
    [I_School_Group_ID]             INT      NOT NULL,
    [I_Class_ID]                    INT      NOT NULL,
    [I_Stream_ID]                   INT      NULL,
    [I_Section_ID]                  INT      NULL,
    [I_Total_Periods]               INT      NULL,
    [T_Start_Slot]                  TIME (0) NULL,
    [T_Duration]                    TIME (0) NULL,
    [T_Period_Gap]                  TIME (0) NULL,
    [I_Break_Period_No]             INT      NULL,
    [T_Break_Period_Duration]       TIME (0) NULL,
    [I_No_Of_WeekDays]              INT      NULL,
    [I_CreatedAt]                   INT      NULL,
    [Dt_CreatedAt]                  DATETIME NULL,
    [I_FacultyClassTeacher]         INT      NULL
);

