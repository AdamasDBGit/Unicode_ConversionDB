CREATE TABLE [ECOMMERCE].[T_Product_Master] (
    [ProductID]        INT            IDENTITY (1, 1) NOT NULL,
    [ProductCode]      VARCHAR (MAX)  NOT NULL,
    [ProductName]      VARCHAR (MAX)  NOT NULL,
    [ProductShortDesc] NVARCHAR (MAX) NULL,
    [ProductLongDesc]  NVARCHAR (MAX) NULL,
    [CourseID]         INT            NOT NULL,
    [BrandID]          INT            NOT NULL,
    [CategoryID]       INT            NULL,
    [StatusID]         INT            NULL,
    [IsPublished]      BIT            NULL,
    [ValidFrom]        DATETIME       NULL,
    [ValidTo]          DATETIME       NULL,
    [CreatedBy]        VARCHAR (MAX)  NULL,
    [CreatedOn]        DATETIME       NULL,
    [UpdatedBy]        VARCHAR (MAX)  NULL,
    [UpdatedOn]        DATETIME       NULL,
    [ProductImage]     VARCHAR (MAX)  NULL,
    [I_Language_ID]    INT            NULL,
    [I_Language_Name]  VARCHAR (200)  NULL
);

