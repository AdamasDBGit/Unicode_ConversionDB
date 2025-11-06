CREATE TABLE [dbo].[T_ERP_FineWaiver_History_Captured] (
    [ID]                   INT             IDENTITY (1, 1) NOT NULL,
    [I_Invoice_Header_ID]  INT             NULL,
    [Dt_Installment_Date]  DATE            NULL,
    [S_Invoice_No]         NVARCHAR (MAX)  NULL,
    [dt_Finewaiveroff]     DATETIME        NULL,
    [Fine_waiveroff_Amt]   NUMERIC (12, 2) NULL,
    [FineWaieveoffRemarks] NVARCHAR (MAX)  NULL,
    [FineActualAmount]     NUMERIC (12, 2) NULL,
    [Fine_waiveroff_perc]  NUMERIC (12, 2) NULL
);

