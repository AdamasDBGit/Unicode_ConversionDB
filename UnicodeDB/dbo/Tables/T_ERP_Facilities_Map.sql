CREATE TABLE [dbo].[T_ERP_Facilities_Map] (
    [inFacilityMapId] INT              IDENTITY (1, 1) NOT NULL,
    [unFacilityMapId] UNIQUEIDENTIFIER DEFAULT (newid()) NULL,
    [inBlockId]       INT              NOT NULL,
    [inFacilityId]    INT              NOT NULL,
    [flgIsAvailable]  BIT              DEFAULT ((1)) NULL,
    [inCreatedBy]     INT              NOT NULL,
    [dtCreatedDate]   DATETIME         NULL,
    PRIMARY KEY CLUSTERED ([inFacilityMapId] ASC)
);

