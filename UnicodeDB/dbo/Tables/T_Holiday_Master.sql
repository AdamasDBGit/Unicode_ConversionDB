CREATE TABLE [dbo].[T_Holiday_Master] (
    [I_Holiday_ID]          INT            IDENTITY (1, 1) NOT NULL,
    [I_Center_ID]           INT            NULL,
    [Dt_Holiday_Date]       DATETIME       NOT NULL,
    [S_Holiday_Description] NVARCHAR (MAX) NOT NULL,
    [I_Brand_ID]            INT            NULL,
    CONSTRAINT [PK_T_Holiday_Master] PRIMARY KEY CLUSTERED ([I_Holiday_ID] ASC)
);

