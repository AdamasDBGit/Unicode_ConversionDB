CREATE TABLE [dbo].[T_ERP_Valid_Transaction_Source_Master] (
    [Transaction_Source_ID]   INT            IDENTITY (1, 1) NOT NULL,
    [Transaction_Source_Name] NVARCHAR (MAX) NULL,
    [Is_Active]               BIT            NULL,
    [Dt_CreatedOn]            DATETIME       NULL
);

