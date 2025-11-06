CREATE TABLE [dbo].[T_Section] (
    [I_Section_ID]           INT           IDENTITY (1, 1) NOT NULL,
    [S_Section_Name]         NVARCHAR (50) NOT NULL,
    [SeatCapacity]           INT           NULL,
    [Occupied_Seat]          INT           NULL,
    [Dt_LastSectionModified] DATETIME      NULL,
    [is_Default]             BIT           NULL,
    [I_Brand_ID]             INT           NULL
);

