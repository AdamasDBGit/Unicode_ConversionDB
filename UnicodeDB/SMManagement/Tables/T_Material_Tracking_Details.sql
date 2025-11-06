CREATE TABLE [SMManagement].[T_Material_Tracking_Details] (
    [ID]                      INT           IDENTITY (1, 1) NOT NULL,
    [DispatchHeaderID]        INT           NULL,
    [StudentDispatchHeaderID] INT           NULL,
    [StudentDetailID]         INT           NULL,
    [CourierTrackingID]       INT           NULL,
    [StatusCode]              VARCHAR (20)  NULL,
    [StatusDescription]       VARCHAR (MAX) NULL,
    [CreatedOn]               DATETIME      NULL
);

