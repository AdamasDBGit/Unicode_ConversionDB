CREATE TABLE [HangFire].[State] (
    [Id]        BIGINT         IDENTITY (1, 1) NOT NULL,
    [JobId]     BIGINT         NOT NULL,
    [Name]      NVARCHAR (20)  NOT NULL,
    [Reason]    NVARCHAR (100) NULL,
    [CreatedAt] DATETIME       NOT NULL,
    [Data]      NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_HangFire_State] PRIMARY KEY CLUSTERED ([JobId] ASC, [Id] ASC)
);

