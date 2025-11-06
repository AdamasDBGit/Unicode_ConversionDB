CREATE TABLE [AUDIT].[T_Audit_Functional_Type] (
    [I_Audit_Functional_Type_ID] INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [S_Audit_Functional_Name]    VARCHAR (100) NULL,
    CONSTRAINT [PK__T_Audit_Function__59AC7ED4] PRIMARY KEY CLUSTERED ([I_Audit_Functional_Type_ID] ASC)
);

