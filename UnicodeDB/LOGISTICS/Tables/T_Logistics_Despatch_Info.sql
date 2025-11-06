CREATE TABLE [LOGISTICS].[T_Logistics_Despatch_Info] (
    [I_Despatch_ID]        INT           IDENTITY (1, 1) NOT NULL,
    [I_Courier_ID]         INT           NULL,
    [I_Logistics_Order_ID] INT           NULL,
    [S_Despatch_Serialno]  VARCHAR (20)  NULL,
    [Dt_Despatch_Date]     DATETIME      NULL,
    [Dt_Exp_Delivery_Date] DATETIME      NULL,
    [S_Docket_No]          VARCHAR (20)  NULL,
    [S_Air_Bill_No]        VARCHAR (20)  NULL,
    [S_Transporter]        VARCHAR (200) NULL,
    [S_Remarks]            VARCHAR (200) NULL,
    [S_Crtd_By]            VARCHAR (20)  NULL,
    [S_Upd_By]             VARCHAR (20)  NULL,
    [Dt_Crtd_On]           DATETIME      NULL,
    [Dt_Upd_On]            DATETIME      NULL,
    [Dt_Act_Delivery_Date] DATETIME      NULL
);

