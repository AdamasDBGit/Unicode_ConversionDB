CREATE TABLE [dbo].[T_ERP_Hostel_Block_Floor_Details] (
    [inFloorId]               INT              IDENTITY (1, 1) NOT NULL,
    [unFloorId]               UNIQUEIDENTIFIER DEFAULT (newid()) NULL,
    [inHostelId]              INT              NOT NULL,
    [inBlockId]               INT              NOT NULL,
    [stFloorName]             NVARCHAR (100)   NOT NULL,
    [inRoomCapacity]          INT              NULL,
    [inStudentIntakeCapacity] INT              NULL,
    [flgIsActive]             BIT              DEFAULT ((0)) NULL,
    [inCreatedBy]             INT              NOT NULL,
    [dtCreatedDate]           DATETIME         NULL,
    PRIMARY KEY CLUSTERED ([inFloorId] ASC)
);

