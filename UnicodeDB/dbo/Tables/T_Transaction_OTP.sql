CREATE TABLE [dbo].[T_Transaction_OTP] (
    [I_Transaction_OTP_ID]        INT           IDENTITY (1, 1) NOT NULL,
    [S_Mobile_Number]             NVARCHAR (50) NULL,
    [I_OTP]                       INT           NULL,
    [I_Transaction_Device_Log_ID] INT           NULL,
    [S_Device]                    NVARCHAR (50) NULL,
    [Dt_CreatedAt]                DATETIME      NULL,
    [Dt_UpdatedAt]                DATETIME      NULL,
    [I_Status]                    INT           NULL,
    [I_Flag]                      INT           NULL
);

