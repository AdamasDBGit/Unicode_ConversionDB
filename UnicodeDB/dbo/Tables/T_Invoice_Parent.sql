CREATE TABLE [dbo].[T_Invoice_Parent] (
    [I_Invoice_Header_ID]           INT             IDENTITY (1, 1) NOT NULL,
    [S_Invoice_No]                  NVARCHAR (MAX)  NULL,
    [I_Student_Detail_ID]           INT             NULL,
    [I_Centre_Id]                   INT             NULL,
    [N_Invoice_Amount]              NUMERIC (18, 2) NULL,
    [N_Discount_Amount]             NUMERIC (18, 2) NULL,
    [N_Tax_Amount]                  NUMERIC (18, 2) NULL,
    [Dt_Invoice_Date]               DATETIME        NULL,
    [I_Status]                      INT             NULL,
    [I_Discount_Scheme_ID]          INT             NULL,
    [I_Discount_Applied_At]         INT             NULL,
    [S_Crtd_By]                     NVARCHAR (MAX)  NULL,
    [S_Upd_By]                      NVARCHAR (MAX)  NULL,
    [Dt_Crtd_On]                    DATETIME        NULL,
    [Dt_Upd_On]                     DATETIME        NULL,
    [I_Coupon_Discount]             INT             NULL,
    [I_Parent_Invoice_ID]           INT             NULL,
    [S_Cancel_Type]                 NVARCHAR (MAX)  NULL,
    [S_Narration]                   NVARCHAR (MAX)  NULL,
    [IsAdmissionInvoice]            BIT             NULL,
    [Is_NewGSTEnvironment]          BIT             NULL,
    [I_Currency_Id]                 INT             NULL,
    [is_Fine_Applicable]            BIT             NULL,
    [I_FineTagID]                   INT             NULL,
    [dt_FineModify_Date]            DATETIME        NULL,
    [Is_Fine_waiveroff]             BIT             CONSTRAINT [DF__T_Invoice__Is_Fi__022A13E3] DEFAULT ((0)) NULL,
    [N_ERP_Discount_Amount]         DECIMAL (8, 2)  NULL,
    [CurrentDiscountClaimRequestID] INT             NULL,
    [IsGlobalFreeze]                BIT             NULL,
    [I_Created_By]                  INT             NULL,
    [I_Updated_By]                  INT             NULL,
    [I_School_Session_ID]           INT             NULL,
    [I_Brand_ID]                    INT             NULL,
    [N_Curr_TotalPaid]              NUMERIC (12, 2) NULL,
    [N_Curr_TotalDue]               NUMERIC (12, 2) NULL,
    [N_Gross_Amount]                DECIMAL (18, 2) NULL,
    [I_DiscountType_ID]             INT             NULL,
    CONSTRAINT [PK__T_Invoice_Parent__6BAFC5BE] PRIMARY KEY CLUSTERED ([I_Invoice_Header_ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [index_Student_ID_Invoice_Parent]
    ON [dbo].[T_Invoice_Parent]([I_Student_Detail_ID] ASC);

