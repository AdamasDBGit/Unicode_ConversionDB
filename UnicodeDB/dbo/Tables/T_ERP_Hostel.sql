CREATE TABLE [dbo].[T_ERP_Hostel] (
    [inHostelId]            INT              IDENTITY (1, 1) NOT NULL,
    [unHostelId]            UNIQUEIDENTIFIER DEFAULT (newid()) NULL,
    [stHostelCode]          NVARCHAR (50)    NULL,
    [stHostelName]          NVARCHAR (100)   NULL,
    [inHostelType]          INT              NULL,
    [stAddress]             NVARCHAR (500)   NULL,
    [inWardenUserId]        INT              NULL,
    [stHostelContactNumber] NVARCHAR (20)    NULL,
    [inNoofBlockBuildings]  INT              NULL,
    [flgIsActive]           BIT              DEFAULT ((0)) NULL,
    [inCreatedBy]           INT              NOT NULL,
    [dtCreatedDate]         DATETIME         NULL,
    [inBrandId]             INT              NULL,
    PRIMARY KEY CLUSTERED ([inHostelId] ASC)
);

