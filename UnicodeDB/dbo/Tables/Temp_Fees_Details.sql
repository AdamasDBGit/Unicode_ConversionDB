CREATE TABLE [dbo].[Temp_Fees_Details] (
    [student_id]                 NVARCHAR (50)   NULL,
    [current_due_amount]         DECIMAL (10, 2) NULL,
    [current_due_date]           DATE            NULL,
    [last_payment_id]            NVARCHAR (50)   NULL,
    [last_payment_status]        NVARCHAR (50)   NULL,
    [current_installment_fees]   DECIMAL (10, 2) NULL,
    [last_payment_received_date] DATE            NULL,
    [current_balance_amount]     DECIMAL (10, 2) NULL,
    [current_late_fee]           DECIMAL (10, 2) NULL,
    [current_due_payment_link]   NVARCHAR (MAX)  NULL
);

