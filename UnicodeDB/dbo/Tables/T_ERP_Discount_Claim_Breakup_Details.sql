CREATE TABLE [dbo].[T_ERP_Discount_Claim_Breakup_Details] (
    [I_ERP_Discount_Claim_Breakup_Detail_ID] INT            IDENTITY (1, 1) NOT NULL,
    [I_ERP_Discount_Claim_Request_ID]        INT            NULL,
    [I_Invoice_Header_ID]                    INT            NULL,
    [I_Invoice_Detail_ID]                    INT            NULL,
    [S_Invoice_Number]                       NVARCHAR (MAX) NULL,
    [S_Discount_Amount]                      DECIMAL (8, 2) NULL,
    [S_Discount_Rate]                        DECIMAL (8, 2) NULL,
    [S_Status]                               NVARCHAR (MAX) NULL,
    [Is_Approved]                            BIT            NULL,
    [Is_Rejected]                            BIT            NULL,
    [Dt_Created_At]                          DATETIME       NULL,
    [Dt_Action_Taken_At]                     DATETIME       NULL
);

