CREATE TABLE [dbo].[CacheObject] (
    [Name]         VARCHAR (50)   NOT NULL,
    [Description]  NVARCHAR (MAX) NULL,
    [ClassName]    NVARCHAR (MAX) NULL,
    [ExpiresIn]    DECIMAL (18)   NULL,
    [UtilizeCache] BIT            NULL,
    [CacheKey]     NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_CacheObject] PRIMARY KEY CLUSTERED ([Name] ASC)
);

