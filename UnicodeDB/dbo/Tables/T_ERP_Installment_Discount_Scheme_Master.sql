CREATE TABLE [dbo].[T_ERP_Installment_Discount_Scheme_Master] (
    [I_ERP_Installment_Discount_Scheme_Master_ID] INT            IDENTITY (1, 1) NOT NULL,
    [I_Brand_ID]                                  INT            NULL,
    [S_Installment_Discount_Scheme_Name]          NVARCHAR (MAX) NULL,
    [Is_Flat_Discount]                            BIT            NULL,
    [Dt_Valid_From]                               DATETIME       NULL,
    [Dt_Valid_To]                                 DATETIME       NULL,
    [N_Discount_Amount]                           INT            NULL,
    [N_Discount_Rate]                             INT            NULL,
    [I_Status]                                    INT            NULL,
    [S_Crtd_By]                                   NVARCHAR (MAX) NULL,
    [S_Upd_By]                                    NVARCHAR (MAX) NULL,
    [Dt_Crtd_On]                                  DATETIME       NULL,
    [Dt_Upd_On]                                   DATETIME       NULL
);

