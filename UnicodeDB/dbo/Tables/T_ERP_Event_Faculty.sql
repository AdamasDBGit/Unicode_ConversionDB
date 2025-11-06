CREATE TABLE [dbo].[T_ERP_Event_Faculty] (
    [I_Event_Faculty_ID]  INT      IDENTITY (1, 1) NOT NULL,
    [I_Event_ID]          INT      NULL,
    [I_Faculty_Master_ID] INT      NULL,
    [Is_Active]           BIT      NULL,
    [dt_Modified_dt]      DATETIME NULL
);

