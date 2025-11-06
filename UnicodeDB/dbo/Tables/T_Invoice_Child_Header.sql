CREATE TABLE [dbo].[T_Invoice_Child_Header] (
    [I_Invoice_Child_Header_ID] INT             IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [I_Invoice_Header_ID]       INT             NULL,
    [I_Course_ID]               INT             NULL,
    [I_Course_FeePlan_ID]       INT             NULL,
    [C_Is_LumpSum]              CHAR (1)        NULL,
    [N_Amount]                  NUMERIC (18, 2) NULL,
    [N_Tax_Amount]              NUMERIC (18, 2) NULL,
    [N_Discount_Amount]         NUMERIC (18, 2) NULL,
    [I_Discount_Scheme_ID]      INT             NULL,
    [I_Discount_Applied_At]     INT             NULL,
    [I_Brand_ID]                INT             NULL,
    [N_Gross_Amount]            DECIMAL (18, 2) NULL,
    CONSTRAINT [PK__T_Invoice_Child___69C77D4C] PRIMARY KEY CLUSTERED ([I_Invoice_Child_Header_ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [index_Course_ID_Invoice_Child]
    ON [dbo].[T_Invoice_Child_Header]([I_Course_ID] ASC);


GO
CREATE NONCLUSTERED INDEX [index_Header_ID_Invoice_Child]
    ON [dbo].[T_Invoice_Child_Header]([I_Invoice_Header_ID] ASC);

