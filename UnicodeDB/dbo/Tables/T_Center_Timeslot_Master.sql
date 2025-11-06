CREATE TABLE [dbo].[T_Center_Timeslot_Master] (
    [I_TimeSlot_ID] INT            IDENTITY (1, 1) NOT NULL,
    [I_Brand_ID]    INT            NOT NULL,
    [I_Center_ID]   INT            NOT NULL,
    [Dt_Start_Time] DATETIME       NOT NULL,
    [Dt_End_Time]   DATETIME       NOT NULL,
    [I_Status]      INT            NOT NULL,
    [S_Crtd_By]     NVARCHAR (MAX) NOT NULL,
    [Dt_Crtd_On]    DATETIME       NOT NULL,
    [S_Updt_By]     NVARCHAR (MAX) NULL,
    [Dt_Updt_On]    DATETIME       NULL,
    CONSTRAINT [PK_T_Center_Timeslot_Master] PRIMARY KEY CLUSTERED ([I_TimeSlot_ID] ASC)
);

