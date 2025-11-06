CREATE TABLE [dbo].[T_Center_TimeSlot] (
    [I_TimeSlot_ID]   INT            IDENTITY (1, 1) NOT NULL,
    [I_Centre_Id]     INT            NULL,
    [S_TimeSlot_Code] NVARCHAR (MAX) NULL,
    [S_TimeSlot_Desc] NVARCHAR (MAX) NULL,
    [I_Status]        INT            NULL,
    [S_Crtd_By]       NVARCHAR (MAX) NULL,
    [S_Upd_By]        NVARCHAR (MAX) NULL,
    [Dt_Crtd_On]      DATETIME       NULL,
    [Dt_Upd_On]       DATETIME       NULL,
    CONSTRAINT [PK__T_Center_TimeSlo__75392FF8] PRIMARY KEY CLUSTERED ([I_TimeSlot_ID] ASC)
);

