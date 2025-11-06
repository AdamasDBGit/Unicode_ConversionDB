CREATE TABLE [dbo].[T_Student_Class_Section_Bak05042024] (
    [I_Student_Class_Section_ID] INT            IDENTITY (1, 1) NOT NULL,
    [I_Student_Detail_ID]        INT            NOT NULL,
    [S_Student_ID]               NVARCHAR (100) NULL,
    [I_Brand_ID]                 INT            NULL,
    [I_School_Session_ID]        NCHAR (10)     NOT NULL,
    [I_School_Group_Class_ID]    INT            NULL,
    [I_Section_ID]               INT            NULL,
    [I_Stream_ID]                INT            NULL,
    [I_Student_Type_ID]          INT            NULL,
    [S_Class_Roll_No]            NVARCHAR (50)  NULL,
    [I_Status]                   INT            NULL
);

