CREATE TABLE [dbo].[T_ERP_Subject_Structure_Plan_Detail] (
    [I_Subject_Structure_Plan_Detail_ID] INT      IDENTITY (1, 1) NOT NULL,
    [I_Subject_Structure_Plan_ID]        INT      NOT NULL,
    [I_Subject_Structure_ID]             INT      NOT NULL,
    [I_CreatedBy]                        INT      NOT NULL,
    [Dt_CreatedAt]                       DATETIME NOT NULL
);

