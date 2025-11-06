CREATE TABLE [ECOMMERCE].[T_Plan_FAQ_Map] (
    [PlanFAQMapID] INT           IDENTITY (1, 1) NOT NULL,
    [PlanID]       INT           NULL,
    [FAQHeaderID]  INT           NULL,
    [StatusID]     INT           NULL,
    [CreatedOn]    DATETIME      NULL,
    [CreatedBy]    VARCHAR (MAX) NULL,
    CONSTRAINT [PK__T_Plan_F__D597AE95F299D7F7] PRIMARY KEY CLUSTERED ([PlanFAQMapID] ASC)
);

