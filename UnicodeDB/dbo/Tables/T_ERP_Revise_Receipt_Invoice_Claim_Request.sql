CREATE TABLE [dbo].[T_ERP_Revise_Receipt_Invoice_Claim_Request] (
    [I_ERP_Revise_Receipt_Invoice_Claim_Request_ID] INT            IDENTITY (1, 1) NOT NULL,
    [I_Brand_ID]                                    INT            NULL,
    [I_Revise_Type_ID]                              INT            NULL,
    [I_Invoice_Header_ID]                           INT            NULL,
    [I_Receipt_Header_ID]                           INT            NULL,
    [I_User_Claim_By]                               INT            NULL,
    [S_Claim_Status]                                NVARCHAR (MAX) NULL,
    [Is_Fully_Approved]                             BIT            NULL,
    [Is_Rejected]                                   BIT            NULL,
    [Dt_Claim_Date]                                 DATETIME       NULL,
    [Dt_Final_Approved_Date]                        DATETIME       NULL,
    [Dt_Rejected_Date]                              DATETIME       NULL,
    [I_Last_Action_Claim_Detail_ID]                 INT            NULL,
    [S_Remarks]                                     NVARCHAR (MAX) NULL,
    [I_Status]                                      BIT            NULL
);

