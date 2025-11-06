CREATE TABLE [dbo].[Nullify_Installments_Details] (
    [ID]                        INT            IDENTITY (1, 1) NOT NULL,
    [Invoice_Header_ID]         INT            NULL,
    [Invoice_No]                INT            NULL,
    [Invoice_Detail_ID]         INT            NULL,
    [FirstAdmissionDate]        DATETIME       NULL,
    [Invoicedate]               DATETIME       NULL,
    [I_Fee_Component]           INT            NULL,
    [StudentDetailID]           INT            NULL,
    [Student_ID]                NVARCHAR (MAX) NULL,
    [Installment_Date]          DATETIME       NULL,
    [PreviousAmount]            DECIMAL (8, 2) NULL,
    [CurrentAmount]             DECIMAL (8, 2) NULL,
    [PreviousTotalAmount]       DECIMAL (8, 2) NULL,
    [TotalReductionAmount]      DECIMAL (8, 2) NULL,
    [CreatedOn]                 DATETIME       NULL,
    [CreatedBy]                 NVARCHAR (MAX) NULL,
    [Isdone]                    BIT            NULL,
    [I_Invoice_Child_Header_ID] INT            NULL,
    [N_Tax_Amount]              DECIMAL (8, 2) NULL,
    [Remarks]                   NVARCHAR (MAX) NULL
);

