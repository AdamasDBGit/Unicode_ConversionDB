CREATE TABLE [AUDIT].[T_Audit_Report_Par_Refference] (
    [I_Audit_Par_ID] INT          NOT NULL,
    [S_Assessment]   VARCHAR (50) NULL,
    [I_AuditScore]   INT          NULL,
    [S_Percentage]   VARCHAR (50) NULL,
    CONSTRAINT [PK_AUDIT]].[T_Audit_Report_Par_Refference] PRIMARY KEY CLUSTERED ([I_Audit_Par_ID] ASC)
);

