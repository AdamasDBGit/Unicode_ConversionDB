CREATE TABLE [AUDIT].[T_Audit_Type] (
    [I_Audit_Type_ID]   INT          IDENTITY (1, 1) NOT NULL,
    [S_Audit_Type_Code] VARCHAR (20) NULL,
    [S_Audit_Type_Desc] VARCHAR (20) NULL,
    [S_Crtd_By]         VARCHAR (20) NULL,
    [S_Upd_By]          VARCHAR (20) NULL,
    [Dt_Crtd_On]        DATETIME     NULL,
    [Dt_Upd_On]         DATETIME     NULL,
    CONSTRAINT [PK__T_Audit_Type__53F3A57E] PRIMARY KEY CLUSTERED ([I_Audit_Type_ID] ASC)
);

