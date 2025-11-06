CREATE TABLE [dbo].[T_ERP_Class_Section] (
    [I_Class_Section_ID]  INT IDENTITY (1, 1) NOT NULL,
    [I_School_Session_ID] INT NOT NULL,
    [I_School_Group_ID]   INT NOT NULL,
    [I_Class_ID]          INT NOT NULL,
    [I_Stream_ID]         INT NULL,
    [I_Section_ID]        INT NULL
);

