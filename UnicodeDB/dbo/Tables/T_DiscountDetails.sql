CREATE TABLE [dbo].[T_DiscountDetails] (
    [I_Discount_Detail_ID]      INT             IDENTITY (1, 1) NOT NULL,
    [I_Invoice_Header_ID]       INT             NULL,
    [I_Invoice_Child_Detail_ID] INT             NULL,
    [N_Discount_Amount]         DECIMAL (14, 2) NULL,
    [S_Crtd_By]                 NVARCHAR (MAX)  NULL,
    [S_Upd_By]                  NVARCHAR (MAX)  NULL,
    [Dt_Crtd_On]                DATETIME        NULL,
    [Dt_Upd_On]                 DATETIME        NULL
);

