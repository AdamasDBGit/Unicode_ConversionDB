CREATE TABLE [dbo].[T_Financial_Data_API] (
    [ID]              INT            IDENTITY (1, 1) NOT NULL,
    [I_Brand_ID]      INT            NULL,
    [S_Brand_Name]    NVARCHAR (MAX) NULL,
    [FinancialRange]  NVARCHAR (MAX) NULL,
    [Enrolment]       INT            NULL,
    [ProspectusSale]  INT            NULL,
    [FreshCollection] INT            NULL,
    [MTFCollection]   INT            NULL,
    [Enquiry]         INT            NULL,
    [TotalCollection] INT            NULL,
    [LastUpdatedOn]   DATETIME       NULL
);

