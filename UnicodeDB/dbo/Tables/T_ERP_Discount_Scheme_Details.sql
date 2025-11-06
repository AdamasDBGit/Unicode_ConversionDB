CREATE TABLE [dbo].[T_ERP_Discount_Scheme_Details] (
    [I_Discount_Scheme_Detail_ID] INT             IDENTITY (1, 1) NOT NULL,
    [I_Discount_Scheme_ID]        INT             NULL,
    [N_Discount_Rate]             NVARCHAR (MAX)  NULL,
    [N_Discount_Amount]           NUMERIC (18, 2) NULL,
    [I_IsApplicableOn]            INT             NULL,
    [I_FromInstalment]            INT             NULL,
    [I_FeeComponentID]            INT             NULL,
    [I_NoofInstallments]          INT             NULL,
    [I_Status_ID]                 INT             NULL,
    [I_Brand_ID]                  INT             NULL
);

