CREATE TABLE [dbo].[T_Paymet_Transaction_Status] (
    [I_Paymet_Transaction_Status_ID] INT      IDENTITY (1, 1) NOT NULL,
    [I_FeeScheduleID]                INT      NOT NULL,
    [I_Payment_Status]               INT      NULL,
    [Dt_CreatedAt]                   DATETIME NULL,
    [Dt_UpdatedAt]                   DATETIME NULL
);

