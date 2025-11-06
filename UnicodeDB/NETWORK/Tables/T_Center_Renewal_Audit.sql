CREATE TABLE [NETWORK].[T_Center_Renewal_Audit] (
    [I_Center_Renewal_Audit_ID] INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [I_Center_Renewal_ID]       INT           NULL,
    [I_Centre_Id]               INT           NULL,
    [S_Reason]                  VARCHAR (200) NULL,
    [I_Status]                  INT           NULL,
    [S_Crtd_By]                 VARCHAR (20)  NULL,
    [S_Upd_By]                  VARCHAR (20)  NULL,
    [Dt_Crtd_On]                DATETIME      NULL,
    [Dt_Upd_On]                 DATETIME      NULL,
    CONSTRAINT [PK__T_Center_Renewal__51BAE991] PRIMARY KEY CLUSTERED ([I_Center_Renewal_Audit_ID] ASC)
);

