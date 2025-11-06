CREATE TABLE [dbo].[StateCity_Mig] (
    [State]         NVARCHAR (255) NULL,
    [State_Code]    FLOAT (53)     NULL,
    [District_Code] FLOAT (53)     NULL,
    [District Name] NVARCHAR (255) NULL,
    [Town_Code]     FLOAT (53)     NULL,
    [Town  Name]    NVARCHAR (255) NULL,
    [ID]            INT            IDENTITY (1, 1) NOT NULL
);

