CREATE TYPE [dbo].[UT_Drop] AS TABLE (
    [I_Teacher_Time_Plan_ID]        INT           NULL,
    [I_Student_Class_Routine_ID]    INT           NOT NULL,
    [I_Subject_ID]                  INT           NOT NULL,
    [I_Subject_Structure_Plan_ID]   INT           NOT NULL,
    [I_Completion_Percentage]       INT           NOT NULL,
    [I_Total_Completion_Percentage] INT           NOT NULL,
    [Is_Completed]                  BIT           NULL,
    [Dt_Class_Date]                 DATETIME      NOT NULL,
    [I_Faculty_ID]                  INT           NULL,
    [I_User_ID]                     INT           NULL,
    [sToken]                        VARCHAR (MAX) NULL);

