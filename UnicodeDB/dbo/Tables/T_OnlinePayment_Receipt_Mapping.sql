CREATE TABLE [dbo].[T_OnlinePayment_Receipt_Mapping] (
    [OnlinePayment_Receipt_Mapping] INT             IDENTITY (1, 1) NOT NULL,
    [I_Receipt_Header_ID]           INT             NULL,
    [S_Receipt_No]                  NVARCHAR (MAX)  NULL,
    [S_Transaction_No]              NVARCHAR (MAX)  NULL,
    [S_Ext_Receipt_No]              NVARCHAR (MAX)  NULL,
    [Dt_Crtd_On]                    DATETIME        NULL,
    [S_Crtd_By]                     NVARCHAR (MAX)  NULL,
    [N_Amount]                      DECIMAL (14, 2) NULL,
    [N_Tax]                         DECIMAL (14, 2) NULL,
    [Dt_ActualReceiptDate]          DATETIME        NULL
);

