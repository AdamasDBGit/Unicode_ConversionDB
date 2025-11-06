CREATE TABLE [dbo].[T_Fee_Sharing_OnAccount_Audit] (
    [I_Fee_Sharing_OnAccount_Audit_ID] INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [I_Fee_Sharing_OnAccount_ID]       INT            NULL,
    [I_Brand_ID]                       INT            NULL,
    [I_Country_ID]                     INT            NULL,
    [I_Center_ID]                      INT            NULL,
    [I_Receipt_Type]                   INT            NULL,
    [N_Company_Share]                  NUMERIC (8, 4) NULL,
    [Dt_Period_Start]                  DATETIME       NULL,
    [Dt_Period_End]                    DATETIME       NULL,
    [I_Status]                         INT            NULL,
    [S_Crtd_By]                        NVARCHAR (MAX) NULL,
    [S_Upd_By]                         NVARCHAR (MAX) NULL,
    [Dt_Crtd_On]                       DATETIME       NULL,
    [Dt_Upd_On]                        DATETIME       NULL,
    CONSTRAINT [PK_T_Fee_Sharing_OnAccount_Audit] PRIMARY KEY CLUSTERED ([I_Fee_Sharing_OnAccount_Audit_ID] ASC)
);

