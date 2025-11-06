CREATE TABLE [dbo].[T_ERP_Hostel_Bed] (
    [inBedId]       INT              IDENTITY (1, 1) NOT NULL,
    [unBedId]       UNIQUEIDENTIFIER DEFAULT (newid()) NULL,
    [inBedDetailId] INT              NULL,
    [inRoomId]      INT              NULL,
    [stBedNumber]   NVARCHAR (100)   NULL,
    [flgIsActive]   BIT              DEFAULT ((0)) NULL,
    [inCreatedBy]   INT              NOT NULL,
    [dtCreatedDate] DATETIME         NOT NULL,
    PRIMARY KEY CLUSTERED ([inBedId] ASC)
);

