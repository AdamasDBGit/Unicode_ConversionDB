CREATE TABLE [dbo].[T_ERP_Methodology_Activity] (
    [I_Methodology_Activity_ID]          INT            IDENTITY (1, 1) NOT NULL,
    [I_Methodology_Category_ID]          INT            NOT NULL,
    [S_Methodology_Activity_Name]        NVARCHAR (MAX) NOT NULL,
    [S_Methodology_Activity_Description] NVARCHAR (MAX) NULL,
    [S_Measure_Unit]                     NVARCHAR (50)  NOT NULL,
    [I_CreatedBy]                        INT            NOT NULL,
    [Dt_CreatedAt]                       DATETIME       NOT NULL,
    [I_Status]                           INT            NOT NULL
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Text/Percentage/Multi Choice/Single Choice/ Time/Assignment', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'T_ERP_Methodology_Activity', @level2type = N'COLUMN', @level2name = N'S_Measure_Unit';

