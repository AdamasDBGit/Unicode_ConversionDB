CREATE TABLE [dbo].[T_ERP_Facilities] (
    [inFacilityId]   INT              IDENTITY (1, 1) NOT NULL,
    [unFacilityId]   UNIQUEIDENTIFIER DEFAULT (newid()) NULL,
    [stFacilityName] NVARCHAR (100)   NOT NULL,
    [stDescription]  NVARCHAR (500)   NULL,
    [flgIsActive]    BIT              DEFAULT ((1)) NULL,
    [inCreatedBy]    INT              NOT NULL,
    [dtCreatedDate]  DATETIME         DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([inFacilityId] ASC)
);

