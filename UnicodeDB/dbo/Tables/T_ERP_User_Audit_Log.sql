CREATE TABLE [dbo].[T_ERP_User_Audit_Log] (
    [I_User_Audit_Log_ID]  INT            IDENTITY (1, 1) NOT NULL,
    [I_User_ID]            INT            NOT NULL,
    [S_Activity_Type]      NVARCHAR (150) NOT NULL,
    [Dt_Activity_Occurred] DATETIME       NOT NULL,
    [S_Descripttion]       NVARCHAR (MAX) NULL
);

