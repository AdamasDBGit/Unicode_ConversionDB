CREATE TABLE [EOS].[T_Employee_Role_Map_Audit] (
    [I_Employee_Role_Map_Audit_ID] INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [I_Status_ID]                  INT          NULL,
    [I_Employee_Role_Map_ID]       INT          NULL,
    [I_Employee_ID]                INT          NULL,
    [I_Role_ID]                    INT          NULL,
    [Dt_Valid_From]                DATETIME     NULL,
    [Dt_Valid_To]                  DATETIME     NULL,
    [S_Crtd_By]                    VARCHAR (20) NULL,
    [S_Upd_By]                     VARCHAR (20) NULL,
    [Dt_Crtd_On]                   DATETIME     NULL,
    [Dt_Upd_On]                    DATETIME     NULL,
    CONSTRAINT [PK__T_Employee_Role___5D61A667] PRIMARY KEY CLUSTERED ([I_Employee_Role_Map_Audit_ID] ASC)
);

