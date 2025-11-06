CREATE TABLE [dbo].[Emp] (
    [Id]         INT            IDENTITY (1, 1) NOT NULL,
    [name]       NVARCHAR (MAX) NULL,
    [Rollnumber] INT            NULL,
    [Is_Active]  BIT            NULL,
    [Dt]         DATE           NULL
);

