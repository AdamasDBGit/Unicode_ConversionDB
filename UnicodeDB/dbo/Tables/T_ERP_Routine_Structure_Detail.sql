CREATE TABLE [dbo].[T_ERP_Routine_Structure_Detail] (
    [I_Routine_Structure_Detail_ID] INT      IDENTITY (1, 1) NOT NULL,
    [I_Routine_Structure_Header_ID] INT      NOT NULL,
    [I_Period_No]                   INT      NOT NULL,
    [T_FromSlot]                    TIME (0) NULL,
    [T_ToSlot]                      TIME (0) NULL,
    [I_Day_ID]                      INT      NULL,
    [I_Is_Break]                    INT      NULL,
    [I_CreatedBy]                   INT      NULL,
    [Dt_CreatedAt]                  DATETIME NULL
);

