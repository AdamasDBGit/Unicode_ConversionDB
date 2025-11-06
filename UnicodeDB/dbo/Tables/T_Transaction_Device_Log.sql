CREATE TABLE [dbo].[T_Transaction_Device_Log] (
    [I_Transaction_Device_Log_ID] INT           IDENTITY (1, 1) NOT NULL,
    [S_Mobile_Number]             NVARCHAR (50) NOT NULL,
    [I_IsPhoneBlock]              INT           NULL,
    [S_Device]                    NVARCHAR (50) NULL,
    [I_IsDeviceBlock]             INT           NULL,
    [Dt_BlockedAt]                DATETIME      NULL,
    [S_CreatedAt]                 NVARCHAR (50) NULL
);

