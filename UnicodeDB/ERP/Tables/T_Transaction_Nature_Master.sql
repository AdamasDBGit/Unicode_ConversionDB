CREATE TABLE [ERP].[T_Transaction_Nature_Master] (
    [I_Transaction_Nature_ID] INT          NOT NULL,
    [S_Nature_Of_Transaction] VARCHAR (50) NOT NULL,
    [I_Status]                INT          NOT NULL,
    CONSTRAINT [PK_T_Transaction_Nature_Master] PRIMARY KEY CLUSTERED ([I_Transaction_Nature_ID] ASC)
);

