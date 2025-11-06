CREATE TABLE [dbo].[T_Device_Details] (
    [I_Device_Details_ID] INT           IDENTITY (1, 1) NOT NULL,
    [S_Device_Name]       NVARCHAR (50) NOT NULL,
    [S_Version]           NVARCHAR (50) NULL,
    [S_VersionCode]       NVARCHAR (50) NULL,
    [I_IsForsce]          BIT           NULL,
    [I_IsForceLogOut]     BIT           NULL
);

