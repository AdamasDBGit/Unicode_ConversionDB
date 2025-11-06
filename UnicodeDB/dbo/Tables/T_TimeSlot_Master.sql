CREATE TABLE [dbo].[T_TimeSlot_Master] (
    [I_TimeSlot_ID]     INT            IDENTITY (1, 1) NOT NULL,
    [S_TimeSlot_Code]   NVARCHAR (MAX) NULL,
    [Dt_StartTime]      DATETIME       NULL,
    [Dt_EndTime]        DATETIME       NULL,
    [S_Crtd_By]         NVARCHAR (MAX) NULL,
    [S_Upd_By]          NVARCHAR (MAX) NULL,
    [Dt_Crtd_On]        DATETIME       NULL,
    [Dt_Upd_On]         DATETIME       NULL,
    [Dt_BreakStartTime] DATETIME       NULL,
    [Dt_BreakEndTime]   DATETIME       NULL,
    [Dt_PeriodInterval] DATETIME       NULL,
    CONSTRAINT [PK_T_TimeSlot_Master] PRIMARY KEY CLUSTERED ([I_TimeSlot_ID] ASC)
);

