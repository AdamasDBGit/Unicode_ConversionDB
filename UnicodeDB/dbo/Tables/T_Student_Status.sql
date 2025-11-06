CREATE TABLE [dbo].[T_Student_Status] (
    [I_Student_Status_ID] INT             IDENTITY (1, 1) NOT NULL,
    [I_Student_Detail_ID] INT             NOT NULL,
    [I_Status_ID]         INT             NOT NULL,
    [I_Status]            INT             NULL,
    [N_Due]               DECIMAL (14, 2) NULL,
    [StatusDate]          DATETIME        NULL,
    [InvoiceHeaderID]     INT             NULL,
    [ValidFrom]           DATETIME        NULL,
    [ValidTo]             DATETIME        NULL,
    [Dt_Crtd_On]          DATETIME        NULL,
    [S_Crtd_By]           NVARCHAR (MAX)  NULL,
    [Dt_Updt_On]          DATETIME        NULL,
    [S_Updt_By]           NVARCHAR (MAX)  NULL,
    [S_MandateLink]       NVARCHAR (MAX)  NULL,
    [S_PayoutLink]        NVARCHAR (MAX)  NULL,
    [B_IsInQueue]         BIT             CONSTRAINT [DF__T_Student__B_IsI__16654B63] DEFAULT ((0)) NULL,
    CONSTRAINT [PK__T_Studen__6BD8D2E5AD92235C] PRIMARY KEY CLUSTERED ([I_Student_Status_ID] ASC)
);

