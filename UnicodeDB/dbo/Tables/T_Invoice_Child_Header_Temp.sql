CREATE TABLE [dbo].[T_Invoice_Child_Header_Temp] (
    [I_Invoice_Child_Header_ID] INT             IDENTITY (1, 1) NOT NULL,
    [I_Invoice_Header_ID]       INT             NULL,
    [I_Course_ID]               INT             NULL,
    [I_Course_FeePlan_ID]       INT             NULL,
    [C_Is_LumpSum]              CHAR (1)        NULL,
    [N_Amount]                  NUMERIC (18, 2) NULL,
    [N_Tax_Amount]              NUMERIC (18, 2) NULL,
    [N_Discount_Amount]         NUMERIC (18, 2) NULL,
    [I_Discount_Scheme_ID]      INT             NULL,
    [I_Discount_Applied_At]     INT             NULL
);

