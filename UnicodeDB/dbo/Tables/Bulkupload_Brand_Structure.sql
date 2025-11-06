CREATE TABLE [dbo].[Bulkupload_Brand_Structure] (
    [Brand_Code] NVARCHAR (MAX) NULL,
    [Brand_Name] NVARCHAR (MAX) NULL,
    [CIN]        NVARCHAR (255) NULL,
    [PAN]        NVARCHAR (255) NULL,
    [State]      NVARCHAR (255) NULL,
    [City]       NVARCHAR (255) NULL,
    [Address]    NVARCHAR (MAX) NULL,
    [GST_No]     NVARCHAR (255) NULL,
    [SAC_Code]   NVARCHAR (255) NULL,
    [Location]   NVARCHAR (255) NULL,
    [ID]         INT            IDENTITY (1, 1) NOT NULL
);

