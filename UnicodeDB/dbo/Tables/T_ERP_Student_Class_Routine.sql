CREATE TABLE [dbo].[T_ERP_Student_Class_Routine] (
    [I_Student_Class_Routine_ID]    INT            IDENTITY (1, 1) NOT NULL,
    [I_Routine_Structure_Detail_ID] INT            NOT NULL,
    [I_Faculty_Master_ID]           INT            NOT NULL,
    [I_Subject_ID]                  INT            NOT NULL,
    [I_CreatedBy]                   INT            NULL,
    [Dt_CreatedAt]                  DATETIME       NULL,
    [S_Class_Type]                  NVARCHAR (MAX) NULL,
    [SubjectGroupID]                INT            NULL
);

