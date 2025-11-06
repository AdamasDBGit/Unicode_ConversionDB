CREATE TABLE [dbo].[T_ERP_Subject_Structure_Plan] (
    [I_Subject_Structure_Plan_ID] INT      IDENTITY (1, 1) NOT NULL,
    [I_School_Session_ID]         INT      NULL,
    [I_Subject_ID]                INT      NOT NULL,
    [I_Month_No]                  INT      NOT NULL,
    [I_Day_No]                    INT      NOT NULL,
    [I_CreatedBy]                 INT      NOT NULL,
    [Dt_CreatedAt]                DATETIME NOT NULL
);

