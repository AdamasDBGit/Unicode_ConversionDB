CREATE TABLE [LMS].[T_AboutBrand] (
    [ID]              INT           IDENTITY (1, 1) NOT NULL,
    [Title]           VARCHAR (MAX) NULL,
    [Description]     VARCHAR (MAX) NULL,
    [BannerImage]     VARCHAR (MAX) NULL,
    [VideoLink]       VARCHAR (MAX) NULL,
    [ToBeDisplayedIn] VARCHAR (MAX) NULL,
    [StatusID]        INT           NULL,
    [BrandID]         INT           NULL,
    [CreatedOn]       DATETIME      NULL,
    [CreatedBy]       VARCHAR (MAX) NULL,
    [UpdatedOn]       DATETIME      NULL,
    [UpdatedBy]       VARCHAR (MAX) NULL,
    CONSTRAINT [PK__T_AboutB__3214EC2783A04B12] PRIMARY KEY CLUSTERED ([ID] ASC)
);

