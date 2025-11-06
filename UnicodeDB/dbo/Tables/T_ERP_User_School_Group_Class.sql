CREATE TABLE [dbo].[T_ERP_User_School_Group_Class] (
    [I_User_School_Group_Class_ID] INT IDENTITY (1, 1) NOT NULL,
    [I_User_ID]                    INT NOT NULL,
    [I_Brand_ID]                   INT NULL,
    [I_School_Group_ID]            INT NOT NULL,
    [I_Class_ID]                   INT NOT NULL,
    [I_Stream_ID]                  INT NULL,
    [I_Section_ID]                 INT NULL
);

