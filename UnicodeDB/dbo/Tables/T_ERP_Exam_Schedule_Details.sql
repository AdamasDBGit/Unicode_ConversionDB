CREATE TABLE [dbo].[T_ERP_Exam_Schedule_Details] (
    [I_ScheduleDetail_ID]         BIGINT   IDENTITY (1, 1) NOT NULL,
    [R_I_Result_Exam_Schedule_ID] INT      NULL,
    [Dt_Exam_Start_Date]          DATE     NULL,
    [Dt_Exam_End_Date]            DATE     NULL,
    [R_I_Slot_ID]                 INT      NULL,
    [I_Exam_Comp_Header_ID]       INT      NULL,
    [I_Exam_Comp_Map_ID]          INT      NULL,
    [I_Faculty_Master_ID]         INT      NULL,
    [Dtt_Created_At]              DATETIME CONSTRAINT [DF__T_ERP_Exa__Dtt_C__49C5BF2F] DEFAULT (getdate()) NULL,
    [Dtt_Modified_At]             DATETIME NULL,
    [I_Created_By]                INT      NULL,
    [I_Modified_By]               INT      NULL,
    [Is_Active]                   BIT      CONSTRAINT [DF__T_ERP_Exa__Is_Ac__4AB9E368] DEFAULT ((1)) NULL,
    CONSTRAINT [PK__T_ERP_Ex__4B1E0E8842DC4392] PRIMARY KEY CLUSTERED ([I_ScheduleDetail_ID] ASC)
);

