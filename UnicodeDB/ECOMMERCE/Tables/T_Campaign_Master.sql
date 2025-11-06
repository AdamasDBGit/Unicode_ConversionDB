CREATE TABLE [ECOMMERCE].[T_Campaign_Master] (
    [CampaignID]   INT           IDENTITY (1, 1) NOT NULL,
    [CampaignName] VARCHAR (MAX) NULL,
    [CampaignDesc] VARCHAR (MAX) NULL,
    [StatusID]     INT           CONSTRAINT [DF__T_Campaig__Statu__527A356A] DEFAULT ((1)) NULL,
    [ValidFrom]    DATETIME      NULL,
    [ValidTo]      DATETIME      NULL,
    [CreatedOn]    DATETIME      NULL,
    [CreatedBy]    VARCHAR (MAX) NULL,
    [UpdatedOn]    DATETIME      NULL,
    [UpdatedBy]    VARCHAR (MAX) NULL,
    CONSTRAINT [PK__T_Campai__3F5E8D79C836B136] PRIMARY KEY CLUSTERED ([CampaignID] ASC)
);

