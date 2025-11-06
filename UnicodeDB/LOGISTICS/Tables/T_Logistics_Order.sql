CREATE TABLE [LOGISTICS].[T_Logistics_Order] (
    [I_Logistic_Order_ID]      INT             IDENTITY (1, 1) NOT NULL,
    [I_Center_ID]              INT             NULL,
    [Order_Date]               DATETIME        NULL,
    [I_Total_Amount]           INT             NULL,
    [S_Transportation_Mode]    VARCHAR (3)     NULL,
    [I_Packing_Charges]        NUMERIC (18, 2) NULL,
    [B_Packing_Waiver]         BIT             NULL,
    [I_Transportation_Charges] NUMERIC (18, 2) NULL,
    [B_Transportation_Waiver]  BIT             NULL,
    [B_Free_Item_Flag]         BIT             NULL,
    [S_Payment_Mode]           VARCHAR (50)    NULL,
    [B_Transferred_To_SAP]     INT             NULL,
    [I_Status_ID]              INT             NULL,
    [S_Crtd_By]                VARCHAR (20)    NULL,
    [S_Upd_By]                 VARCHAR (20)    NULL,
    [Dt_Crtd_On]               DATETIME        NULL,
    [Dt_Upd_On]                DATETIME        NULL
);

