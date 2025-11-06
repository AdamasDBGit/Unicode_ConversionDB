CREATE TABLE [dbo].[T_Invoice_Child_Detail] (
    [I_Invoice_Detail_ID]                       INT             IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [I_Fee_Component_ID]                        INT             NULL,
    [I_Invoice_Child_Header_ID]                 INT             NULL,
    [I_Installment_No]                          INT             NULL,
    [Dt_Installment_Date]                       DATETIME        NULL,
    [N_Amount_Due]                              NUMERIC (18, 2) NULL,
    [I_Display_Fee_Component_ID]                INT             NULL,
    [I_Sequence]                                INT             NULL,
    [N_Amount_Adv_Coln]                         NUMERIC (18, 2) CONSTRAINT [DF__T_Invoice__N_Amo__57A50628] DEFAULT ((0)) NULL,
    [Flag_IsAdvanceTax]                         VARCHAR (1)     CONSTRAINT [DF__T_Invoice__Flag___58992A61] DEFAULT ('N') NULL,
    [I_Receipt_Header_ID]                       INT             NULL,
    [S_Invoice_Number]                          VARCHAR (256)   NULL,
    [Tmp_AutoIdTag]                             INT             NULL,
    [N_Discount_Amount]                         DECIMAL (14, 2) NULL,
    [N_Due]                                     DECIMAL (14, 2) NULL,
    [I_Payment_Status]                          INT             CONSTRAINT [DF_T_Invoice_Child_Detail_I_Payment_Status] DEFAULT ((0)) NULL,
    [N_CGST]                                    NUMERIC (18, 2) NULL,
    [N_SGST]                                    NUMERIC (18, 2) NULL,
    [N_IGST]                                    NUMERIC (18, 2) NULL,
    [I_GST_FeeComponent_Catagory_ID]            INT             NULL,
    [is_Freezed]                                BIT             NULL,
    [ERP_Installment_Discount_Scheme_Master_ID] INT             NULL,
    [N_ERP_Discount_Amount]                     DECIMAL (8, 2)  NULL,
    [Is_Finance_Push]                           BIT             NULL,
    [Is_Finance_Reconcile]                      BIT             NULL,
    [N_CGST_per]                                NUMERIC (12, 2) NULL,
    [N_SGST_per]                                NUMERIC (12, 2) NULL,
    [N_IGST_per]                                NUMERIC (12, 2) NULL,
    [N_CGST_Tax_Value_Scheduled]                NUMERIC (12, 2) NULL,
    [N_SGST_Tax_Value_Scheduled]                NUMERIC (12, 2) NULL,
    [I_GST_Tax_Value_Scheduled]                 NUMERIC (12, 2) NULL,
    [IsDiscountRateApplied]                     BIT             NULL,
    [Discount_Amount_Rate]                      INT             NULL,
    [N_Disc_Amount]                             NUMERIC (12, 2) NULL,
    [N_Gross_Amount]                            NUMERIC (12, 2) NULL,
    [N_Tax_Disc_Amount]                         NUMERIC (18, 2) NULL,
    [N_DISC_IGST_Tax_Amount]                    NUMERIC (12, 2) NULL,
    [Is_Fine_waiveroff]                         BIT             NULL,
    [dt_Finewaiveroff]                          DATETIME        NULL,
    [I_Brand_ID]                                INT             NULL,
    [Fine_waiveroff_Amt]                        NUMERIC (12, 2) NULL,
    [N_Curr_PaidAmt]                            NUMERIC (12, 2) NULL,
    [N_Curr_DueAmt]                             NUMERIC (12, 2) NULL,
    [I_DiscountType_ID]                         INT             NULL,
    [N_Fix_Discount]                            DECIMAL (8, 2)  NULL,
    [N_Perc_Discount]                           DECIMAL (8, 2)  NULL,
    [s_finewaieveoff_remarks]                   NVARCHAR (MAX)  NULL,
    [Actual_FineAmount]                         NUMERIC (12, 2) NULL,
    [FineDiscountAmount]                        NUMERIC (12, 2) NULL,
    [FineDiscountPerc]                          NUMERIC (3)     NULL,
    [Dt_partialwaeve_off]                       DATE            NULL,
    [is_Partial_finewaiver]                     BIT             NULL,
    CONSTRAINT [PK__T_Invoice_Child___67DF34DA] PRIMARY KEY CLUSTERED ([I_Invoice_Detail_ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [index_Header_ID_Invoice_Detail]
    ON [dbo].[T_Invoice_Child_Detail]([I_Invoice_Child_Header_ID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_T_Invoice_Child_Detail_InvoiceNo_Discount]
    ON [dbo].[T_Invoice_Child_Detail]([S_Invoice_Number] ASC)
    INCLUDE([N_Disc_Amount], [N_Tax_Disc_Amount]);

