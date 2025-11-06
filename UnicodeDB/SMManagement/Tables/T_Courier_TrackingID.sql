CREATE TABLE [SMManagement].[T_Courier_TrackingID] (
    [ID]         INT           IDENTITY (1, 1) NOT NULL,
    [CourierID]  INT           NULL,
    [TrackingID] VARCHAR (MAX) NULL,
    [ValidFrom]  DATETIME      NULL,
    [ValidTo]    DATETIME      NULL,
    [StatusID]   INT           NULL
);

