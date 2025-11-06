CREATE TABLE [ECOMMERCE].[T_Product_ExamCategory_Map] (
    [Product_ExamCategory_ID] INT IDENTITY (1, 1) NOT NULL,
    [ProductID]               INT NOT NULL,
    [ExamCategoryID]          INT NOT NULL,
    [StatusID]                INT NULL
);

