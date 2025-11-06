CREATE TABLE [dbo].[T_Send_Attendance_Data_Audit] (
    [ID]            INT            IDENTITY (1, 1) NOT NULL,
    [StdID]         NVARCHAR (MAX) NULL,
    [AttnDate]      NVARCHAR (MAX) NULL,
    [ArrivalTime]   NVARCHAR (MAX) NULL,
    [DepartureTime] NVARCHAR (MAX) NULL,
    [Attendance]    NVARCHAR (MAX) NULL,
    [TrnNo]         INT            NULL,
    [Centercode]    NVARCHAR (MAX) NULL
);

