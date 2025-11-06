CREATE TABLE [LOGISTICS].[T_Logistics_Payment] (
    [I_Logistic_Payment_ID] INT          IDENTITY (1, 1) NOT NULL,
    [I_Logistics_Order_ID]  INT          NULL,
    [S_DD_Cheque_No]        VARCHAR (20) NULL,
    [S_Bank_Name]           VARCHAR (20) NULL,
    [S_Branch_Name]         VARCHAR (20) NULL,
    [S_Payable_At]          VARCHAR (20) NULL,
    [I_Payment_Amount_INR]  INT          NULL,
    [I_Payment_Amount_USD]  INT          NULL,
    [Dt_Issue_Date]         DATETIME     NULL,
    [S_Remarks]             VARCHAR (20) NULL,
    [S_Crtd_By]             VARCHAR (20) NULL,
    [S_Upd_By]              VARCHAR (20) NULL,
    [Dt_Crtd_On]            DATETIME     NULL,
    [Dt_Upd_On]             DATETIME     NULL
);

