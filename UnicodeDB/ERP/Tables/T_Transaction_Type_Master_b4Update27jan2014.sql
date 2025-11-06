CREATE TABLE [ERP].[T_Transaction_Type_Master_b4Update27jan2014] (
    [I_Transaction_Type_ID]   INT           NOT NULL,
    [I_Fee_Component_ID]      INT           NULL,
    [I_Tax_ID]                INT           NULL,
    [I_Transaction_Nature_ID] INT           NOT NULL,
    [S_Transaction_Code]      VARCHAR (100) NULL,
    [S_Transaction_Type]      VARCHAR (250) NULL,
    [I_Status]                INT           NOT NULL,
    [I_Brand_ID]              INT           NULL,
    [I_Status_ID]             INT           NULL,
    [I_Payment_Mode_ID]       INT           NULL
);

