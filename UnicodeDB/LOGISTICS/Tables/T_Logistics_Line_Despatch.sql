CREATE TABLE [LOGISTICS].[T_Logistics_Line_Despatch] (
    [I_Logistics_Line_Despatch_ID] INT             IDENTITY (1, 1) NOT NULL,
    [I_Logistic_Line_ID]           INT             NULL,
    [I_Logistics_Order_ID]         INT             NULL,
    [I_Despatch_ID]                INT             NULL,
    [I_Sl_No]                      INT             NULL,
    [I_Despatch_Qty]               NUMERIC (18, 2) NULL
);

