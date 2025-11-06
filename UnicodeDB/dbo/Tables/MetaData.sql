CREATE TABLE [dbo].[MetaData] (
    [Name]          VARCHAR (100)    NOT NULL,
    [Description]   NVARCHAR (MAX)   NULL,
    [SelectCommand] NVARCHAR (MAX)   NOT NULL,
    [UpdateCommand] NVARCHAR (MAX)   NULL,
    [InsertCommand] NVARCHAR (MAX)   NULL,
    [DeleteCommand] NVARCHAR (MAX)   NULL,
    [RefreshPerDay] DECIMAL (15, 10) NULL,
    [IsActive]      BIT              NOT NULL,
    CONSTRAINT [PK_MetaData] PRIMARY KEY CLUSTERED ([Name] ASC)
);

