CREATE TABLE [dbo].[T_ERP_BusMaster] (
    [I_Bus_ID]             INT           IDENTITY (1, 1) NOT NULL,
    [I_Brand_ID]           INT           NOT NULL,
    [S_Bus_Number]         NVARCHAR (50) NULL,
    [I_Total_Seat]         INT           NULL,
    [S_Tracking_Device_ID] NVARCHAR (50) NULL,
    [Dt_CreatedAt]         DATETIME      CONSTRAINT [DF_T_ERP_BusMaster_CreatedAt] DEFAULT (getdate()) NOT NULL,
    [Dt_UpdatedAt]         DATETIME      NULL,
    [I_Flag]               TINYINT       CONSTRAINT [DF_T_ERP_BusMaster_Flag] DEFAULT ((0)) NOT NULL,
    PRIMARY KEY CLUSTERED ([I_Bus_ID] ASC)
);

