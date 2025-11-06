CREATE TABLE [dbo].[T_ERP_Teacher_Time_Plan] (
    [I_Teacher_Time_Plan_ID]      INT            IDENTITY (1, 1) NOT NULL,
    [I_Student_Class_Routine_ID]  INT            NULL,
    [I_Subject_Structure_Plan_ID] INT            NULL,
    [Dt_Class_Date]               DATETIME       NULL,
    [Dt_Plan_Date]                DATETIME       NULL,
    [I_CreatedBy]                 NVARCHAR (MAX) NULL,
    [Dt_CreatedAt]                DATETIME       NULL
);

