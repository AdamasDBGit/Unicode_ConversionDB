CREATE TABLE [ECOMMERCE].[T_FAQ_Header] (
    [FAQHeaderID] INT           IDENTITY (1, 1) NOT NULL,
    [FAQName]     VARCHAR (MAX) NULL,
    [StatusID]    INT           NULL,
    [CreatedOn]   DATETIME      NULL,
    [CreatedBy]   VARCHAR (MAX) NULL,
    [UpdatedOn]   DATETIME      NULL,
    [UpdatedBy]   VARCHAR (MAX) NULL,
    CONSTRAINT [PK__T_FAQ_He__538176047FA2D19E] PRIMARY KEY CLUSTERED ([FAQHeaderID] ASC)
);

