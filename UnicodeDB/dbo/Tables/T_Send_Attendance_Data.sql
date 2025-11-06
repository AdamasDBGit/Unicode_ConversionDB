CREATE TABLE [dbo].[T_Send_Attendance_Data] (
    [id]            BIGINT         IDENTITY (1, 1) NOT NULL,
    [StdID]         NVARCHAR (MAX) NULL,
    [AttnDate]      NVARCHAR (MAX) NULL,
    [ArrivalTime]   NVARCHAR (MAX) NOT NULL,
    [DepartureTime] NVARCHAR (MAX) NULL,
    [Attendance]    NVARCHAR (MAX) NULL,
    [TrnNo]         INT            NULL,
    [Centercode]    NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_T_Send_Attendance_Data] PRIMARY KEY CLUSTERED ([id] ASC)
);

