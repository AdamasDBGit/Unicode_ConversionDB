CREATE TABLE [dbo].[T_Temp_Attdn_Table] (
    [StdID]         NVARCHAR (21)  NULL,
    [AttnDate]      DATETIME       NULL,
    [ArrivalTime]   DATETIME       NULL,
    [DepartureTime] DATETIME       NULL,
    [Attendance]    NVARCHAR (10)  NULL,
    [TrnNo]         INT            NULL,
    [centercode]    NVARCHAR (MAX) NOT NULL
);

