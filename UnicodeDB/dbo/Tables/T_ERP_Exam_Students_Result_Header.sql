CREATE TABLE [dbo].[T_ERP_Exam_Students_Result_Header] (
    [I_Exam_Result_Header_ID]   BIGINT   NULL,
    [I_Result_Exam_Schedule_ID] INT      NULL,
    [I_ScheduleDetail_ID]       INT      NULL,
    [I_School_Group_id]         INT      NULL,
    [I_Class_ID]                INT      NULL,
    [I_Exam_Comp_Header_ID]     INT      NULL,
    [Is_Active]                 BIT      CONSTRAINT [DF__T_ERP_Exa__Is_Ac__59FC26F8] DEFAULT ((1)) NULL,
    [Dt_Created_At]             DATETIME CONSTRAINT [DF__T_ERP_Exa__Dt_Cr__5AF04B31] DEFAULT (getdate()) NULL,
    [Dt_Modified_At]            DATETIME NULL,
    [I_Created_By]              INT      NULL,
    [I_Modified_By]             INT      NULL
);

