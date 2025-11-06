CREATE TABLE [dbo].[T_buzzedDB_Time_Slots] (
    [I_Slot_ID]     INT            NOT NULL,
    [I_Client_ID]   INT            NULL,
    [S_Slot_Title]  NVARCHAR (MAX) NULL,
    [Dt_Start_Time] TIME (0)       NULL,
    [Dt_End_Time]   TIME (0)       NULL
);

