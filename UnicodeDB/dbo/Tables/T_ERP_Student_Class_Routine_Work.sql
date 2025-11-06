CREATE TABLE [dbo].[T_ERP_Student_Class_Routine_Work] (
    [I_Student_Class_Routine_Work_ID] INT            IDENTITY (1, 1) NOT NULL,
    [I_Student_Class_Routine_ID]      INT            NOT NULL,
    [I_Faculty_Master_ID]             INT            NOT NULL,
    [Dt_Date]                         DATETIME       NULL,
    [S_CreatedBy]                     NCHAR (50)     NULL,
    [D_CreatedAt]                     DATETIME       NULL,
    [S_ClassWork]                     NVARCHAR (MAX) NOT NULL
);

