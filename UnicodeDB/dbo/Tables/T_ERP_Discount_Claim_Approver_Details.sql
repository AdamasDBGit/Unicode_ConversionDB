CREATE TABLE [dbo].[T_ERP_Discount_Claim_Approver_Details] (
    [I_Discount_Claim_Approver_DetailID] INT            IDENTITY (1, 1) NOT NULL,
    [I_ERP_Discount_Claim_Request_ID]    INT            NULL,
    [I_Approver_Seq]                     INT            NULL,
    [S_Status]                           NVARCHAR (MAX) NULL,
    [Is_Approved]                        BIT            NULL,
    [Is_Rejected]                        BIT            NULL,
    [Dt_Created_At]                      DATETIME       NULL,
    [Dt_Action_Taken_At]                 DATETIME       NULL,
    [Remarks]                            NVARCHAR (MAX) NULL,
    [I_Saas_Header_ID]                   INT            NULL,
    [I_Action_Taken_By]                  INT            NULL
);

