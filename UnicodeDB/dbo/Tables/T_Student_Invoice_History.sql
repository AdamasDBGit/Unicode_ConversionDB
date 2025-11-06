CREATE TABLE [dbo].[T_Student_Invoice_History] (
    [I_Student_Invoice_History_ID] INT            IDENTITY (1, 1) NOT NULL,
    [I_Invoice_Header_ID]          INT            NOT NULL,
    [I_Student_Detail_ID]          INT            NOT NULL,
    [I_Cancellation_Reason_ID]     INT            NULL,
    [I_Status]                     INT            NULL,
    [S_Crtd_By]                    NVARCHAR (MAX) NULL,
    [S_Upd_By]                     NVARCHAR (MAX) NULL,
    [Dt_Crtd_On]                   DATETIME       NULL,
    [Dt_Upd_On]                    DATETIME       NULL,
    CONSTRAINT [PK_T_Student_Invoice_History] PRIMARY KEY CLUSTERED ([I_Student_Invoice_History_ID] ASC)
);

