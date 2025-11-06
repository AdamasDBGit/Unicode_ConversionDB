CREATE TABLE [dbo].[T_Event_Class] (
    [I_Event_Class_ID]  INT      IDENTITY (1, 1) NOT NULL,
    [I_Event_ID]        INT      NULL,
    [I_School_Group_ID] INT      NULL,
    [I_Class_ID]        INT      NULL,
    [Is_Active]         BIT      NULL,
    [dt_Modified_dt]    DATETIME NULL
);

