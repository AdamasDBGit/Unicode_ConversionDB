CREATE TABLE [ECOMMERCE].[T_Plan_Config] (
    [PlanConfigID]      INT           IDENTITY (1, 1) NOT NULL,
    [PlanID]            INT           NOT NULL,
    [ConfigID]          INT           NOT NULL,
    [ConfigValue]       VARCHAR (MAX) NULL,
    [ConfigDisplayName] VARCHAR (MAX) NULL,
    [StatusID]          INT           NULL
);

