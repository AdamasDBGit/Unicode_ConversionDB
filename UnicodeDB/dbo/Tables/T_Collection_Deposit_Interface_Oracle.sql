CREATE TABLE [dbo].[T_Collection_Deposit_Interface_Oracle] (
    [I_Receipt_Header_ID] INT             NULL,
    [I_Centre_Id]         INT             NULL,
    [Dt_Deposit_Date]     DATETIME        NULL,
    [Bank_Account_Name]   NVARCHAR (MAX)  NULL,
    [N_Receipt_Amount]    NUMERIC (18, 2) NULL,
    [N_Tax_Amount]        NUMERIC (18, 2) NULL,
    [I_Status]            INT             NULL,
    [Dt_Crtd_On]          DATETIME        NULL,
    [Dt_Upd_On]           DATETIME        NULL,
    [IsUploaded]          INT             NULL,
    [UploadedDate]        DATETIME        NULL
);

