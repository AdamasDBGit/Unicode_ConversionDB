CREATE TABLE [dbo].[T_ERP_Hostel_Block_Details] (
    [inBlockId]     INT              IDENTITY (1, 1) NOT NULL,
    [unBlockId]     UNIQUEIDENTIFIER DEFAULT (newid()) NULL,
    [inHostelId]    INT              NOT NULL,
    [stBlockName]   NVARCHAR (100)   NOT NULL,
    [inNoofFloor]   INT              NULL,
    [flgIsActive]   BIT              DEFAULT ((0)) NULL,
    [inCreatedBy]   INT              NOT NULL,
    [dtCreatedDate] DATETIME         NULL,
    PRIMARY KEY CLUSTERED ([inBlockId] ASC)
);

