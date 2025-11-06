CREATE TABLE [CORPORATE].[T_Corporate_Invoice] (
    [I_Corporate_Invoice_Id] INT             IDENTITY (1, 1) NOT NULL,
    [I_Corporate_Plan_ID]    INT             NULL,
    [S_Crtd_By]              VARCHAR (20)    NULL,
    [S_Upd_By]               VARCHAR (20)    NULL,
    [Dt_Crtd_On]             DATETIME        NULL,
    [Dt_Upd_On]              DATETIME        NULL,
    [I_Status]               INT             NULL,
    [N_Excess_Amt]           DECIMAL (18, 2) NULL,
    CONSTRAINT [PK_T_Corporate_Invoice] PRIMARY KEY CLUSTERED ([I_Corporate_Invoice_Id] ASC)
);

