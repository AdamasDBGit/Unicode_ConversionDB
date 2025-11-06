CREATE TABLE [HangFire].[Job] (
    [Id]             BIGINT         IDENTITY (1, 1) NOT NULL,
    [StateId]        BIGINT         NULL,
    [StateName]      NVARCHAR (20)  NULL,
    [InvocationData] NVARCHAR (MAX) NOT NULL,
    [Arguments]      NVARCHAR (MAX) NOT NULL,
    [CreatedAt]      DATETIME       NOT NULL,
    [ExpireAt]       DATETIME       NULL,
    CONSTRAINT [PK_HangFire_Job] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_Hangfire_Job_ExpireAt]
    ON [HangFire].[Job]([ExpireAt] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Hangfire_Job_StateName]
    ON [HangFire].[Job]([StateName] ASC);

