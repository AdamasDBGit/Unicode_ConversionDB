CREATE TABLE [dbo].[T_School_Group_Class_Timing_bkp] (
    [I_School_Group_Class_Timing_ID] INT        IDENTITY (1, 1) NOT NULL,
    [I_School_Session_ID]            INT        NULL,
    [I_School_Group_ID]              INT        NULL,
    [I_Class_ID]                     INT        NULL,
    [Start_Time]                     TIME (0)   NULL,
    [End_Time]                       TIME (0)   NULL,
    [I_Status]                       INT        NULL,
    [Dt_CreatedBy]                   INT        NULL,
    [Dt_CreatedAt]                   DATETIME   NULL,
    [Dt_UpdatedBy]                   INT        NULL,
    [Dt_UpdatedAt]                   NCHAR (10) NULL
);

