CREATE TABLE [ECOMMERCE].[T_Plan_Product_Map] (
    [PlanProductID] INT IDENTITY (1, 1) NOT NULL,
    [PlanID]        INT NOT NULL,
    [ProductID]     INT NOT NULL,
    [StatusID]      INT NULL
);

