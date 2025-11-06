CREATE TABLE [dbo].[T_ERP_Hostel_Room] (
    [inRoomId]       INT              IDENTITY (1, 1) NOT NULL,
    [unRoomId]       UNIQUEIDENTIFIER DEFAULT (newid()) NULL,
    [inHostelId]     INT              NULL,
    [inBlockId]      INT              NULL,
    [inFloorId]      INT              NULL,
    [inRoomTypeId]   INT              NULL,
    [inRoomCategory] INT              NULL,
    [inRoomNumber]   INT              NULL,
    [flgIsActive]    BIT              DEFAULT ((0)) NULL,
    [inCreatedBy]    INT              NOT NULL,
    [dtCreatedDate]  DATETIME         NOT NULL,
    PRIMARY KEY CLUSTERED ([inRoomId] ASC)
);

