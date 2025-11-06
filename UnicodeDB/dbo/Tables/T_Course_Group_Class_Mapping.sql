CREATE TABLE [dbo].[T_Course_Group_Class_Mapping] (
    [I_Course_Group_Class_ID] INT      IDENTITY (1, 1) NOT NULL,
    [I_Course_ID]             INT      NULL,
    [I_Brand_ID]              INT      NULL,
    [I_Class_ID]              INT      NULL,
    [Dt_Create_Dt]            DATETIME NULL,
    [I_School_Session_ID]     INT      NULL,
    [I_Stream_ID]             INT      NULL,
    [I_Batch_ID]              INT      NULL
);

