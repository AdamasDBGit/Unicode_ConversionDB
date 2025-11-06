CREATE TABLE [ECOMMERCE].[T_FAQ_Details] (
    [FAQDetailID] INT           IDENTITY (1, 1) NOT NULL,
    [FAQHeaderID] INT           NULL,
    [Question]    VARCHAR (MAX) NULL,
    [Answer]      VARCHAR (MAX) NULL,
    [StatusID]    INT           NULL,
    CONSTRAINT [PK__T_FAQ_De__F93B75DFBF7E6B8F] PRIMARY KEY CLUSTERED ([FAQDetailID] ASC)
);

