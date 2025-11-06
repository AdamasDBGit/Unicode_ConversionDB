CREATE TABLE [dbo].[T_School_Group_Class_bkp] (
    [I_School_Group_Class_ID] INT  IDENTITY (1, 1) NOT NULL,
    [I_School_Group_ID]       INT  NOT NULL,
    [I_Class_ID]              INT  NOT NULL,
    [Dt_StartedAt]            DATE NULL,
    [I_Status]                INT  NOT NULL
);

