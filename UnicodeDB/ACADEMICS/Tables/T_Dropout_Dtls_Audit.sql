CREATE TABLE [ACADEMICS].[T_Dropout_Dtls_Audit] (
    [I_Dropout_Dtls_Audit_ID] INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [I_Dropout_ID]            INT           NULL,
    [I_Student_ID]            INT           NULL,
    [I_Center_Id]             INT           NULL,
    [I_Dropout_Status]        INT           NULL,
    [I_Dropout_Type_ID]       INT           NULL,
    [Dt_Dropout_Date]         DATETIME      NULL,
    [S_Reason]                VARCHAR (500) NULL,
    [S_Crtd_By]               VARCHAR (20)  NULL,
    [S_Upd_By]                VARCHAR (20)  NULL,
    [Dt_Crtd_On]              DATETIME      NULL,
    [Dt_Upd_On]               DATETIME      NULL,
    CONSTRAINT [PK__T_Dropout_Dtls_A__756E3A22] PRIMARY KEY CLUSTERED ([I_Dropout_Dtls_Audit_ID] ASC)
);

