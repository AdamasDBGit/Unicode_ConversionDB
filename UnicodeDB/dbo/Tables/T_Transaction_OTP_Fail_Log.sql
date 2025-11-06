CREATE TABLE [dbo].[T_Transaction_OTP_Fail_Log] (
    [I_Transaction_OTP_Fail_ID]   INT           IDENTITY (1, 1) NOT NULL,
    [I_Transaction_Device_Log_ID] INT           NULL,
    [S_Mobile_Number]             NVARCHAR (50) NULL,
    [I_OTP]                       INT           NULL,
    [I_Given_Wrong_OTP]           INT           NULL,
    [Dt_CreatedAt]                DATETIME      NULL,
    [Dt_UpdatedAt]                DATETIME      NULL,
    [I_Status]                    INT           NULL
);

