CREATE TABLE [ECOMMERCE].[T_Plan_Brand_Map] (
    [PlanBrandMapID] INT IDENTITY (1, 1) NOT NULL,
    [PlanID]         INT NULL,
    [BrandID]        INT NULL,
    [StatusID]       INT NULL,
    CONSTRAINT [PK__T_Plan_B__ABA77091D82F3CD0] PRIMARY KEY CLUSTERED ([PlanBrandMapID] ASC)
);

