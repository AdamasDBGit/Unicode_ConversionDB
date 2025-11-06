CREATE TABLE [dbo].[T_Credit_Note_Invoice_Child_Detail_raj] (
    [I_Credit_Note_Invoice_Child_Detail_ID] INT             IDENTITY (1, 1) NOT NULL,
    [I_Invoice_Header_ID]                   INT             NULL,
    [I_Invoice_Detail_ID]                   INT             NULL,
    [S_Invoice_Number]                      NVARCHAR (MAX)  NULL,
    [Dt_Crtd_On]                            DATETIME        NULL,
    [Dt_Upd_On]                             DATETIME        NULL,
    [N_Amount]                              NUMERIC (18, 2) NULL,
    [N_Amount_Due]                          NUMERIC (18, 2) NULL,
    [N_Amount_Adv]                          NUMERIC (18, 2) NULL
);

