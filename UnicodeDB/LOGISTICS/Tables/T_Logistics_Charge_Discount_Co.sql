CREATE TABLE [LOGISTICS].[T_Logistics_Charge_Discount_Co] (
    [I_Logistic_ChrgDiscount_Audit_ID] INT             IDENTITY (1, 1) NOT NULL,
    [I_Logistics_Charge_ID]            INT             NULL,
    [I_Brand_ID]                       INT             NULL,
    [S_Logistics_Charge_Code]          VARCHAR (50)    NULL,
    [S_Logistics_Charge_Desc]          VARCHAR (100)   NULL,
    [I_Amount]                         NUMERIC (18, 2) NULL,
    [S_Crtd_By]                        VARCHAR (20)    NULL,
    [S_Upd_By]                         VARCHAR (20)    NULL,
    [Dt_Crtd_On]                       DATETIME        NULL,
    [Dt_Upd_On]                        DATETIME        NULL,
    [Dt_Start]                         DATETIME        NULL,
    [Dt_End]                           DATETIME        NULL
);

