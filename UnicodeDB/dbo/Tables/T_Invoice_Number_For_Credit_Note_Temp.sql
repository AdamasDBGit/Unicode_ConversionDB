CREATE TABLE [dbo].[T_Invoice_Number_For_Credit_Note_Temp] (
    [ID]                                    INT            IDENTITY (1, 1) NOT NULL,
    [I_Credit_Note_Invoice_Child_Detail_ID] INT            NULL,
    [I_Installment_No]                      INT            NULL,
    [S_Invoice_Type]                        NVARCHAR (MAX) NULL,
    [S_Invoice_No]                          NVARCHAR (MAX) NULL,
    [I_Invoice_Header_ID]                   INT            NULL,
    [I_Invoice_Detail_ID]                   INT            NULL,
    [I_Receipt_Header_ID]                   INT            NULL,
    CONSTRAINT [PK_T_Invoice_Number_For_Credit_Note_Temp] PRIMARY KEY CLUSTERED ([ID] ASC)
);

