CREATE TABLE [dbo].[T_ERP_Subject_Structure_Plan_Execution_Remarks] (
    [I_Subject_Structure_Plan_Execution_Remarks_ID] INT            IDENTITY (1, 1) NOT NULL,
    [I_Teacher_Time_Plan_ID]                        INT            NULL,
    [I_Completion_Percentage]                       DECIMAL (4, 1) NULL,
    [Is_Completed]                                  BIT            NULL,
    [S_Remarks]                                     NVARCHAR (MAX) NULL,
    [S_Learning_Outcome_Achieved]                   NVARCHAR (MAX) NULL,
    [I_CreatedBy]                                   INT            NULL,
    [Dt_CreatedAt]                                  DATETIME       NULL,
    [Dt_ExecutedAt]                                 DATETIME       NULL,
    [I_UpdatedBy]                                   INT            NULL,
    [Dt_UpdatedAt]                                  DATETIME       NULL
);

