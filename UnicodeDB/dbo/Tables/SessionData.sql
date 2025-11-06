CREATE TABLE [dbo].[SessionData] (
    [Id]                         NVARCHAR (449)     NOT NULL,
    [Value]                      VARBINARY (MAX)    NOT NULL,
    [ExpiresAtTime]              DATETIMEOFFSET (7) NOT NULL,
    [SlidingExpirationInSeconds] BIGINT             NULL,
    [AbsoluteExpiration]         DATETIMEOFFSET (7) NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_SessionData_ExpiresAtTime]
    ON [dbo].[SessionData]([ExpiresAtTime] ASC);

