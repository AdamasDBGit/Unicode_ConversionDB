CREATE TABLE [ECOMMERCE].[T_Registration_Language_Map] (
    [I_Regn_Lang_Details_ID] INT           IDENTITY (1, 1) NOT NULL,
    [RegID]                  INT           NOT NULL,
    [CustomerID]             VARCHAR (MAX) NOT NULL,
    [I_Language_ID]          INT           NOT NULL,
    [I_Language_Name]        VARCHAR (200) NOT NULL,
    PRIMARY KEY CLUSTERED ([I_Regn_Lang_Details_ID] ASC)
);

