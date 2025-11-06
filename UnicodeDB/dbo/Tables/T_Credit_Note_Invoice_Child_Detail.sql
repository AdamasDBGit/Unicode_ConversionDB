CREATE TABLE [dbo].[T_Credit_Note_Invoice_Child_Detail] (
    [I_Credit_Note_Invoice_Child_Detail_ID] INT             IDENTITY (1, 1) NOT NULL,
    [I_Invoice_Header_ID]                   INT             NULL,
    [I_Invoice_Detail_ID]                   INT             NULL,
    [S_Invoice_Number]                      VARCHAR (256)   NULL,
    [Dt_Crtd_On]                            DATETIME        NULL,
    [Dt_Upd_On]                             DATETIME        NULL,
    [N_Amount]                              NUMERIC (18, 2) NULL,
    [N_Amount_Due]                          NUMERIC (18, 2) NULL,
    [N_Amount_Adv]                          NUMERIC (18, 2) NULL,
    CONSTRAINT [PK_T_Credit_Note_Invoice_Child_Detail] PRIMARY KEY CLUSTERED ([I_Credit_Note_Invoice_Child_Detail_ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [Idx_I_Invoice_Detail_ID]
    ON [dbo].[T_Credit_Note_Invoice_Child_Detail]([I_Invoice_Detail_ID] ASC)
    INCLUDE([S_Invoice_Number], [Dt_Crtd_On], [N_Amount]);

