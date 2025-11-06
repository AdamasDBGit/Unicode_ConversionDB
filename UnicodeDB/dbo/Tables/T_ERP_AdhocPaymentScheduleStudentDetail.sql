CREATE TABLE [dbo].[T_ERP_AdhocPaymentScheduleStudentDetail] (
    [inAdhocPaymentScheduleStudentDetailID] INT            IDENTITY (1, 1) NOT NULL,
    [inAdhocPaymentScheduleHeaderDetailID]  INT            NOT NULL,
    [inStudentDetailID]                     INT            NOT NULL,
    [inPaymentStatus]                       INT            NULL,
    [I_Receipt_Header_ID]                   INT            NULL,
    [sInvoiceNo]                            NVARCHAR (50)  NULL,
    [sRemarks]                              NVARCHAR (MAX) NULL,
    [IsFreeze]                              BIT            NULL
);

