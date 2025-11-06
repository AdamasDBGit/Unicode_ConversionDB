CREATE TYPE [dbo].[UT_EXAM_Schedule_Config] AS TABLE (
    [I_ScheduleDetail_ID]   BIGINT NULL,
    [Dt_Exam_Start_Date]    DATE   NULL,
    [Dt_Exam_End_Date]      DATE   NULL,
    [R_I_Slot_ID]           INT    NULL,
    [I_Exam_Comp_Header_ID] INT    NULL,
    [I_Exam_Comp_Map_ID]    INT    NOT NULL,
    [I_Faculty_Master_ID]   INT    NULL,
    [Is_Active_Details]     BIT    NULL);

