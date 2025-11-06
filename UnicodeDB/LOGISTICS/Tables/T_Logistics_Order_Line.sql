CREATE TABLE [LOGISTICS].[T_Logistics_Order_Line] (
    [I_Logistic_Line_ID]   INT          IDENTITY (1, 1) NOT NULL,
    [I_Logistics_Order_ID] INT          NULL,
    [I_Logistics_ID]       INT          NULL,
    [I_Sl_No]              INT          NULL,
    [I_Item_Qty]           FLOAT (53)   NULL,
    [I_Item_Amount]        FLOAT (53)   NULL,
    [S_Crtd_By]            VARCHAR (20) NULL,
    [S_Upd_By]             VARCHAR (20) NULL,
    [Dt_Crtd_On]           DATETIME     NULL,
    [Dt_Upd_On]            DATETIME     NULL
);

