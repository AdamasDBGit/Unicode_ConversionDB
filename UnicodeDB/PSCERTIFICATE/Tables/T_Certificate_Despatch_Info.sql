CREATE TABLE [PSCERTIFICATE].[T_Certificate_Despatch_Info] (
    [I_Despatch_ID]        INT          IDENTITY (1, 1) NOT NULL,
    [I_Logistic_ID]        INT          NULL,
    [I_Courier_ID]         INT          NULL,
    [S_Despatch_Serialno]  VARCHAR (20) NULL,
    [Dt_Dispatch_Date]     DATETIME     NULL,
    [Dt_Exp_Delivery_Date] DATETIME     NULL,
    [S_Docket_No]          VARCHAR (20) NULL,
    [S_Crtd_By]            VARCHAR (20) NULL,
    [S_Upd_By]             VARCHAR (20) NULL,
    [Dt_Crtd_On]           DATETIME     NULL,
    [Dt_Upd_On]            DATETIME     NULL
);

