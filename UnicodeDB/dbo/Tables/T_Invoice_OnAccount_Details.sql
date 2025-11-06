CREATE TABLE [dbo].[T_Invoice_OnAccount_Details] (
    [I_OnAccount_Ivoice_ID] INT             IDENTITY (1, 1) NOT NULL,
    [I_Receipt_Header_ID]   INT             NULL,
    [S_Receipt_No]          NVARCHAR (MAX)  NULL,
    [Dt_Receipt_Date]       DATETIME        NULL,
    [I_Student_Detail_ID]   INT             NULL,
    [I_Enquiry_Regn_ID]     INT             NULL,
    [I_Centre_Id]           INT             NULL,
    [I_Status]              INT             NULL,
    [I_Receipt_Type]        SMALLINT        NULL,
    [N_Receipt_Amount]      NUMERIC (18, 2) NULL,
    [N_Tax_Amount]          NUMERIC (18, 2) NULL,
    [S_Invoice_Type]        CHAR (10)       NULL,
    [S_Invoice_Number]      NVARCHAR (MAX)  NULL,
    [Dt_Crtd_On]            DATETIME        NULL,
    [Dt_Upd_On]             DATETIME        NULL,
    CONSTRAINT [PK_T_OnAccount_Invoice_Details] PRIMARY KEY CLUSTERED ([I_OnAccount_Ivoice_ID] ASC)
);

