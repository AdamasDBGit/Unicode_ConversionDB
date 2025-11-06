CREATE TABLE [dbo].[T_ERP_Hostel_BedDetails] (
    [inBedDetailId]  INT              IDENTITY (1, 1) NOT NULL,
    [unBedDetailId]  UNIQUEIDENTIFIER DEFAULT (newid()) NULL,
    [inHostelId]     INT              NULL,
    [inBlockId]      INT              NULL,
    [inFloorId]      INT              NULL,
    [inRoomId]       INT              NULL,
    [inRoomTypeId]   INT              NULL,
    [stRoomType]     NVARCHAR (100)   NULL,
    [inRoomCategory] INT              NULL,
    [stRoomCategory] NVARCHAR (100)   NULL,
    [flgIsActive]    BIT              DEFAULT ((0)) NULL,
    [inCreatedBy]    INT              NOT NULL,
    [dtCreatedDate]  DATETIME         NOT NULL,
    PRIMARY KEY CLUSTERED ([inBedDetailId] ASC)
);

