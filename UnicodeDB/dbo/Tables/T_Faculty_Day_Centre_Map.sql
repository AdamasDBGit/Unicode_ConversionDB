CREATE TABLE [dbo].[T_Faculty_Day_Centre_Map] (
    [ID]            INT            IDENTITY (1, 1) NOT NULL,
    [I_Employee_ID] INT            NOT NULL,
    [S_DayofWeek]   NVARCHAR (MAX) NULL,
    [I_Centre_ID]   INT            NULL,
    [S_TimeSlots]   NVARCHAR (MAX) NULL,
    [I_Status]      INT            NULL,
    [S_Crtd_By]     NVARCHAR (MAX) NULL,
    [Dt_Crtd_On]    DATETIME       NULL,
    [S_Upd_By]      NVARCHAR (MAX) NULL,
    [Dt_Upd_On]     DATETIME       NULL
);

