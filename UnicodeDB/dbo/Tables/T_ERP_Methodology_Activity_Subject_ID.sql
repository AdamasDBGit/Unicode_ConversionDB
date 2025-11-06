CREATE TABLE [dbo].[T_ERP_Methodology_Activity_Subject_ID] (
    [I_Methodology_Activity_Subject_ID] INT      IDENTITY (1, 1) NOT NULL,
    [I_Subject_ID]                      INT      NOT NULL,
    [I_Methodology_Activity_ID]         INT      NOT NULL,
    [I_CreatedBy]                       INT      NOT NULL,
    [Dt_CreatedAt]                      DATETIME NOT NULL
);

