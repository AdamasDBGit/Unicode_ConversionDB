CREATE TABLE [dbo].[T_ERP_Hostel_Warden] (
    [inWardenId]       INT              IDENTITY (1, 1) NOT NULL,
    [unWardenId]       UNIQUEIDENTIFIER DEFAULT (newid()) NULL,
    [inUserId]         INT              NULL,
    [flgIsChiefWarden] BIT              DEFAULT ((0)) NULL,
    [flgIsStatus]      BIT              DEFAULT ((1)) NULL,
    [inCreatedBy]      INT              NOT NULL,
    [dtCreatedDate]    DATETIME         NULL,
    [inBrandId]        INT              NULL,
    PRIMARY KEY CLUSTERED ([inWardenId] ASC)
);

